<%--
  Created by IntelliJ IDEA.
  User: 1hear
  Date: 15/10/2025
  Time: 10:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enregistrer un patient - Infirmier</title>
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

<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
           class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
            <i class="fas fa-arrow-left mr-2"></i>Retour à la liste
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Enregistrer un nouveau patient</h1>
        <p class="text-gray-600">Remplissez les informations du patient et ses signes vitaux initiaux</p>
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
    <form method="post" action="${pageContext.request.contextPath}/infirmier/patient/enregistrer" class="space-y-6">
        <input type="hidden" name="csrfToken" value="${csrfToken}">

        <!-- Informations personnelles -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-user text-blue-600 mr-2"></i>
                Informations personnelles
            </h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Nom <span class="text-red-500">*</span>
                    </label>
                    <input type="text"
                           name="nom"
                           required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Nom de famille">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Prénom <span class="text-red-500">*</span>
                    </label>
                    <input type="text"
                           name="prenom"
                           required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Prénom">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Date de naissance <span class="text-red-500">*</span>
                    </label>
                    <input type="date"
                           name="dateNaissance"
                           required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Numéro de Sécurité Sociale <span class="text-red-500">*</span>
                    </label>
                    <div class="relative">
                        <input type="text"
                               id="numeroSecuriteSociale"
                               name="numeroSecuriteSociale"
                               required
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                               placeholder="Ex: 1 85 03 75 116 012 34">
                        <button type="button"
                                onclick="rechercherPatient()"
                                class="absolute right-2 top-1/2 transform -translate-y-1/2 text-blue-600 hover:text-blue-800">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Nous vérifierons si le patient existe déjà</p>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Téléphone
                    </label>
                    <input type="tel"
                           name="telephone"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Ex: 0612345678">
                </div>
            </div>

            <div id="patientExistant" class="hidden mt-4 p-4 bg-yellow-50 border-l-4 border-yellow-500 rounded">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-triangle text-yellow-500 text-xl mr-3"></i>
                    <div>
                        <p class="text-yellow-800 font-medium">Patient déjà enregistré</p>
                        <p class="text-yellow-700 text-sm mt-1" id="patientInfo"></p>
                        <a id="patientLink" href="#" class="text-yellow-800 underline text-sm mt-2 inline-block">
                            Voir le dossier du patient
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Signes vitaux -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-heartbeat text-red-600 mr-2"></i>
                Signes vitaux initiaux
            </h2>
            <p class="text-sm text-gray-600 mb-4">Au moins un signe vital doit être renseigné</p>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-tachometer-alt text-blue-600 mr-1"></i>
                        Tension artérielle
                    </label>
                    <input type="text"
                           name="tensionArterielle"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Ex: 120/80">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-heart text-red-600 mr-1"></i>
                        Fréquence cardiaque (bpm)
                    </label>
                    <input type="number"
                           name="frequenceCardiaque"
                           min="0"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Ex: 72">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-thermometer-half text-orange-600 mr-1"></i>
                        Température (°C)
                    </label>
                    <input type="number"
                           name="temperature"
                           step="0.1"
                           min="0"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Ex: 37.5">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-lungs text-teal-600 mr-1"></i>
                        Fréquence respiratoire (/min)
                    </label>
                    <input type="number"
                           name="frequenceRespiratoire"
                           min="0"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Ex: 16">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-weight text-purple-600 mr-1"></i>
                        Poids (kg)
                    </label>
                    <input type="number"
                           name="poids"
                           step="0.1"
                           min="0"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Ex: 70.5">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-ruler-vertical text-indigo-600 mr-1"></i>
                        Taille (cm)
                    </label>
                    <input type="number"
                           name="taille"
                           step="0.1"
                           min="0"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           placeholder="Ex: 175">
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex justify-end space-x-4">
            <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
               class="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg font-medium hover:bg-gray-300 transition">
                <i class="fas fa-times mr-2"></i>Annuler
            </a>
            <button type="submit"
                    class="px-6 py-3 bg-green-600 text-white rounded-lg font-medium hover:bg-green-700 transition shadow-lg">
                <i class="fas fa-save mr-2"></i>Enregistrer le patient
            </button>
        </div>
    </form>
</div>

<script>
    function rechercherPatient() {
        const numeroSecu = document.getElementById('numeroSecuriteSociale').value.trim();

        if (!numeroSecu) {
            alert('Veuillez saisir un numéro de sécurité sociale');
            return;
        }

        fetch('${pageContext.request.contextPath}/infirmier/patient/rechercher?numeroSecuriteSociale=' + encodeURIComponent(numeroSecu))
            .then(response => response.json())
            .then(data => {
                const alertDiv = document.getElementById('patientExistant');
                const infoP = document.getElementById('patientInfo');
                const linkA = document.getElementById('patientLink');

                if (data.found) {
                    infoP.textContent = data.nom + ' ' + data.prenom + (data.telephone ? ' - ' + data.telephone : '');
                    linkA.href = '${pageContext.request.contextPath}/infirmier/patient/detail?id=' + data.id;
                    alertDiv.classList.remove('hidden');
                } else {
                    alertDiv.classList.add('hidden');
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                alert('Erreur lors de la recherche');
            });
    }
</script>
</body>
</html>
