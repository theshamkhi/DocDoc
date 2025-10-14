package com.docdoc.docdoc.repository;

import com.docdoc.docdoc.config.JPAUtil;
import com.docdoc.docdoc.model.Consultation;
import com.docdoc.docdoc.model.MedecinGeneraliste;
import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.model.enums.StatutConsultation;
import jakarta.persistence.EntityManager;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class ConsultationRepository extends GenericRepository<Consultation, Long> {

    public ConsultationRepository() {
        super(Consultation.class);
    }

    @Override
    protected boolean isNew(Consultation entity) {
        return entity.getId() == null;
    }

    public List<Consultation> findByPatient(Patient patient) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT c FROM Consultation c WHERE c.patient = :patient " +
                    "ORDER BY c.dateConsultation DESC";
            return em.createQuery(jpql, Consultation.class)
                    .setParameter("patient", patient)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByMedecin(MedecinGeneraliste medecin) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT c FROM Consultation c WHERE c.medecin = :medecin " +
                    "ORDER BY c.dateConsultation DESC";
            return em.createQuery(jpql, Consultation.class)
                    .setParameter("medecin", medecin)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByStatut(StatutConsultation statut) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT c FROM Consultation c WHERE c.statut = :statut " +
                    "ORDER BY c.dateConsultation DESC";
            return em.createQuery(jpql, Consultation.class)
                    .setParameter("statut", statut)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findConsultationsDuJour() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            LocalDateTime debutJournee = LocalDate.now().atStartOfDay();
            LocalDateTime finJournee = LocalDate.now().atTime(23, 59, 59);

            String jpql = "SELECT c FROM Consultation c " +
                    "WHERE c.dateConsultation BETWEEN :debut AND :fin " +
                    "ORDER BY c.dateConsultation DESC";
            return em.createQuery(jpql, Consultation.class)
                    .setParameter("debut", debutJournee)
                    .setParameter("fin", finJournee)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}