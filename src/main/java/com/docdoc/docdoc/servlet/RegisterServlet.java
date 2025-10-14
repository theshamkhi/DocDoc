package com.docdoc.docdoc.servlet;

import com.docdoc.docdoc.model.*;
import com.docdoc.docdoc.model.enums.Role;
import com.docdoc.docdoc.model.enums.Specialite;
import com.docdoc.docdoc.service.AuthService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/register")
public class RegisterServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier que l'utilisateur connecté est un admin
        HttpSession session = request.getSession(false);
        if (session == null || !isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Accès refusé : seuls les administrateurs peuvent créer des comptes");
            return;
        }

        // Générer un token CSRF
        String csrfToken = CSRFTokenUtil.generateToken(session);
        request.setAttribute("csrfToken", csrfToken);

        request.getRequestDispatcher("/WEB-INF/views/admin/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier que l'utilisateur connecté est un admin
        HttpSession session = request.getSession(false);
        if (session == null || !isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Accès refusé : seuls les administrateurs peuvent créer des comptes");
            return;
        }

        // Valider le token CSRF
        String csrfToken = request.getParameter("csrfToken");
        if (!CSRFTokenUtil.validateToken(session, csrfToken)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Token CSRF invalide");
            return;
        }

        // Récupérer les paramètres du formulaire
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String roleStr = request.getParameter("role");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String specialiteStr = request.getParameter("specialite");

        // Validation des champs obligatoires
        if (nom == null || nom.trim().isEmpty() ||
                prenom == null || prenom.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                roleStr == null || roleStr.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
            doGet(request, response);
            return;
        }

        // Validation de l'email
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Format d'email invalide");
            doGet(request, response);
            return;
        }

        // Vérifier que l'email n'existe pas déjà
        if (authService.emailExists(email)) {
            request.setAttribute("error", "Cet email est déjà utilisé");
            doGet(request, response);
            return;
        }

        // Validation du mot de passe
        if (password.length() < 8) {
            request.setAttribute("error", "Le mot de passe doit contenir au moins 8 caractères");
            doGet(request, response);
            return;
        }

        // Vérifier que les mots de passe correspondent
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas");
            doGet(request, response);
            return;
        }

        try {
            Role role = Role.valueOf(roleStr);
            User user = null;

            // Créer l'utilisateur selon le rôle
            switch (role) {
                case INFIRMIER:
                    user = createInfirmier(nom, prenom, email, telephone);
                    break;

                case GENERALISTE:
                    user = createGeneraliste(nom, prenom, email, telephone);
                    break;

                case SPECIALISTE:
                    if (specialiteStr == null || specialiteStr.trim().isEmpty()) {
                        request.setAttribute("error", "La spécialité est requise pour un médecin spécialiste");
                        doGet(request, response);
                        return;
                    }
                    Specialite specialite = Specialite.valueOf(specialiteStr);
                    user = createSpecialiste(nom, prenom, email, telephone, specialite);
                    break;

                case ADMIN:
                    user = createAdmin(nom, prenom, email, telephone);
                    break;
            }

            // Enregistrer l'utilisateur
            authService.register(user, password);

            // Rediriger vers le dashboard admin avec message de succès
            session.setAttribute("successMessage", "Utilisateur créé avec succès");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Une erreur est survenue lors de l'inscription");
            doGet(request, response);
        }
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && user.getRole() == Role.ADMIN;
    }

    private Infirmier createInfirmier(String nom, String prenom, String email, String telephone) {
        Infirmier infirmier = new Infirmier(email, "", nom, prenom);
        if (telephone != null && !telephone.trim().isEmpty()) {
            infirmier.setTelephone(telephone);
        }
        return infirmier;
    }

    private MedecinGeneraliste createGeneraliste(String nom, String prenom, String email, String telephone) {
        MedecinGeneraliste generaliste = new MedecinGeneraliste(email, "", nom, prenom);
        if (telephone != null && !telephone.trim().isEmpty()) {
            generaliste.setTelephone(telephone);
        }
        return generaliste;
    }

    private MedecinSpecialiste createSpecialiste(String nom, String prenom, String email,
                                                 String telephone, Specialite specialite) {
        MedecinSpecialiste specialiste = new MedecinSpecialiste(email, "", nom, prenom, specialite);
        if (telephone != null && !telephone.trim().isEmpty()) {
            specialiste.setTelephone(telephone);
        }
        specialiste.setTarif(getDefaultTarif(specialite));
        return specialiste;
    }

    private Admin createAdmin(String nom, String prenom, String email, String telephone) {
        Admin admin = new Admin(email, "", nom, prenom);
        if (telephone != null && !telephone.trim().isEmpty()) {
            admin.setTelephone(telephone);
        }
        return admin;
    }

    private Double getDefaultTarif(Specialite specialite) {
        switch (specialite) {
            case CARDIOLOGIE:
            case NEUROLOGIE:
                return 450.0;
            case PNEUMOLOGIE:
            case GASTROENTEROLOGIE:
                return 350.0;
            case DERMATOLOGIE:
            case RHUMATOLOGIE:
            case OPHTALMOLOGIE:
            case ORL:
                return 300.0;
            case ENDOCRINOLOGIE:
            case PEDIATRIE:
                return 320.0;
            default:
                return 300.0;
        }
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email.matches(emailRegex);
    }
}