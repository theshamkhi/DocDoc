<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 16/10/2025
  Time: 23:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer une consultation - Médecin Généraliste</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<!-- Navigation -->
<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <i class="fas fa-stethoscope text-blue-600 text-2xl mr-3"></i>
                <span class="text-xl font-bold text-gray-800">DocDoc - Médecin Généraliste</span>
            </div>
            <div class="flex items-center space-x-4">
                <a href="${pageContext.request.contextPath}/generaliste/dashboard"
                   class="text-gray-600 hover:text-gray-800">
                    <i class="fas fa-home mr-2"></i>Tableau de bord
                </a>
                <a href="${pageContext.request.contextPath}/logout"
                   class="text-red-600 hover:text-red-800">
                    <i class="fas fa-sign-out-alt mr-2"></i>Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/generaliste/dashboard"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour
        </a>
        <p class="text-gray-600">Sélectionner un patient et saisir le motif de consultation</p>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty error}">
        <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded">
            <div class="flex items-center">
                <i class="fas fa-exclamation-circle text-red-500 text-xl mr-3"></i>
                <p class="text-red-800">${error}</p>
            </div>
        </div>
    </c:if>

    <!-- Form -->
    <form method="post" action="${pageContext.request.contextPath}/generaliste/consultation/creer" class="space-y-6">
        <input type="hidden" name="csrfToken" value="${csrfToken}">

        <!-- Patient Selection -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-user text-blue-600 mr-2"></i>
                Sélectionner un patient
            </h2>

            <c:choose>
                <c:when test="${empty patientsEnAttente}">
                    <div class="bg-blue-50 border-l-4 border-blue-500 p-4 rounded">
                        <p class="text-blue-800">
                            <i class="fas fa-info-circle mr-2"></i>
                            Aucun patient en attente pour le moment
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="relative">
                        <select name="patientId" required
                                class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 appearance-none bg-white cursor-pointer">
                            <option value="">-- Sélectionner un patient --</option>
                            <c:forEach var="patient" items="${patientsEnAttente}">
                                <option value="${patient.id}">
                                        ${patient.nom} ${patient.prenom} (${patient.numeroSecuriteSociale})
                                </option>
                            </c:forEach>
                        </select>
                        <i class="fas fa-chevron-down absolute right-4 top-4 text-gray-400 pointer-events-none"></i>
                    </div>
                    <p class="text-sm text-gray-600 mt-2">
                        <i class="fas fa-users mr-1"></i>
                            ${patientsEnAttente.size()} patient(s) en attente
                    </p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Consultation Details -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-file-medical text-green-600 mr-2"></i>
                Détails de la consultation
            </h2>

            <!-- Motif -->
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Motif de consultation <span class="text-red-500">*</span>
                </label>
                <input type="text"
                       name="motif"
                       required
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       placeholder="Ex: Mal de tête persistant, consultation de suivi...">
                <p class="text-xs text-gray-500 mt-1">Décrivez le motif principal de la visite</p>
            </div>

            <!-- Observations -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Observations
                </label>
                <textarea name="observations"
                          rows="4"
                          class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          placeholder="Notes cliniques, symptômes observés..."></textarea>
                <p class="text-xs text-gray-500 mt-1">Remarques supplémentaires (optionnel)</p>
            </div>
        </div>

        <!-- Cost Information -->
        <div class="bg-gradient-to-r from-blue-50 to-indigo-50 border-l-4 border-blue-600 p-6 rounded-r-lg">
            <div class="flex items-start">
                <i class="fas fa-info-circle text-blue-600 text-2xl mr-4 mt-1"></i>
                <div>
                    <h3 class="text-lg font-bold text-blue-900 mb-2">Coût de la consultation</h3>
                    <div class="space-y-1 text-blue-800">
                        <p><i class="fas fa-check-circle mr-2"></i>Consultation: <strong>150 DH</strong> (fixe)</p>
                        <p><i class="fas fa-check-circle mr-2"></i>Actes techniques: À ajouter après</p>
                        <p><i class="fas fa-check-circle mr-2"></i>Expertise: Si demandée au spécialiste</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex justify-end space-x-4">
            <a href="${pageContext.request.contextPath}/generaliste/dashboard"
               class="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg font-medium hover:bg-gray-300 transition">
                <i class="fas fa-times mr-2"></i>Annuler
            </a>
            <button type="submit"
                    class="px-6 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition shadow-lg disabled:opacity-50"
            ${empty patientsEnAttente ? 'disabled' : ''}>
                <i class="fas fa-check mr-2"></i>Créer la consultation
            </button>
        </div>
    </form>
</div>
</body>
</html>