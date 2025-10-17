package com.docdoc.docdoc.servlet.generaliste;

import com.docdoc.docdoc.model.ActeTechnique;
import com.docdoc.docdoc.model.Consultation;
import com.docdoc.docdoc.service.ConsultationGeneralisteService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@WebServlet("/generaliste/consultation/detail")
public class DetailConsultationServlet extends HttpServlet {

    private ConsultationGeneralisteService consultationService;

    @Override
    public void init() throws ServletException {
        consultationService = new ConsultationGeneralisteService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String consultationIdStr = request.getParameter("id");

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

            Consultation consultation = consultationOpt.get();

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            String formattedDate = consultation.getDateConsultation() != null
                    ? consultation.getDateConsultation().format(formatter)
                    : "";

            request.setAttribute("formattedDate", formattedDate);

            // Récupérer les actes techniques
            List<ActeTechnique> actes = consultationService.getActesTechniques(consultationId);

            // NEW: Calculate the sum of technical acts using Lambda/Stream
            double coutActes = actes.stream()
                    .mapToDouble(ActeTechnique::getTarif)
                    .sum();

            // US4: Calculer le coût total (utilise Lambda dans le service)
            Double coutTotal = consultationService.calculerCoutTotal(consultationId);

            request.setAttribute("consultation", consultation);
            request.setAttribute("actes", actes);
            request.setAttribute("coutActes", coutActes);  // NEW
            request.setAttribute("coutTotal", coutTotal);

            // Types d'actes disponibles
            request.setAttribute("typesActes", com.docdoc.docdoc.model.enums.TypeActeTechnique.values());

            // Messages
            String success = request.getParameter("success");
            if (success != null) request.setAttribute("success", success);

            // Token CSRF
            String csrfToken = CSRFTokenUtil.getToken(request.getSession());
            request.setAttribute("csrfToken", csrfToken);

            request.getRequestDispatcher("/WEB-INF/views/generaliste/detail-consultation.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
        }
    }
}