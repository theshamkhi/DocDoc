package com.docdoc.docdoc.servlet;

import com.docdoc.docdoc.model.User;
import com.docdoc.docdoc.model.enums.Role;
import com.docdoc.docdoc.repository.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private UserRepository userRepository;

    @Override
    public void init() throws ServletException {
        userRepository = new UserRepository();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Double vérification que l'utilisateur est admin
        if (session == null || !isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Accès refusé : réservé aux administrateurs");
            return;
        }

        try {
            // Récupérer tous les utilisateurs
            List<User> allUsers = userRepository.findAll();

            // Statistiques
            long totalUsers = allUsers.size();
            long adminCount = allUsers.stream()
                    .filter(u -> u.getRole() == Role.ADMIN).count();
            long infirmierCount = allUsers.stream()
                    .filter(u -> u.getRole() == Role.INFIRMIER).count();
            long generalisteCount = allUsers.stream()
                    .filter(u -> u.getRole() == Role.GENERALISTE).count();
            long specialisteCount = allUsers.stream()
                    .filter(u -> u.getRole() == Role.SPECIALISTE).count();

            // Passer les données à la JSP
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("infirmierCount", infirmierCount);
            request.setAttribute("generalisteCount", generalisteCount);
            request.setAttribute("specialisteCount", specialisteCount);
            request.setAttribute("allUsers", allUsers);

            // Message de succès si présent
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }

            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des données");
            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                    .forward(request, response);
        }
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && user.getRole() == Role.ADMIN;
    }
}