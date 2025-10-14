<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - DocDoc</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-950 flex items-center justify-center p-6">
<!-- Animated Background Elements -->
<div class="absolute inset-0 overflow-hidden pointer-events-none">
    <div class="absolute top-20 left-20 w-72 h-72 bg-emerald-500/10 rounded-full blur-3xl"></div>
    <div class="absolute bottom-20 right-20 w-96 h-96 bg-violet-500/10 rounded-full blur-3xl"></div>
    <div class="absolute top-1/2 left-1/2 w-80 h-80 bg-blue-500/10 rounded-full blur-3xl"></div>
</div>

<div class="relative w-full max-w-4xl">
    <!-- Header -->
    <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-emerald-500 to-blue-500 rounded-2xl mb-4 shadow-lg shadow-emerald-500/50">
            <span class="text-4xl">🏥</span>
        </div>
        <h1 class="text-4xl font-bold text-white mb-2">Rejoignez DocDoc</h1>
        <p class="text-slate-400 text-lg">Créez votre compte professionnel médical</p>
    </div>

    <!-- Registration Card -->
    <div class="bg-slate-900/50 backdrop-blur-xl rounded-3xl p-8 md:p-10 shadow-2xl border border-slate-800">
        <!-- Error Alert -->
        <c:if test="${not empty error}">
            <div class="mb-6 p-4 bg-red-500/10 border border-red-500/50 rounded-xl">
                <p class="text-red-400 text-sm">${error}</p>
            </div>
        </c:if>

        <!-- Form -->
        <form method="post" action="${pageContext.request.contextPath}/register" class="space-y-6">
            <input type="hidden" name="csrfToken" value="${csrfToken}">

            <!-- Personal Information Section -->
            <div>
                <h3 class="text-lg font-semibold text-white mb-4 flex items-center gap-2">
                    <span class="w-8 h-8 bg-blue-500/20 rounded-lg flex items-center justify-center text-sm">👤</span>
                    Informations personnelles
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            Nom <span class="text-red-400">*</span>
                        </label>
                        <input type="text"
                               name="nom"
                               value="${param.nom}"
                               placeholder="Nom de famille"
                               required
                               class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 transition-all">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            Prénom <span class="text-red-400">*</span>
                        </label>
                        <input type="text"
                               name="prenom"
                               value="${param.prenom}"
                               placeholder="Prénom"
                               required
                               class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 transition-all">
                    </div>
                </div>
            </div>

            <!-- Contact Section -->
            <div>
                <h3 class="text-lg font-semibold text-white mb-4 flex items-center gap-2">
                    <span class="w-8 h-8 bg-emerald-500/20 rounded-lg flex items-center justify-center text-sm">📧</span>
                    Coordonnées
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            Email professionnel <span class="text-red-400">*</span>
                        </label>
                        <input type="email"
                               name="email"
                               value="${param.email}"
                               placeholder="votre.email@docdoc.ma"
                               required
                               class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 transition-all">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            Téléphone
                        </label>
                        <input type="tel"
                               name="telephone"
                               value="${param.telephone}"
                               placeholder="06XXXXXXXX"
                               pattern="[0-9]{10}"
                               class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 transition-all">
                    </div>
                </div>
            </div>

            <!-- Professional Section -->
            <div>
                <h3 class="text-lg font-semibold text-white mb-4 flex items-center gap-2">
                    <span class="w-8 h-8 bg-violet-500/20 rounded-lg flex items-center justify-center text-sm">👨‍⚕️</span>
                    Informations professionnelles
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            Rôle <span class="text-red-400">*</span>
                        </label>
                        <select name="role"
                                required
                                class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white focus:outline-none focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 transition-all appearance-none cursor-pointer">
                            <option value="" class="bg-slate-800">Sélectionnez un rôle</option>
                            <option value="INFIRMIER" ${param.role == 'INFIRMIER' ? 'selected' : ''} class="bg-slate-800">
                                Infirmier(ère)
                            </option>
                            <option value="GENERALISTE" ${param.role == 'GENERALISTE' ? 'selected' : ''} class="bg-slate-800">
                                Médecin Généraliste
                            </option>
                            <option value="SPECIALISTE" ${param.role == 'SPECIALISTE' ? 'selected' : ''} class="bg-slate-800">
                                Médecin Spécialiste
                            </option>
                        </select>
                    </div>

                    <div class="${param.role == 'SPECIALISTE' ? '' : 'hidden'}">
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            Spécialité <span class="text-red-400">*</span>
                        </label>
                        <select name="specialite"
                                class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white focus:outline-none focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 transition-all appearance-none cursor-pointer">
                            <option value="" class="bg-slate-800">Sélectionnez une spécialité</option>
                            <option value="CARDIOLOGIE" class="bg-slate-800">Cardiologie</option>
                            <option value="PNEUMOLOGIE" class="bg-slate-800">Pneumologie</option>
                            <option value="DERMATOLOGIE" class="bg-slate-800">Dermatologie</option>
                            <option value="NEUROLOGIE" class="bg-slate-800">Neurologie</option>
                            <option value="ENDOCRINOLOGIE" class="bg-slate-800">Endocrinologie</option>
                            <option value="GASTROENTEROLOGIE" class="bg-slate-800">Gastroentérologie</option>
                            <option value="RHUMATOLOGIE" class="bg-slate-800">Rhumatologie</option>
                            <option value="OPHTALMOLOGIE" class="bg-slate-800">Ophtalmologie</option>
                            <option value="ORL" class="bg-slate-800">ORL</option>
                            <option value="PEDIATRIE" class="bg-slate-800">Pédiatrie</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Security Section -->
            <div>
                <h3 class="text-lg font-semibold text-white mb-4 flex items-center gap-2">
                    <span class="w-8 h-8 bg-red-500/20 rounded-lg flex items-center justify-center text-sm">🔒</span>
                    Sécurité
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            Mot de passe <span class="text-red-400">*</span>
                        </label>
                        <input type="password"
                               name="password"
                               placeholder="••••••••••••"
                               minlength="8"
                               required
                               class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 transition-all">
                        <p class="mt-1.5 text-xs text-slate-500">Minimum 8 caractères</p>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            Confirmer mot de passe <span class="text-red-400">*</span>
                        </label>
                        <input type="password"
                               name="confirmPassword"
                               placeholder="••••••••••••"
                               required
                               class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 transition-all">
                    </div>
                </div>
            </div>

            <!-- Divider -->
            <div class="border-t border-slate-800"></div>

            <!-- Buttons -->
            <div class="flex flex-col sm:flex-row gap-4">
                <button type="submit"
                        class="flex-1 py-3.5 bg-gradient-to-r from-emerald-500 to-blue-500 hover:from-emerald-600 hover:to-blue-600 text-white font-semibold rounded-xl shadow-lg shadow-emerald-500/30 hover:shadow-emerald-500/50 transform hover:scale-[1.02] transition-all duration-200">
                    Créer mon compte
                </button>

                <a href="${pageContext.request.contextPath}/login"
                   class="flex-1 py-3.5 text-center border-2 border-slate-700 hover:border-slate-600 text-slate-300 hover:text-white font-semibold rounded-xl hover:bg-slate-800/50 transition-all duration-200">
                    Retour à la connexion
                </a>
            </div>
        </form>
    </div>

    <!-- Footer Info -->
    <div class="mt-6 text-center">
        <p class="text-slate-500 text-sm">
            En créant un compte, vous acceptez nos conditions d'utilisation
        </p>
    </div>
</div>
</body>
</html>