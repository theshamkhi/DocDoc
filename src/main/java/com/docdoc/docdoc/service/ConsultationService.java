package com.docdoc.docdoc.service;

import com.docdoc.docdoc.model.Consultation;
import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.model.MedecinGeneraliste;
import com.docdoc.docdoc.model.enums.StatutConsultation;
import com.docdoc.docdoc.repository.ConsultationRepository;
import com.docdoc.docdoc.repository.PatientRepository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class ConsultationService {

    private final ConsultationRepository consultationRepository;
    private final PatientRepository patientRepository;

    public ConsultationService() {
        this.consultationRepository = new ConsultationRepository();
        this.patientRepository = new PatientRepository();
    }

    public Consultation creerConsultation(Patient patient, MedecinGeneraliste medecin, String motif) {
        Consultation consultation = new Consultation(patient, medecin, motif);
        consultation.setDateConsultation(LocalDateTime.now());
        return consultationRepository.save(consultation);
    }

    public List<Consultation> getConsultationsByPatient(Patient patient) {
        return consultationRepository.findByPatient(patient);
    }

    public List<Consultation> getConsultationsByMedecin(MedecinGeneraliste medecin) {
        return consultationRepository.findByMedecin(medecin);
    }

    public List<Consultation> getConsultationsEnCours(MedecinGeneraliste medecin) {
        return consultationRepository.findByMedecin(medecin).stream()
                .filter(c -> c.getStatut() == StatutConsultation.EN_COURS)
                .sorted((c1, c2) -> c1.getDateConsultation().compareTo(c2.getDateConsultation()))
                .collect(Collectors.toList());
    }

    public List<Consultation> getConsultationsDuJour() {
        return consultationRepository.findConsultationsDuJour();
    }

    public List<Consultation> getConsultationsDuJour(MedecinGeneraliste medecin) {
        return consultationRepository.findConsultationsDuJour().stream()
                .filter(c -> c.getMedecin().equals(medecin))
                .collect(Collectors.toList());
    }

    public Consultation updateConsultation(Consultation consultation) {
        return consultationRepository.save(consultation);
    }

    public Consultation cloturerConsultation(Long consultationId, String diagnostic, String traitement) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation non trouvée");
        }

        Consultation consultation = consultationOpt.get();
        consultation.setDiagnostic(diagnostic);
        consultation.setTraitement(traitement);
        consultation.cloturer();

        // Automatically remove patient from queue
        Patient patient = consultation.getPatient();
        patient.setEnAttente(false);
        patientRepository.save(patient);

        return consultationRepository.save(consultation);
    }

    public Optional<Consultation> getConsultationById(Long id) {
        return consultationRepository.findById(id);
    }

    public Patient getProchainPatientEnAttente() {
        return consultationRepository.getProchainPatient();
    }

    public long getNombreConsultationsDuJour(MedecinGeneraliste medecin) {
        return getConsultationsDuJour(medecin).size();
    }

    public ConsultationStats getStatsMedecin(MedecinGeneraliste medecin) {
        List<Consultation> consultations = consultationRepository.findByMedecin(medecin);

        long enCours = consultations.stream()
                .filter(c -> c.getStatut() == StatutConsultation.EN_COURS)
                .count();

        long terminees = consultations.stream()
                .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                .count();

        double revenuTotal = consultations.stream()
                .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                .mapToDouble(Consultation::calculerCoutTotal)
                .sum();

        return new ConsultationStats(consultations.size(), enCours, terminees, revenuTotal);
    }

    public static class ConsultationStats {
        private final long total;
        private final long enCours;
        private final long terminees;
        private final double revenuTotal;

        public ConsultationStats(long total, long enCours, long terminees, double revenuTotal) {
            this.total = total;
            this.enCours = enCours;
            this.terminees = terminees;
            this.revenuTotal = revenuTotal;
        }

        public long getTotal() { return total; }
        public long getEnCours() { return enCours; }
        public long getTerminees() { return terminees; }
        public double getRevenuTotal() { return revenuTotal; }
    }
}