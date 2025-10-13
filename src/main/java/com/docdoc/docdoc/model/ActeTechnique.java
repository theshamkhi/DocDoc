package com.docdoc.docdoc.model;

import com.docdoc.docdoc.model.enums.TypeActeTechnique;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "actes_techniques")
public class ActeTechnique {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "consultation_id", nullable = false)
    private Consultation consultation;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TypeActeTechnique type;

    @Column(nullable = false)
    private Double tarif;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "date_realisation")
    private LocalDateTime dateRealisation;

    @PrePersist
    protected void onCreate() {
        if (dateRealisation == null) {
            dateRealisation = LocalDateTime.now();
        }
        if (tarif == null && type != null) {
            tarif = type.getTarif();
        }
    }

    // Constructeurs
    public ActeTechnique() {}

    public ActeTechnique(TypeActeTechnique type) {
        this.type = type;
        this.tarif = type.getTarif();
    }

    public ActeTechnique(Consultation consultation, TypeActeTechnique type) {
        this.consultation = consultation;
        this.type = type;
        this.tarif = type.getTarif();
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Consultation getConsultation() { return consultation; }
    public void setConsultation(Consultation consultation) { this.consultation = consultation; }

    public TypeActeTechnique getType() { return type; }
    public void setType(TypeActeTechnique type) {
        this.type = type;
        if (type != null && this.tarif == null) {
            this.tarif = type.getTarif();
        }
    }

    public Double getTarif() { return tarif; }
    public void setTarif(Double tarif) { this.tarif = tarif; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getDateRealisation() { return dateRealisation; }
    public void setDateRealisation(LocalDateTime dateRealisation) {
        this.dateRealisation = dateRealisation;
    }
}