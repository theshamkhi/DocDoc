<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - DocDoc</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-950 flex items-center justify-center p-6">
<!-- Animated Background Elements -->
<div class="absolute inset-0 overflow-hidden pointer-events-none">
    <div class="absolute top-20 left-20 w-72 h-72 bg-blue-500/10 rounded-full blur-3xl"></div>
    <div class="absolute bottom-20 right-20 w-96 h-96 bg-purple-500/10 rounded-full blur-3xl"></div>
    <div class="absolute top-1/2 left-1/2 w-80 h-80 bg-cyan-500/10 rounded-full blur-3xl"></div>
</div>

<div class="relative w-full max-w-md">
    <!-- Logo and Title -->
    <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-blue-500 to-cyan-500 rounded-2xl mb-4 shadow-lg shadow-blue-500/50">
            <span class="text-4xl">🏥</span>
        </div>
        <h1 class="text-4xl font-bold text-white mb-2">DocDoc</h1>
        <p class="text-slate-400 text-lg">Télé-expertise Médicale</p>
    </div>

    <!-- Login Card -->
    <div class="bg-slate-900/50 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-slate-800">
        <div class="mb-8">
            <h2 class="text-2xl font-bold text-white mb-2">Bienvenue</h2>
            <p class="text-slate-400">Connectez-vous pour continuer</p>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty error}">
            <div class="mb-6 p-4 bg-red-500/10 border border-red-500/50 rounded-xl">
                <p class="text-red-400 text-sm">${error}</p>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="mb-6 p-4 bg-green-500/10 border border-green-500/50 rounded-xl">
                <p class="text-green-400 text-sm">${success}</p>
            </div>
        </c:if>

        <!-- Form -->
        <form method="post" action="${pageContext.request.contextPath}/login" class="space-y-5">
            <input type="hidden" name="csrfToken" value="${csrfToken}">

            <div>
                <label for="email" class="block text-sm font-medium text-slate-300 mb-2">
                    Adresse email
                </label>
                <input type="email"
                       id="email"
                       name="email"
                       value="${param.email}"
                       placeholder="votre.email@docdoc.ma"
                       required
                       autofocus
                       class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all">
            </div>

            <div>
                <label for="password" class="block text-sm font-medium text-slate-300 mb-2">
                    Mot de passe
                </label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="••••••••••••"
                       required
                       class="w-full px-4 py-3 bg-slate-800/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all">
            </div>

            <button type="submit"
                    class="w-full py-3.5 bg-gradient-to-r from-blue-500 to-cyan-500 hover:from-blue-600 hover:to-cyan-600 text-white font-semibold rounded-xl shadow-lg shadow-blue-500/30 hover:shadow-blue-500/50 transform hover:scale-[1.02] transition-all duration-200">
                Se connecter
            </button>
        </form>

        <!-- Divider -->
        <div class="relative my-8">
            <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-slate-800"></div>
            </div>
            <div class="relative flex justify-center text-sm">
                <span class="px-4 bg-slate-900/50 text-slate-500">Nouveau sur DocDoc ?</span>
            </div>
        </div>

        <!-- Register Link -->
        <a href="${pageContext.request.contextPath}/register"
           class="block w-full py-3.5 text-center border-2 border-slate-700 hover:border-slate-600 text-slate-300 hover:text-white font-semibold rounded-xl hover:bg-slate-800/50 transition-all duration-200">
            Créer un compte
        </a>
    </div>

    <!-- Test Accounts -->
    <div class="mt-6 p-5 bg-slate-900/30 backdrop-blur-xl rounded-2xl border border-slate-800">
        <p class="text-xs font-semibold text-slate-400 mb-3">🔑 Comptes de démonstration</p>
        <div class="space-y-2 text-xs text-slate-500">
            <div class="flex justify-between items-center py-2 px-3 bg-slate-800/30 rounded-lg">
                <span class="text-slate-400">Infirmier</span>
                <span class="font-mono text-slate-500">infirmier1@docdoc.ma</span>
            </div>
            <div class="flex justify-between items-center py-2 px-3 bg-slate-800/30 rounded-lg">
                <span class="text-slate-400">Généraliste</span>
                <span class="font-mono text-slate-500">generaliste1@docdoc.ma</span>
            </div>
            <div class="flex justify-between items-center py-2 px-3 bg-slate-800/30 rounded-lg">
                <span class="text-slate-400">Spécialiste</span>
                <span class="font-mono text-slate-500">cardio1@docdoc.ma</span>
            </div>
            <p class="text-center pt-2 text-slate-600">Mot de passe: <span class="font-mono">password123</span></p>
        </div>
    </div>
</div>
</body>
</html>