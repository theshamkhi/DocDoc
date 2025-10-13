package com.docdoc.docdoc.model;

import com.docdoc.docdoc.model.enums.Priorite;
import com.docdoc.docdoc.model.enums.StatutExpertise;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "demandes_expertise")
public class DemandeExpertise {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "consultation_id", nullable = false)
    private Consultation consultation;

    @ManyToOne
    @JoinColumn(name = "specialiste_id", nullable = false)
    private MedecinSpecialiste specialiste;

    @OneToOne
    @JoinColumn(name = "creneau_id")
    private Creneau creneau;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String question;

    @Column(columnDefinition = "TEXT")
    private String donneesSupplementaires;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Priorite priorite = Priorite.NORMALE;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutExpertise statut = StatutExpertise.EN_ATTENTE;

    @Column(columnDefinition = "TEXT")
    private String avisMedical;

    @Column(columnDefinition = "TEXT")
    private String recommandations;

    @Column(name = "date_demande", nullable = false)
    private LocalDateTime dateDemande;

    @Column(name = "date_reponse")
    private LocalDateTime dateReponse;

    @PrePersist
    protected void onCreate() {
        if (dateDemande == null) {
            dateDemande = LocalDateTime.now();
        }
    }

    // Constructeurs
    public DemandeExpertise() {}

    public DemandeExpertise(Consultation consultation, MedecinSpecialiste specialiste,
                            String question, Priorite priorite) {
        this.consultation = consultation;
        this.specialiste = specialiste;
        this.question = question;
        this.priorite = priorite;
    }

    // Méthodes métier
    public void repondre(String avisMedical, String recommandations) {
        this.avisMedical = avisMedical;
        this.recommandations = recommandations;
        this.statut = StatutExpertise.TERMINEE;
        this.dateReponse = LocalDateTime.now();
    }

    public void annuler() {
        this.statut = StatutExpertise.ANNULEE;
        if (this.creneau != null) {
            this.creneau.liberer();
        }
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Consultation getConsultation() { return consultation; }
    public void setConsultation(Consultation consultation) { this.consultation = consultation; }

    public MedecinSpecialiste getSpecialiste() { return specialiste; }
    public void setSpecialiste(MedecinSpecialiste specialiste) { this.specialiste = specialiste; }

    public Creneau getCreneau() { return creneau; }
    public void setCreneau(Creneau creneau) { this.creneau = creneau; }

    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }

    public String getDonneesSupplementaires() { return donneesSupplementaires; }
    public void setDonneesSupplementaires(String donneesSupplementaires) {
        this.donneesSupplementaires = donneesSupplementaires;
    }

    public Priorite getPriorite() { return priorite; }
    public void setPriorite(Priorite priorite) { this.priorite = priorite; }

    public StatutExpertise getStatut() { return statut; }
    public void setStatut(StatutExpertise statut) { this.statut = statut; }

    public String getAvisMedical() { return avisMedical; }
    public void setAvisMedical(String avisMedical) { this.avisMedical = avisMedical; }

    public String getRecommandations() { return recommandations; }
    public void setRecommandations(String recommandations) { this.recommandations = recommandations; }

    public LocalDateTime getDateDemande() { return dateDemande; }
    public void setDateDemande(LocalDateTime dateDemande) { this.dateDemande = dateDemande; }

    public LocalDateTime getDateReponse() { return dateReponse; }
    public void setDateReponse(LocalDateTime dateReponse) { this.dateReponse = dateReponse; }
}
