package com.docdoc.docdoc.servlet.infirmier;

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

        String filtre = request.getParameter("filtre");

        List<Patient> patients;

        if ("attente".equals(filtre)) {
            patients = patientService.getPatientsEnAttente();
            request.setAttribute("filtreActif", "attente");
        } else {
            patients = patientService.getPatientsDuJour();
            request.setAttribute("filtreActif", "jour");
        }

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

        long nombreEnAttente = patients.stream()
                .filter(Patient::getEnAttente)
                .count();

        request.setAttribute("patients", patients);
        request.setAttribute("nombreTotal", patients.size());
        request.setAttribute("nombreEnAttente", nombreEnAttente);

        // Token CSRF pour les actions
        String csrfToken = CSRFTokenUtil.getToken(request.getSession());
        request.setAttribute("csrfToken", csrfToken);

        // Messages de succès ou d'erreur
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