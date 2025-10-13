package com.docdoc.docdoc.repository;

import com.docdoc.docdoc.model.Infirmier;

public class InfirmierRepository extends GenericRepository<Infirmier, String> {

    public InfirmierRepository() {
        super(Infirmier.class);
    }

    @Override
    protected boolean isNew(Infirmier entity) {
        return entity.getId() == null;
    }
}