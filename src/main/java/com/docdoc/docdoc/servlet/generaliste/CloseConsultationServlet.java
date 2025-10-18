package com.docdoc.docdoc.servlet.generaliste;

import com.docdoc.docdoc.service.ConsultationGeneralisteService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/generaliste/consultation/close")
public class CloseConsultationServlet extends HttpServlet {

    private ConsultationGeneralisteService consultationService;

    @Override
    public void init() throws ServletException {
        consultationService = new ConsultationGeneralisteService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String csrfToken = request.getParameter("csrfToken");
        if (!CSRFTokenUtil.validateToken(request.getSession(), csrfToken)) {
            request.setAttribute("error", "Token de sécurité invalide");
            response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
            return;
        }

        try {
            String consultationIdStr = request.getParameter("consultationId");
            String diagnostic = request.getParameter("diagnostic");
            String traitement = request.getParameter("traitement");

            if (consultationIdStr == null || consultationIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
                return;
            }

            if (diagnostic == null || diagnostic.trim().isEmpty()) {
                request.setAttribute("error", "Le diagnostic est obligatoire");
                response.sendRedirect(request.getContextPath() +
                        "/generaliste/consultation/detail?id=" + consultationIdStr + "&error=Diagnostic%20obligatoire");
                return;
            }

            Long consultationId = Long.parseLong(consultationIdStr);

            // Close consultation
            consultationService.cloturerConsultation(
                    consultationId,
                    diagnostic.trim(),
                    traitement != null ? traitement.trim() : ""
            );

            response.sendRedirect(request.getContextPath() +
                    "/generaliste/consultation/detail?id=" + consultationId +
                    "&success=Consultation%20termin%C3%A9e%20avec%20succ%C3%A8s");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                    "/generaliste/dashboard?error=" + e.getMessage());
        }
    }
}