<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 15/10/2025
  Time: 10:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter des signes vitaux - Infirmier</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<!-- Navigation -->
<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <i class="fas fa-heartbeat text-blue-600 text-2xl mr-3"></i>
                <span class="text-xl font-bold text-gray-800">DocDoc - Infirmier</span>
            </div>
            <div class="flex items-center space-x-4">
                <a href="${pageContext.request.contextPath}/infirmier/dashboard"
                   class="text-gray-600 hover:text-gray-800">
                    <i class="fas fa-home mr-2"></i>Tableau de bord
                </a>
                <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
                   class="text-gray-600 hover:text-gray-800">
                    <i class="fas fa-users mr-2"></i>Patients
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
        <a href="${pageContext.request.contextPath}/infirmier/patient/detail?id=${patient.id}"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour au dossier
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Ajouter des signes vitaux</h1>
        <p class="text-gray-600">Pour le patient: <span class="font-semibold">${patient.nom} ${patient.prenom}</span></p>
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

    <c:if test="${not empty info}">
        <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6 rounded">
            <div class="flex items-center">
                <i class="fas fa-info-circle text-blue-500 text-xl mr-3"></i>
                <p class="text-blue-800">${info}</p>
            </div>
        </div>
    </c:if>

    <!-- Patient Info Card -->
    <div class="bg-gradient-to-r from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 mb-6 text-white">
        <div class="flex items-center">
            <div class="bg-white bg-opacity-20 rounded-full p-4 mr-4">
                <i class="fas fa-user text-3xl"></i>
            </div>
            <div>
                <h2 class="text-2xl font-bold">${patient.nom} ${patient.prenom}</h2>
                <p class="text-blue-100 mt-1">
                    <i class="fas fa-id-card mr-2"></i>${patient.numeroSecuriteSociale}
                </p>
                <c:if test="${not empty patient.telephone}">
                    <p class="text-blue-100">
                        <i class="fas fa-phone mr-2"></i>${patient.telephone}
                    </p>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Form -->
    <form method="post" action="${pageContext.request.contextPath}/infirmier/patient/signes-vitaux" class="space-y-6">
        <input type="hidden" name="csrfToken" value="${csrfToken}">
        <input type="hidden" name="patientId" value="${patient.id}">

        <!-- Signes vitaux -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-heartbeat text-red-600 mr-2"></i>
                Mesures des signes vitaux
            </h2>
            <p class="text-sm text-gray-600 mb-6">Renseignez au moins un signe vital</p>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Tension artérielle -->
                <div class="p-4 border-2 border-gray-200 rounded-lg hover:border-blue-500 transition">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-tachometer-alt text-blue-600 mr-2"></i>
                        Tension artérielle
                    </label>
                    <input type="text"
                           name="tensionArterielle"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Ex: 120/80">
                    <p class="text-xs text-gray-500 mt-1">Format: systolique/diastolique (mmHg)</p>
                </div>

                <!-- Fréquence cardiaque -->
                <div class="p-4 border-2 border-gray-200 rounded-lg hover:border-red-500 transition">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-heart text-red-600 mr-2"></i>
                        Fréquence cardiaque
                    </label>
                    <div class="relative">
                        <input type="number"
                               name="frequenceCardiaque"
                               min="0"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent"
                               placeholder="Ex: 72">
                        <span class="absolute right-3 top-2 text-gray-500 text-sm">bpm</span>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Battements par minute</p>
                </div>

                <!-- Température -->
                <div class="p-4 border-2 border-gray-200 rounded-lg hover:border-orange-500 transition">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-thermometer-half text-orange-600 mr-2"></i>
                        Température
                    </label>
                    <div class="relative">
                        <input type="number"
                               name="temperature"
                               step="0.1"
                               min="0"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                               placeholder="Ex: 37.5">
                        <span class="absolute right-3 top-2 text-gray-500 text-sm">°C</span>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Température corporelle</p>
                </div>

                <!-- Fréquence respiratoire -->
                <div class="p-4 border-2 border-gray-200 rounded-lg hover:border-teal-500 transition">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-lungs text-teal-600 mr-2"></i>
                        Fréquence respiratoire
                    </label>
                    <div class="relative">
                        <input type="number"
                               name="frequenceRespiratoire"
                               min="0"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                               placeholder="Ex: 16">
                        <span class="absolute right-3 top-2 text-gray-500 text-sm">/min</span>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Respirations par minute</p>
                </div>

                <!-- Poids -->
                <div class="p-4 border-2 border-gray-200 rounded-lg hover:border-purple-500 transition">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-weight text-purple-600 mr-2"></i>
                        Poids
                    </label>
                    <div class="relative">
                        <input type="number"
                               name="poids"
                               step="0.1"
                               min="0"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                               placeholder="Ex: 70.5">
                        <span class="absolute right-3 top-2 text-gray-500 text-sm">kg</span>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Poids du patient</p>
                </div>

                <!-- Taille -->
                <div class="p-4 border-2 border-gray-200 rounded-lg hover:border-indigo-500 transition">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-ruler-vertical text-indigo-600 mr-2"></i>
                        Taille
                    </label>
                    <div class="relative">
                        <input type="number"
                               name="taille"
                               step="0.1"
                               min="0"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                               placeholder="Ex: 175">
                        <span class="absolute right-3 top-2 text-gray-500 text-sm">cm</span>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Taille du patient</p>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex justify-end space-x-4">
            <a href="${pageContext.request.contextPath}/infirmier/patient/detail?id=${patient.id}"
               class="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg font-medium hover:bg-gray-300 transition">
                <i class="fas fa-times mr-2"></i>Annuler
            </a>
            <button type="submit"
                    class="px-6 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition shadow-lg">
                <i class="fas fa-save mr-2"></i>Enregistrer les signes vitaux
            </button>
        </div>
    </form>
</div>
</body>
</html>
