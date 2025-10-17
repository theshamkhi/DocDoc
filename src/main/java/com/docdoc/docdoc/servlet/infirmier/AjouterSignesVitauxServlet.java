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
import java.util.Optional;

@WebServlet("/infirmier/patient/signes-vitaux")
public class AjouterSignesVitauxServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String patientId = request.getParameter("id");

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

        Patient patient = patientOpt.get();
        request.setAttribute("patient", patient);

        // Message d'information si présent
        String info = request.getParameter("info");
        if (info != null) {
            request.setAttribute("info", info);
        }

        // Token CSRF
        String csrfToken = CSRFTokenUtil.getToken(request.getSession());
        request.setAttribute("csrfToken", csrfToken);

        request.getRequestDispatcher("/WEB-INF/views/infirmier/ajouter-signes-vitaux.jsp")
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

        try {
            HttpSession session = request.getSession();
            Infirmier infirmier = (Infirmier) session.getAttribute("user");

            if (infirmier == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Optional<Patient> patientOpt = patientService.getPatientById(patientId);

            if (patientOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() +
                        "/infirmier/liste-patients?error=Patient not found");
                return;
            }

            Patient patient = patientOpt.get();

            // Créer les nouveaux signes vitaux
            SigneVital signeVital = new SigneVital();

            String tensionArterielle = request.getParameter("tensionArterielle");
            if (tensionArterielle != null && !tensionArterielle.trim().isEmpty()) {
                signeVital.setTensionArterielle(tensionArterielle.trim());
            }

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

            // Vérifier qu'au moins un signe vital a été renseigné
            if (signeVital.getTensionArterielle() == null &&
                    signeVital.getFrequenceCardiaque() == null &&
                    signeVital.getTemperature() == null &&
                    signeVital.getFrequenceRespiratoire() == null &&
                    signeVital.getPoids() == null &&
                    signeVital.getTaille() == null) {

                request.setAttribute("error", "Au moins un signe vital doit être renseigné");
                request.setAttribute("patient", patient);
                doGet(request, response);
                return;
            }

            patientService.ajouterSignesVitaux(patient, signeVital, infirmier);

            response.sendRedirect(request.getContextPath() +
                    "/infirmier/patient/detail?id=" + patientId +
                    "&success=Vital signs successfully added");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format de nombre invalide");
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de l'ajout: " + e.getMessage());
            doGet(request, response);
        }
    }
}