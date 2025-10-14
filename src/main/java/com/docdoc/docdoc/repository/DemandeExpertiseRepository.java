package com.docdoc.docdoc.repository;

import com.docdoc.docdoc.config.JPAUtil;
import com.docdoc.docdoc.model.DemandeExpertise;
import com.docdoc.docdoc.model.MedecinSpecialiste;
import com.docdoc.docdoc.model.enums.Priorite;
import com.docdoc.docdoc.model.enums.StatutExpertise;
import jakarta.persistence.EntityManager;
import java.util.List;

public class DemandeExpertiseRepository extends GenericRepository<DemandeExpertise, Long> {

    public DemandeExpertiseRepository() {
        super(DemandeExpertise.class);
    }

    @Override
    protected boolean isNew(DemandeExpertise entity) {
        return entity.getId() == null;
    }

    public List<DemandeExpertise> findBySpecialiste(MedecinSpecialiste specialiste) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT d FROM DemandeExpertise d WHERE d.specialiste = :specialiste " +
                    "ORDER BY d.dateDemande DESC";
            return em.createQuery(jpql, DemandeExpertise.class)
                    .setParameter("specialiste", specialiste)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findBySpecialisteAndStatut(MedecinSpecialiste specialiste, StatutExpertise statut) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT d FROM DemandeExpertise d " +
                    "WHERE d.specialiste = :specialiste AND d.statut = :statut " +
                    "ORDER BY d.dateDemande DESC";
            return em.createQuery(jpql, DemandeExpertise.class)
                    .setParameter("specialiste", specialiste)
                    .setParameter("statut", statut)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findBySpecialisteAndPriorite(MedecinSpecialiste specialiste, Priorite priorite) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT d FROM DemandeExpertise d " +
                    "WHERE d.specialiste = :specialiste AND d.priorite = :priorite " +
                    "ORDER BY d.dateDemande DESC";
            return em.createQuery(jpql, DemandeExpertise.class)
                    .setParameter("specialiste", specialiste)
                    .setParameter("priorite", priorite)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public long countBySpecialisteAndStatut(MedecinSpecialiste specialiste, StatutExpertise statut) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(d) FROM DemandeExpertise d " +
                    "WHERE d.specialiste = :specialiste AND d.statut = :statut";
            return em.createQuery(jpql, Long.class)
                    .setParameter("specialiste", specialiste)
                    .setParameter("statut", statut)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    public Double calculateRevenusBySpecialiste(MedecinSpecialiste specialiste) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT SUM(s.tarif) FROM DemandeExpertise d " +
                    "JOIN d.specialiste s " +
                    "WHERE d.specialiste = :specialiste AND d.statut = :statut";
            Double revenus = em.createQuery(jpql, Double.class)
                    .setParameter("specialiste", specialiste)
                    .setParameter("statut", StatutExpertise.TERMINEE)
                    .getSingleResult();
            return revenus != null ? revenus : 0.0;
        } finally {
            em.close();
        }
    }
}