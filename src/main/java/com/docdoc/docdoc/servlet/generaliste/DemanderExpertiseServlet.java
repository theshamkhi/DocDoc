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

        try {
            String consultationIdStr = request.getParameter("consultationId");
            String specialisteId = request.getParameter("specialisteId");
            String creneauIdStr = request.getParameter("creneauId");
            String question = request.getParameter("question");
            String donneesSupplementaires = request.getParameter("donneesSupplementaires");
            String priorite = request.getParameter("priorite");

            if (consultationIdStr == null || specialisteId == null || creneauIdStr == null) {
                request.setAttribute("error", "Paramètres manquants");
                doGet(request, response);
                return;
            }

            if (question == null || question.trim().isEmpty()) {
                request.setAttribute("error", "La question est obligatoire");
                doGet(request, response);
                return;
            }

            Long consultationId = Long.parseLong(consultationIdStr);
            Long creneauId = Long.parseLong(creneauIdStr);

            if (priorite == null || priorite.trim().isEmpty()) {
                priorite = "NORMALE";
            }

            consultationService.demanderExpertise(
                    consultationId,
                    specialisteId.trim(),
                    creneauId,
                    question.trim(),
                    donneesSupplementaires != null ? donneesSupplementaires.trim() : "",
                    priorite
            );

            response.sendRedirect(request.getContextPath() +
                    "/generaliste/consultation/detail?id=" + consultationId +
                    "&success=Expertise demandée avec succès");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format de numéro invalide");
            doGet(request, response);
        } catch (IllegalStateException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(request, response);
        }
    }
}