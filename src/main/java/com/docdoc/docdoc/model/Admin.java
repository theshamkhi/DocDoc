package com.docdoc.docdoc.model;

import com.docdoc.docdoc.model.enums.Role;
import jakarta.persistence.Entity;
import jakarta.persistence.DiscriminatorValue;


@Entity
@DiscriminatorValue("ADMIN")
public class Admin extends User {

    public Admin() {
        super();
        this.setRole(Role.ADMIN);
    }

    public Admin(String email, String password, String nom, String prenom) {
        super(email, password, nom, prenom, Role.ADMIN);
    }

    public boolean isAdmin() {
        return true;
    }

}
