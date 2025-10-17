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

@WebServlet("/infirmier/dashboard")
public class InfirmierDashboardServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Patient> patientsDuJour = patientService.getPatientsDuJour();
        List<Patient> patientsEnAttente = patientService.getPatientsEnAttente();

        // Utilisation Stream API : Prendre les 5 derniers patients enregistrés
        List<Patient> patientsRecents = patientsDuJour.stream()
                .sorted((p1, p2) -> p2.getDateEnregistrement().compareTo(p1.getDateEnregistrement()))
                .limit(5)
                .collect(Collectors.toList());


        // Calculer les statistiques
        request.setAttribute("nombrePatientsDuJour", patientsDuJour.size());
        request.setAttribute("nombrePatientsEnAttente", patientsEnAttente.size());
        request.setAttribute("patientsRecents", patientsRecents);

        // Token CSRF pour les actions rapides
        String csrfToken = CSRFTokenUtil.getToken(request.getSession());
        request.setAttribute("csrfToken", csrfToken);

        request.getRequestDispatcher("/WEB-INF/views/infirmier/dashboard.jsp")
                .forward(request, response);
    }
}