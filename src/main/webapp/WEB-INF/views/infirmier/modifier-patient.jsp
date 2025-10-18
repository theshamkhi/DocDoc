<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 15/10/2025
  Time: 10:48
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
    <title>Dossier patient - ${patient.nom} ${patient.prenom}</title>
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

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour à la liste
        </a>
        <div class="flex justify-between items-start">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Dossier patient</h1>
                <p class="text-gray-600">${patient.nom} ${patient.prenom}</p>
            </div>
            <a href="${pageContext.request.contextPath}/infirmier/patient/signes-vitaux?id=${patient.id}"
               class="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-blue-700 transition shadow-lg">
                <i class="fas fa-heartbeat mr-2"></i>Ajouter des signes vitaux
            </a>
        </div>
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

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Left Column - Patient Info & Edit Form -->
        <div class="lg:col-span-1 space-y-6">
            <!-- Patient Card -->
            <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
                <div class="flex flex-col items-center text-center">
                    <div class="bg-white bg-opacity-20 rounded-full p-6 mb-4">
                        <i class="fas fa-user text-5xl"></i>
                    </div>
                    <h2 class="text-2xl font-bold mb-2">${patient.nom} ${patient.prenom}</h2>
                    <p class="text-blue-100 mb-4">
                        <i class="fas fa-birthday-cake mr-2"></i>
                        <fmt:formatDate value="${patient.dateNaissance}" pattern="dd/MM/yyyy"/>
                    </p>
                    <div class="w-full bg-white bg-opacity-10 rounded-lg p-3 mt-4">
                        <p class="text-xs text-blue-100 mb-1">N° Sécurité Sociale</p>
                        <p class="font-mono font-bold">${patient.numeroSecuriteSociale}</p>
                    </div>
                </div>
            </div>

            <!-- Status Card with Queue Info -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h3 class="text-lg font-bold text-gray-900 mb-4">Statut</h3>
                <c:choose>
                    <c:when test="${patient.enAttente}">
                        <div class="flex items-center p-4 bg-orange-100 rounded-lg border-l-4 border-orange-500">
                            <i class="fas fa-hourglass-end text-orange-600 text-3xl mr-4"></i>
                            <div>
                                <p class="font-bold text-orange-900 text-lg">En file d'attente</p>
                                <p class="text-sm text-orange-700 mt-1">Patient en attente de consultation</p>
                                <p class="text-xs text-orange-600 mt-2">
                                    <i class="fas fa-info-circle mr-1"></i>
                                    Sera automatiquement retiré après la consultation
                                </p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex items-center p-4 bg-green-100 rounded-lg border-l-4 border-green-500">
                            <i class="fas fa-check-circle text-green-600 text-3xl mr-4"></i>
                            <div>
                                <p class="font-bold text-green-900 text-lg">Traité</p>
                                <p class="text-sm text-green-700 mt-1">Patient hors de la file d'attente</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Edit Patient Info Form -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-user-edit text-blue-600 mr-2"></i>
                    Modifier les informations
                </h3>
                <form method="post" action="${pageContext.request.contextPath}/infirmier/patient/modifier">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <input type="hidden" name="patientId" value="${patient.id}">

                    <div class="space-y-4">
                        <!-- Nom -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-user mr-1"></i>Nom
                            </label>
                            <input type="text"
                                   name="nom"
                                   value="${patient.nom}"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                   placeholder="Nom de famille">
                        </div>

                        <!-- Prénom -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-user mr-1"></i>Prénom
                            </label>
                            <input type="text"
                                   name="prenom"
                                   value="${patient.prenom}"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                   placeholder="Prénom">
                        </div>

                        <!-- Date de naissance -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-birthday-cake mr-1"></i>Date de naissance
                            </label>
                            <input type="date"
                                   name="dateNaissance"
                                   value="<fmt:formatDate value='${patient.dateNaissance}' pattern='yyyy-MM-dd'/>"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        </div>

                        <!-- Numéro de sécurité sociale -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-id-card mr-1"></i>N° Sécurité Sociale
                            </label>
                            <input type="text"
                                   name="numeroSecuriteSociale"
                                   value="${patient.numeroSecuriteSociale}"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent font-mono"
                                   placeholder="1234567">
                            <p class="mt-1 text-xs text-gray-500">15 chiffres</p>
                        </div>

                        <!-- Téléphone -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-phone mr-1"></i>Téléphone
                            </label>
                            <input type="tel"
                                   name="telephone"
                                   value="${patient.telephone}"
                                   pattern="[0-9]{10}"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                   placeholder="0612345678">
                            <p class="mt-1 text-xs text-gray-500">10 chiffres</p>
                        </div>
                    </div>

                    <button type="submit"
                            class="w-full mt-6 bg-blue-600 text-white px-4 py-3 rounded-lg font-medium hover:bg-blue-700 transition shadow-lg">
                        <i class="fas fa-save mr-2"></i>Enregistrer les modifications
                    </button>
                </form>
            </div>
        </div>

        <!-- Right Column - History -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Vital Signs History -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <div class="px-6 py-4 bg-gradient-to-r from-red-500 to-red-600 text-white">
                    <h3 class="text-xl font-bold flex items-center">
                        <i class="fas fa-heartbeat mr-2"></i>
                        Historique des signes vitaux
                    </h3>
                </div>

                <c:choose>
                    <c:when test="${empty signesVitaux}">
                        <div class="p-8 text-center text-gray-500">
                            <i class="fas fa-chart-line text-4xl mb-3"></i>
                            <p>Aucun signe vital enregistré</p>
                            <a href="${pageContext.request.contextPath}/infirmier/patient/signes-vitaux?id=${patient.id}"
                               class="inline-block mt-4 text-blue-600 hover:text-blue-800 font-medium">
                                <i class="fas fa-plus mr-1"></i>Ajouter les premiers signes vitaux
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-6 space-y-4">
                            <c:forEach var="signe" items="${signesVitaux}">
                                <div class="border-l-4 border-blue-500 bg-gray-50 p-4 rounded-r-lg hover:shadow-md transition">
                                    <div class="flex justify-between items-start mb-3">
                                        <div>
                                            <p class="text-sm text-gray-600">
                                                <i class="far fa-calendar mr-1"></i>
                                                <fmt:formatDate value="${signe.dateMesure}" pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                            <c:if test="${not empty signe.infirmier}">
                                                <p class="text-xs text-gray-500 mt-1">
                                                    <i class="fas fa-user-nurse mr-1"></i>
                                                    Par ${signe.infirmier.nom} ${signe.infirmier.prenom}
                                                </p>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-2 md:grid-cols-3 gap-3">
                                        <c:if test="${not empty signe.tensionArterielle}">
                                            <div class="bg-white p-2 rounded border border-gray-200">
                                                <p class="text-xs text-gray-600">
                                                    <i class="fas fa-tachometer-alt text-blue-600 mr-1"></i>
                                                    Tension
                                                </p>
                                                <p class="font-semibold text-gray-900">${signe.tensionArterielle}</p>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty signe.frequenceCardiaque}">
                                            <div class="bg-white p-2 rounded border border-gray-200">
                                                <p class="text-xs text-gray-600">
                                                    <i class="fas fa-heart text-red-600 mr-1"></i>
                                                    FC
                                                </p>
                                                <p class="font-semibold text-gray-900">${signe.frequenceCardiaque} bpm</p>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty signe.temperature}">
                                            <div class="bg-white p-2 rounded border border-gray-200">
                                                <p class="text-xs text-gray-600">
                                                    <i class="fas fa-thermometer-half text-orange-600 mr-1"></i>
                                                    Température
                                                </p>
                                                <p class="font-semibold text-gray-900">${signe.temperature}°C</p>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty signe.frequenceRespiratoire}">
                                            <div class="bg-white p-2 rounded border border-gray-200">
                                                <p class="text-xs text-gray-600">
                                                    <i class="fas fa-lungs text-teal-600 mr-1"></i>
                                                    FR
                                                </p>
                                                <p class="font-semibold text-gray-900">${signe.frequenceRespiratoire}/min</p>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty signe.poids}">
                                            <div class="bg-white p-2 rounded border border-gray-200">
                                                <p class="text-xs text-gray-600">
                                                    <i class="fas fa-weight text-purple-600 mr-1"></i>
                                                    Poids
                                                </p>
                                                <p class="font-semibold text-gray-900">${signe.poids} kg</p>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty signe.taille}">
                                            <div class="bg-white p-2 rounded border border-gray-200">
                                                <p class="text-xs text-gray-600">
                                                    <i class="fas fa-ruler-vertical text-indigo-600 mr-1"></i>
                                                    Taille
                                                </p>
                                                <p class="font-semibold text-gray-900">${signe.taille} cm</p>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Consultations History -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <div class="px-6 py-4 bg-gradient-to-r from-green-500 to-green-600 text-white">
                    <h3 class="text-xl font-bold flex items-center">
                        <i class="fas fa-stethoscope mr-2"></i>
                        Historique des consultations
                    </h3>
                </div>

                <c:choose>
                    <c:when test="${empty consultations}">
                        <div class="p-8 text-center text-gray-500">
                            <i class="fas fa-file-medical text-4xl mb-3"></i>
                            <p>Aucune consultation enregistrée</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-6 space-y-4">
                            <c:forEach var="consultation" items="${consultations}">
                                <div class="border-l-4 border-green-500 bg-gray-50 p-4 rounded-r-lg hover:shadow-md transition">
                                    <div class="flex justify-between items-start mb-2">
                                        <div>
                                            <p class="text-sm text-gray-600">
                                                <i class="far fa-calendar mr-1"></i>
                                                <c:out value="${formattedDate}" />
                                            </p>
                                            <c:if test="${not empty consultation.medecin}">
                                                <p class="text-sm font-medium text-gray-900 mt-1">
                                                    <i class="fas fa-user-md mr-1"></i>
                                                    Dr ${consultation.medecin.nom} ${consultation.medecin.prenom}
                                                </p>
                                            </c:if>
                                        </div>
                                        <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${consultation.statut.name() == 'EN_COURS' ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-800'}">
                                                ${consultation.statut.name() == 'EN_COURS' ? 'En cours' : 'Terminée'}
                                        </span>
                                    </div>

                                    <c:if test="${not empty consultation.motif}">
                                        <div class="mt-2 bg-white p-2 rounded border border-gray-200">
                                            <p class="text-xs text-gray-600 font-medium">Motif</p>
                                            <p class="text-sm text-gray-900">${consultation.motif}</p>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty consultation.diagnostic}">
                                        <div class="mt-2 bg-white p-2 rounded border border-gray-200">
                                            <p class="text-xs text-gray-600 mb-1 font-medium">Diagnostic</p>
                                            <p class="text-sm text-gray-900">${consultation.diagnostic}</p>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty consultation.traitement}">
                                        <div class="mt-2 bg-white p-2 rounded border border-gray-200">
                                            <p class="text-xs text-gray-600 mb-1 font-medium">Traitement</p>
                                            <p class="text-sm text-gray-900">${consultation.traitement}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
</body>
</html>