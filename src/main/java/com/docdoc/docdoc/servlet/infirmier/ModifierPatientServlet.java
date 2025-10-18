package com.docdoc.docdoc.servlet.infirmier;

import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.service.PatientService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Optional;

@WebServlet("/infirmier/patient/modifier")
public class ModifierPatientServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String patientIdStr = request.getParameter("id");

        if (patientIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/infirmier/liste-patients");
            return;
        }

        try {
            Optional<Patient> patientOpt = patientService.getPatientById(patientIdStr);

            if (patientOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/infirmier/liste-patients");
                return;
            }

            request.setAttribute("patient", patientOpt.get());

            String csrfToken = CSRFTokenUtil.getToken(request.getSession());
            request.setAttribute("csrfToken", csrfToken);

            request.getRequestDispatcher("/WEB-INF/views/infirmier/modifier-patient.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/infirmier/liste-patients");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CSRF Token validation
        String csrfToken = request.getParameter("csrfToken");
        if (!CSRFTokenUtil.validateToken(request.getSession(), csrfToken)) {
            request.setAttribute("error", "Invalid CSRF token");
            doGet(request, response);
            return;
        }

        String patientIdStr = request.getParameter("patientId");

        if (patientIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/infirmier/liste-patients");
            return;
        }

        try {
            Optional<Patient> patientOpt = patientService.getPatientById(patientIdStr);

            if (patientOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/infirmier/liste-patients");
                return;
            }

            Patient patient = patientOpt.get();

            // Retrieve form parameters
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String dateNaissanceStr = request.getParameter("dateNaissance");
            String numeroSecuriteSociale = request.getParameter("numeroSecuriteSociale");
            String telephone = request.getParameter("telephone");

            // Update only non-empty fields
            if (nom != null && !nom.trim().isEmpty()) {
                patient.setNom(nom.trim());
            }

            if (prenom != null && !prenom.trim().isEmpty()) {
                patient.setPrenom(prenom.trim());
            }

            // Parse and validate date if provided
            if (dateNaissanceStr != null && !dateNaissanceStr.trim().isEmpty()) {
                try {
                    LocalDate dateNaissance = LocalDate.parse(dateNaissanceStr, DateTimeFormatter.ISO_LOCAL_DATE);

                    // Validate date is not in the future
                    if (dateNaissance.isAfter(LocalDate.now())) {
                        request.setAttribute("error", "La date de naissance ne peut pas être dans le futur");
                        request.setAttribute("patient", patient);
                        doGet(request, response);
                        return;
                    }

                    patient.setDateNaissance(dateNaissance);
                } catch (DateTimeParseException e) {
                    request.setAttribute("error", "Format de date invalide");
                    request.setAttribute("patient", patient);
                    doGet(request, response);
                    return;
                }
            }

            if (numeroSecuriteSociale != null && !numeroSecuriteSociale.trim().isEmpty()) {
                patient.setNumeroSecuriteSociale(numeroSecuriteSociale.trim());
            }

            // Validate and update telephone if provided
            if (telephone != null && !telephone.trim().isEmpty()) {
                if (!telephone.matches("\\d{10}")) {
                    request.setAttribute("error", "Le numéro de téléphone doit contenir exactement 10 chiffres");
                    request.setAttribute("patient", patient);
                    doGet(request, response);
                    return;
                }
                patient.setTelephone(telephone.trim());
            } else {
                // If telephone is empty, set it to null
                patient.setTelephone(null);
            }


            patientService.updatePatient(patient);

            response.sendRedirect(request.getContextPath() +
                    "/infirmier/patient/detail?id=" + patientIdStr +
                    "&success=Updated Successfully");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la modification: " + e.getMessage());
            doGet(request, response);
        }
    }
}