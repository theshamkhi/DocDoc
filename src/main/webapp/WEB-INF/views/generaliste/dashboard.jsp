<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord - Médecin Généraliste</title>
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
                <span class="text-gray-700">
                    <i class="fas fa-user-md mr-2"></i>
                    <strong>Dr ${medecin.nom} ${medecin.prenom}</strong>
                </span>
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
        <p class="text-gray-600">Bienvenue, Dr ${medecin.nom}. Vue d'ensemble de votre activité</p>
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

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total Consultations -->
        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-blue-100 text-sm font-medium mb-1">Total consultations</p>
                    <p class="text-4xl font-bold">${stats.total}</p>
                    <p class="text-blue-100 text-xs mt-1">Jour en cours</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-file-medical text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Consultations En Cours -->
        <div class="bg-gradient-to-br from-yellow-500 to-yellow-600 rounded-lg shadow-lg p-6 text-white hover:shadow-xl transition">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-yellow-100 text-sm font-medium mb-1">En cours</p>
                    <p class="text-4xl font-bold">${stats.enCours}</p>
                    <p class="text-yellow-100 text-xs mt-1">À traiter</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-hourglass-half text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Consultations Terminées -->
        <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg p-6 text-white">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-green-100 text-sm font-medium mb-1">Terminées</p>
                    <p class="text-4xl font-bold">${stats.terminees}</p>
                    <p class="text-green-100 text-xs mt-1">Complétées</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-check-circle text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Revenue Total -->
        <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg shadow-lg p-6 text-white">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-purple-100 text-sm font-medium mb-1">Revenu total</p>
                    <p class="text-4xl font-bold">
                        <fmt:formatNumber value="${stats.revenuTotal}" minFractionDigits="0" maxFractionDigits="0"/>
                    </p>
                    <p class="text-purple-100 text-xs mt-1">DH</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-money-bill-wave text-3xl"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <a href="${pageContext.request.contextPath}/generaliste/consultation/creer"
           class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition border-l-4 border-blue-500">
            <i class="fas fa-plus text-3xl text-blue-500 mb-3"></i>
            <h3 class="text-lg font-bold text-gray-900 mb-2">Créer une consultation</h3>
        </a>

        <a href="#patients-en-attente"
           class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition border-l-4 border-orange-500">
            <i class="fas fa-users text-3xl text-orange-500 mb-3"></i>
            <h3 class="text-lg font-bold text-gray-900 mb-2">Patients en attente</h3>
            <p class="text-gray-600 text-sm"><strong>${patientsEnAttente.size()}</strong> patients en file</p>
        </a>
    </div>

    <!-- Main Content Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Left Column: Consultations -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Consultations En Cours -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center bg-gradient-to-r from-yellow-50 to-white">
                    <h2 class="text-xl font-bold text-gray-900">
                        <i class="fas fa-hourglass-half text-yellow-600 mr-2"></i>
                        Consultations en cours
                    </h2>
                    <span class="bg-yellow-500 text-white px-3 py-1 rounded-full text-sm font-bold">${consultationsEnCours.size()}</span>
                </div>

                <c:choose>
                    <c:when test="${empty consultationsEnCours}">
                        <div class="p-8 text-center text-gray-500">
                            <i class="fas fa-inbox text-4xl mb-3"></i>
                            <p>Aucune consultation en cours</p>
                            <!-- DEBUG -->
                            <p class="text-xs text-red-600 mt-2">
                                (Consultations total du jour: ${consultationsDuJour.size()})
                            </p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="divide-y divide-gray-200">
                            <c:forEach var="consultation" items="${consultationsEnCours}" varStatus="status">
                                <div class="p-6 hover:bg-gray-50 transition">
                                    <div class="flex justify-between items-start mb-2">
                                        <div class="flex-1">
                                            <h3 class="text-lg font-bold text-gray-900">
                                                    ${consultation.patient.nom} ${consultation.patient.prenom}
                                            </h3>
                                            <p class="text-sm text-gray-600">
                                                <i class="fas fa-stethoscope mr-1"></i>
                                                    ${consultation.motif}
                                            </p>
                                        </div>
                                        <div class="text-right ml-4">
                                            <p class="text-sm text-gray-600">
                                                <c:out value="${formattedDate}" />
                                            </p>
                                            <c:if test="${consultation.demandeExpertise ne null}">
                                                <span class="inline-block mt-1 px-2 py-1 bg-purple-100 text-purple-800 text-xs rounded font-semibold">
                                                    <i class="fas fa-check-circle mr-1"></i>Expertise
                                                </span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="flex justify-between items-center mt-3 pt-3 border-t border-gray-200">
                                        <p class="text-xs text-gray-500">
                                            <i class="fas fa-id-card mr-1"></i>
                                                ${consultation.patient.numeroSecuriteSociale}
                                        </p>
                                        <a href="${pageContext.request.contextPath}/generaliste/consultation/detail?id=${consultation.id}"
                                           class="text-blue-600 hover:text-blue-900 text-sm font-medium">
                                            Voir détails <i class="fas fa-arrow-right ml-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Consultations Terminées -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center bg-gradient-to-r from-green-50 to-white">
                    <h2 class="text-xl font-bold text-gray-900">
                        <i class="fas fa-check-circle text-green-600 mr-2"></i>
                        Consultations terminées
                    </h2>
                    <span class="bg-green-500 text-white px-3 py-1 rounded-full text-sm font-bold">${consultationsTerminees.size()}</span>
                </div>

                <c:choose>
                    <c:when test="${empty consultationsTerminees}">
                        <div class="p-8 text-center text-gray-500">
                            <i class="fas fa-inbox text-4xl mb-3"></i>
                            <p>Aucune consultation terminée</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="divide-y divide-gray-200">
                            <c:forEach var="consultation" items="${consultationsTerminees}">
                                <div class="p-6 hover:bg-gray-50 transition">
                                    <div class="flex justify-between items-start">
                                        <div class="flex-1">
                                            <h3 class="text-lg font-bold text-gray-900">
                                                    ${consultation.patient.nom} ${consultation.patient.prenom}
                                            </h3>
                                            <p class="text-sm text-gray-600">
                                                <i class="fas fa-stethoscope mr-1"></i>
                                                    ${consultation.motif}
                                            </p>
                                        </div>
                                        <div class="text-right ml-4">
                                            <p class="text-sm text-gray-600">
                                                <c:out value="${formattedDate}" />
                                            </p>
                                            <span class="inline-block mt-1 px-2 py-1 bg-green-100 text-green-800 text-xs rounded font-semibold">
                                                <i class="fas fa-check mr-1"></i>Terminée
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Right Column: Sidebar -->
        <div class="space-y-6">
            <!-- Patients en Attente -->
            <div id="patients-en-attente" class="bg-white rounded-lg shadow-lg overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-orange-50 to-white">
                    <h2 class="text-xl font-bold text-gray-900">
                        <i class="fas fa-users text-orange-600 mr-2"></i>
                        Patients en attente
                    </h2>
                </div>

                <c:choose>
                    <c:when test="${empty patientsEnAttente}">
                        <div class="p-6 text-center text-gray-500">
                            <i class="fas fa-smile-wink text-3xl mb-2"></i>
                            <p>Aucun patient en attente</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="divide-y divide-gray-200 max-h-96 overflow-y-auto">
                            <c:forEach var="patient" items="${patientsEnAttente}">
                                <div class="p-4 hover:bg-gray-50 transition">
                                    <div class="flex items-center justify-between mb-2">
                                        <h3 class="font-bold text-gray-900">
                                                ${patient.nom} ${patient.prenom}
                                        </h3>
                                        <a href="${pageContext.request.contextPath}/generaliste/consultation/creer"
                                           class="text-blue-600 hover:text-blue-900 text-sm">
                                            <i class="fas fa-plus-circle"></i>
                                        </a>
                                    </div>
                                    <p class="text-xs text-gray-600">
                                        <i class="fas fa-id-card mr-1"></i>
                                            ${patient.numeroSecuriteSociale}
                                    </p>
                                    <c:if test="${not empty patient.telephone}">
                                        <p class="text-xs text-gray-600">
                                            <i class="fas fa-phone mr-1"></i>
                                                ${patient.telephone}
                                        </p>
                                    </c:if>
                                    <p class="text-xs text-gray-500 mt-1">
                                        Depuis <fmt:formatDate value="${patient.dateEnregistrement}" pattern="HH:mm"/>
                                    </p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Demandes d'Expertise -->

            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-purple-50 to-white">
                    <h2 class="text-xl font-bold text-gray-900">
                        <i class="fas fa-user-check text-purple-600 mr-2"></i>
                        Expertises demandées
                    </h2>
                </div>

                <div class="divide-y divide-gray-200 max-h-96 overflow-y-auto">
                    <c:if test="${not empty demandesExpertise}">
                        <c:forEach var="consultation" items="${demandesExpertise}">
                            <div class="p-4 hover:bg-gray-50 transition">
                                <p class="font-bold text-gray-900 mb-1">
                                    Dr ${consultation.demandeExpertise.specialiste.nom}
                                </p>
                                <p class="text-xs text-gray-600 mb-2">
                                    <i class="fas fa-stethoscope mr-1"></i>
                                        ${consultation.demandeExpertise.specialiste.specialite.label}
                                </p>
                                <p class="text-xs text-gray-700 italic mb-2">
                                    "${consultation.demandeExpertise.question}"
                                </p>
                                <span class="inline-block px-2 py-1 text-xs rounded font-semibold
                                    ${consultation.demandeExpertise.statut.name() == 'EN_ATTENTE' ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-800'}">
                                        ${consultation.demandeExpertise.statut.name() == 'EN_ATTENTE' ? 'En attente' : 'Répondue'}
                                </span>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>