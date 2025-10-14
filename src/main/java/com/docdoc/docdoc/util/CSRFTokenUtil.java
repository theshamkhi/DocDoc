package com.docdoc.docdoc.util;

import jakarta.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class CSRFTokenUtil {

    private static final String CSRF_TOKEN_SESSION_ATTR = "csrfToken";
    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Génère un nouveau token CSRF et le stocke dans la session
     */
    public static String generateToken(HttpSession session) {
        byte[] tokenBytes = new byte[32];
        RANDOM.nextBytes(tokenBytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
        session.setAttribute(CSRF_TOKEN_SESSION_ATTR, token);
        return token;
    }

    /**
     * Récupère le token CSRF de la session (ou en génère un nouveau)
     */
    public static String getToken(HttpSession session) {
        String token = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        if (token == null) {
            token = generateToken(session);
        }
        return token;
    }

    /**
     * Valide un token CSRF
     */
    public static boolean validateToken(HttpSession session, String token) {
        if (token == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        return token.equals(sessionToken);
    }

    /**
     * Invalide le token CSRF actuel
     */
    public static void invalidateToken(HttpSession session) {
        session.removeAttribute(CSRF_TOKEN_SESSION_ATTR);
    }
}