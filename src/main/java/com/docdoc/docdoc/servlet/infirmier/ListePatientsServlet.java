package com.docdoc.docdoc.servlet.infirmier;

import com.docdoc.docdoc.model.Infirmier;
import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.service.PatientService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/infirmier/liste-patients")
public class ListePatientsServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Infirmier infirmier = (Infirmier) session.getAttribute("user");

        if (infirmier == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String filtre = request.getParameter("filtre");
        List<Patient> patients;

        // Apply filter based on parameter
        if ("attente".equals(filtre)) {
            patients = patientService.getPatientsEnAttente();
            request.setAttribute("filtreActif", "attente");
        } else if ("mes-patients".equals(filtre)) {
            patients = patientService.findPatientsByInfirmier(infirmier);
            request.setAttribute("filtreActif", "mes-patients");
        } else {
            patients = patientService.getPatientsDuJour();
            request.setAttribute("filtreActif", "jour");
        }

        // Search functionality
        String recherche = request.getParameter("recherche");
        if (recherche != null && !recherche.trim().isEmpty()) {
            String rechercheLC = recherche.toLowerCase().trim();

            patients = patients.stream()
                    .filter(p ->
                            p.getNom().toLowerCase().contains(rechercheLC) ||
                                    p.getPrenom().toLowerCase().contains(rechercheLC) ||
                                    p.getNumeroSecuriteSociale().contains(rechercheLC)
                    )
                    .collect(Collectors.toList());

            request.setAttribute("recherche", recherche);
        }

        // Statistics
        long nombreEnAttente = patients.stream()
                .filter(Patient::getEnAttente)
                .count();

        // Set attributes
        request.setAttribute("infirmier", infirmier);
        request.setAttribute("patients", patients);
        request.setAttribute("nombreTotal", patients.size());
        request.setAttribute("nombreEnAttente", nombreEnAttente);

        // CSRF Token
        String csrfToken = CSRFTokenUtil.getToken(session);
        request.setAttribute("csrfToken", csrfToken);

        // Messages
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        String info = request.getParameter("info");

        if (success != null) request.setAttribute("success", success);
        if (error != null) request.setAttribute("error", error);
        if (info != null) request.setAttribute("info", info);

        request.getRequestDispatcher("/WEB-INF/views/infirmier/liste-patients.jsp")
                .forward(request, response);
    }
}