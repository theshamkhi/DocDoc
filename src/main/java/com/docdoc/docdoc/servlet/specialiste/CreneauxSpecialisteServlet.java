package com.docdoc.docdoc.servlet.specialiste;

import com.docdoc.docdoc.model.MedecinSpecialiste;
import com.docdoc.docdoc.service.ExpertiseSpecialisteService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet("/specialiste/creneaux")
public class CreneauxSpecialisteServlet extends HttpServlet {

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
            String dateStr = request.getParameter("date");
            java.time.LocalDate date = dateStr != null ? java.time.LocalDate.parse(dateStr) : java.time.LocalDate.now();

            var creneaux = expertiseService.getCreneauxByDate(specialiste.getId(), date);

            request.setAttribute("specialiste", specialiste);
            request.setAttribute("creneaux", creneaux);
            request.setAttribute("dateSelected", date);

            String csrfToken = CSRFTokenUtil.getToken(session);
            request.setAttribute("csrfToken", csrfToken);

            request.getRequestDispatcher("/WEB-INF/views/specialiste/creneaux.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/specialiste/creneaux.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String csrfToken = request.getParameter("csrfToken");
        if (!CSRFTokenUtil.validateToken(request.getSession(), csrfToken)) {
            doGet(request, response);
            return;
        }

        try {
            HttpSession session = request.getSession();
            MedecinSpecialiste specialiste = (MedecinSpecialiste) session.getAttribute("user");

            String dateStr = request.getParameter("date");
            java.time.LocalDate date = dateStr != null ? java.time.LocalDate.parse(dateStr) : java.time.LocalDate.now();

            expertiseService.initialiserCreneauxPredefinies(specialiste.getId(), date);

            response.sendRedirect(request.getContextPath() +
                    "/specialiste/creneaux?date=" + date + "&success=Créneaux initialisés");

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(request, response);
        }
    }
}
