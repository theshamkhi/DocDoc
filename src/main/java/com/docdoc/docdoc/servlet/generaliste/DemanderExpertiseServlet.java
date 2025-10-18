package com.docdoc.docdoc.servlet.generaliste;

import com.docdoc.docdoc.model.Consultation;
import com.docdoc.docdoc.service.ConsultationGeneralisteService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/generaliste/consultation/demander-expertise")
public class DemanderExpertiseServlet extends HttpServlet {

    private ConsultationGeneralisteService consultationService;

    @Override
    public void init() throws ServletException {
        consultationService = new ConsultationGeneralisteService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String consultationIdStr = request.getParameter("consultationId");

        if (consultationIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
            return;
        }

        try {
            Long consultationId = Long.parseLong(consultationIdStr);
            Optional<Consultation> consultationOpt = consultationService.getConsultationById(consultationId);

            if (consultationOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
                return;
            }

            request.setAttribute("consultation", consultationOpt.get());
            request.setAttribute("specialites", com.docdoc.docdoc.model.enums.Specialite.values());

            String csrfToken = CSRFTokenUtil.getToken(request.getSession());
            request.setAttribute("csrfToken", csrfToken);

            request.getRequestDispatcher("/WEB-INF/views/generaliste/demander-expertise.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String csrfToken = request.getParameter("csrfToken");
        if (!CSRFTokenUtil.validateToken(request.getSession(), csrfToken)) {
            request.setAttribute("error", "Token de sécurité invalide");
            doGet(request, response);
            return;
        }

        String consultationIdStr = null;
        try {
            consultationIdStr = request.getParameter("consultationId");
            String specialisteId = request.getParameter("specialisteId");
            String creneauIdStr = request.getParameter("creneauId");
            String question = request.getParameter("question");
            String donneesSupplementaires = request.getParameter("donneesSupplementaires");
            String priorite = request.getParameter("priorite");

            // Validation
            if (consultationIdStr == null || consultationIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Consultation non trouvée");
                doGet(request, response);
                return;
            }

            if (specialisteId == null || specialisteId.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez sélectionner un spécialiste");
                doGet(request, response);
                return;
            }

            if (creneauIdStr == null || creneauIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez sélectionner un créneau");
                doGet(request, response);
                return;
            }

            if (question == null || question.trim().isEmpty()) {
                request.setAttribute("error", "La question est obligatoire");
                doGet(request, response);
                return;
            }

            // Parse IDs
            Long consultationId;
            Long creneauId;
            try {
                consultationId = Long.parseLong(consultationIdStr.trim());
                creneauId = Long.parseLong(creneauIdStr.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Format de numéro invalide");
                doGet(request, response);
                return;
            }

            if (priorite == null || priorite.trim().isEmpty()) {
                priorite = "NORMALE";
            }

            // Request expertise
            consultationService.demanderExpertise(
                    consultationId,
                    specialisteId.trim(),
                    creneauId,
                    question.trim(),
                    donneesSupplementaires != null ? donneesSupplementaires.trim() : "",
                    priorite
            );

            // Success redirect
            response.sendRedirect(request.getContextPath() +
                    "/generaliste/consultation/detail?id=" + consultationId +
                    "&success=Expertise%20demand%C3%A9e%20avec%20succ%C3%A8s");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Erreur de validation: " + e.getMessage());
            doGet(request, response);
        } catch (IllegalStateException e) {
            request.setAttribute("error", "Statut invalide: " + e.getMessage());
            doGet(request, response);
        } catch (RuntimeException e) {
            // This is a database error
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage() +
                    ". Vérifiez que le créneau n'a pas été réservé par un autre utilisateur.");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(request, response);
        }
    }
}