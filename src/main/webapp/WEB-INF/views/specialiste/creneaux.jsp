<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 17/10/2025
  Time: 20:59
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
    <title>Créneaux - Médecin Spécialiste</title>
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
            </div>
        </div>
    </div>
</nav>

<div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/specialiste/dashboard"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">US6: Gestion des créneaux</h1>
        <p class="text-gray-600">Créneaux fixes de 30 minutes (09h00 - 12h00)</p>
    </div>

    <c:if test="${not empty param.success}">
        <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded animate-pulse">
            <i class="fas fa-check-circle text-green-500 mr-3"></i>
            <p class="text-green-800">${param.success}</p>
        </div>
    </c:if>

    <!-- Date Selection -->
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <form method="get" class="flex gap-4 items-end">
            <div class="flex-1">
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-calendar-alt mr-2"></i>Sélectionner une date
                </label>
                <input type="date" name="date" value="${dateSelected}"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
            </div>
            <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                <i class="fas fa-search mr-2"></i>Charger
            </button>
        </form>
    </div>

    <!-- Initialize New Slots -->
    <div class="bg-gradient-to-r from-purple-50 to-indigo-50 border-l-4 border-purple-500 p-6 rounded-r-lg mb-6">
        <h3 class="text-lg font-bold text-purple-900 mb-3">
            <i class="fas fa-plus-circle mr-2"></i>Initialiser les créneaux
        </h3>
        <p class="text-purple-800 text-sm mb-4">
            Créez les 6 créneaux prédéfinis de 30 minutes pour la date sélectionnée
        </p>
        <form method="post" action="${pageContext.request.contextPath}/specialiste/creneaux">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="date" value="${dateSelected}">
            <button type="submit" class="px-6 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 font-medium">
                <i class="fas fa-calendar-plus mr-2"></i>Créer les créneaux du ${dateSelected}
            </button>
        </form>
    </div>

    <!-- Creneaux Table -->
    <div class="bg-white rounded-lg shadow-lg overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-white">
            <h2 class="text-xl font-bold text-gray-900">
                <i class="fas fa-clock text-blue-600 mr-2"></i>
                Créneaux du ${dateSelected}
            </h2>
        </div>

        <c:choose>
            <c:when test="${empty creneaux}">
                <div class="p-12 text-center text-gray-500">
                    <i class="fas fa-inbox text-4xl mb-3"></i>
                    <p>Aucun créneau pour cette date</p>
                    <p class="text-sm mt-2">Cliquez sur "Créer les créneaux" pour initialiser</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Horaire</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Durée</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Statut</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Réservé par</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                        <c:forEach var="creneau" items="${creneaux}">
                            <tr class="hover:bg-gray-50 transition ${creneau.disponible ? '' : 'bg-gray-100'}">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <p class="text-lg font-bold text-gray-900">
                                            ${creneau.heureDebut} - ${creneau.heureFin}
                                    </p>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <p class="text-gray-700">30 minutes</p>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${creneau.disponible}">
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                    <i class="fas fa-check-circle mr-1"></i>Disponible
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                    <i class="fas fa-times-circle mr-1"></i>Réservé
                                                </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:if test="${not empty creneau.demandeExpertise}">
                                        <p class="text-sm text-gray-900">
                                                ${creneau.demandeExpertise.consultation.patient.nom} ${creneau.demandeExpertise.consultation.patient.prenom}
                                        </p>
                                        <p class="text-xs text-gray-600">
                                            ${creneau.demandeExpertise.dateDemande}
                                        </p>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Info Box -->
    <div class="mt-8 bg-gradient-to-r from-blue-50 to-indigo-50 border-l-4 border-blue-600 p-6 rounded-r-lg">
        <h3 class="text-lg font-bold text-blue-900 mb-3">À propos des créneaux</h3>
        <ul class="text-blue-800 space-y-2 text-sm">
            <li><i class="fas fa-check-circle mr-2 text-green-600"></i>Créneaux fixes: 09h00 à 12h00 (6 créneaux de 30 min)</li>
            <li><i class="fas fa-check-circle mr-2 text-green-600"></i>Réservé: Marque automatiquement comme non disponible</li>
            <li><i class="fas fa-check-circle mr-2 text-green-600"></i>Passé: Archivé automatiquement</li>
            <li><i class="fas fa-check-circle mr-2 text-green-600"></i>Annulation: Redevient disponible</li>
        </ul>
    </div>
</div>
</body>
</html>