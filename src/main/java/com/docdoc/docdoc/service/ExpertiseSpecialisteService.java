package com.docdoc.docdoc.service;

import com.docdoc.docdoc.model.*;
import com.docdoc.docdoc.model.enums.Priorite;
import com.docdoc.docdoc.model.enums.Specialite;
import com.docdoc.docdoc.model.enums.StatutExpertise;
import com.docdoc.docdoc.repository.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service pour gérer les consultations des médecins spécialistes
 * US5, US6, US7, US8
 */
public class ExpertiseSpecialisteService {

    private final MedecinSpecialisteRepository specialisteRepository;
    private final CreneauRepository creneauRepository;
    private final DemandeExpertiseRepository demandeExpertiseRepository;
    private final ConsultationRepository consultationRepository;

    public ExpertiseSpecialisteService() {
        this.specialisteRepository = new MedecinSpecialisteRepository();
        this.creneauRepository = new CreneauRepository();
        this.demandeExpertiseRepository = new DemandeExpertiseRepository();
        this.consultationRepository = new ConsultationRepository();
    }

    /**
     * US5: Met à jour le profil du spécialiste
     * @param specialisteId ID du spécialiste
     * @param tarif Tarif de consultation
     * @param specialite Spécialité médicale
     * @return Le spécialiste mis à jour
     */
    public MedecinSpecialiste updateProfilSpecialiste(String specialisteId, Double tarif, Specialite specialite) {
        Optional<MedecinSpecialiste> specialisteOpt = specialisteRepository.findById(specialisteId);

        if (specialisteOpt.isEmpty()) {
            throw new IllegalArgumentException("Spécialiste introuvable");
        }

        MedecinSpecialiste specialiste = specialisteOpt.get();

        if (tarif != null && tarif > 0) {
            specialiste.setTarif(tarif);
        }

        if (specialite != null) {
            specialiste.setSpecialite(specialite);
        }

        return specialisteRepository.save(specialiste);
    }

    /**
     * US6: Initialise les créneaux prédéfinis pour un spécialiste (30 min chacun)
     * Créneaux de 09h00 à 12h00
     * @param specialisteId ID du spécialiste
     * @param date Date pour laquelle créer les créneaux
     */
    public void initialiserCreneauxPredefinies(String specialisteId, LocalDate date) {
        Optional<MedecinSpecialiste> specialisteOpt = specialisteRepository.findById(specialisteId);

        if (specialisteOpt.isEmpty()) {
            throw new IllegalArgumentException("Spécialiste introuvable");
        }

        MedecinSpecialiste specialiste = specialisteOpt.get();

        // Créneaux prédéfinis (09h00 à 12h00, par 30 min)
        LocalTime[] heuresDebut = {
                LocalTime.of(9, 0),
                LocalTime.of(9, 30),
                LocalTime.of(10, 0),
                LocalTime.of(10, 30),
                LocalTime.of(11, 0),
                LocalTime.of(11, 30)
        };

        for (LocalTime heureDebut : heuresDebut) {
            LocalTime heureFin = heureDebut.plusMinutes(30);

            // Vérifier que le créneau n'existe pas déjà
            if (!creneauRepository.existsCreneau(specialiste, date, heureDebut)) {
                Creneau creneau = new Creneau(specialiste, date, heureDebut, heureFin);
                creneauRepository.save(creneau);
            }
        }
    }

    /**
     * US6: Récupère tous les créneaux d'un spécialiste pour une date donnée
     * Met à jour automatiquement le statut (archivé si passé)
     * @param specialisteId ID du spécialiste
     * @param date Date requise
     * @return Liste des créneaux avec statut mis à jour
     */
    public List<Creneau> getCreneauxByDate(String specialisteId, LocalDate date) {
        Optional<MedecinSpecialiste> specialisteOpt = specialisteRepository.findById(specialisteId);

        if (specialisteOpt.isEmpty()) {
            throw new IllegalArgumentException("Spécialiste introuvable");
        }

        List<Creneau> creneaux = creneauRepository.findBySpecialisteAndDate(specialisteOpt.get(), date);

        // Auto-archivage des créneaux passés
        creneaux.forEach(c -> {
            if (c.estPasse()) {
                // Créneau passé - pas besoin de sauvegarder, juste indication visuelle
                c.setDisponible(false);
            }
        });

        return creneaux;
    }

    /**
     * US7: Récupère les demandes d'expertise filtrées par statut et priorité
     * Utilise Stream API pour filtrer et grouper
     * @param specialisteId ID du spécialiste
     * @param statut Statut des demandes (EN_ATTENTE, TERMINEE, etc.)
     * @param priorite Priorité des demandes (URGENTE, NORMALE, NON_URGENTE)
     * @return Liste des demandes d'expertise filtrées
     */
    public List<DemandeExpertise> getDemandesExpertiseFiltrées(String specialisteId,
                                                               StatutExpertise statut,
                                                               Priorite priorite) {
        Optional<MedecinSpecialiste> specialisteOpt = specialisteRepository.findById(specialisteId);

        if (specialisteOpt.isEmpty()) {
            throw new IllegalArgumentException("Spécialiste introuvable");
        }

        MedecinSpecialiste specialiste = specialisteOpt.get();

        // Récupérer toutes les demandes du spécialiste
        List<DemandeExpertise> demandes = demandeExpertiseRepository.findBySpecialiste(specialiste);

        // Utilisation de Stream API pour filtrer par statut ET priorité
        return demandes.stream()
                .filter(d -> statut == null || d.getStatut() == statut)
                .filter(d -> priorite == null || d.getPriorite() == priorite)
                .sorted((d1, d2) -> {
                    // Trier par priorité d'abord, puis par date
                    int priorityOrder = getPrioriteOrder(d2.getPriorite()) - getPrioriteOrder(d1.getPriorite());
                    if (priorityOrder != 0) return priorityOrder;
                    return d2.getDateDemande().compareTo(d1.getDateDemande());
                })
                .collect(Collectors.toList());
    }

    /**
     * Récupère les demandes en attente avec filtrage Stream API
     * @param specialisteId ID du spécialiste
     * @return Demandes d'expertise en attente
     */
    public List<DemandeExpertise> getDemandesEnAttente(String specialisteId) {
        return getDemandesExpertiseFiltrées(specialisteId, StatutExpertise.EN_ATTENTE, null);
    }

    /**
     * Récupère les demandes urgentes
     * @param specialisteId ID du spécialiste
     * @return Demandes d'expertise urgentes
     */
    public List<DemandeExpertise> getDemandesUrgentes(String specialisteId) {
        return getDemandesExpertiseFiltrées(specialisteId, null, Priorite.URGENTE);
    }

    /**
     * US8: Répond à une demande d'expertise
     * @param demandeId ID de la demande
     * @param avisMedical Avis médical du spécialiste
     * @param recommandations Recommandations du spécialiste
     * @return La demande d'expertise mise à jour
     */
    public DemandeExpertise repondreExpertise(Long demandeId, String avisMedical, String recommandations) {
        Optional<DemandeExpertise> demandeOpt = demandeExpertiseRepository.findById(demandeId);

        if (demandeOpt.isEmpty()) {
            throw new IllegalArgumentException("Demande d'expertise introuvable");
        }

        DemandeExpertise demande = demandeOpt.get();

        if (!demande.getStatut().equals(StatutExpertise.EN_ATTENTE)) {
            throw new IllegalStateException("Cette demande a déjà été traitée");
        }

        // Marquer comme terminée
        demande.repondre(avisMedical, recommandations);

        return demandeExpertiseRepository.save(demande);
    }

    /**
     * Récupère une demande d'expertise par ID avec les détails du patient
     * @param demandeId ID de la demande
     * @return La demande d'expertise
     */
    public Optional<DemandeExpertise> getDemandeExpertiseById(Long demandeId) {
        return demandeExpertiseRepository.findById(demandeId);
    }

    /**
     * Statistiques du spécialiste
     * @param specialisteId ID du spécialiste
     * @return Objet contenant les statistiques
     */
    public SpecialisteStats getStatsSpecialiste(String specialisteId) {
        Optional<MedecinSpecialiste> specialisteOpt = specialisteRepository.findById(specialisteId);

        if (specialisteOpt.isEmpty()) {
            throw new IllegalArgumentException("Spécialiste introuvable");
        }

        MedecinSpecialiste specialiste = specialisteOpt.get();
        List<DemandeExpertise> demandes = demandeExpertiseRepository.findBySpecialiste(specialiste);

        // Stream API: Compter les demandes par statut
        long enAttente = demandes.stream()
                .filter(d -> d.getStatut() == StatutExpertise.EN_ATTENTE)
                .count();

        long terminees = demandes.stream()
                .filter(d -> d.getStatut() == StatutExpertise.TERMINEE)
                .count();

        long urgentes = demandes.stream()
                .filter(d -> d.getPriorite() == Priorite.URGENTE)
                .count();

        // Calcul du revenu
        double revenus = demandeExpertiseRepository.calculateRevenusBySpecialiste(specialiste);

        return new SpecialisteStats(demandes.size(), enAttente, terminees, urgentes, revenus);
    }

    /**
     * Annule une demande d'expertise et libère le créneau
     * @param demandeId ID de la demande
     */
    public void annulerExpertise(Long demandeId) {
        Optional<DemandeExpertise> demandeOpt = demandeExpertiseRepository.findById(demandeId);

        if (demandeOpt.isEmpty()) {
            throw new IllegalArgumentException("Demande d'expertise introuvable");
        }

        DemandeExpertise demande = demandeOpt.get();
        demande.annuler();
        demandeExpertiseRepository.save(demande);
    }

    private int getPrioriteOrder(Priorite priorite) {
        switch (priorite) {
            case URGENTE: return 3;
            case NON_URGENTE: return 2;
            case NORMALE: return 1;
            default: return 0;
        }
    }

    /**
     * Classe pour les statistiques du spécialiste
     */
    public static class SpecialisteStats {
        private final long total;
        private final long enAttente;
        private final long terminees;
        private final long urgentes;
        private final double revenus;

        public SpecialisteStats(long total, long enAttente, long terminees, long urgentes, double revenus) {
            this.total = total;
            this.enAttente = enAttente;
            this.terminees = terminees;
            this.urgentes = urgentes;
            this.revenus = revenus;
        }

        public long getTotal() { return total; }
        public long getEnAttente() { return enAttente; }
        public long getTerminees() { return terminees; }
        public long getUrgentes() { return urgentes; }
        public double getRevenus() { return revenus; }
    }
}