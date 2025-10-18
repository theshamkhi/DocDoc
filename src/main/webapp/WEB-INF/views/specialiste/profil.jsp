<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 17/10/2025
  Time: 20:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Médecin Spécialiste</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <i class="fas fa-microscope text-blue-600 text-2xl mr-3"></i>
                <span class="text-xl font-bold text-gray-800">DocDoc</span>
            </div>
            <div class="flex items-center space-x-4">
                <a href="${pageContext.request.contextPath}/specialiste/dashboard"
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
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/specialiste/dashboard"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Configurer mon profil</h1>
        <p class="text-gray-600">Définir votre tarif et spécialité</p>
    </div>

    <c:if test="${not empty error}">
        <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded">
            <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
            <p class="text-red-800">${error}</p>
        </div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded animate-pulse">
            <i class="fas fa-check-circle text-green-500 mr-3"></i>
            <p class="text-green-800">${success}</p>
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/specialiste/profil" class="space-y-6">
        <input type="hidden" name="csrfToken" value="${csrfToken}">

        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                <i class="fas fa-user-circle text-blue-600 mr-3"></i>
                Informations personnelles
            </h2>

            <div class="grid grid-cols-2 gap-4 mb-6 pb-6 border-b border-gray-200">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Nom</label>
                    <input type="text" value="${specialiste.nom}" disabled
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg bg-gray-100">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Prénom</label>
                    <input type="text" value="${specialiste.prenom}" disabled
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg bg-gray-100">
                </div>
            </div>

            <!-- Spécialité -->
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-stethoscope text-blue-600 mr-2"></i>
                    Spécialité
                </label>
                <select name="specialite"
                        class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200">
                    <option value="">-- Sélectionner --</option>
                    <c:forEach var="spec" items="${specialites}">
                        <option value="${spec.name()}"
                            ${specialiste.specialite.name() == spec.name() ? 'selected' : ''}>
                                ${spec.label}
                        </option>
                    </c:forEach>
                </select>
                <p class="text-xs text-gray-600 mt-1">Votre domaine de spécialité</p>
            </div>

            <!-- Tarif -->
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-money-bill-wave text-green-600 mr-2"></i>
                    Tarif de consultation (DH)
                </label>
                <div class="relative">
                    <input type="number" name="tarif" value="${specialiste.tarif}"
                           min="50" step="10" required
                           class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-green-500 focus:ring-2 focus:ring-green-200"
                           placeholder="Ex: 300">
                    <span class="absolute right-4 top-3 text-gray-600">DH</span>
                </div>
                <p class="text-xs text-gray-600 mt-1">Tarif horaire pour une expertise</p>
            </div>

            <!-- Durée (Read-only) -->
            <div class="mb-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
                <label class="block text-sm font-medium text-blue-900 mb-2">
                    <i class="fas fa-clock text-blue-600 mr-2"></i>
                    Durée de consultation (fixe)
                </label>
                <p class="text-2xl font-bold text-blue-700">${specialiste.dureeConsultation} minutes</p>
                <p class="text-xs text-blue-700 mt-2">La durée est fixée à 30 minutes pour tous les créneaux</p>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex justify-end space-x-4">
            <a href="${pageContext.request.contextPath}/specialiste/dashboard"
               class="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg font-medium hover:bg-gray-300">
                <i class="fas fa-times mr-2"></i>Annuler
            </a>
            <button type="submit"
                    class="px-6 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 shadow-lg">
                <i class="fas fa-save mr-2"></i>Enregistrer
            </button>
        </div>
    </form>
</div>
</body>
</html>