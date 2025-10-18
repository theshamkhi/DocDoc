<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 17/10/2025
  Time: 21:02
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
    <title>Répondre à l'expertise - Médecin Spécialiste</title>
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
                <a href="${pageContext.request.contextPath}/specialiste/demandes-expertise"
                   class="text-gray-600 hover:text-gray-800">
                    <i class="fas fa-list mr-2"></i>Demandes
                </a>
                <a href="${pageContext.request.contextPath}/specialiste/dashboard"
                   class="text-gray-600 hover:text-gray-800">
                    <i class="fas fa-home mr-2"></i>Tableau de bord
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/specialiste/demandes-expertise"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour aux demandes
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Répondre à l'expertise</h1>
        <p class="text-gray-600">Saisir l'avis médical et les recommandations</p>
    </div>

    <c:if test="${not empty error}">
        <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded">
            <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
            <p class="text-red-800">${error}</p>
        </div>
    </c:if>

    <!-- Demande d'expertise Card -->
    <div class="bg-gradient-to-r from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white mb-6">
        <h2 class="text-2xl font-bold mb-4">
            ${demande.consultation.patient.nom} ${demande.consultation.patient.prenom}
        </h2>
        <div class="grid grid-cols-2 gap-6">
            <div>
                <p class="text-blue-100 text-sm mb-1">Motif</p>
                <p class="font-semibold">${demande.consultation.motif}</p>
            </div>
            <div>
                <p class="text-blue-100 text-sm mb-1">N° Sécurité Sociale</p>
                <p class="font-mono font-semibold">${demande.consultation.patient.numeroSecuriteSociale}</p>
            </div>
            <div>
                <p class="text-blue-100 text-sm mb-1">Priorité</p>
                <p class="font-semibold">
                    <c:choose>
                        <c:when test="${demande.priorite.name() == 'URGENTE'}">
                            <i class="fas fa-exclamation-triangle mr-1"></i>URGENTE
                        </c:when>
                        <c:otherwise>
                            ${demande.priorite}
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div>
                <p class="text-blue-100 text-sm mb-1">Date demande</p>
                <p class="font-semibold">
                    ${demande.dateDemande}
                </p>
            </div>
        </div>
    </div>

    <!-- Question and Data -->
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <h3 class="text-xl font-bold text-gray-900 mb-4">Détails de la demande</h3>

        <div class="mb-6 pb-6 border-b border-gray-200">
            <p class="text-sm font-medium text-gray-700 mb-2">Question posée</p>
            <p class="text-gray-900 italic text-lg">
                <i class="fas fa-question-circle text-blue-600 mr-2"></i>
                "${demande.question}"
            </p>
        </div>

        <c:if test="${not empty demande.donneesSupplementaires}">
            <div class="mb-6 pb-6 border-b border-gray-200">
                <p class="text-sm font-medium text-gray-700 mb-2">Données supplémentaires</p>
                <div class="bg-gray-50 p-4 rounded border border-gray-200">
                    <p class="text-gray-900 text-sm whitespace-pre-wrap">
                            ${demande.donneesSupplementaires}
                    </p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty demande.creneau}">
            <div>
                <p class="text-sm font-medium text-gray-700 mb-2">Créneau réservé</p>
                <div class="bg-green-50 p-3 rounded border border-green-200">
                    <p class="text-green-900">
                        <i class="fas fa-calendar-check mr-2"></i>
                        ${demande.creneau.dateCreneau}
                        de ${demande.creneau.heureDebut} à ${demande.creneau.heureFin}
                    </p>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Response Form -->
    <c:if test="${demande.statut.name() == 'EN_ATTENTE'}">
        <form method="post" action="${pageContext.request.contextPath}/specialiste/repondre-expertise" class="space-y-6">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="demandeId" value="${demande.id}">

            <div class="bg-white rounded-lg shadow-lg p-6">
                <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-pen-fancy text-green-600 mr-2"></i>
                    Votre réponse
                </h3>

                <!-- Avis Médical -->
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-stethoscope text-blue-600 mr-2"></i>
                        Avis médical <span class="text-red-500">*</span>
                    </label>
                    <textarea name="avisMedical" required
                              rows="6"
                              class="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:border-green-500 focus:ring-2 focus:ring-green-200"
                              placeholder="Donnez votre avis médical suite à la consultation du patient..."></textarea>
                    <p class="text-xs text-gray-600 mt-1">Votre expertise et diagnostic</p>
                </div>

                <!-- Recommandations -->
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-prescription-bottle text-orange-600 mr-2"></i>
                        Recommandations et traitement
                    </label>
                    <textarea name="recommandations"
                              rows="4"
                              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                              placeholder="Vos recommandations de traitement et suivi..."></textarea>
                    <p class="text-xs text-gray-600 mt-1">Traitement suggéré (optionnel)</p>
                </div>
            </div>

            <!-- Actions -->
            <div class="flex justify-end space-x-4">
                <a href="${pageContext.request.contextPath}/specialiste/demandes-expertise"
                   class="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg font-medium hover:bg-gray-300">
                    <i class="fas fa-times mr-2"></i>Annuler
                </a>
                <button type="submit"
                        class="px-6 py-3 bg-green-600 text-white rounded-lg font-medium hover:bg-green-700 shadow-lg">
                    <i class="fas fa-check mr-2"></i>Marquer comme terminée
                </button>
            </div>
        </form>
    </c:if>

    <!-- View Mode (if already answered) -->
    <c:if test="${demande.statut.name() == 'TERMINEE'}">
        <div class="space-y-6">
            <!-- Avis Médical -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-stethoscope text-blue-600 mr-2"></i>
                    Avis médical
                </h3>
                <div class="bg-blue-50 p-4 rounded border-l-4 border-blue-500">
                    <p class="text-gray-900 whitespace-pre-wrap">${demande.avisMedical}</p>
                </div>
                <p class="text-xs text-gray-600 mt-2">
                    <i class="fas fa-clock mr-1"></i>
                    Répondu le ${demande.dateReponse}
                </p>
            </div>

            <!-- Recommandations -->
            <c:if test="${not empty demande.recommandations}">
                <div class="bg-white rounded-lg shadow-lg p-6">
                    <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-prescription-bottle text-orange-600 mr-2"></i>
                        Recommandations
                    </h3>
                    <div class="bg-orange-50 p-4 rounded border-l-4 border-orange-500">
                        <p class="text-gray-900 whitespace-pre-wrap">${demande.recommandations}</p>
                    </div>
                </div>
            </c:if>

            <!-- Status Badge -->
            <div class="bg-gradient-to-r from-green-50 to-teal-50 border-l-4 border-green-600 p-6 rounded-r-lg">
                <div class="flex items-center">
                    <i class="fas fa-check-circle text-green-600 text-3xl mr-4"></i>
                    <div>
                        <p class="text-lg font-bold text-green-900">Expertise terminée</p>
                        <p class="text-sm text-green-700 mt-1">
                            Cette demande d'expertise a été traitée et archivée.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Back Button -->
            <div class="flex justify-end">
                <a href="${pageContext.request.contextPath}/specialiste/demandes-expertise"
                   class="px-6 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700">
                    <i class="fas fa-arrow-left mr-2"></i>Retour aux demandes
                </a>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>
