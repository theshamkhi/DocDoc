package com.docdoc.docdoc.servlet.generaliste;

import com.docdoc.docdoc.model.MedecinGeneraliste;
import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.service.ConsultationGeneralisteService;
import com.docdoc.docdoc.service.PatientService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/generaliste/consultation/creer")
public class CreerConsultationServlet extends HttpServlet {

    private ConsultationGeneralisteService consultationService;
    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        consultationService = new ConsultationGeneralisteService();
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer les patients en attente
        List<Patient> patientsEnAttente = patientService.getPatientsEnAttente();

        request.setAttribute("patientsEnAttente", patientsEnAttente);

        // Token CSRF
        String csrfToken = CSRFTokenUtil.getToken(request.getSession());
        request.setAttribute("csrfToken", csrfToken);

        request.getRequestDispatcher("/WEB-INF/views/generaliste/creer-consultation.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier le token CSRF
        String csrfToken = request.getParameter("csrfToken");
        if (!CSRFTokenUtil.validateToken(request.getSession(), csrfToken)) {
            request.setAttribute("error", "Token de sécurité invalide");
            doGet(request, response);
            return;
        }

        try {
            // Récupérer le médecin connecté
            HttpSession session = request.getSession();
            MedecinGeneraliste medecin = (MedecinGeneraliste) session.getAttribute("user");

            if (medecin == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Récupérer les paramètres
            String patientId = request.getParameter("patientId");
            String motif = request.getParameter("motif");
            String observations = request.getParameter("observations");

            // Validation
            if (patientId == null || patientId.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez sélectionner un patient");
                doGet(request, response);
                return;
            }

            if (motif == null || motif.trim().isEmpty()) {
                request.setAttribute("error", "Le motif est obligatoire");
                doGet(request, response);
                return;
            }

            // Créer la consultation
            var consultation = consultationService.creerConsultation(
                    patientId.trim(),
                    medecin,
                    motif.trim(),
                    observations != null ? observations.trim() : ""
            );

            // Redirection vers la page de consultation
            response.sendRedirect(request.getContextPath() +
                    "/generaliste/consultation/detail?id=" + consultation.getId() +
                    "&success=Consultation created successfully");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error while creating: " + e.getMessage());
            doGet(request, response);
        }
    }
}