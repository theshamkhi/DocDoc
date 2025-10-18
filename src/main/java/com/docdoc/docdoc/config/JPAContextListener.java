package com.docdoc.docdoc.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class JPAContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application démarrée - EntityManagerFactory initialisée");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application arrêtée - Fermeture de l'EntityManagerFactory");
        JPAUtil.closeEntityManagerFactory();
    }
}