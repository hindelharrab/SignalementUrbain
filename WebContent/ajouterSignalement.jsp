<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.javabeans.*" %>

<%
    List<Type> types = (List<Type>) request.getAttribute("types");
    List<Ville> villes = (List<Ville>) request.getAttribute("villes");
    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ajouter un signalement - CityReport</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/auth.css">

<style>
/* Largeur du formulaire */
.auth-box-large {
    max-width: 900px;
    width: 80%;
}

/* Form-row pour deux colonnes */
.form-row {
    display: flex;
    gap: 20px;
    margin-bottom: 15px;
}

/* Form-group */
.form-group {
    flex: 1;
    display: flex;
    flex-direction: column;
}

/* Champ description plus large (2 colonnes) */
.form-group.description {
    flex: 2;
}

/* Champs input, select, textarea */
input, select, textarea {
    width: 100%;
    padding: 10px;
    border-radius: 6px;
    border: 1px solid #ced4da;  /* couleur normale */
    font-family: inherit;
    font-size: 14px;
    background-color: #f8f9fa;
    color: #495057;
}

/* Focus uniforme */
input:focus, select:focus, textarea:focus {
    outline: none;
    border-color: #84a98c; /* vert uniforme */
    box-shadow: 0 0 0 2px rgba(132, 169, 140, 0.25);
}

/* Textarea description */
textarea {
    resize: vertical;
}

/* Bouton localisation */
.localisation-container {
    display: flex;
    gap: 10px;
    align-items: center;
}

.btn-location {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 15px 20px;
    border-radius: 6px;
    border: none;
    background-color: #84a98c; /* couleur verte uniforme */
    color: white;
    cursor: pointer;
    font-size: 15px;
     font-weight: 600;
}

.btn-location svg {
    width: 20px;
    height: 20px;
    margin-right: 6px;
    fill: white;
}
</style>
</head>
<body>

<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
        <a href="citoyen_accueil.jsp">Accueil</a>
        <a href="apropos.jsp"> A propos</a>
        <a href="carte.jsp">Carte</a>
        <a href="inscription?action=logout">Se déconnecter</a>            
    </nav>
</header>

<section class="auth-container">
<div class="auth-box auth-box-large">
    <div class="auth-header">
        <h1>Ajouter un signalement</h1>
        <p>Remplissez les informations ci-dessous pour signaler un problème</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error">
            <span class="alert-icon">⚠️</span>
            <span>${error}</span>
        </div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="alert alert-success">
            <span class="alert-icon">✓</span>
            <span>${success}</span>
        </div>
    </c:if>

    <form action="CitoyenServlet" method="POST" enctype="multipart/form-data" class="auth-form">
        <input type="hidden" name="action" value="ajouterSignalement">
        <input type="hidden" name="idCitoyenFK" value="<%= utilisateur.getIdUtilisateur() %>">
        <input type="hidden" name="idStatutFK" value="1">
        <input type="hidden" name="idTechnicienFK" id="idTechnicienFK">

        <div class="form-row">
            <div class="form-group description">
                <label for="description">Description</label>
                <textarea id="description" name="description" placeholder="Décrivez le problème" rows="4" required></textarea>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="photo">Photo (optionnel)</label>
                <input type="file" id="photo" name="photo" accept="image/*">
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="localisation">Localisation</label>
                <div class="localisation-container">
                    <input type="text" id="localisation" name="Localisation" placeholder="Adresse ou GPS" required>
                    <button type="button" class="btn-location" onclick="getLocation()">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                            <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5S10.62 6.5 12 6.5s2.5 1.12 2.5 2.5S13.38 11.5 12 11.5z"/>
                        </svg>
                        Localiser
                    </button>
                </div>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="type">Type de signalement</label>
                <select id="type" name="idTypeFK" required>
                    <option value="">Sélectionnez un type</option>
                    <% if (types != null) {
                        for (Type t : types) { %>
                            <option value="<%= t.getIdType() %>"><%= t.getNomType() %></option>
                    <% } } %>
                </select>
            </div>

            <div class="form-group">
                <label for="ville">Ville</label>
                <select id="ville" name="idVilleFK" required>
                    <option value="">Sélectionnez une ville</option>
                    <% if (villes != null) {
                        for (Ville v : villes) { %>
                            <option value="<%= v.getIdVille() %>"><%= v.getNomVille() %></option>
                    <% } } %>
                </select>
            </div>
        </div>

        <button type="submit" class="btn-submit">Envoyer le signalement</button>
    </form>

   
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
function getLocation() {
    if (!navigator.geolocation) {
        alert("La géolocalisation n'est pas supportée par votre navigateur.");
        return;
    }
    navigator.geolocation.getCurrentPosition(
        function(position) {
            var lat = position.coords.latitude;
            var lon = position.coords.longitude;
            var geocodeUrl = "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=" + lat + "&lon=" + lon;
            fetch(geocodeUrl, { headers: { 'Accept': 'application/json' } })
                .then(response => response.json())
                .then(data => {
                    if (data.display_name) {
                        document.getElementById("localisation").value = data.display_name;
                    } else {
                        alert("Impossible de récupérer l'adresse.");
                    }
                })
                .catch(err => alert("Erreur lors de la récupération de l'adresse : " + err));
        },
        function(error) {
            alert("Impossible de récupérer la position : " + error.message);
        }
    );
}
</script>

</body>
</html>
