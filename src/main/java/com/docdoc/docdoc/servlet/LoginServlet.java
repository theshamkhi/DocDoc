package com.docdoc.docdoc.servlet;

import com.docdoc.docdoc.model.User;
import com.docdoc.docdoc.model.enums.Role;
import com.docdoc.docdoc.service.AuthService;
import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Si déjà connecté, rediriger vers le dashboard approprié
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectToDashboard(response, request.getContextPath(), user.getRole());
            return;
        }

        // Générer un token CSRF
        session = request.getSession(true);
        String csrfToken = CSRFTokenUtil.generateToken(session);
        request.setAttribute("csrfToken", csrfToken);

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validation des paramètres
        if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email et mot de passe sont requis");
            doGet(request, response);
            return;
        }

        // Authentification
        Optional<User> userOpt = authService.authenticate(email, password);

        if (userOpt.isEmpty()) {
            request.setAttribute("error", "Email ou mot de passe incorrect");
            doGet(request, response);
            return;
        }

        User user = userOpt.get();

        // Créer une nouvelle session
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("userName", user.getFullName());

        // Générer nouveau token CSRF
        CSRFTokenUtil.generateToken(session);

        // Rediriger vers le dashboard approprié
        redirectToDashboard(response, request.getContextPath(), user.getRole());
    }

    private void redirectToDashboard(HttpServletResponse response, String contextPath, Role role)
            throws IOException {
        switch (role) {
            case INFIRMIER:
                response.sendRedirect(contextPath + "/infirmier/dashboard");
                break;
            case GENERALISTE:
                response.sendRedirect(contextPath + "/generaliste/dashboard");
                break;
            case SPECIALISTE:
                response.sendRedirect(contextPath + "/specialiste/dashboard");
                break;
            case ADMIN:
                response.sendRedirect(contextPath + "/admin/dashboard");
                break;
            default:
                response.sendRedirect(contextPath + "/login");
        }
    }
}