package com.docdoc.docdoc.model;

import com.docdoc.docdoc.model.enums.Role;
import jakarta.persistence.*;

@Entity
@Table(name = "infirmiers")
public class Infirmier extends User {

    public Infirmier() {
        super();
        setRole(Role.INFIRMIER);
    }

    public Infirmier(String email, String password, String nom, String prenom) {
        super(email, password, nom, prenom, Role.INFIRMIER);
    }
}