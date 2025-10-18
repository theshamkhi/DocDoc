package com.docdoc.docdoc.servlet.specialiste;

import com.docdoc.docdoc.model.MedecinSpecialiste;
import com.docdoc.docdoc.service.ExpertiseSpecialisteService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/specialiste/dashboard")
public class SpecialisteDashboardServlet extends HttpServlet {

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
            var stats = expertiseService.getStatsSpecialiste(specialiste.getId());

            var demandesEnAttente = expertiseService.getDemandesEnAttente(specialiste.getId());

            var demandesUrgentes = expertiseService.getDemandesUrgentes(specialiste.getId());

            var creneauxAujourdhui = expertiseService.getCreneauxByDate(
                    specialiste.getId(),
                    java.time.LocalDate.now()
            );

            request.setAttribute("specialiste", specialiste);
            request.setAttribute("stats", stats);
            request.setAttribute("demandesEnAttente", demandesEnAttente);
            request.setAttribute("demandesUrgentes", demandesUrgentes);
            request.setAttribute("creneauxAujourdhui", creneauxAujourdhui);

            String csrfToken = CSRFTokenUtil.getToken(session);
            request.setAttribute("csrfToken", csrfToken);

            request.getRequestDispatcher("/WEB-INF/views/specialiste/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/specialiste/dashboard.jsp")
                    .forward(request, response);
        }
    }
}