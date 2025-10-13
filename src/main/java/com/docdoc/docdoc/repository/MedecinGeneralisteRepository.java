package com.docdoc.docdoc.repository;

import com.docdoc.docdoc.model.MedecinGeneraliste;

public class MedecinGeneralisteRepository extends GenericRepository<MedecinGeneraliste, String> {

    public MedecinGeneralisteRepository() {
        super(MedecinGeneraliste.class);
    }

    @Override
    protected boolean isNew(MedecinGeneraliste entity) {
        return entity.getId() == null;
    }
}