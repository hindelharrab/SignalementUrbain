<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - CityReport</title>
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

<!-- 📝 Formulaire d'inscription -->
<section class="auth-container">
    <div class="auth-box auth-box-large">
        <div class="auth-header">
            <h1>Créer un compte</h1>
            <p>Rejoignez CityReport et participez à l'amélioration de votre ville</p>
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
            <input type="hidden" name="action" value="inscp">

            <div class="form-row">
                <div class="form-group">
                 <input type="hidden" name="action" value="inscp">
                    <label for="nom">Nom</label>
                    <input
                        type="text"
                        id="nom"
                        name="nom"
                        placeholder="Votre nom"
                        required
                        value="${param.nom}"
                    >
                </div>

                <div class="form-group">
                    <label for="prenom">Prénom</label>
                    <input
                        type="text"
                        id="prenom"
                        name="prenom"
                        placeholder="Votre prénom"
                        required
                        value="${param.prenom}"
                    >
                </div>
            </div>

            <div class="form-row">
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
                    <small class="form-hint">Nous ne partagerons jamais votre e-mail</small>
                </div>

                <div class="form-group">
                    <label for="telephone">Téléphone (optionnel)</label>
                    <input
                        type="tel"
                        id="telephone"
                        name="telephone"
                        placeholder="06 12 34 56 78"
                        value="${param.telephone}"
                    >
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="motDePasse">Mot de passe</label>
                    <input
                        type="password"
                        id="motDePasse"
                        name="motDePasse"
                        placeholder="••••••••"
                        required
                        minlength="8"
                    >
                    <small class="form-hint">Minimum 8 caractères</small>
                </div>

                <div class="form-group">
                    <label for="confirmationMotDePasse">Confirmer le mot de passe</label>
                    <input
                        type="password"
                        id="password-confirm"
                        name="confirmationMotDePasse"
                        placeholder="••••••••"
                        required
                        minlength="8"
                    >
                </div>
            </div>

            

            <div class="form-row">
                <div class="form-group">
    <label for="ville">Ville</label>
    <select id="ville" name="ville_id" required>
        <option value="">Sélectionnez votre ville</option>
        <c:forEach var="v" items="${villes}">
            <option value="${v.idVille}">${v.nomVille}</option>
        </c:forEach>
    </select>
</div>

                <div class="form-group">
                     <label for="role">Type de compte</label>
                <select id="role" name="role" required>
                    <option value="">Sélectionnez un type de compte</option>
                    <option value="citoyen" >Citoyen</option>
                    <option value="agent" >Agent municipal</option>
                    <option value="technicien">Technicien</option>
                </select>
                </div>
            </div>
            
            <div class="form-group" id="specialiteDiv" style="display:none;">
              <label for="idSpecialiteTech">Spécialité</label>
              <select id="idSpecialiteTech" name="idSpecialiteTech">
                   <option value="">Sélectionnez une spécialité</option>
                   <c:forEach var="s" items="${specialites}">
                   <option value="${s.idSpecialite}">${s.nomSpecialite}</option>
                   </c:forEach>
              </select>
           </div>
            
            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" name="acceptTerms" value="true" required>
                    <span>J'accepte les <a href="conditions.jsp" class="link-primary">conditions d'utilisation</a> et la <a href="confidentialite.jsp" class="link-primary">politique de confidentialité</a></span>
                </label>
            </div>

            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" name="newsletter" value="true">
                    <span>Je souhaite recevoir les actualités de CityReport</span>
                </label>
            </div>

            <button type="submit" class="btn-submit">
                Créer mon compte
            </button>
        </form>

        <div class="auth-footer">
            <p>Vous avez déjà un compte ?
                <a href="connexion.jsp" class="link-primary">Se connecter</a>
            </p>
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

<script>
// Validation du mot de passe
document.querySelector('.auth-form').addEventListener('submit', function(e) {
    const password = document.getElementById('password').value;
    const passwordConfirm = document.getElementById('password-confirm').value;

    if (password !== passwordConfirm) {
        e.preventDefault();
        alert('Les mots de passe ne correspondent pas');
        return false;
    }

    if (password.length < 8) {
        e.preventDefault();
        alert('Le mot de passe doit contenir au moins 8 caractères');
        return false;
    }
});

document.getElementById('role').addEventListener('change', function() {
    const specialiteDiv = document.getElementById('specialiteDiv');
    if (this.value === 'technicien') {
        specialiteDiv.style.display = 'block';
    } else {
        specialiteDiv.style.display = 'none';
    }
});
</script>

</body>
</html>
