package com.docdoc.docdoc.repository;

import com.docdoc.docdoc.config.JPAUtil;
import com.docdoc.docdoc.model.Creneau;
import com.docdoc.docdoc.model.MedecinSpecialiste;
import jakarta.persistence.EntityManager;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

public class CreneauRepository extends GenericRepository<Creneau, Long> {

    public CreneauRepository() {
        super(Creneau.class);
    }

    @Override
    protected boolean isNew(Creneau entity) {
        return entity.getId() == null;
    }

    public List<Creneau> findBySpecialiste(MedecinSpecialiste specialiste) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT c FROM Creneau c WHERE c.specialiste = :specialiste " +
                    "ORDER BY c.dateCreneau ASC, c.heureDebut ASC";
            return em.createQuery(jpql, Creneau.class)
                    .setParameter("specialiste", specialiste)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Creneau> findCreneauxDisponibles(MedecinSpecialiste specialiste) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            LocalDate aujourdhui = LocalDate.now();

            String jpql = "SELECT c FROM Creneau c " +
                    "WHERE c.specialiste = :specialiste " +
                    "AND c.disponible = true " +
                    "AND c.dateCreneau >= :aujourdhui " +
                    "ORDER BY c.dateCreneau ASC, c.heureDebut ASC";
            return em.createQuery(jpql, Creneau.class)
                    .setParameter("specialiste", specialiste)
                    .setParameter("aujourdhui", aujourdhui)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Creneau> findBySpecialisteAndDate(MedecinSpecialiste specialiste, LocalDate date) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT c FROM Creneau c " +
                    "WHERE c.specialiste = :specialiste AND c.dateCreneau = :date " +
                    "ORDER BY c.heureDebut ASC";
            return em.createQuery(jpql, Creneau.class)
                    .setParameter("specialiste", specialiste)
                    .setParameter("date", date)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<Creneau> findBySpecialisteAndDateTime(MedecinSpecialiste specialiste,
                                                          LocalDate date, LocalTime heureDebut) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT c FROM Creneau c " +
                    "WHERE c.specialiste = :specialiste " +
                    "AND c.dateCreneau = :date " +
                    "AND c.heureDebut = :heureDebut";
            Creneau creneau = em.createQuery(jpql, Creneau.class)
                    .setParameter("specialiste", specialiste)
                    .setParameter("date", date)
                    .setParameter("heureDebut", heureDebut)
                    .getSingleResult();
            return Optional.of(creneau);
        } catch (Exception e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public boolean existsCreneau(MedecinSpecialiste specialiste, LocalDate date, LocalTime heureDebut) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(c) FROM Creneau c " +
                    "WHERE c.specialiste = :specialiste " +
                    "AND c.dateCreneau = :date " +
                    "AND c.heureDebut = :heureDebut";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("specialiste", specialiste)
                    .setParameter("date", date)
                    .setParameter("heureDebut", heureDebut)
                    .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }
}