package com.docdoc.docdoc.service;

import com.docdoc.docdoc.model.*;
import com.docdoc.docdoc.model.enums.Priorite;
import com.docdoc.docdoc.model.enums.Specialite;
import com.docdoc.docdoc.repository.*;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class ConsultationGeneralisteService {

    private final ConsultationRepository consultationRepository;
    private final DemandeExpertiseRepository demandeExpertiseRepository;
    private final MedecinSpecialisteRepository specialisteRepository;
    private final CreneauRepository creneauRepository;
    private final ActeTechniqueRepository acteTechniqueRepository;
    private final PatientRepository patientRepository;

    public ConsultationGeneralisteService() {
        this.consultationRepository = new ConsultationRepository();
        this.demandeExpertiseRepository = new DemandeExpertiseRepository();
        this.specialisteRepository = new MedecinSpecialisteRepository();
        this.creneauRepository = new CreneauRepository();
        this.acteTechniqueRepository = new ActeTechniqueRepository();
        this.patientRepository = new PatientRepository();
    }

    public Consultation creerConsultation(String patientId, MedecinGeneraliste medecin,
                                          String motif, String observations) {
        Optional<Patient> patientOpt = patientRepository.findById(patientId);

        if (patientOpt.isEmpty()) {
            throw new IllegalArgumentException("Patient introuvable");
        }

        Patient patient = patientOpt.get();

        Consultation consultation = new Consultation(patient, medecin, motif);
        consultation.setObservations(observations);

        patient.setEnAttente(false);
        patientRepository.save(patient);

        return consultationRepository.save(consultation);
    }

    public List<MedecinSpecialiste> obtenirSpecialistesBySpecialite(Specialite specialite) {
        List<MedecinSpecialiste> specialistes = specialisteRepository.findBySpecialiteOrderByTarif(specialite);

        return specialistes.stream()
                .filter(s -> s.getTarif() != null && s.getTarif() > 0)
                .sorted((s1, s2) -> Double.compare(s1.getTarif(), s2.getTarif()))
                .collect(Collectors.toList());
    }

    public List<Creneau> obtenirCreneauxDisponibles(String specialisteId) {
        Optional<MedecinSpecialiste> specialisteOpt = specialisteRepository.findById(specialisteId);

        if (specialisteOpt.isEmpty()) {
            throw new IllegalArgumentException("Spécialiste introuvable");
        }

        return creneauRepository.findCreneauxDisponibles(specialisteOpt.get());
    }

    /**
     * Demande une expertise - supports multiple expertise requests per consultation
     * Fixed to handle @OneToMany relationship properly
     */
    public DemandeExpertise demanderExpertise(Long consultationId, String specialisteId,
                                              Long creneauId, String question,
                                              String donneesSupplementaires,
                                              String prioriteStr) {

        // Validate all inputs first
        if (consultationId == null || consultationId <= 0) {
            throw new IllegalArgumentException("ID consultation invalide");
        }
        if (specialisteId == null || specialisteId.trim().isEmpty()) {
            throw new IllegalArgumentException("ID spécialiste invalide");
        }
        if (creneauId == null || creneauId <= 0) {
            throw new IllegalArgumentException("ID créneau invalide");
        }
        if (question == null || question.trim().isEmpty()) {
            throw new IllegalArgumentException("La question est obligatoire");
        }

        // Retrieve all entities FIRST
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);
        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable avec l'ID: " + consultationId);
        }

        Optional<MedecinSpecialiste> specialisteOpt = specialisteRepository.findById(specialisteId);
        if (specialisteOpt.isEmpty()) {
            throw new IllegalArgumentException("Spécialiste introuvable avec l'ID: " + specialisteId);
        }

        Optional<Creneau> creneauOpt = creneauRepository.findById(creneauId);
        if (creneauOpt.isEmpty()) {
            throw new IllegalArgumentException("Créneau introuvable avec l'ID: " + creneauId);
        }

        Consultation consultation = consultationOpt.get();
        MedecinSpecialiste specialiste = specialisteOpt.get();
        Creneau creneau = creneauOpt.get();

        // Verify creneau is available
        if (creneau.getDisponible() == null || !creneau.getDisponible()) {
            throw new IllegalStateException("Ce créneau n'est plus disponible. Veuillez en sélectionner un autre.");
        }

        // Verify creneau belongs to the specialist
        if (creneau.getSpecialiste() == null || !creneau.getSpecialiste().getId().equals(specialiste.getId())) {
            throw new IllegalStateException("Ce créneau ne correspond pas au spécialiste sélectionné");
        }

        // Parse priority
        Priorite priorite;
        try {
            priorite = Priorite.valueOf(prioriteStr != null ? prioriteStr.toUpperCase() : "NORMALE");
        } catch (IllegalArgumentException e) {
            priorite = Priorite.NORMALE;
        }

        try {
            // STEP 1: Reserve the creneau FIRST
            creneau.reserver();
            Creneau savedCreneau = creneauRepository.save(creneau);

            // STEP 2: Create and save the expertise request
            DemandeExpertise demandeExpertise = new DemandeExpertise();
            demandeExpertise.setConsultation(consultation);
            demandeExpertise.setSpecialiste(specialiste);
            demandeExpertise.setCreneau(savedCreneau); // Use the saved creneau
            demandeExpertise.setQuestion(question.trim());
            demandeExpertise.setDonneesSupplementaires(donneesSupplementaires != null ? donneesSupplementaires.trim() : "");
            demandeExpertise.setPriorite(priorite);

            // Ensure date is set
            if (demandeExpertise.getDateDemande() == null) {
                demandeExpertise.setDateDemande(java.time.LocalDateTime.now());
            }

            DemandeExpertise savedExpertise = demandeExpertiseRepository.save(demandeExpertise);

            // STEP 3: Add to consultation's list (supports multiple expertise requests)
            if (consultation.getDemandesExpertise() == null) {
                consultation.setDemandesExpertise(new java.util.ArrayList<>());
            }
            consultation.getDemandesExpertise().add(savedExpertise);
            consultationRepository.save(consultation);

            return savedExpertise;

        } catch (IllegalStateException e) {
            throw new IllegalStateException("Impossible de réserver ce créneau: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la sauvegarde de l'expertise. Détails: " + e.getMessage(), e);
        }
    }

    public ActeTechnique ajouterActeTechnique(Long consultationId, String typeActe) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }

        com.docdoc.docdoc.model.enums.TypeActeTechnique type;
        try {
            type = com.docdoc.docdoc.model.enums.TypeActeTechnique.valueOf(typeActe);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Type d'acte invalide: " + typeActe);
        }

        ActeTechnique acte = new ActeTechnique(consultationOpt.get(), type);
        return acteTechniqueRepository.save(acte);
    }

    /**
     * US4: Calcule le coût total avec Lambda/Stream API
     */
    public Double calculerCoutTotal(Long consultationId) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }

        Consultation consultation = consultationOpt.get();

        // Consultation cost (fixed)
        Double coutConsultation = consultation.getCoutConsultation(); // 150 DH

        // Technical acts cost (Lambda/Stream)
        List<ActeTechnique> actes = acteTechniqueRepository.findByConsultation(consultation);
        Double coutActes = actes.stream()
                .mapToDouble(ActeTechnique::getTarif)
                .sum();

        // Expertise cost - sum ALL expertise requests if multiple
        Double coutExpertise = 0.0;
        if (consultation.getDemandesExpertise() != null && !consultation.getDemandesExpertise().isEmpty()) {
            // Sum tariffs of all specialists involved in expertise requests
            coutExpertise = consultation.getDemandesExpertise().stream()
                    .mapToDouble(d -> d.getSpecialiste() != null ? d.getSpecialiste().getTarif() : 0.0)
                    .sum();
        }

        return coutConsultation + coutActes + coutExpertise;
    }

    public List<ActeTechnique> getActesTechniques(Long consultationId) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }

        return acteTechniqueRepository.findByConsultation(consultationOpt.get());
    }

    public Optional<Consultation> getConsultationById(Long consultationId) {
        return consultationRepository.findById(consultationId);
    }

    public Consultation cloturerConsultation(Long consultationId, String diagnostic, String traitement) {
        return new ConsultationService().cloturerConsultation(consultationId, diagnostic, traitement);
    }
}