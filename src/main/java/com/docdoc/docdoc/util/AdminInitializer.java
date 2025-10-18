package com.docdoc.docdoc.util;

import com.docdoc.docdoc.model.Admin;
import com.docdoc.docdoc.service.AuthService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Listener to initialize the first administrator at application startup
 * If no admin exists, creates a default admin
 */
@WebListener
public class AdminInitializer implements ServletContextListener {

    private static final String DEFAULT_ADMIN_EMAIL = "admin@docdoc.com";
    private static final String DEFAULT_ADMIN_PASSWORD = "Admin@123";
    private static final String DEFAULT_ADMIN_NOM = "Admin";
    private static final String DEFAULT_ADMIN_PRENOM = "DocDoc";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Checking if an administrator exists...");

        AuthService authService = new AuthService();

        try {
            // Check if the default admin already exists
            if (!authService.emailExists(DEFAULT_ADMIN_EMAIL)) {
                // Create the default admin
                Admin admin = new Admin(
                        DEFAULT_ADMIN_EMAIL,
                        "",
                        DEFAULT_ADMIN_NOM,
                        DEFAULT_ADMIN_PRENOM
                );

                authService.register(admin, DEFAULT_ADMIN_PASSWORD);

                System.out.println("=========================================");
                System.out.println("DEFAULT ADMIN CREATED SUCCESSFULLY");
                System.out.println("Email: " + DEFAULT_ADMIN_EMAIL);
                System.out.println("Password: " + DEFAULT_ADMIN_PASSWORD);
                System.out.println("IMPORTANT: Change this password on first login!");
                System.out.println("=========================================");
            } else {
                System.out.println("An administrator already exists in the system.");
            }
        } catch (Exception e) {
            System.err.println("Error initializing the administrator: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
