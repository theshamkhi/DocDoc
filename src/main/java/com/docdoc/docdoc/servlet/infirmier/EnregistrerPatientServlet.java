package com.docdoc.docdoc.servlet.infirmier;

import com.docdoc.docdoc.model.Infirmier;
import com.docdoc.docdoc.model.Patient;
import com.docdoc.docdoc.model.SigneVital;
import com.docdoc.docdoc.service.PatientService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.Optional;

@WebServlet("/infirmier/patient/enregistrer")
public class EnregistrerPatientServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Générer token CSRF
        String csrfToken = CSRFTokenUtil.getToken(request.getSession());
        request.setAttribute("csrfToken", csrfToken);

        request.getRequestDispatcher("/WEB-INF/views/infirmier/enregistrer-patient.jsp")
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

        try {
            HttpSession session = request.getSession();
            Infirmier infirmier = (Infirmier) session.getAttribute("user");

            if (infirmier == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String dateNaissanceStr = request.getParameter("dateNaissance");
            String numeroSecuriteSociale = request.getParameter("numeroSecuriteSociale");
            String telephone = request.getParameter("telephone");

            // Validation des champs obligatoires
            if (nom == null || nom.trim().isEmpty() ||
                    prenom == null || prenom.trim().isEmpty() ||
                    dateNaissanceStr == null || dateNaissanceStr.trim().isEmpty() ||
                    numeroSecuriteSociale == null || numeroSecuriteSociale.trim().isEmpty()) {

                request.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
                doGet(request, response);
                return;
            }

            Optional<Patient> existingPatient = patientService.rechercherPatient(numeroSecuriteSociale);

            if (existingPatient.isPresent()) {
                // Patient existe déjà, rediriger vers l'ajout de signes vitaux
                response.sendRedirect(request.getContextPath() +
                        "/infirmier/patient/signes-vitaux?id=" + existingPatient.get().getId() +
                        "&info=Patient already registered");
                return;
            }

            // Créer le nouveau patient
            LocalDate dateNaissance = LocalDate.parse(dateNaissanceStr);
            Patient patient = new Patient(nom.trim(), prenom.trim(), dateNaissance, numeroSecuriteSociale.trim());

            if (telephone != null && !telephone.trim().isEmpty()) {
                patient.setTelephone(telephone.trim());
            }

            // Créer les signes vitaux
            SigneVital signeVital = new SigneVital();
            signeVital.setTensionArterielle(request.getParameter("tensionArterielle"));

            String frequenceCardiaqueStr = request.getParameter("frequenceCardiaque");
            if (frequenceCardiaqueStr != null && !frequenceCardiaqueStr.trim().isEmpty()) {
                signeVital.setFrequenceCardiaque(Integer.parseInt(frequenceCardiaqueStr));
            }

            String temperatureStr = request.getParameter("temperature");
            if (temperatureStr != null && !temperatureStr.trim().isEmpty()) {
                signeVital.setTemperature(Double.parseDouble(temperatureStr));
            }

            String frequenceRespiratoireStr = request.getParameter("frequenceRespiratoire");
            if (frequenceRespiratoireStr != null && !frequenceRespiratoireStr.trim().isEmpty()) {
                signeVital.setFrequenceRespiratoire(Integer.parseInt(frequenceRespiratoireStr));
            }

            String poidsStr = request.getParameter("poids");
            if (poidsStr != null && !poidsStr.trim().isEmpty()) {
                signeVital.setPoids(Double.parseDouble(poidsStr));
            }

            String tailleStr = request.getParameter("taille");
            if (tailleStr != null && !tailleStr.trim().isEmpty()) {
                signeVital.setTaille(Double.parseDouble(tailleStr));
            }

            Patient savedPatient = patientService.enregistrerNouveauPatient(patient, signeVital, infirmier);

            response.sendRedirect(request.getContextPath() +
                    "/infirmier/patient/detail?id=" + savedPatient.getId() +
                    "&success=Patient successfully registered");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error while saving: " + e.getMessage());
            doGet(request, response);
        }
    }
}