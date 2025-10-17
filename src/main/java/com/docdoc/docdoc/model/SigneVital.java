package com.docdoc.docdoc.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Entity
@Table(name = "signes_vitaux")
public class SigneVital {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "tension_arterielle")
    private String tensionArterielle; // Ex: "120/80"

    @Column(name = "frequence_cardiaque")
    private Integer frequenceCardiaque; // bpm

    @Column(name = "temperature")
    private Double temperature; // °C

    @Column(name = "frequence_respiratoire")
    private Integer frequenceRespiratoire; // par minute

    @Column(name = "poids")
    private Double poids; // kg

    @Column(name = "taille")
    private Double taille; // cm

    @Column(name = "date_mesure", nullable = false)
    private LocalDateTime dateMesure;

    @ManyToOne
    @JoinColumn(name = "infirmier_id")
    private Infirmier infirmier;

    @PrePersist
    protected void onCreate() {
        if (dateMesure == null) {
            dateMesure = LocalDateTime.now();
        }
    }

    // Constructeurs
    public SigneVital() {}

    public SigneVital(Patient patient, Infirmier infirmier) {
        this.patient = patient;
        this.infirmier = infirmier;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public String getTensionArterielle() { return tensionArterielle; }
    public void setTensionArterielle(String tensionArterielle) {
        this.tensionArterielle = tensionArterielle;
    }

    public Integer getFrequenceCardiaque() { return frequenceCardiaque; }
    public void setFrequenceCardiaque(Integer frequenceCardiaque) {
        this.frequenceCardiaque = frequenceCardiaque;
    }

    public Double getTemperature() { return temperature; }
    public void setTemperature(Double temperature) { this.temperature = temperature; }

    public Integer getFrequenceRespiratoire() { return frequenceRespiratoire; }
    public void setFrequenceRespiratoire(Integer frequenceRespiratoire) {
        this.frequenceRespiratoire = frequenceRespiratoire;
    }

    public Double getPoids() { return poids; }
    public void setPoids(Double poids) { this.poids = poids; }

    public Double getTaille() { return taille; }
    public void setTaille(Double taille) { this.taille = taille; }

    public Date getDateMesure() {
        return dateMesure != null ? Date.from(dateMesure.atZone(ZoneId.systemDefault()).toInstant()) : null;
    }
    public void setDateMesure(LocalDateTime dateMesure) { this.dateMesure = dateMesure; }

    public Infirmier getInfirmier() { return infirmier; }
    public void setInfirmier(Infirmier infirmier) { this.infirmier = infirmier; }
}