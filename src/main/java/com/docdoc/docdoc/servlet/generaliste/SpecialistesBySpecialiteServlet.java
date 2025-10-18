package com.docdoc.docdoc.servlet.generaliste;

import com.docdoc.docdoc.model.MedecinSpecialiste;
import com.docdoc.docdoc.model.enums.Specialite;
import com.docdoc.docdoc.service.ConsultationGeneralisteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/generaliste/api/specialistes-par-specialite")
public class SpecialistesBySpecialiteServlet extends HttpServlet {

    private ConsultationGeneralisteService consultationService;

    @Override
    public void init() throws ServletException {
        consultationService = new ConsultationGeneralisteService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String specialiteStr = request.getParameter("specialite");

        if (specialiteStr == null || specialiteStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("[]");
            return;
        }

        try {
            Specialite specialite = Specialite.valueOf(specialiteStr);

            List<MedecinSpecialiste> specialistes = consultationService.obtenirSpecialistesBySpecialite(specialite);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Construire le JSON
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < specialistes.size(); i++) {
                MedecinSpecialiste s = specialistes.get(i);
                json.append("{")
                        .append("\"id\":\"").append(s.getId()).append("\",")
                        .append("\"nom\":\"").append(s.getNom()).append("\",")
                        .append("\"prenom\":\"").append(s.getPrenom()).append("\",")
                        .append("\"tarif\":").append(s.getTarif())
                        .append("}");
                if (i < specialistes.size() - 1) json.append(",");
            }
            json.append("]");

            response.getWriter().write(json.toString());

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("[]");
        }
    }
}