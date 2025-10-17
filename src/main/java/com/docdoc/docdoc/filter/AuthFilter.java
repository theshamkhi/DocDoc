package com.docdoc.docdoc.filter;

import com.docdoc.docdoc.model.User;
import com.docdoc.docdoc.model.enums.Role;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/login",
            "/login.jsp",
            "/css/",
            "/js/",
            "/images/"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Vérifier si la ressource est publique
        boolean isPublicResource = PUBLIC_URLS.stream()
                .anyMatch(path::startsWith);

        if (isPublicResource) {
            chain.doFilter(request, response);
            return;
        }

        // Vérifier l'authentification
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Rediriger vers la page de login
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // Vérifier les autorisations par rôle
        if (!isAuthorized(user.getRole(), path)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Accès refusé : vous n'avez pas les permissions nécessaires");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isAuthorized(Role role, String path) {
        switch (role) {
            case ADMIN:
                return true;

            case INFIRMIER:
                return path.startsWith("/infirmier") ||
                        path.equals("/") ||
                        path.startsWith("/logout");

            case GENERALISTE:
                return path.startsWith("/generaliste") ||
                        path.equals("/") ||
                        path.startsWith("/logout");

            case SPECIALISTE:
                return path.startsWith("/specialiste") ||
                        path.equals("/") ||
                        path.startsWith("/logout");

            default:
                return false;
        }
    }
}