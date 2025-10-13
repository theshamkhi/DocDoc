package com.docdoc.docdoc.repository;

import com.docdoc.docdoc.model.MedecinSpecialiste;
import com.docdoc.docdoc.config.JPAUtil;
import com.docdoc.docdoc.model.enums.Specialite;
import jakarta.persistence.EntityManager;
import java.util.List;

public class MedecinSpecialisteRepository extends GenericRepository<MedecinSpecialiste, String> {

    public MedecinSpecialisteRepository() {
        super(MedecinSpecialiste.class);
    }

    @Override
    protected boolean isNew(MedecinSpecialiste entity) {
        return entity.getId() == null;
    }

    public List<MedecinSpecialiste> findBySpecialite(Specialite specialite) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT m FROM MedecinSpecialiste m WHERE m.specialite = :specialite";
            return em.createQuery(jpql, MedecinSpecialiste.class)
                    .setParameter("specialite", specialite)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<MedecinSpecialiste> findBySpecialiteOrderByTarif(Specialite specialite) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT m FROM MedecinSpecialiste m " +
                    "WHERE m.specialite = :specialite " +
                    "ORDER BY m.tarif ASC";
            return em.createQuery(jpql, MedecinSpecialiste.class)
                    .setParameter("specialite", specialite)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}