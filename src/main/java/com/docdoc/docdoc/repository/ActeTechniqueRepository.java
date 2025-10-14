package com.docdoc.docdoc.repository;

import com.docdoc.docdoc.config.JPAUtil;
import com.docdoc.docdoc.model.ActeTechnique;
import com.docdoc.docdoc.model.Consultation;
import jakarta.persistence.EntityManager;
import java.util.List;

public class ActeTechniqueRepository extends GenericRepository<ActeTechnique, Long> {

    public ActeTechniqueRepository() {
        super(ActeTechnique.class);
    }

    @Override
    protected boolean isNew(ActeTechnique entity) {
        return entity.getId() == null;
    }

    public List<ActeTechnique> findByConsultation(Consultation consultation) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT a FROM ActeTechnique a WHERE a.consultation = :consultation " +
                    "ORDER BY a.dateRealisation DESC";
            return em.createQuery(jpql, ActeTechnique.class)
                    .setParameter("consultation", consultation)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}