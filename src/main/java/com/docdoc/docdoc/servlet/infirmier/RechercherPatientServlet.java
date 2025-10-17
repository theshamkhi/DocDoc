package com.docdoc.docdoc.servlet.infirmier;

import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.service.PatientService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Optional;


@WebServlet("/infirmier/patient/rechercher")
public class RechercherPatientServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String numeroSecu = request.getParameter("numeroSecuriteSociale");

        if (numeroSecu == null || numeroSecu.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Numéro de sécurité sociale requis\"}");
            return;
        }

        Optional<Patient> patientOpt = patientService.rechercherPatient(numeroSecu.trim());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (patientOpt.isPresent()) {
            Patient patient = patientOpt.get();

            // Patient trouvé - retourner ses informations en JSON
            String json = String.format(
                    "{\"found\": true, \"id\": \"%s\", \"nom\": \"%s\", \"prenom\": \"%s\", \"telephone\": \"%s\"}",
                    patient.getId(),
                    patient.getNom(),
                    patient.getPrenom(),
                    patient.getTelephone() != null ? patient.getTelephone() : ""
            );

            response.getWriter().write(json);
        } else {
            response.getWriter().write("{\"found\": false}");
        }
    }
}