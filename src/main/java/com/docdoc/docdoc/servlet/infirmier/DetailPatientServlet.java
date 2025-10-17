package com.docdoc.docdoc.servlet.infirmier;

import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.model.SigneVital;
import com.docdoc.docdoc.model.Consultation;
import com.docdoc.docdoc.service.PatientService;
import com.docdoc.docdoc.service.ConsultationService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/infirmier/patient/detail")
public class DetailPatientServlet extends HttpServlet {

    private PatientService patientService;
    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
        consultationService = new ConsultationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String patientId = request.getParameter("id");

        if (patientId == null) {
            response.sendRedirect(request.getContextPath() +
                    "/infirmier/liste-patients?error=Missing patient ID");
            return;
        }

        Optional<Patient> patientOpt = patientService.getPatientById(patientId);

        if (patientOpt.isEmpty()) {
            response.sendRedirect(request.getContextPath() +
                    "/infirmier/liste-patients?error=Patient not found");
            return;
        }

        Patient patient = patientOpt.get();

        // Historique des signes vitaux (triés du plus récent au plus ancien)
        List<SigneVital> signesVitaux = patientService.getHistoriqueSignesVitaux(patientId);

        List<Consultation> consultations = consultationService.getConsultationsByPatient(patient);

        request.setAttribute("patient", patient);
        request.setAttribute("signesVitaux", signesVitaux);
        request.setAttribute("consultations", consultations);

        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) request.setAttribute("success", success);
        if (error != null) request.setAttribute("error", error);

        // Token CSRF
        String csrfToken = CSRFTokenUtil.getToken(request.getSession());
        request.setAttribute("csrfToken", csrfToken);

        request.getRequestDispatcher("/WEB-INF/views/infirmier/modifier-patient.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier le token CSRF
        String csrfToken = request.getParameter("csrfToken");
        if (!CSRFTokenUtil.validateToken(request.getSession(), csrfToken)) {
            request.setAttribute("error", "Token de sécurité invalide");
            doGet(request, response);
            return;
        }

        String patientId = request.getParameter("patientId");

        if (patientId == null) {
            response.sendRedirect(request.getContextPath() + "/infirmier/liste-patients");
            return;
        }

        Optional<Patient> patientOpt = patientService.getPatientById(patientId);

        if (patientOpt.isEmpty()) {
            response.sendRedirect(request.getContextPath() +
                    "/infirmier/liste-patients?error=Patient not found");
            return;
        }

        try {
            Patient patient = patientOpt.get();

            // Mettre à jour les informations modifiables
            String telephone = request.getParameter("telephone");
            if (telephone != null && !telephone.trim().isEmpty()) {
                patient.setTelephone(telephone.trim());
            }

            // Sauvegarder les modifications
            patientService.updatePatient(patient);

            response.sendRedirect(request.getContextPath() +
                    "/infirmier/patient/detail?id=" + patientId +
                    "&success=Patient successfully modified");

        } catch (Exception e) {
            request.setAttribute("error", "Error while editing: " + e.getMessage());
            doGet(request, response);
        }
    }
}