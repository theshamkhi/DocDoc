package com.docdoc.docdoc.repository;

import com.docdoc.docdoc.config.JPAUtil;
import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.model.SigneVital;
import jakarta.persistence.EntityManager;
import java.util.List;

public class SigneVitalRepository extends GenericRepository<SigneVital, Long> {

    public SigneVitalRepository() {
        super(SigneVital.class);
    }

    @Override
    protected boolean isNew(SigneVital entity) {
        return entity.getId() == null;
    }

    public List<SigneVital> findByPatient(Patient patient) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT s FROM SigneVital s WHERE s.patient = :patient " +
                    "ORDER BY s.dateMesure DESC";
            return em.createQuery(jpql, SigneVital.class)
                    .setParameter("patient", patient)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<SigneVital> findByPatientId(String patientId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT s FROM SigneVital s WHERE s.patient.id = :patientId " +
                    "ORDER BY s.dateMesure DESC";
            return em.createQuery(jpql, SigneVital.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}