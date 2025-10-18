<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 17/10/2025
  Time: 21:01
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
    <title>Demandes d'Expertise - Médecin Spécialiste</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <i class="fas fa-microscope text-blue-600 text-2xl mr-3"></i>
                <span class="text-xl font-bold text-gray-800">DocDoc - Demandes d'Expertise</span>
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

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/specialiste/dashboard"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Consulter les demandes d'expertise</h1>
        <p class="text-gray-600">Filtrage par statut et priorité</p>
    </div>

    <c:if test="${not empty param.success}">
        <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded animate-pulse">
            <i class="fas fa-check-circle text-green-500 mr-3"></i>
            <p class="text-green-800">${param.success}</p>
        </div>
    </c:if>

    <!-- Statistics -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div class="bg-blue-500 text-white rounded-lg shadow p-6">
            <p class="text-blue-100 text-sm">Total</p>
            <p class="text-3xl font-bold">${stats.total}</p>
        </div>
        <div class="bg-yellow-500 text-white rounded-lg shadow p-6">
            <p class="text-yellow-100 text-sm">En attente</p>
            <p class="text-3xl font-bold">${stats.enAttente}</p>
        </div>
        <div class="bg-red-500 text-white rounded-lg shadow p-6">
            <p class="text-red-100 text-sm">Urgentes</p>
            <p class="text-3xl font-bold">${stats.urgentes}</p>
        </div>
        <div class="bg-green-500 text-white rounded-lg shadow p-6">
            <p class="text-green-100 text-sm">Terminées</p>
            <p class="text-3xl font-bold">${stats.terminees}</p>
        </div>
    </div>

    <!-- Filters (Stream API) -->
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
            <i class="fas fa-filter text-blue-600 mr-2"></i>
            Filtrer par statut et priorité
        </h2>

        <form method="get" class="flex gap-4 flex-wrap">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Statut</label>
                <select name="statut" class="px-4 py-2 border border-gray-300 rounded-lg">
                    <option value="">-- Tous les statuts --</option>
                    <option value="EN_ATTENTE" ${statutSelected == 'EN_ATTENTE' ? 'selected' : ''}>En attente</option>
                    <option value="TERMINEE" ${statutSelected == 'TERMINEE' ? 'selected' : ''}>Terminée</option>
                    <option value="EN_COURS" ${statutSelected == 'EN_COURS' ? 'selected' : ''}>En cours</option>
                    <option value="ANNULEE" ${statutSelected == 'ANNULEE' ? 'selected' : ''}>Annullée</option>
                </select>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Priorité</label>
                <select name="priorite" class="px-4 py-2 border border-gray-300 rounded-lg">
                    <option value="">-- Toutes priorités --</option>
                    <option value="URGENTE" ${prioriteSelected == 'URGENTE' ? 'selected' : ''}>Urgente</option>
                    <option value="NORMALE" ${prioriteSelected == 'NORMALE' ? 'selected' : ''}>Normale</option>
                    <option value="NON_URGENTE" ${prioriteSelected == 'NON_URGENTE' ? 'selected' : ''}>Non-Urgente</option>
                </select>
            </div>

            <div class="flex items-end">
                <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                    <i class="fas fa-search mr-2"></i>Filtrer
                </button>
                <a href="${pageContext.request.contextPath}/specialiste/demandes-expertise"
                   class="ml-2 px-6 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400">
                    <i class="fas fa-redo mr-2"></i>Réinitialiser
                </a>
            </div>
        </form>
    </div>

    <!-- Demandes List -->
    <div class="bg-white rounded-lg shadow-lg overflow-hidden">
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="p-12 text-center text-gray-500">
                    <i class="fas fa-inbox text-4xl mb-3"></i>
                    <p>Aucune demande trouvée</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Patient</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Motif</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Priorité</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Statut</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">Actions</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                        <c:forEach var="demande" items="${demandes}">
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="text-sm font-bold text-gray-900">
                                            ${demande.consultation.patient.nom} ${demande.consultation.patient.prenom}
                                    </div>
                                    <div class="text-xs text-gray-600">
                                            ${demande.consultation.patient.numeroSecuriteSociale}
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm text-gray-900">${demande.consultation.motif}</div>
                                    <div class="text-xs text-gray-600 mt-1">"${demande.question}"</div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${demande.priorite.name() == 'URGENTE'}">
                                                <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                    <i class="fas fa-exclamation-triangle mr-1"></i>URGENTE
                                                </span>
                                        </c:when>
                                        <c:when test="${demande.priorite.name() == 'NORMALE'}">
                                                <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                    <i class="fas fa-hourglass mr-1"></i>NORMALE
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                                <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                    <i class="fas fa-check-circle mr-1"></i>${demande.priorite}
                                                </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${demande.statut.name() == 'EN_ATTENTE'}">
                                                <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                    En attente
                                                </span>
                                        </c:when>
                                        <c:when test="${demande.statut.name() == 'TERMINEE'}">
                                                <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                    <i class="fas fa-check mr-1"></i>Terminée
                                                </span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                    ${demande.dateDemande}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <c:if test="${demande.statut.name() == 'EN_ATTENTE'}">
                                        <a href="${pageContext.request.contextPath}/specialiste/repondre-expertise?id=${demande.id}"
                                           class="text-blue-600 hover:text-blue-900">
                                            <i class="fas fa-reply mr-1"></i>Répondre
                                        </a>
                                    </c:if>
                                    <c:if test="${demande.statut.name() == 'TERMINEE'}">
                                        <a href="${pageContext.request.contextPath}/specialiste/repondre-expertise?id=${demande.id}"
                                           class="text-gray-600 hover:text-gray-900">
                                            <i class="fas fa-eye mr-1"></i>Voir
                                        </a>
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
</div>
</body>
</html>