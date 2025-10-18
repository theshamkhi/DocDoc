package com.docdoc.docdoc.servlet.generaliste;

import com.docdoc.docdoc.service.ConsultationGeneralisteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

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
            response.getWriter().write("[]");
            return;
        }

        try {
            var creneaux = consultationService.obtenirCreneauxDisponibles(specialisteId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Construire le JSON - seulement les créneaux disponibles
            StringBuilder json = new StringBuilder("[");
            int count = 0;
            for (var c : creneaux) {
                // Only include available slots
                if (c.getDisponible() != null && c.getDisponible()) {
                    if (count > 0) json.append(",");
                    json.append("{")
                            .append("\"id\":").append(c.getId()).append(",")
                            .append("\"date\":\"").append(c.getDateCreneau()).append("\",")
                            .append("\"heure\":\"").append(c.getPlageHoraire()).append("\"")
                            .append("}");
                    count++;
                }
            }
            json.append("]");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }
}