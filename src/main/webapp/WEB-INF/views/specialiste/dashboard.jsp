<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord - Médecin Spécialiste</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<!-- Navigation -->
<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <i class="fas fa-microscope text-blue-600 text-2xl mr-3"></i>
                <span class="text-xl font-bold text-gray-800">DocDoc - Médecin Spécialiste</span>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-gray-700">
                    <i class="fas fa-user-md mr-2"></i>
                    <strong>Dr ${specialiste.nom} ${specialiste.prenom}</strong>
                </span>
                <span class="text-sm text-gray-600 bg-blue-100 px-3 py-1 rounded">
                    ${specialiste.specialite.label}
                </span>
                <a href="${pageContext.request.contextPath}/specialiste/profil"
                   class="text-blue-600 hover:text-blue-800">
                    <i class="fas fa-cog mr-1"></i>Profil
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
        <p class="text-gray-600">Bienvenue, Dr ${specialiste.nom}. Gérez vos consultations et expertises</p>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total Demandes -->
        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-blue-100 text-sm font-medium mb-1">Demandes totales</p>
                    <p class="text-4xl font-bold">${stats.total}</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-file-medical text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- En Attente -->
        <div class="bg-gradient-to-br from-yellow-500 to-yellow-600 rounded-lg shadow-lg p-6 text-white hover:shadow-xl transition">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-yellow-100 text-sm font-medium mb-1">En attente</p>
                    <p class="text-4xl font-bold">${stats.enAttente}</p>
                    <p class="text-yellow-100 text-xs mt-1">À traiter</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-hourglass-half text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Urgentes -->
        <div class="bg-gradient-to-br from-red-500 to-red-600 rounded-lg shadow-lg p-6 text-white">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-red-100 text-sm font-medium mb-1">Urgentes</p>
                    <p class="text-4xl font-bold">${stats.urgentes}</p>
                    <p class="text-red-100 text-xs mt-1">Prioritaires</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-exclamation-triangle text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Revenus -->
        <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg p-6 text-white">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-green-100 text-sm font-medium mb-1">Revenus</p>
                    <p class="text-3xl font-bold">
                        <fmt:formatNumber value="${stats.revenus}" minFractionDigits="0" maxFractionDigits="0"/>
                    </p>
                    <p class="text-green-100 text-xs mt-1">DH</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-money-bill-wave text-3xl"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <a href="${pageContext.request.contextPath}/specialiste/profil"
           class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition border-l-4 border-blue-500">
            <i class="fas fa-edit text-3xl text-blue-500 mb-3"></i>
            <h3 class="text-lg font-bold text-gray-900 mb-2">US5: Profil</h3>
            <p class="text-gray-600 text-sm">Configurer tarif & spécialité</p>
        </a>

        <a href="${pageContext.request.contextPath}/specialiste/creneaux"
           class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition border-l-4 border-purple-500">
            <i class="fas fa-calendar text-3xl text-purple-500 mb-3"></i>
            <h3 class="text-lg font-bold text-gray-900 mb-2">US6: Créneaux</h3>
            <p class="text-gray-600 text-sm">Gérer 30 min de créneaux</p>
        </a>

        <a href="${pageContext.request.contextPath}/specialiste/demandes-expertise"
           class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition border-l-4 border-red-500">
            <i class="fas fa-inbox text-3xl text-red-500 mb-3"></i>
            <h3 class="text-lg font-bold text-gray-900 mb-2">US7-US8: Expertises</h3>
            <p class="text-gray-600 text-sm">Consulter & répondre</p>
        </a>
    </div>

    <!-- Main Content -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Left Column -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Demandes Urgentes -->
            <c:if test="${not empty demandesUrgentes}">
                <div class="bg-white rounded-lg shadow-lg overflow-hidden border-l-4 border-red-500">
                    <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center bg-gradient-to-r from-red-50 to-white">
                        <h2 class="text-xl font-bold text-gray-900">
                            <i class="fas fa-exclamation-triangle text-red-600 mr-2"></i>
                            Demandes urgentes
                        </h2>
                        <span class="bg-red-500 text-white px-3 py-1 rounded-full text-sm font-bold">${demandesUrgentes.size()}</span>
                    </div>

                    <div class="divide-y divide-gray-200">
                        <c:forEach var="demande" items="${demandesUrgentes}">
                            <div class="p-6 hover:bg-gray-50 transition cursor-pointer"
                                 onclick="window.location.href='${pageContext.request.contextPath}/specialiste/repondre-expertise?id=${demande.id}'">
                                <div class="flex justify-between items-start">
                                    <div class="flex-1">
                                        <h3 class="text-lg font-bold text-gray-900">
                                                ${demande.consultation.patient.nom} ${demande.consultation.patient.prenom}
                                        </h3>
                                        <p class="text-sm text-gray-600 mt-1">
                                            <i class="fas fa-question-circle mr-1"></i>
                                            "${demande.question}"
                                        </p>
                                        <p class="text-xs text-gray-500 mt-2">
                                            <i class="fas fa-clock mr-1"></i>
                                                ${demande.dateDemande}
                                        </p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/specialiste/repondre-expertise?id=${demande.id}"
                                       class="text-red-600 hover:text-red-900 text-sm font-medium">
                                        Répondre <i class="fas fa-arrow-right ml-1"></i>
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- Demandes En Attente -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center bg-gradient-to-r from-yellow-50 to-white">
                    <h2 class="text-xl font-bold text-gray-900">
                        <i class="fas fa-hourglass-half text-yellow-600 mr-2"></i>
                        Demandes en attente
                    </h2>
                    <span class="bg-yellow-500 text-white px-3 py-1 rounded-full text-sm font-bold">${demandesEnAttente.size()}</span>
                </div>

                <c:choose>
                    <c:when test="${empty demandesEnAttente}">
                        <div class="p-8 text-center text-gray-500">
                            <i class="fas fa-inbox text-4xl mb-3"></i>
                            <p>Aucune demande en attente</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="divide-y divide-gray-200 max-h-96 overflow-y-auto">
                            <c:forEach var="demande" items="${demandesEnAttente}">
                                <div class="p-4 hover:bg-gray-50 transition cursor-pointer"
                                     onclick="window.location.href='${pageContext.request.contextPath}/specialiste/repondre-expertise?id=${demande.id}'">
                                    <div class="flex justify-between items-start mb-2">
                                        <h3 class="font-bold text-gray-900">
                                                ${demande.consultation.patient.nom} ${demande.consultation.patient.prenom}
                                        </h3>
                                        <span class="px-2 py-1 text-xs rounded font-semibold bg-yellow-100 text-yellow-800">
                                                ${demande.priorite}
                                        </span>
                                    </div>
                                    <p class="text-sm text-gray-700 mb-1">
                                        <i class="fas fa-stethoscope mr-1"></i>
                                            ${demande.consultation.motif}
                                    </p>
                                    <p class="text-xs text-gray-500">
                                            ${demande.dateDemande}
                                    </p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Right Column -->
        <div class="space-y-6">
            <!-- Créneaux Aujourd'hui -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-purple-50 to-white">
                    <h2 class="text-xl font-bold text-gray-900">
                        <i class="fas fa-calendar text-purple-600 mr-2"></i>
                        Créneaux (30 min)
                    </h2>
                </div>

                <c:choose>
                    <c:when test="${empty creneauxAujourdhui}">
                        <div class="p-6 text-center text-gray-500">
                            <i class="fas fa-calendar-times text-3xl mb-2"></i>
                            <p>Pas de créneaux</p>
                            <a href="${pageContext.request.contextPath}/specialiste/creneaux"
                               class="text-blue-600 hover:text-blue-800 text-sm mt-2 inline-block">
                                <i class="fas fa-plus mr-1"></i>Initialiser créneaux
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="divide-y divide-gray-200 max-h-96 overflow-y-auto">
                            <c:forEach var="creneau" items="${creneauxAujourdhui}">
                                <div class="p-4">
                                    <div class="flex justify-between items-center">
                                        <div>
                                            <p class="font-bold text-gray-900">
                                                    ${creneau.heureDebut} - ${creneau.heureFin}
                                            </p>
                                            <p class="text-xs text-gray-600 mt-1">
                                                30 minutes
                                            </p>
                                        </div>
                                        <span class="px-3 py-1 text-xs rounded-full font-semibold
                                            ${creneau.disponible ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                                ${creneau.disponible ? '✓ Disponible' : '✗ Réservé'}
                                        </span>
                                    </div>
                                    <c:if test="${not empty creneau.demandeExpertise}">
                                        <p class="text-xs text-blue-600 mt-2">
                                            <i class="fas fa-user mr-1"></i>
                                                ${creneau.demandeExpertise.consultation.patient.nom}
                                        </p>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="px-6 py-3 border-t border-gray-200 bg-gray-50">
                    <a href="${pageContext.request.contextPath}/specialiste/creneaux"
                       class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                        <i class="fas fa-arrow-right mr-1"></i>Voir tous les créneaux
                    </a>
                </div>
            </div>

            <!-- Info Box -->
            <div class="bg-gradient-to-r from-blue-50 to-indigo-50 border-l-4 border-blue-600 p-6 rounded-r-lg">
                <h3 class="text-lg font-bold text-blue-900 mb-3">Votre profil</h3>
                <div class="space-y-2 text-sm text-blue-900">
                    <p>
                        <i class="fas fa-stethoscope mr-2 text-blue-600"></i>
                        <strong>${specialiste.specialite.label}</strong>
                    </p>
                    <p>
                        <i class="fas fa-money-bill-wave mr-2 text-blue-600"></i>
                        Tarif: <strong>${specialiste.tarif} DH</strong>
                    </p>
                    <p>
                        <i class="fas fa-clock mr-2 text-blue-600"></i>
                        Durée: <strong>${specialiste.dureeConsultation} min</strong>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/specialiste/profil"
                   class="mt-4 block text-center bg-blue-600 text-white px-3 py-2 rounded hover:bg-blue-700 text-sm font-medium">
                    <i class="fas fa-edit mr-1"></i>Modifier
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>