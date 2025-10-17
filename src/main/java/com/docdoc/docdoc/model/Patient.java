package com.docdoc.docdoc.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

@Entity
@Table(name = "patients")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String nom;

    @Column(nullable = false)
    private String prenom;

    @Column(name = "date_naissance", nullable = false)
    private LocalDate dateNaissance;

    @Column(name = "numero_securite_sociale", unique = true, nullable = false)
    private String numeroSecuriteSociale;

    private String telephone;

    @Column(name = "date_enregistrement")
    private LocalDateTime dateEnregistrement;

    @Column(name = "en_attente")
    private Boolean enAttente = false;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL)
    private List<SigneVital> signesVitaux = new ArrayList<>();

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL)
    private List<Consultation> consultations = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        if (dateEnregistrement == null) {
            dateEnregistrement = LocalDateTime.now();
        }
    }

    // Constructeurs
    public Patient() {}

    public Patient(String nom, String prenom, LocalDate dateNaissance, String numeroSecuriteSociale) {
        this.nom = nom;
        this.prenom = prenom;
        this.dateNaissance = dateNaissance;
        this.numeroSecuriteSociale = numeroSecuriteSociale;
    }

    // Getters et Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; }

    public Date getDateNaissance() {
        return Date.from(this.dateNaissance.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

    public String getNumeroSecuriteSociale() { return numeroSecuriteSociale; }
    public void setNumeroSecuriteSociale(String numeroSecuriteSociale) {
        this.numeroSecuriteSociale = numeroSecuriteSociale;
    }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public Date getDateEnregistrement() {
        return Date.from(this.dateEnregistrement.atZone(ZoneId.systemDefault()).toInstant());
    }

    public void setDateEnregistrement(LocalDateTime dateEnregistrement) {
        this.dateEnregistrement = dateEnregistrement;
    }

    public Boolean getEnAttente() { return enAttente; }
    public void setEnAttente(Boolean enAttente) { this.enAttente = enAttente; }

    public List<SigneVital> getSignesVitaux() { return signesVitaux; }
    public void setSignesVitaux(List<SigneVital> signesVitaux) { this.signesVitaux = signesVitaux; }

    public List<Consultation> getConsultations() { return consultations; }
    public void setConsultations(List<Consultation> consultations) { this.consultations = consultations; }

    public String getFullName() {
        return prenom + " " + nom;
    }

    public SigneVital getDernierSigneVital() {
        return signesVitaux.isEmpty() ? null : signesVitaux.get(signesVitaux.size() - 1);
    }
}