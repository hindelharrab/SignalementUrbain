<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - CityReport</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/auth.css">
</head>
<body>

<!-- 🧭 Barre de navigation -->
<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
        <a href="PagePpl.jsp">Accueil</a>
        <a href="SignalementController?action=liste">Signalements</a>
        <a href="carte.jsp">Carte</a>
        <a href="a_propos.jsp">À propos</a>
        <a href="connexion.jsp" class="btn-nav">Connexion</a>
    </nav>
</header>

<!-- 🔐 Formulaire de connexion -->
<section class="auth-container">
    <div class="auth-layout">
        <div class="auth-box-compact">
            <div class="auth-header">
                <h1>Connexion</h1>
                <p>Bienvenue sur CityReport</p>
            </div>

        <!-- Message d'erreur -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <span class="alert-icon">⚠️</span>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Message de succès -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <span class="alert-icon">✓</span>
                <span>${success}</span>
            </div>
        </c:if>

        <form action="inscription" method="POST" class="auth-form">
            <input type="hidden" name="action" value="login">

            <div class="form-group">
                <label for="email">Adresse e-mail</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="votreemail@exemple.com"
                    required
                    value="${param.email}"
                >
            </div>

            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="••••••••"
                    required
                >
            </div>

            <div class="form-options">
                <label class="checkbox-label">
                    <input type="checkbox" name="remember" value="true">
                    <span>Se souvenir de moi</span>
                </label>
                <a href="mot-de-passe-oublie.jsp" class="link-secondary">Mot de passe oublié ?</a>
            </div>

            <button type="submit" class="btn-submit">
                Se connecter
            </button>
        </form>

            <div class="auth-footer">
                <p>Vous n'avez pas de compte ?
                    <a  href="inscription?action=formulaireInscp" class="link-primary">Créer un compte</a>
                </p>
            </div>
        </div>

        <div class="auth-side-panel">
            <div class="side-header">
                <h2>Qui peut se connecter ?</h2>
            </div>
            <div class="role-cards">
                <div class="role-card">
                    <div class="role-icon">👥</div>
                    <h3>Citoyens</h3>
                    <p>Signalez les problèmes de votre quartier et suivez leur résolution en temps réel</p>
                </div>
                <div class="role-card">
                    <div class="role-icon">🔧</div>
                    <h3>Techniciens</h3>
                    <p>Traitez et résolvez les signalements assignés à votre équipe</p>
                </div>
                <div class="role-card">
                    <div class="role-icon">🏛️</div>
                    <h3>Agents municipaux</h3>
                    <p>Gérez l'ensemble des signalements et coordonnez les interventions</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 🧾 Pied de page -->
<footer class="footer">
    <div class="footer-content">
        <div class="footer-main">
            <div class="footer-section">
                <h3>CityReport</h3>
                <p>
                    Plateforme citoyenne pour signaler et suivre les problèmes urbains.
                    Ensemble, améliorons notre cadre de vie et contribuons à une ville plus agréable pour tous.
                </p>
                <div class="social-links">
                    <a href="#" aria-label="Facebook">f</a>
                    <a href="#" aria-label="Twitter">𝕏</a>
                    <a href="#" aria-label="Instagram">📷</a>
                    <a href="#" aria-label="LinkedIn">in</a>
                </div>
            </div>

            <div class="footer-section">
                <h3>Navigation</h3>
                <ul class="footer-links">
                    <li><a href="accueil.jsp">Accueil</a></li>
                    <li><a href="SignalementController?action=liste">Signalements</a></li>
                    <li><a href="carte.jsp">Carte interactive</a></li>
                    <li><a href="a_propos.jsp">À propos</a></li>
                    <li><a href="connexion.jsp">Connexion</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h3>Aide</h3>
                <ul class="footer-links">
                    <li><a href="faq.jsp">FAQ</a></li>
                    <li><a href="guide.jsp">Guide d'utilisation</a></li>
                    <li><a href="contact.jsp">Nous contacter</a></li>
                    <li><a href="conditions.jsp">Conditions d'utilisation</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h3>Contact</h3>
                <ul class="footer-links">
                    <li> contact@cityreport.fr</li>
                    <li> 01 23 45 67 89</li>
                    <li> 123 Avenue de la République</li>
                    <li>75001 Paris, France</li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2025 CityReport. Tous droits réservés.</p>
            <p>
                <a href="mentions-legales.jsp" style="color: rgba(255, 255, 255, 0.6); text-decoration: none; margin: 0 1rem;">Mentions légales</a> |
                <a href="confidentialite.jsp" style="color: rgba(255, 255, 255, 0.6); text-decoration: none; margin: 0 1rem;">Politique de confidentialité</a> |
                <a href="cookies.jsp" style="color: rgba(255, 255, 255, 0.6); text-decoration: none; margin: 0 1rem;">Gestion des cookies</a>
            </p>
        </div>
    </div>
</footer>
</body>
</html>
