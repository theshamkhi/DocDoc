<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 15/10/2025
  Time: 10:28
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
    <title>Liste des patients - Infirmier</title>
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
                   class="text-blue-600 hover:text-blue-800 font-medium">
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

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header with Actions -->
    <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between">
        <div class="mb-4 md:mb-0">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Liste des patients</h1>
            <p class="text-gray-600">Gestion de la file d'attente et des patients</p>
        </div>
        <a href="${pageContext.request.contextPath}/infirmier/patient/enregistrer"
           class="bg-green-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-green-700 transition shadow-lg inline-flex items-center justify-center">
            <i class="fas fa-plus mr-2"></i>Nouveau patient
        </a>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty success}">
        <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded animate-pulse">
            <div class="flex items-center">
                <i class="fas fa-check-circle text-green-500 text-xl mr-3"></i>
                <p class="text-green-800">${success}</p>
            </div>
        </div>
    </c:if>

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

    <!-- Statistics with Queue Info -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div class="bg-white p-4 rounded-lg shadow border-l-4 border-blue-500">
            <div class="flex items-center">
                <i class="fas fa-users text-blue-500 text-3xl mr-4"></i>
                <div>
                    <p class="text-gray-600 text-sm">Total patients</p>
                    <p class="text-2xl font-bold text-gray-900">${nombreTotal}</p>
                </div>
            </div>
        </div>
        <div class="bg-white p-4 rounded-lg shadow border-l-4 border-orange-500">
            <div class="flex items-center">
                <i class="fas fa-hourglass-end text-orange-500 text-3xl mr-4"></i>
                <div>
                    <p class="text-gray-600 text-sm">En file d'attente</p>
                    <p class="text-2xl font-bold text-gray-900">${nombreEnAttente}</p>
                    <p class="text-xs text-gray-500 mt-1">Ordre FIFO</p>
                </div>
            </div>
        </div>
        <div class="bg-white p-4 rounded-lg shadow border-l-4 border-green-500">
            <div class="flex items-center">
                <i class="fas fa-check-circle text-green-500 text-3xl mr-4"></i>
                <div>
                    <p class="text-gray-600 text-sm">Traités</p>
                    <p class="text-2xl font-bold text-gray-900">${nombreTotal - nombreEnAttente}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters and Search -->
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <form method="get" action="${pageContext.request.contextPath}/infirmier/liste-patients" class="space-y-4">
            <!-- Filter Tabs -->
            <div class="flex flex-wrap gap-2 mb-4">
                <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
                   class="px-4 py-2 rounded-lg font-medium transition ${filtreActif eq 'jour' ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'}">
                    <i class="fas fa-calendar-day mr-2"></i>Patients du jour
                </a>
                <a href="${pageContext.request.contextPath}/infirmier/liste-patients?filtre=attente"
                   class="px-4 py-2 rounded-lg font-medium transition ${filtreActif eq 'attente' ? 'bg-orange-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'}">
                    <i class="fas fa-hourglass-end mr-2"></i>File d'attente
                    <c:if test="${nombreEnAttente > 0}">
                        <span class="ml-2 bg-red-500 text-white px-2 py-1 rounded-full text-xs font-bold">${nombreEnAttente}</span>
                    </c:if>
                </a>
            </div>

            <!-- Search Bar -->
            <div class="flex gap-2">
                <div class="flex-1 relative">
                    <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    <input type="text"
                           name="recherche"
                           value="${recherche}"
                           placeholder="Rechercher par nom, prénom ou numéro de sécurité sociale..."
                           class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                </div>
                <input type="hidden" name="filtre" value="${filtreActif}">
                <button type="submit"
                        class="bg-blue-600 text-white px-6 py-2 rounded-lg font-medium hover:bg-blue-700 transition">
                    <i class="fas fa-search mr-2"></i>Rechercher
                </button>
                <c:if test="${not empty recherche}">
                    <a href="${pageContext.request.contextPath}/infirmier/liste-patients?filtre=${filtreActif}"
                       class="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg font-medium hover:bg-gray-300 transition">
                        <i class="fas fa-times"></i>
                    </a>
                </c:if>
            </div>
        </form>
    </div>

    <!-- Queue Order Info (shown only when in attente filter) -->
    <c:if test="${filtreActif eq 'attente' and not empty patients}">
        <div class="bg-gradient-to-r from-orange-50 to-yellow-50 border-l-4 border-orange-500 p-4 mb-6 rounded-r-lg">
            <div class="flex items-start">
                <i class="fas fa-arrow-down text-orange-600 text-2xl mr-3 mt-1"></i>
                <div>
                    <h3 class="font-bold text-orange-900 mb-1">Ordre de la file d'attente</h3>
                    <p class="text-orange-800 text-sm">Les patients sont présentés par ordre d'arrivée (FIFO). Le premier de la liste est le prochain à être consulté.</p>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Patients Table -->
    <div class="bg-white rounded-lg shadow-lg overflow-hidden">
        <c:choose>
            <c:when test="${empty patients}">
                <div class="p-12 text-center">
                    <i class="fas fa-user-slash text-6xl text-gray-300 mb-4"></i>
                    <h3 class="text-xl font-bold text-gray-700 mb-2">Aucun patient trouvé</h3>
                    <p class="text-gray-500 mb-6">
                        <c:choose>
                            <c:when test="${not empty recherche}">
                                Aucun résultat pour "${recherche}"
                            </c:when>
                            <c:when test="${filtreActif eq 'attente'}">
                                Aucun patient en attente pour le moment
                            </c:when>
                            <c:otherwise>
                                Aucun patient enregistré aujourd'hui
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/infirmier/patient/enregistrer"
                       class="inline-flex items-center bg-green-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-green-700 transition">
                        <i class="fas fa-plus mr-2"></i>Enregistrer un patient
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <c:if test="${filtreActif eq 'attente'}">
                                    <i class="fas fa-sort-numeric-down mr-2"></i>Position
                                </c:if>
                                Patient
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                N° Sécurité Sociale
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Date d'enregistrement
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Statut
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Actions
                            </th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="patient" items="${patients}" varStatus="status">
                            <tr class="hover:bg-gray-50 transition ${patient.enAttente ? 'bg-orange-50 border-l-4 border-orange-500' : ''}">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <c:if test="${filtreActif eq 'attente'}">
                                            <div class="flex-shrink-0 h-8 w-8 bg-orange-500 text-white rounded-full flex items-center justify-center font-bold text-sm mr-3">
                                                    ${status.index + 1}
                                            </div>
                                        </c:if>
                                        <div class="flex-shrink-0 h-10 w-10 ${patient.enAttente ? 'bg-orange-100' : 'bg-blue-100'} rounded-full flex items-center justify-center shadow">
                                            <i class="fas fa-user ${patient.enAttente ? 'text-orange-600' : 'text-blue-600'}"></i>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-bold text-gray-900">
                                                    ${patient.nom} ${patient.prenom}
                                            </div>
                                            <c:if test="${not empty patient.telephone}">
                                                <div class="text-sm text-gray-500">
                                                    <i class="fas fa-phone text-xs mr-1"></i>${patient.telephone}
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="text-sm font-mono text-gray-900 bg-gray-100 px-2 py-1 rounded">
                                            ${patient.numeroSecuriteSociale}
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    <i class="far fa-calendar-alt mr-1"></i>
                                    <fmt:formatDate value="${patient.dateEnregistrement}" pattern="dd/MM/yyyy"/>
                                    <br>
                                    <i class="far fa-clock mr-1"></i>
                                    <fmt:formatDate value="${patient.dateEnregistrement}" pattern="HH:mm"/>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${patient.enAttente}">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-orange-100 text-orange-800 animate-pulse">
                                                <i class="fas fa-hourglass-end mr-1"></i> En file
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                <i class="fas fa-check mr-1"></i> Traité
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <div class="flex space-x-2">
                                        <a href="${pageContext.request.contextPath}/infirmier/patient/detail?id=${patient.id}"
                                           class="text-blue-600 hover:text-blue-900 font-medium">
                                            <i class="fas fa-eye mr-1"></i>Voir
                                        </a>
                                        <a href="${pageContext.request.contextPath}/infirmier/patient/signes-vitaux?id=${patient.id}"
                                           class="text-green-600 hover:text-green-900 font-medium">
                                            <i class="fas fa-heartbeat mr-1"></i>Signes
                                        </a>
                                        <c:if test="${patient.enAttente}">
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/infirmier/patient/retirer-attente"
                                                  class="inline"
                                                  onsubmit="return confirm('Retirer ce patient de la file d\'attente ?');">
                                                <input type="hidden" name="patientId" value="${patient.id}">
                                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                <button type="submit"
                                                        class="text-red-600 hover:text-red-900 font-medium">
                                                    <i class="fas fa-times mr-1"></i>Retirer
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Queue Management Info -->
    <div class="mt-8 bg-gradient-to-r from-blue-50 to-indigo-50 border-l-4 border-blue-600 p-6 rounded-r-lg">
        <div class="flex items-start">
            <i class="fas fa-lightbulb text-blue-600 text-2xl mr-4 mt-1"></i>
            <div>
                <h3 class="text-lg font-bold text-blue-900 mb-2">Gestion de la file d'attente</h3>
                <ul class="text-blue-800 text-sm space-y-2">
                    <li><i class="fas fa-check-circle mr-2 text-green-600"></i>Les patients sont ajoutés à la file lors de l'enregistrement de leurs signes vitaux</li>
                    <li><i class="fas fa-check-circle mr-2 text-green-600"></i>Classement FIFO: Premier arrivé, premier consulté</li>
                    <li><i class="fas fa-check-circle mr-2 text-green-600"></i>La position dans la file est visible dans le filtre "File d'attente"</li>
                    <li><i class="fas fa-check-circle mr-2 text-green-600"></i>Après la consultation, les patients sont automatiquement retirés</li>
                    <li><i class="fas fa-check-circle mr-2 text-green-600"></i>Statut "En file" = patient en attente de consultation</li>
                </ul>
            </div>
        </div>
    </div>
</div>
</body>
</html>