package com.docdoc.docdoc.servlet.generaliste;

import com.docdoc.docdoc.model.Creneau;
import com.docdoc.docdoc.service.ConsultationGeneralisteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


@WebServlet("/generaliste/api/creneaux-disponibles")
public class CreneauxDisponiblesServlet extends HttpServlet {

    private ConsultationGeneralisteService consultationService;

    @Override
    public void init() throws ServletException {
        consultationService = new ConsultationGeneralisteService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String specialisteId = request.getParameter("specialisteId");

        if (specialisteId == null || specialisteId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("[]");
            return;
        }

        try {
            List<Creneau> creneaux = consultationService.obtenirCreneauxDisponibles(specialisteId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Construire le JSON
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < creneaux.size(); i++) {
                Creneau c = creneaux.get(i);
                json.append("{")
                        .append("\"id\":").append(c.getId()).append(",")
                        .append("\"date\":\"").append(c.getDateCreneau()).append("\",")
                        .append("\"heure\":\"").append(escapeJson(c.getPlageHoraire())).append("\"")
                        .append("}");
                if (i < creneaux.size() - 1) json.append(",");
            }
            json.append("]");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("[]");
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}