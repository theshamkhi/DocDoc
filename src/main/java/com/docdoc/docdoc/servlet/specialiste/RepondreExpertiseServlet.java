package com.docdoc.docdoc.servlet.specialiste;

import com.docdoc.docdoc.model.MedecinSpecialiste;

import com.docdoc.docdoc.model.MedecinSpecialiste;
import com.docdoc.docdoc.service.ExpertiseSpecialisteService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/specialiste/repondre-expertise")
public class RepondreExpertiseServlet extends HttpServlet {

    private ExpertiseSpecialisteService expertiseService;

    @Override
    public void init() throws ServletException {
        expertiseService = new ExpertiseSpecialisteService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        MedecinSpecialiste specialiste = (MedecinSpecialiste) session.getAttribute("user");

        if (specialiste == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String demandeIdStr = request.getParameter("id");
            if (demandeIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/specialiste/demandes-expertise");
                return;
            }

            Long demandeId = Long.parseLong(demandeIdStr);
            var demandeOpt = expertiseService.getDemandeExpertiseById(demandeId);

            if (demandeOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/specialiste/demandes-expertise");
                return;
            }

            request.setAttribute("specialiste", specialiste);
            request.setAttribute("demande", demandeOpt.get());

            String csrfToken = CSRFTokenUtil.getToken(session);
            request.setAttribute("csrfToken", csrfToken);

            request.getRequestDispatcher("/WEB-INF/views/specialiste/repondre-expertise.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/specialiste/demandes-expertise");
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
            String demandeIdStr = request.getParameter("demandeId");
            String avisMedical = request.getParameter("avisMedical");
            String recommandations = request.getParameter("recommandations");

            if (demandeIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/specialiste/demandes-expertise");
                return;
            }

            if (avisMedical == null || avisMedical.trim().isEmpty()) {
                request.setAttribute("error", "L'avis médical est obligatoire");
                doGet(request, response);
                return;
            }

            Long demandeId = Long.parseLong(demandeIdStr);

            expertiseService.repondreExpertise(
                    demandeId,
                    avisMedical.trim(),
                    recommandations != null ? recommandations.trim() : ""
            );

            response.sendRedirect(request.getContextPath() +
                    "/specialiste/demandes-expertise?success=Expertise%20r%C3%A9pondue%20avec%20succ%C3%A8s");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/specialiste/demandes-expertise");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(request, response);
        }
    }
}