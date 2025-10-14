<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - DocDoc</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-950">
<!-- Animated Background -->
<div class="absolute inset-0 overflow-hidden pointer-events-none">
    <div class="absolute top-20 left-20 w-96 h-96 bg-emerald-500/10 rounded-full blur-3xl"></div>
    <div class="absolute bottom-20 right-20 w-96 h-96 bg-violet-500/10 rounded-full blur-3xl"></div>
    <div class="absolute top-1/2 left-1/2 w-96 h-96 bg-blue-500/10 rounded-full blur-3xl"></div>
</div>

<div class="relative min-h-screen">
    <!-- Header -->
    <header class="bg-slate-900/50 backdrop-blur-xl border-b border-slate-800 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-6 py-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-4">
                    <div class="w-12 h-12 bg-gradient-to-br from-violet-500 to-purple-500 rounded-xl flex items-center justify-center shadow-lg shadow-violet-500/50">
                        <span class="text-2xl">👨‍💼</span>
                    </div>
                    <div>
                        <h1 class="text-2xl font-bold text-white">Administration</h1>
                        <p class="text-sm text-slate-400">Gestion du système DocDoc</p>
                    </div>
                </div>
                <div class="flex items-center gap-4">
                    <div class="text-right">
                        <p class="text-sm font-medium text-white">${sessionScope.user.prenom} ${sessionScope.user.nom}</p>
                        <p class="text-xs text-slate-400">Administrateur</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="px-4 py-2 bg-red-500/10 hover:bg-red-500/20 border border-red-500/50 text-red-400 rounded-lg transition-all">
                        🚪 Déconnexion
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-6 py-8">
        <!-- Success Message -->
        <c:if test="${not empty successMessage}">
            <div class="mb-6 p-4 bg-emerald-500/10 border border-emerald-500/50 rounded-xl flex items-start gap-3 animate-fadeIn">
                <span class="text-emerald-400 text-xl">✅</span>
                <p class="text-emerald-400 text-sm flex-1">${successMessage}</p>
            </div>
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="mb-6 p-4 bg-red-500/10 border border-red-500/50 rounded-xl flex items-start gap-3">
                <span class="text-red-400 text-xl">⚠️</span>
                <p class="text-red-400 text-sm flex-1">${error}</p>
            </div>
        </c:if>

        <!-- Statistics Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6 mb-8">
            <!-- Total Users -->
            <div class="bg-slate-900/50 backdrop-blur-xl border border-slate-800 rounded-2xl p-6 hover:border-slate-700 transition-all">
                <div class="flex items-center justify-between mb-4">
                    <div class="w-12 h-12 bg-blue-500/20 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">👥</span>
                    </div>
                    <span class="text-3xl font-bold text-white">${totalUsers}</span>
                </div>
                <h3 class="text-slate-400 text-sm font-medium">Total Utilisateurs</h3>
            </div>

            <!-- Admins -->
            <div class="bg-slate-900/50 backdrop-blur-xl border border-slate-800 rounded-2xl p-6 hover:border-slate-700 transition-all">
                <div class="flex items-center justify-between mb-4">
                    <div class="w-12 h-12 bg-violet-500/20 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">👨‍💼</span>
                    </div>
                    <span class="text-3xl font-bold text-white">${adminCount}</span>
                </div>
                <h3 class="text-slate-400 text-sm font-medium">Administrateurs</h3>
            </div>

            <!-- Nurses -->
            <div class="bg-slate-900/50 backdrop-blur-xl border border-slate-800 rounded-2xl p-6 hover:border-slate-700 transition-all">
                <div class="flex items-center justify-between mb-4">
                    <div class="w-12 h-12 bg-emerald-500/20 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">👨‍⚕️</span>
                    </div>
                    <span class="text-3xl font-bold text-white">${infirmierCount}</span>
                </div>
                <h3 class="text-slate-400 text-sm font-medium">Infirmiers</h3>
            </div>

            <!-- General Practitioners -->
            <div class="bg-slate-900/50 backdrop-blur-xl border border-slate-800 rounded-2xl p-6 hover:border-slate-700 transition-all">
                <div class="flex items-center justify-between mb-4">
                    <div class="w-12 h-12 bg-cyan-500/20 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">🩺</span>
                    </div>
                    <span class="text-3xl font-bold text-white">${generalisteCount}</span>
                </div>
                <h3 class="text-slate-400 text-sm font-medium">Généralistes</h3>
            </div>

            <!-- Specialists -->
            <div class="bg-slate-900/50 backdrop-blur-xl border border-slate-800 rounded-2xl p-6 hover:border-slate-700 transition-all">
                <div class="flex items-center justify-between mb-4">
                    <div class="w-12 h-12 bg-purple-500/20 rounded-xl flex items-center justify-center">
                        <span class="text-2xl">⚕️</span>
                    </div>
                    <span class="text-3xl font-bold text-white">${specialisteCount}</span>
                </div>
                <h3 class="text-slate-400 text-sm font-medium">Spécialistes</h3>
            </div>
        </div>

        <!-- Actions -->
        <div class="mb-8">
            <a href="${pageContext.request.contextPath}/admin/register"
               class="inline-flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-emerald-500 to-blue-500 hover:from-emerald-600 hover:to-blue-600 text-white font-semibold rounded-xl shadow-lg shadow-emerald-500/30 hover:shadow-emerald-500/50 transform hover:scale-[1.02] transition-all duration-200">
                <span class="text-xl">✨</span>
                Créer un nouvel utilisateur
            </a>
        </div>

        <!-- Users Table -->
        <div class="bg-slate-900/50 backdrop-blur-xl border border-slate-800 rounded-2xl overflow-hidden">
            <div class="p-6 border-b border-slate-800">
                <h2 class="text-xl font-bold text-white flex items-center gap-3">
                    <span class="text-2xl">📋</span>
                    Liste des utilisateurs
                </h2>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-slate-800/50">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-300 uppercase tracking-wider">ID</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-300 uppercase tracking-wider">Nom complet</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-300 uppercase tracking-wider">Email</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-300 uppercase tracking-wider">Téléphone</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-300 uppercase tracking-wider">Rôle</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-300 uppercase tracking-wider">Spécialité</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-300 uppercase tracking-wider">Actions</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800">
                    <c:forEach var="user" items="${allUsers}">
                        <tr class="hover:bg-slate-800/30 transition-colors">
                            <td class="px-6 py-4 text-sm text-slate-400">#${user.id}</td>
                            <td class="px-6 py-4">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-full bg-gradient-to-br from-emerald-500 to-blue-500 flex items-center justify-center text-white font-semibold">
                                            ${fn:substring(user.prenom, 0, 1)}${fn:substring(user.nom, 0, 1)}
                                    </div>
                                    <div>
                                        <p class="text-sm font-medium text-white">${user.prenom} ${user.nom}</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-sm text-slate-300">${user.email}</td>
                            <td class="px-6 py-4 text-sm text-slate-300">
                                <c:choose>
                                    <c:when test="${not empty user.telephone}">${user.telephone}</c:when>
                                    <c:otherwise><span class="text-slate-500">-</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-6 py-4">
                                <c:choose>
                                    <c:when test="${user.role == 'ADMIN'}">
                                            <span class="inline-flex items-center gap-1 px-3 py-1 bg-violet-500/20 border border-violet-500/50 text-violet-400 text-xs font-medium rounded-full">
                                                👨‍💼 Admin
                                            </span>
                                    </c:when>
                                    <c:when test="${user.role == 'INFIRMIER'}">
                                            <span class="inline-flex items-center gap-1 px-3 py-1 bg-emerald-500/20 border border-emerald-500/50 text-emerald-400 text-xs font-medium rounded-full">
                                                👨‍⚕️ Infirmier
                                            </span>
                                    </c:when>
                                    <c:when test="${user.role == 'GENERALISTE'}">
                                            <span class="inline-flex items-center gap-1 px-3 py-1 bg-cyan-500/20 border border-cyan-500/50 text-cyan-400 text-xs font-medium rounded-full">
                                                🩺 Généraliste
                                            </span>
                                    </c:when>
                                    <c:when test="${user.role == 'SPECIALISTE'}">
                                            <span class="inline-flex items-center gap-1 px-3 py-1 bg-purple-500/20 border border-purple-500/50 text-purple-400 text-xs font-medium rounded-full">
                                                ⚕️ Spécialiste
                                            </span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td class="px-6 py-4 text-sm text-slate-300">
                                <c:choose>
                                    <c:when test="${user.role == 'SPECIALISTE'}">
                                        ${user.specialite}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-slate-500">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex items-center gap-2">
                                    <button class="p-2 hover:bg-slate-800 rounded-lg text-blue-400 hover:text-blue-300 transition-colors" title="Modifier">
                                        ✏️
                                    </button>
                                    <button class="p-2 hover:bg-slate-800 rounded-lg text-red-400 hover:text-red-300 transition-colors" title="Supprimer">
                                        🗑️
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty allUsers}">
                    <div class="p-12 text-center">
                        <div class="text-6xl mb-4">📭</div>
                        <p class="text-slate-400 text-lg">Aucun utilisateur trouvé</p>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>
</body>
</html>