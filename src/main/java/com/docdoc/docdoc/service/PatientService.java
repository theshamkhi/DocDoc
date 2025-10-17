package com.docdoc.docdoc.service;

import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.model.SigneVital;
import com.docdoc.docdoc.model.Infirmier;
import com.docdoc.docdoc.repository.PatientRepository;
import com.docdoc.docdoc.repository.SigneVitalRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import com.docdoc.docdoc.config.JPAUtil;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class PatientService {

    private final PatientRepository patientRepository;
    private final SigneVitalRepository signeVitalRepository;

    public PatientService() {
        this.patientRepository = new PatientRepository();
        this.signeVitalRepository = new SigneVitalRepository();
    }

    public Optional<Patient> rechercherPatient(String numeroSecuriteSociale) {
        return patientRepository.findByNumeroSecuriteSociale(numeroSecuriteSociale);
    }

    public Patient enregistrerNouveauPatient(Patient patient, SigneVital signeVital, Infirmier infirmier) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            // Vérifier si le patient existe déjà
            if (patientRepository.existsByNumeroSecuriteSociale(patient.getNumeroSecuriteSociale())) {
                throw new IllegalArgumentException("Un patient avec ce numéro de sécurité sociale existe déjà");
            }

            // Sauvegarder le patient
            patient.setDateEnregistrement(LocalDateTime.now());
            patient.setEnAttente(true);
            Patient savedPatient = em.merge(patient);

            // Ajouter les signes vitaux
            if (signeVital != null) {
                signeVital.setPatient(savedPatient);
                signeVital.setInfirmier(infirmier);
                signeVital.setDateMesure(LocalDateTime.now());
                em.merge(signeVital);
            }

            tx.commit();
            return savedPatient;

        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Erreur lors de l'enregistrement du patient", e);
        } finally {
            em.close();
        }
    }

    public SigneVital ajouterSignesVitaux(Patient patient, SigneVital signeVital, Infirmier infirmier) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            // Refresh patient to get latest state
            patient = em.merge(patient);

            signeVital.setPatient(patient);
            signeVital.setInfirmier(infirmier);
            signeVital.setDateMesure(LocalDateTime.now());
            SigneVital saved = em.merge(signeVital);

            // Mettre le patient en attente s'il ne l'est pas déjà
            if (!patient.getEnAttente()) {
                patient.setEnAttente(true);
                patient.setDateEnregistrement(LocalDateTime.now());
                em.merge(patient);
            }

            tx.commit();
            return saved;

        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Erreur lors de l'ajout des signes vitaux", e);
        } finally {
            em.close();
        }
    }

    public List<Patient> getPatientsDuJour() {
        List<Patient> patients = patientRepository.findPatientsDuJour();

        return patients.stream()
                .sorted((p1, p2) -> p1.getDateEnregistrement().compareTo(p2.getDateEnregistrement()))
                .collect(Collectors.toList());
    }

    public List<Patient> getPatientsEnAttente() {
        return patientRepository.findPatientsEnAttente();
    }

    public void retirerDeLaFileAttente(String patientId) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Patient patient = em.find(Patient.class, patientId);
            if (patient != null) {
                patient.setEnAttente(false);
                em.merge(patient);
            }

            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Erreur lors du retrait de la file d'attente", e);
        } finally {
            em.close();
        }
    }

    public void remettreEnAttente(String patientId) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Patient patient = em.find(Patient.class, patientId);
            if (patient != null) {
                patient.setEnAttente(true);
                patient.setDateEnregistrement(LocalDateTime.now());
                em.merge(patient);
            }

            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Erreur lors de la remise en attente", e);
        } finally {
            em.close();
        }
    }

    public boolean estEnAttente(String patientId) {
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        return patientOpt.map(Patient::getEnAttente).orElse(false);
    }

    public int getPositionDansFile(String patientId) {
        List<Patient> patientsEnAttente = getPatientsEnAttente();

        for (int i = 0; i < patientsEnAttente.size(); i++) {
            if (patientsEnAttente.get(i).getId().equals(patientId)) {
                return i + 1; // Position commence à 1
            }
        }

        return -1; // Patient pas dans la file
    }

    public Optional<Patient> getProchainPatient() {
        List<Patient> patientsEnAttente = getPatientsEnAttente();
        return patientsEnAttente.isEmpty() ? Optional.empty() : Optional.of(patientsEnAttente.get(0));
    }

    public List<SigneVital> getHistoriqueSignesVitaux(String patientId) {
        return signeVitalRepository.findByPatientId(patientId);
    }

    public Optional<Patient> getPatientById(String id) {
        return patientRepository.findById(id);
    }

    public Patient updatePatient(Patient patient) {
        return patientRepository.save(patient);
    }
}