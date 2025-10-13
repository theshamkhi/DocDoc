package com.docdoc.docdoc.model;

import com.docdoc.docdoc.model.enums.Role;
import com.docdoc.docdoc.model.enums.Specialite;
import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "medecins_specialistes")
public class MedecinSpecialiste extends User {

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Specialite specialite;

    @Column(nullable = false)
    private Double tarif = 300.0;

    @Column(name = "duree_consultation")
    private Integer dureeConsultation = 30; // en minutes

    @OneToMany(mappedBy = "specialiste", cascade = CascadeType.ALL)
    private List<DemandeExpertise> demandesExpertise = new ArrayList<>();

    @OneToMany(mappedBy = "specialiste", cascade = CascadeType.ALL)
    private List<Creneau> creneaux = new ArrayList<>();

    public MedecinSpecialiste() {
        super();
        setRole(Role.SPECIALISTE);
    }

    public MedecinSpecialiste(String email, String password, String nom, String prenom, Specialite specialite) {
        super(email, password, nom, prenom, Role.SPECIALISTE);
        this.specialite = specialite;
    }

    // Getters et Setters
    public Specialite getSpecialite() { return specialite; }
    public void setSpecialite(Specialite specialite) { this.specialite = specialite; }

    public Double getTarif() { return tarif; }
    public void setTarif(Double tarif) { this.tarif = tarif; }

    public Integer getDureeConsultation() { return dureeConsultation; }
    public void setDureeConsultation(Integer dureeConsultation) { this.dureeConsultation = dureeConsultation; }

    public List<DemandeExpertise> getDemandesExpertise() { return demandesExpertise; }
    public void setDemandesExpertise(List<DemandeExpertise> demandesExpertise) {
        this.demandesExpertise = demandesExpertise;
    }

    public List<Creneau> getCreneaux() { return creneaux; }
    public void setCreneaux(List<Creneau> creneaux) { this.creneaux = creneaux; }
}