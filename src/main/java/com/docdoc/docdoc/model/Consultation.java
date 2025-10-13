package com.docdoc.docdoc.model;

import com.docdoc.docdoc.model.enums.StatutConsultation;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "consultations")
public class Consultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "medecin_id", nullable = false)
    private MedecinGeneraliste medecin;

    @Column(nullable = false)
    private String motif;

    @Column(columnDefinition = "TEXT")
    private String observations;

    @Column(columnDefinition = "TEXT")
    private String diagnostic;

    @Column(columnDefinition = "TEXT")
    private String traitement;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutConsultation statut = StatutConsultation.EN_COURS;

    @Column(name = "cout_consultation", nullable = false)
    private Double coutConsultation = 150.0;

    @Column(name = "date_consultation", nullable = false)
    private LocalDateTime dateConsultation;

    @Column(name = "date_cloture")
    private LocalDateTime dateCloture;

    @OneToMany(mappedBy = "consultation", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ActeTechnique> actesTechniques = new ArrayList<>();

    @OneToOne(mappedBy = "consultation", cascade = CascadeType.ALL)
    private DemandeExpertise demandeExpertise;

    @PrePersist
    protected void onCreate() {
        if (dateConsultation == null) {
            dateConsultation = LocalDateTime.now();
        }
    }

    // Constructeurs
    public Consultation() {}

    public Consultation(Patient patient, MedecinGeneraliste medecin, String motif) {
        this.patient = patient;
        this.medecin = medecin;
        this.motif = motif;
    }

    // Méthodes métier
    public void ajouterActeTechnique(ActeTechnique acte) {
        actesTechniques.add(acte);
        acte.setConsultation(this);
    }

    public void cloturer() {
        this.statut = StatutConsultation.TERMINEE;
        this.dateCloture = LocalDateTime.now();
    }

    public double calculerCoutTotal() {
        double coutActes = actesTechniques.stream()
                .mapToDouble(ActeTechnique::getTarif)
                .sum();

        double coutExpertise = 0.0;
        if (demandeExpertise != null && demandeExpertise.getCreneau() != null) {
            coutExpertise = demandeExpertise.getCreneau().getSpecialiste().getTarif();
        }

        return coutConsultation + coutActes + coutExpertise;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public MedecinGeneraliste getMedecin() { return medecin; }
    public void setMedecin(MedecinGeneraliste medecin) { this.medecin = medecin; }

    public String getMotif() { return motif; }
    public void setMotif(String motif) { this.motif = motif; }

    public String getObservations() { return observations; }
    public void setObservations(String observations) { this.observations = observations; }

    public String getDiagnostic() { return diagnostic; }
    public void setDiagnostic(String diagnostic) { this.diagnostic = diagnostic; }

    public String getTraitement() { return traitement; }
    public void setTraitement(String traitement) { this.traitement = traitement; }

    public StatutConsultation getStatut() { return statut; }
    public void setStatut(StatutConsultation statut) { this.statut = statut; }

    public Double getCoutConsultation() { return coutConsultation; }
    public void setCoutConsultation(Double coutConsultation) { this.coutConsultation = coutConsultation; }

    public LocalDateTime getDateConsultation() { return dateConsultation; }
    public void setDateConsultation(LocalDateTime dateConsultation) {
        this.dateConsultation = dateConsultation;
    }

    public LocalDateTime getDateCloture() { return dateCloture; }
    public void setDateCloture(LocalDateTime dateCloture) { this.dateCloture = dateCloture; }

    public List<ActeTechnique> getActesTechniques() { return actesTechniques; }
    public void setActesTechniques(List<ActeTechnique> actesTechniques) {
        this.actesTechniques = actesTechniques;
    }

    public DemandeExpertise getDemandeExpertise() { return demandeExpertise; }
    public void setDemandeExpertise(DemandeExpertise demandeExpertise) {
        this.demandeExpertise = demandeExpertise;
    }
}