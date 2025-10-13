package com.docdoc.docdoc.model.enums;

public enum Specialite {
    CARDIOLOGIE("Cardiologie"),
    PNEUMOLOGIE("Pneumologie"),
    DERMATOLOGIE("Dermatologie"),
    NEUROLOGIE("Neurologie"),
    ENDOCRINOLOGIE("Endocrinologie"),
    GASTROENTEROLOGIE("Gastroentérologie"),
    RHUMATOLOGIE("Rhumatologie"),
    OPHTALMOLOGIE("Ophtalmologie"),
    ORL("ORL"),
    PEDIATRIE("Pédiatrie");

    private final String label;

    Specialite(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}