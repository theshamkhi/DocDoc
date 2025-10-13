package com.docdoc.docdoc.model;

import com.docdoc.docdoc.model.enums.Role;
import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "medecins_generalistes")
public class MedecinGeneraliste extends User {

    @OneToMany(mappedBy = "medecin", cascade = CascadeType.ALL)
    private List<Consultation> consultations = new ArrayList<>();

    public MedecinGeneraliste() {
        super();
        setRole(Role.GENERALISTE);
    }

    public MedecinGeneraliste(String email, String password, String nom, String prenom) {
        super(email, password, nom, prenom, Role.GENERALISTE);
    }

    public List<Consultation> getConsultations() { return consultations; }
    public void setConsultations(List<Consultation> consultations) { this.consultations = consultations; }
}