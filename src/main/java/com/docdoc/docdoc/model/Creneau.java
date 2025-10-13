package com.docdoc.docdoc.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

@Entity
@Table(name = "creneaux", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"specialiste_id", "date_creneau", "heure_debut"})
})
public class Creneau {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "specialiste_id", nullable = false)
    private MedecinSpecialiste specialiste;

    @Column(name = "date_creneau", nullable = false)
    private LocalDate dateCreneau;

    @Column(name = "heure_debut", nullable = false)
    private LocalTime heureDebut;

    @Column(name = "heure_fin", nullable = false)
    private LocalTime heureFin;

    @Column(nullable = false)
    private Boolean disponible = true;

    @OneToOne(mappedBy = "creneau")
    private DemandeExpertise demandeExpertise;

    // Constructeurs
    public Creneau() {}

    public Creneau(MedecinSpecialiste specialiste, LocalDate dateCreneau,
                   LocalTime heureDebut, LocalTime heureFin) {
        this.specialiste = specialiste;
        this.dateCreneau = dateCreneau;
        this.heureDebut = heureDebut;
        this.heureFin = heureFin;
    }

    // Méthodes métier
    public boolean estFutur() {
        LocalDateTime maintenant = LocalDateTime.now();
        LocalDateTime debutCreneau = LocalDateTime.of(dateCreneau, heureDebut);
        return debutCreneau.isAfter(maintenant);
    }

    public boolean estPasse() {
        return !estFutur();
    }

    public void reserver() {
        if (!disponible) {
            throw new IllegalStateException("Ce créneau n'est pas disponible");
        }
        if (estPasse()) {
            throw new IllegalStateException("Ce créneau est déjà passé");
        }
        this.disponible = false;
    }

    public void liberer() {
        if (estFutur()) {
            this.disponible = true;
        }
    }

    public String getPlageHoraire() {
        return heureDebut + " - " + heureFin;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public MedecinSpecialiste getSpecialiste() { return specialiste; }
    public void setSpecialiste(MedecinSpecialiste specialiste) { this.specialiste = specialiste; }

    public LocalDate getDateCreneau() { return dateCreneau; }
    public void setDateCreneau(LocalDate dateCreneau) { this.dateCreneau = dateCreneau; }

    public LocalTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalTime heureDebut) { this.heureDebut = heureDebut; }

    public LocalTime getHeureFin() { return heureFin; }
    public void setHeureFin(LocalTime heureFin) { this.heureFin = heureFin; }

    public Boolean getDisponible() { return disponible; }
    public void setDisponible(Boolean disponible) { this.disponible = disponible; }

    public DemandeExpertise getDemandeExpertise() { return demandeExpertise; }
    public void setDemandeExpertise(DemandeExpertise demandeExpertise) {
        this.demandeExpertise = demandeExpertise;
    }
}