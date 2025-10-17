<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 15/10/2025
  Time: 10:19
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
    <title>Tableau de bord - Infirmier</title>
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
                   class="text-blue-600 hover:text-blue-800 font-medium">
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

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Tableau de bord</h1>
        <p class="text-gray-600">Vue d'ensemble de l'activité du jour</p>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
        <!-- Patients du jour -->
        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-blue-100 text-sm font-medium mb-1">Patients du jour</p>
                    <p class="text-4xl font-bold">${nombrePatientsDuJour}</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-user-injured text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Patients en attente (Queue) -->
        <div class="bg-gradient-to-br from-orange-500 to-orange-600 rounded-lg shadow-lg p-6 text-white hover:shadow-xl transition">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-orange-100 text-sm font-medium mb-1">
                        <i class="fas fa-hourglass-end mr-1"></i>En attente (File)
                    </p>
                    <p class="text-4xl font-bold">${nombrePatientsEnAttente}</p>
                    <p class="text-orange-100 text-xs mt-2">Classés par heure d'arrivée</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-clock text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Quick Action -->
        <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg p-6 text-white">
            <div class="flex flex-col justify-between h-full">
                <div>
                    <p class="text-green-100 text-sm font-medium mb-2">Action rapide</p>
                    <p class="text-lg mb-4">Enregistrer un nouveau patient</p>
                </div>
                <a href="${pageContext.request.contextPath}/infirmier/patient/enregistrer"
                   class="bg-white text-green-600 px-4 py-2 rounded-lg font-medium hover:bg-green-50 transition text-center">
                    <i class="fas fa-plus mr-2"></i>Nouveau patient
                </a>
            </div>
        </div>
    </div>

    <!-- Recent Patients with Queue Indicator -->
    <div class="bg-white rounded-lg shadow-lg overflow-hidden mb-8">
        <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center bg-gradient-to-r from-gray-50 to-white">
            <h2 class="text-xl font-bold text-gray-900">
                <i class="fas fa-history text-blue-600 mr-2"></i>
                Patients récents (Derniers enregistrés)
            </h2>
            <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
               class="text-blue-600 hover:text-blue-800 font-medium">
                Voir tous <i class="fas fa-arrow-right ml-1"></i>
            </a>
        </div>

        <c:choose>
            <c:when test="${empty patientsRecents}">
                <div class="p-8 text-center text-gray-500">
                    <i class="fas fa-inbox text-4xl mb-3"></i>
                    <p>Aucun patient enregistré aujourd'hui</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
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
                        <c:forEach var="patient" items="${patientsRecents}">
                            <tr class="hover:bg-gray-50 transition ${patient.enAttente ? 'bg-orange-50 border-l-4 border-orange-500' : ''}">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 ${patient.enAttente ? 'bg-orange-100' : 'bg-blue-100'} rounded-full flex items-center justify-center">
                                            <i class="fas fa-user ${patient.enAttente ? 'text-orange-600' : 'text-blue-600'}"></i>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">
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
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        ${patient.numeroSecuriteSociale}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    <fmt:formatDate value="${patient.dateEnregistrement}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${patient.enAttente}">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-orange-100 text-orange-800 animate-pulse">
                                                <i class="fas fa-hourglass-end mr-1"></i> En file d'attente
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                <i class="fas fa-check-circle mr-1"></i> Traité
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <a href="${pageContext.request.contextPath}/infirmier/patient/detail?id=${patient.id}"
                                       class="text-blue-600 hover:text-blue-900 mr-3">
                                        <i class="fas fa-eye"></i> Détails
                                    </a>
                                    <a href="${pageContext.request.contextPath}/infirmier/patient/signes-vitaux?id=${patient.id}"
                                       class="text-green-600 hover:text-green-900">
                                        <i class="fas fa-heartbeat"></i> Signes
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Quick Links -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <a href="${pageContext.request.contextPath}/infirmier/liste-patients?filtre=attente"
           class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition border-l-4 border-orange-500">
            <i class="fas fa-user-clock text-3xl text-orange-500 mb-3"></i>
            <h3 class="text-lg font-bold text-gray-900 mb-2">File d'attente</h3>
            <p class="text-gray-600 text-sm">Patients classés par ordre d'arrivée (FIFO)</p>
        </a>

        <a href="${pageContext.request.contextPath}/infirmier/patient/enregistrer"
           class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition border-l-4 border-green-500">
            <i class="fas fa-user-plus text-3xl text-green-500 mb-3"></i>
            <h3 class="text-lg font-bold text-gray-900 mb-2">Nouveau patient</h3>
            <p class="text-gray-600 text-sm">Enregistrer un nouveau patient</p>
        </a>

        <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
           class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition border-l-4 border-blue-500">
            <i class="fas fa-list text-3xl text-blue-500 mb-3"></i>
            <h3 class="text-lg font-bold text-gray-900 mb-2">Tous les patients</h3>
            <p class="text-gray-600 text-sm">Vue complète du jour</p>
        </a>
    </div>

    <!-- Queue Info Banner -->
    <div class="mt-8 bg-gradient-to-r from-blue-50 to-indigo-50 border-l-4 border-blue-600 p-6 rounded-r-lg">
        <div class="flex items-start">
            <i class="fas fa-info-circle text-blue-600 text-2xl mr-4 mt-1"></i>
            <div>
                <h3 class="text-lg font-bold text-blue-900 mb-2">À propos de la file d'attente</h3>
                <ul class="text-blue-800 text-sm space-y-1">
                    <li><i class="fas fa-check-circle mr-2"></i>Les patients sont automatiquement ajoutés à la file d'attente lors de l'enregistrement</li>
                    <li><i class="fas fa-check-circle mr-2"></i>Ils sont traités par ordre d'arrivée (FIFO - Premier arrivé, premier servi)</li>
                    <li><i class="fas fa-check-circle mr-2"></i>Après la consultation, ils sont automatiquement retirés de la file</li>
                    <li><i class="fas fa-check-circle mr-2"></i>Le statut "En attente" indique une position dans la file d'attente</li>
                </ul>
            </div>
        </div>
    </div>
</div>
</body>
</html>