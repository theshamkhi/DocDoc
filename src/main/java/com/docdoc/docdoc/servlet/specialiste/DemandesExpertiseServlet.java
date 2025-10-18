package com.docdoc.docdoc.servlet.specialiste;

import com.docdoc.docdoc.model.MedecinSpecialiste;
import com.docdoc.docdoc.model.enums.Priorite;
import com.docdoc.docdoc.model.enums.StatutExpertise;
import com.docdoc.docdoc.service.ExpertiseSpecialisteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/specialiste/demandes-expertise")
public class DemandesExpertiseServlet extends HttpServlet {

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
            String statutStr = request.getParameter("statut");
            String prioriteStr = request.getParameter("priorite");

            StatutExpertise statut = null;
            Priorite priorite = null;

            if (statutStr != null && !statutStr.isEmpty()) {
                try {
                    statut = StatutExpertise.valueOf(statutStr);
                } catch (IllegalArgumentException e) {
                    // Invalid statut, ignore
                }
            }

            if (prioriteStr != null && !prioriteStr.isEmpty()) {
                try {
                    priorite = Priorite.valueOf(prioriteStr);
                } catch (IllegalArgumentException e) {
                    // Invalid priorite, ignore
                }
            }

            var demandes = expertiseService.getDemandesExpertiseFiltrées(specialiste.getId(), statut, priorite);

            var stats = expertiseService.getStatsSpecialiste(specialiste.getId());

            request.setAttribute("specialiste", specialiste);
            request.setAttribute("demandes", demandes);
            request.setAttribute("stats", stats);
            request.setAttribute("statutSelected", statutStr != null ? statutStr : "");
            request.setAttribute("prioriteSelected", prioriteStr != null ? prioriteStr : "");

            String success = request.getParameter("success");
            if (success != null && !success.isEmpty()) {
                request.setAttribute("success", success);
            }

            request.getRequestDispatcher("/WEB-INF/views/specialiste/demandes-expertise.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/specialiste/demandes-expertise.jsp")
                    .forward(request, response);
        }
    }
}