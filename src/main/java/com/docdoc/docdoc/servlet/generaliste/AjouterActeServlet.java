package com.docdoc.docdoc.servlet.generaliste;

import com.docdoc.docdoc.service.ConsultationGeneralisteService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet("/generaliste/consultation/ajouter-acte")
public class AjouterActeServlet extends HttpServlet {

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
            String typeActe = request.getParameter("typeActe");

            if (consultationIdStr == null || typeActe == null) {
                response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
                return;
            }

            Long consultationId = Long.parseLong(consultationIdStr);

            consultationService.ajouterActeTechnique(consultationId, typeActe);

            response.sendRedirect(request.getContextPath() +
                    "/generaliste/consultation/detail?id=" + consultationId +
                    "&success=Acte added");

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
        }
    }
}