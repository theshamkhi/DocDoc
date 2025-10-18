package com.docdoc.docdoc.servlet.generaliste;

import com.docdoc.docdoc.model.Consultation;
import com.docdoc.docdoc.model.MedecinGeneraliste;
import com.docdoc.docdoc.model.enums.StatutConsultation;
import com.docdoc.docdoc.service.ConsultationService;
import com.docdoc.docdoc.service.PatientService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/generaliste/dashboard")
public class GeneralisteDashboardServlet extends HttpServlet {

    private ConsultationService consultationService;
    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        consultationService = new ConsultationService();
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        MedecinGeneraliste medecin = (MedecinGeneraliste) session.getAttribute("user");

        if (medecin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Consultation> toutesConsultations = consultationService.getConsultationsByMedecin(medecin);

            var consultationsDuJour = consultationService.getConsultationsDuJour(medecin);

            var consultationsEnCours = toutesConsultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.EN_COURS)
                    .collect(Collectors.toList());

            var consultationsTerminees = toutesConsultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .collect(Collectors.toList());

            var demandesExpertise = toutesConsultations.stream()
                    .filter(c -> c.getDemandesExpertise() != null && !c.getDemandesExpertise().isEmpty())
                    .collect(Collectors.toList());

            var patientsEnAttente = patientService.getPatientsEnAttente();

            var stats = consultationService.getStatsMedecin(medecin);

            request.setAttribute("medecin", medecin);
            request.setAttribute("consultationsDuJour", consultationsDuJour);
            request.setAttribute("consultationsEnCours", consultationsEnCours);
            request.setAttribute("consultationsTerminees", consultationsTerminees);
            request.setAttribute("demandesExpertise", demandesExpertise);
            request.setAttribute("patientsEnAttente", patientsEnAttente);
            request.setAttribute("stats", stats);

            String csrfToken = CSRFTokenUtil.getToken(session);
            request.setAttribute("csrfToken", csrfToken);

            request.getRequestDispatcher("/WEB-INF/views/generaliste/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/generaliste/dashboard.jsp")
                    .forward(request, response);
        }
    }
}