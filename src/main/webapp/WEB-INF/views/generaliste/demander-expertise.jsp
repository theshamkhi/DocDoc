<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 16/10/2025
  Time: 23:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demander une expertise - Médecin Généraliste</title>
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
        <a href="${pageContext.request.contextPath}/generaliste/consultation/detail?id=${consultation.id}"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour à la consultation
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">US3: Demander une expertise</h1>
        <p class="text-gray-600">
            Pour ${consultation.patient.nom} ${consultation.patient.prenom}
        </p>
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
    <form method="post" action="${pageContext.request.contextPath}/generaliste/consultation/demander-expertise" class="space-y-6">
        <input type="hidden" name="csrfToken" value="${csrfToken}">
        <input type="hidden" name="consultationId" value="${consultation.id}">

        <!-- Consultation Info Card -->
        <div class="bg-gradient-to-r from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
            <div class="flex items-center">
                <div class="bg-white bg-opacity-20 rounded-full p-4 mr-4">
                    <i class="fas fa-file-medical text-3xl"></i>
                </div>
                <div>
                    <h2 class="text-2xl font-bold">${consultation.motif}</h2>
                    <p class="text-blue-100 mt-1">
                        <i class="fas fa-calendar mr-2"></i>
                        <c:out value="${formattedDate}" />
                    </p>
                </div>
            </div>
        </div>

        <!-- Step 1: Choose Specialty -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-list text-green-600 mr-2"></i>
                Étape 1: Choisir une spécialité
            </h2>

            <div class="relative">
                <select name="specialite" id="specialite" required
                        onchange="chargerSpecialistes()"
                        class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-green-500 focus:ring-2 focus:ring-green-200 appearance-none bg-white cursor-pointer">
                    <option value="">-- Sélectionner une spécialité --</option>
                    <c:forEach var="spec" items="${specialites}">
                        <option value="${spec.name()}">${spec.label}</option>
                    </c:forEach>
                </select>
                <i class="fas fa-chevron-down absolute right-4 top-4 text-gray-400 pointer-events-none"></i>
            </div>
            <p class="text-xs text-gray-600 mt-2">
                <i class="fas fa-info-circle mr-1"></i>
                Utilisation Stream API: Filtrage des spécialistes par spécialité
            </p>
        </div>

        <!-- Step 2: Choose Specialist -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-user-md text-blue-600 mr-2"></i>
                Étape 2: Choisir un spécialiste
            </h2>

            <div class="relative">
                <select name="specialisteId" id="specialiste" required
                        onchange="chargerCreneaux()"
                        disabled
                        class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 appearance-none bg-white cursor-pointer disabled:opacity-50">
                    <option value="">-- Sélectionner un spécialiste --</option>
                </select>
                <i class="fas fa-chevron-down absolute right-4 top-4 text-gray-400 pointer-events-none"></i>
            </div>
            <p class="text-xs text-gray-600 mt-2">
                <i class="fas fa-info-circle mr-1"></i>
                Les spécialistes sont triés par tarif (du moins cher au plus cher)
            </p>
        </div>

        <!-- Step 3: Choose Time Slot -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-calendar-check text-purple-600 mr-2"></i>
                Étape 3: Sélectionner un créneau
            </h2>

            <div class="relative">
                <select name="creneauId" id="creneau" required
                        disabled
                        class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-200 appearance-none bg-white cursor-pointer disabled:opacity-50">
                    <option value="">-- Sélectionner un créneau horaire --</option>
                </select>
                <i class="fas fa-chevron-down absolute right-4 top-4 text-gray-400 pointer-events-none"></i>
            </div>
            <p class="text-xs text-gray-600 mt-2">
                <i class="fas fa-info-circle mr-1"></i>
                Les créneaux prédéfinis disponibles du spécialiste
            </p>
        </div>

        <!-- Step 4: Question and Data -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-comments text-orange-600 mr-2"></i>
                Étape 4: Question et données
            </h2>

            <!-- Question -->
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Question au spécialiste <span class="text-red-500">*</span>
                </label>
                <input type="text"
                       name="question"
                       required
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                       placeholder="Ex: Confirmer le diagnostic, préciser le traitement...">
                <p class="text-xs text-gray-500 mt-1">Votre question au spécialiste</p>
            </div>

            <!-- Additional Data -->
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Données et analyses supplémentaires
                </label>
                <textarea name="donneesSupplementaires"
                          rows="4"
                          class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                          placeholder="Analyses, images, historique médical pertinent..."></textarea>
                <p class="text-xs text-gray-500 mt-1">Informations complémentaires pour le spécialiste</p>
            </div>

            <!-- Priority -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Priorité
                </label>
                <div class="flex space-x-4">
                    <label class="flex items-center">
                        <input type="radio" name="priorite" value="NORMALE" checked
                               class="w-4 h-4 text-orange-600">
                        <span class="ml-2 text-sm text-gray-700">Normale</span>
                    </label>
                    <label class="flex items-center">
                        <input type="radio" name="priorite" value="HAUTE"
                               class="w-4 h-4 text-red-600">
                        <span class="ml-2 text-sm text-gray-700">Haute</span>
                    </label>
                    <label class="flex items-center">
                        <input type="radio" name="priorite" value="URGENTE"
                               class="w-4 h-4 text-red-700">
                        <span class="ml-2 text-sm text-gray-700">Urgente</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex justify-end space-x-4">
            <a href="${pageContext.request.contextPath}/generaliste/consultation/detail?id=${consultation.id}"
               class="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg font-medium hover:bg-gray-300 transition">
                <i class="fas fa-times mr-2"></i>Annuler
            </a>
            <button type="submit"
                    class="px-6 py-3 bg-green-600 text-white rounded-lg font-medium hover:bg-green-700 transition shadow-lg">
                <i class="fas fa-check mr-2"></i>Demander l'expertise
            </button>
        </div>
    </form>
</div>

<script>
    function chargerSpecialistes() {
        const specialite = document.getElementById('specialite').value;
        const selectSpecialiste = document.getElementById('specialiste');

        if (!specialite) {
            selectSpecialiste.disabled = true;
            selectSpecialiste.innerHTML = '<option value="">-- Sélectionner un spécialiste --</option>';
            return;
        }

        fetch('${pageContext.request.contextPath}/generaliste/api/specialistes-par-specialite?specialite=' + specialite)
            .then(response => response.json())
            .then(data => {
                selectSpecialiste.innerHTML = '<option value="">-- Sélectionner un spécialiste --</option>';

                if (data.length === 0) {
                    selectSpecialiste.disabled = true;
                    return;
                }

                data.forEach(specialiste => {
                    const option = document.createElement('option');
                    option.value = specialiste.id;
                    option.textContent = specialiste.nom + ' ' + specialiste.prenom + ' (' + specialiste.tarif + ' DH)';
                    selectSpecialiste.appendChild(option);
                });

                selectSpecialiste.disabled = false;
            });
    }

    function chargerCreneaux() {
        const specialisteId = document.getElementById('specialiste').value;
        const selectCreneau = document.getElementById('creneau');

        if (!specialisteId) {
            selectCreneau.disabled = true;
            selectCreneau.innerHTML = '<option value="">-- Sélectionner un créneau --</option>';
            return;
        }

        fetch('${pageContext.request.contextPath}/generaliste/api/creneaux-disponibles?specialisteId=' + specialisteId)
            .then(response => response.json())
            .then(data => {
                selectCreneau.innerHTML = '<option value="">-- Sélectionner un créneau --</option>';

                if (data.length === 0) {
                    selectCreneau.disabled = true;
                    const option = document.createElement('option');
                    option.textContent = 'Aucun créneau disponible';
                    option.disabled = true;
                    selectCreneau.appendChild(option);
                    return;
                }

                data.forEach(creneau => {
                    const option = document.createElement('option');
                    option.value = creneau.id;
                    option.textContent = creneau.date + ' - ' + creneau.heure;
                    selectCreneau.appendChild(option);
                });

                selectCreneau.disabled = false;
            });
    }
</script>
</body>
</html>
