package com.docdoc.docdoc.servlet.specialiste;

import com.docdoc.docdoc.model.MedecinSpecialiste;
import com.docdoc.docdoc.model.enums.Specialite;
import com.docdoc.docdoc.service.ExpertiseSpecialisteService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/specialiste/profil")
public class ProfilSpecialisteServlet extends HttpServlet {

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


        request.setAttribute("specialiste", specialiste);
        request.setAttribute("specialites", Specialite.values());

        String success = request.getParameter("success");
        String error = request.getParameter("error");

        if (success != null && !success.isEmpty()) {
            request.setAttribute("success", success);
        }
        if (error != null && !error.isEmpty()) {
            request.setAttribute("error", error);
        }

        String csrfToken = CSRFTokenUtil.getToken(session);
        request.setAttribute("csrfToken", csrfToken);

        request.getRequestDispatcher("/WEB-INF/views/specialiste/profil.jsp")
                .forward(request, response);
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
            HttpSession session = request.getSession();
            MedecinSpecialiste specialiste = (MedecinSpecialiste) session.getAttribute("user");

            if (specialiste == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String tarifStr = request.getParameter("tarif");
            String specialiteStr = request.getParameter("specialite");

            Double tarif = null;
            if (tarifStr != null && !tarifStr.trim().isEmpty()) {
                tarif = Double.parseDouble(tarifStr);
                if (tarif <= 0) {
                    request.setAttribute("error", "Le tarif doit être positif");
                    request.setAttribute("specialiste", specialiste);
                    request.setAttribute("specialites", Specialite.values());
                    request.getRequestDispatcher("/WEB-INF/views/specialiste/profil.jsp")
                            .forward(request, response);
                    return;
                }
            }

            Specialite specialite = null;
            if (specialiteStr != null && !specialiteStr.trim().isEmpty()) {
                try {
                    specialite = Specialite.valueOf(specialiteStr);
                } catch (IllegalArgumentException e) {
                    request.setAttribute("error", "Spécialité invalide");
                    request.setAttribute("specialiste", specialiste);
                    request.setAttribute("specialites", Specialite.values());
                    request.getRequestDispatcher("/WEB-INF/views/specialiste/profil.jsp")
                            .forward(request, response);
                    return;
                }
            }

            MedecinSpecialiste updated = expertiseService.updateProfilSpecialiste(
                    specialiste.getId(),
                    tarif,
                    specialite
            );

            session.setAttribute("user", updated);

            response.sendRedirect(request.getContextPath() +
                    "/specialiste/profil?success=Profil%20mis%20%C3%A0%20jour%20avec%20succ%C3%A8s");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format de nombre invalide");
            request.setAttribute("specialiste", (MedecinSpecialiste) request.getSession().getAttribute("user"));
            request.setAttribute("specialites", Specialite.values());
            request.getRequestDispatcher("/WEB-INF/views/specialiste/profil.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.setAttribute("specialiste", (MedecinSpecialiste) request.getSession().getAttribute("user"));
            request.setAttribute("specialites", Specialite.values());
            request.getRequestDispatcher("/WEB-INF/views/specialiste/profil.jsp")
                    .forward(request, response);
        }
    }
}