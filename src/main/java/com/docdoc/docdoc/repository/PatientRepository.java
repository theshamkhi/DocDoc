package com.docdoc.docdoc.repository;

import com.docdoc.docdoc.config.JPAUtil;
import com.docdoc.docdoc.model.Patient;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class PatientRepository extends GenericRepository<Patient, String> {

    public PatientRepository() {
        super(Patient.class);
    }

    @Override
    protected boolean isNew(Patient entity) {
        return entity.getId() == null;
    }

    public Optional<Patient> findByNumeroSecuriteSociale(String numeroSS) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT p FROM Patient p WHERE p.numeroSecuriteSociale = :numero";
            Patient patient = em.createQuery(jpql, Patient.class)
                    .setParameter("numero", numeroSS)
                    .getSingleResult();
            return Optional.of(patient);
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<Patient> findPatientsEnAttente() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT p FROM Patient p WHERE p.enAttente = true " +
                    "ORDER BY p.dateEnregistrement ASC";
            return em.createQuery(jpql, Patient.class).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Patient> findPatientsDuJour() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            LocalDateTime debutJournee = LocalDate.now().atStartOfDay();
            LocalDateTime finJournee = LocalDate.now().atTime(23, 59, 59);

            String jpql = "SELECT p FROM Patient p " +
                    "WHERE p.dateEnregistrement BETWEEN :debut AND :fin " +
                    "ORDER BY p.dateEnregistrement ASC";
            return em.createQuery(jpql, Patient.class)
                    .setParameter("debut", debutJournee)
                    .setParameter("fin", finJournee)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean existsByNumeroSecuriteSociale(String numeroSS) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Patient p WHERE p.numeroSecuriteSociale = :numero";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("numero", numeroSS)
                    .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }
}