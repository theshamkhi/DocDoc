package com.docdoc.docdoc.model.enums;

public enum TypeActeTechnique {
    RADIOGRAPHIE("Radiographie", 200.0),
    ECHOGRAPHIE("Échographie", 300.0),
    IRM("IRM", 800.0),
    ELECTROCARDIOGRAMME("Électrocardiogramme", 150.0),
    LASER_DERMATOLOGIQUE("Laser Dermatologique", 500.0),
    FOND_OEIL("Fond d'œil", 100.0),
    ANALYSE_SANG("Analyse de sang", 80.0),
    ANALYSE_URINE("Analyse d'urine", 50.0);

    private final String label;
    private final double tarif;

    TypeActeTechnique(String label, double tarif) {
        this.label = label;
        this.tarif = tarif;
    }

    public String getLabel() {
        return label;
    }

    public double getTarif() {
        return tarif;
    }
}