package com.docdoc.docdoc.service;


import com.docdoc.docdoc.model.User;
import com.docdoc.docdoc.repository.UserRepository;
import com.docdoc.docdoc.util.PasswordUtil;

import java.util.Optional;

public class AuthService {

    private final UserRepository userRepository;

    public AuthService() {
        this.userRepository = new UserRepository();
    }

    /**
     * Authentifie un utilisateur
     * @return Optional<User> contenant l'utilisateur si l'authentification réussit
     */
    public Optional<User> authenticate(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmail(email);

        if (userOpt.isEmpty()) {
            return Optional.empty();
        }

        User user = userOpt.get();

        if (PasswordUtil.checkPassword(password, user.getPassword())) {
            return Optional.of(user);
        }

        return Optional.empty();
    }

    /**
     * Vérifie si un email existe déjà
     */
    public boolean emailExists(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Enregistre un nouvel utilisateur
     */
    public User register(User user, String plainPassword) {
        if (emailExists(user.getEmail())) {
            throw new IllegalArgumentException("Cet email est déjà utilisé");
        }

        String hashedPassword = PasswordUtil.hashPassword(plainPassword);
        user.setPassword(hashedPassword);

        return userRepository.save(user);
    }

    /**
     * Change le mot de passe d'un utilisateur
     */
    public void changePassword(User user, String oldPassword, String newPassword) {
        if (!PasswordUtil.checkPassword(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("L'ancien mot de passe est incorrect");
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        user.setPassword(hashedPassword);
        userRepository.save(user);
    }
}