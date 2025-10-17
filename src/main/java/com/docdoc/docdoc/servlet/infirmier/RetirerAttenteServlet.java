package com.docdoc.docdoc.servlet.infirmier;

import com.docdoc.docdoc.service.PatientService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/infirmier/patient/retirer-attente")
public class RetirerAttenteServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String csrfToken = request.getParameter("csrfToken");
        if (!CSRFTokenUtil.validateToken(request.getSession(), csrfToken)) {
            response.sendRedirect(request.getContextPath() +
                    "/infirmier/liste-patients?error=Invalid security token");
            return;
        }

        String patientId = request.getParameter("patientId");
        if (patientId == null) {
            response.sendRedirect(request.getContextPath() +
                    "/infirmier/liste-patients?error=Missing patient ID");
            return;
        }

        try {
            patientService.retirerDeLaFileAttente(patientId);
            response.sendRedirect(request.getContextPath() +
                    "/infirmier/liste-patients?success=Patient removed from queue");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/infirmier/liste-patients?error=" + e.getMessage());
        }
    }
}
