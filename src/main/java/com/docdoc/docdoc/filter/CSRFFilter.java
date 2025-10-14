package com.docdoc.docdoc.filter;

import com.docdoc.docdoc.util.CSRFTokenUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class CSRFFilter implements Filter {

    // Méthodes HTTP qui nécessitent la vérification CSRF
    private static final List<String> CSRF_METHODS = Arrays.asList("POST", "PUT", "DELETE");

    // URLs exemptées de la vérification CSRF
    private static final List<String> EXEMPT_URLS = Arrays.asList(
            "/login",
            "/register"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String method = httpRequest.getMethod();
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Vérifier si la requête nécessite la protection CSRF
        boolean requiresCSRF = CSRF_METHODS.contains(method);
        boolean isExempt = EXEMPT_URLS.stream().anyMatch(path::startsWith);

        if (requiresCSRF && !isExempt && session != null) {
            String token = httpRequest.getParameter("csrfToken");

            if (!CSRFTokenUtil.validateToken(session, token)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Token CSRF invalide ou manquant");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
