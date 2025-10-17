<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 16/10/2025
  Time: 23:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détail Consultation - Médecin Généraliste</title>
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

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/generaliste/dashboard"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Détail de la consultation</h1>
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

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Left Column -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Consultation Info -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h2 class="text-2xl font-bold text-gray-900 mb-4">
                    ${consultation.patient.nom} ${consultation.patient.prenom}
                </h2>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <p class="text-gray-600 text-sm">Motif</p>
                        <p class="text-gray-900 font-semibold">${consultation.motif}</p>
                    </div>
                    <div>
                        <p class="text-gray-600 text-sm">Date</p>
                        <p class="text-gray-900 font-semibold">
                            <c:out value="${formattedDate}" />
                        </p>
                    </div>
                </div>

                <c:if test="${not empty consultation.observations}">
                    <div class="mt-4 pt-4 border-t border-gray-200">
                        <p class="text-gray-600 text-sm mb-2">Observations</p>
                        <p class="text-gray-900">${consultation.observations}</p>
                    </div>
                </c:if>

                <div class="mt-4 pt-4 border-t border-gray-200">
                    <p class="text-sm text-gray-600">Statut</p>
                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
                        ${consultation.statut.name() == 'EN_COURS' ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-800'}">
                        ${consultation.statut.name() == 'EN_COURS' ? 'En cours' : 'Terminée'}
                    </span>
                </div>
            </div>

            <!-- Expertise Section -->
                <div class="bg-gradient-to-r from-purple-50 to-indigo-50 rounded-lg shadow-lg p-6 border-l-4 border-purple-500">
                    <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-user-check text-purple-600 mr-2"></i>
                        Expertise demandée
                    </h3>

                <div class="space-y-3">
                    <c:if test="${not empty consultation.demandeExpertise}">
                        <div>
                            <p class="text-gray-600 text-sm">Spécialiste</p>
                            <p class="text-gray-900 font-semibold">
                                Dr ${consultation.demandeExpertise.specialiste.nom} ${consultation.demandeExpertise.specialiste.prenom}
                                <span class="text-xs text-gray-600 ml-2">${consultation.demandeExpertise.specialiste.specialite.label}</span>
                            </p>
                        </div>
                        <div>
                            <p class="text-gray-600 text-sm">Question</p>
                            <p class="text-gray-900">${consultation.demandeExpertise.question}</p>
                        </div>
                        <c:if test="${not empty consultation.demandeExpertise.donneesSupplementaires}">
                            <div>
                                <p class="text-gray-600 text-sm">Données supplémentaires</p>
                                <p class="text-gray-900">${consultation.demandeExpertise.donneesSupplementaires}</p>
                            </div>
                        </c:if>
                        <c:if test="${not empty consultation.demandeExpertise.creneau}">
                            <div>
                                <p class="text-gray-600 text-sm">Créneau</p>
                                <p class="text-gray-900 font-semibold">
                                    <fmt:formatDate value="${consultation.demandeExpertise.creneau.dateCreneau}" pattern="dd/MM/yyyy"/>
                                    à ${consultation.demandeExpertise.creneau.heureDebut}
                                </p>
                            </div>
                        </c:if>
                    </c:if>
                </div>
            </div>

            <!-- Actes Techniques Section -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-stethoscope text-green-600 mr-2"></i>
                    Actes techniques
                </h3>

                <c:choose>
                    <c:when test="${empty actes}">
                        <p class="text-gray-600 mb-4">Aucun acte technique ajouté</p>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-2 mb-4">
                            <c:forEach var="acte" items="${actes}">
                                <div class="flex justify-between items-center p-3 bg-gray-50 rounded border border-gray-200">
                                    <div>
                                        <p class="font-medium text-gray-900">${acte.type.label}</p>
                                        <p class="text-xs text-gray-600">
                                                ${acte.dateRealisation.toString().substring(0, 16).replace('T', ' ')}
                                        </p>
                                    </div>
                                    <p class="font-semibold text-green-600">${acte.tarif} DH</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Add Technical Act Form -->
                <form method="post" action="${pageContext.request.contextPath}/generaliste/consultation/ajouter-acte"
                      class="flex gap-2">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <input type="hidden" name="consultationId" value="${consultation.id}">

                    <select name="typeActe" required
                            class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                        <option value="">-- Ajouter un acte --</option>
                        <c:forEach var="type" items="${typesActes}">
                            <option value="${type.name()}">${type.label} (${type.tarif} DH)</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm font-medium">
                        <i class="fas fa-plus mr-1"></i>Ajouter
                    </button>
                </form>
            </div>
        </div>

        <!-- Right Column - Cost Summary -->
        <div class="lg:col-span-1">
            <!-- Total Cost Calculation with Lambda/Stream -->
            <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg p-6 text-white sticky top-8">
                <h3 class="text-2xl font-bold mb-6 flex items-center">
                    <i class="fas fa-receipt mr-2"></i>
                    Résumé des coûts
                </h3>

                <div class="space-y-4 border-b border-green-400 pb-4 mb-4">
                    <!-- Consultation Cost -->
                    <div class="flex justify-between items-center">
                        <div>
                            <p class="text-green-100 text-sm">Consultation (fixe)</p>
                            <p class="text-xs text-green-100">Coût fixe</p>
                        </div>
                        <p class="text-lg font-bold">150 DH</p>
                    </div>

                    <!-- Technical Acts Cost (Lambda/Stream) -->
                    <c:if test="${not empty actes}">
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="text-green-100 text-sm">Actes techniques</p>
                                <p class="text-xs text-green-100">
                                    <i class="fas fa-lambda mr-1"></i>
                                        ${actes.size()} acte(s)
                                </p>
                            </div>
                            <p class="text-lg font-bold">
                                <fmt:formatNumber value="${coutActes}" minFractionDigits="0" maxFractionDigits="2"/>
                                DH
                            </p>
                        </div>
                    </c:if>

                    <!-- Expertise Cost -->
                    <c:if test="${not empty consultation.demandeExpertise}">
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="text-green-100 text-sm">Expertise</p>
                                <p class="text-xs text-green-100">Tarif spécialiste</p>
                            </div>
                            <p class="text-lg font-bold">${consultation.demandeExpertise.specialiste.tarif} DH</p>
                        </div>
                    </c:if>
                </div>

                <!-- Total -->
                <div class="flex justify-between items-center">
                    <p class="text-xl font-bold text-green-100">TOTAL</p>
                    <p class="text-3xl font-bold">
                        <fmt:formatNumber value="${coutTotal}" minFractionDigits="2" maxFractionDigits="2"/>
                        DH
                    </p>
                </div>

                <!-- Action Buttons -->
                <c:if test="${consultation.statut.name() == 'EN_COURS'}">
                    <div class="mt-6 space-y-2">
                        <a href="${pageContext.request.contextPath}/generaliste/consultation/demander-expertise?consultationId=${consultation.id}"
                           class="block w-full text-center bg-white text-green-600 px-4 py-2 rounded-lg font-medium hover:bg-green-50 transition">
                            <i class="fas fa-plus mr-1"></i>Demander expertise
                        </a>
                    </div>
                </c:if>
            </div>

            <!-- Patient Info Card -->
            <div class="bg-white rounded-lg shadow-lg p-6 mt-6">
                <h3 class="text-lg font-bold text-gray-900 mb-4">Patient</h3>

                <div class="space-y-3">
                    <div>
                        <p class="text-gray-600 text-sm">Nom complet</p>
                        <p class="text-gray-900 font-semibold">${consultation.patient.nom} ${consultation.patient.prenom}</p>
                    </div>
                    <div>
                        <p class="text-gray-600 text-sm">N° Sécurité Sociale</p>
                        <p class="text-gray-900 font-mono">${consultation.patient.numeroSecuriteSociale}</p>
                    </div>
                    <c:if test="${not empty consultation.patient.telephone}">
                        <div>
                            <p class="text-gray-600 text-sm">Téléphone</p>
                            <p class="text-gray-900">${consultation.patient.telephone}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

