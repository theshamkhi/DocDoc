package com.docdoc.docdoc.service;

import com.docdoc.docdoc.model.*;
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

    public DemandeExpertise demanderExpertise(Long consultationId, String specialisteId,
                                              Long creneauId, String question,
                                              String donneesSupplementaires,
                                              String priorite) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);
        Optional<MedecinSpecialiste> specialisteOpt = specialisteRepository.findById(specialisteId);
        Optional<Creneau> creneauOpt = creneauRepository.findById(creneauId);

        if (consultationOpt.isEmpty() || specialisteOpt.isEmpty() || creneauOpt.isEmpty()) {
            throw new IllegalArgumentException("Ressource introuvable");
        }

        Consultation consultation = consultationOpt.get();
        MedecinSpecialiste specialiste = specialisteOpt.get();
        Creneau creneau = creneauOpt.get();

        if (!creneau.getDisponible()) {
            throw new IllegalStateException("Ce créneau n'est plus disponible");
        }

        DemandeExpertise demandeExpertise = new DemandeExpertise();
        demandeExpertise.setConsultation(consultation);
        demandeExpertise.setSpecialiste(specialiste);
        demandeExpertise.setCreneau(creneau);
        demandeExpertise.setQuestion(question);
        demandeExpertise.setDonneesSupplementaires(donneesSupplementaires);
        demandeExpertise.setPriorite(Enum.valueOf(com.docdoc.docdoc.model.enums.Priorite.class, priorite));

        creneau.reserver();
        creneauRepository.save(creneau);

        consultation.setDemandeExpertise(demandeExpertise);
        consultationRepository.save(consultation);

        return demandeExpertiseRepository.save(demandeExpertise);
    }

    public ActeTechnique ajouterActeTechnique(Long consultationId, String typeActe) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }

        com.docdoc.docdoc.model.enums.TypeActeTechnique type =
                com.docdoc.docdoc.model.enums.TypeActeTechnique.valueOf(typeActe);

        ActeTechnique acte = new ActeTechnique(consultationOpt.get(), type);
        return acteTechniqueRepository.save(acte);
    }

    public Double calculerCoutTotal(Long consultationId) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }

        Consultation consultation = consultationOpt.get();

        Double coutConsultation = consultation.getCoutConsultation();

        // Lambda + Stream: mapToDouble().sum() for technical acts
        List<ActeTechnique> actes = acteTechniqueRepository.findByConsultation(consultation);
        Double coutActes = actes.stream()
                .mapToDouble(ActeTechnique::getTarif)
                .sum();

        Double coutExpertise = 0.0;
        if (consultation.getDemandeExpertise() != null) {
            DemandeExpertise expertise = consultation.getDemandeExpertise();
            if (expertise.getCreneau() != null) {
                coutExpertise = expertise.getSpecialiste().getTarif();
            }
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