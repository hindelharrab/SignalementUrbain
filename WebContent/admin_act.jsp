<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, java.util.Base64, Model.javabeans.*" %>

<%
    List<Actualite> actualites = (List<Actualite>) request.getAttribute("actualites");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Toutes les Actualités - CityReport</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/actualite2.css">

</head>

<body>
<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
       <a href="AdminServlet">Accueil</a>
       <a href="AdminServlet?action=gererUtilisateurs">Gérer utilisateurs</a>
       <a href="AdminServlet?action=profil">Mon profil</a>
       <a href="inscription?action=logout">Déconnexion</a>
    </nav>
</header>

<section class="section-card">
    <div class="section-header">
        <h2>📰 Toutes les actualités</h2>
    </div>

    <div class="actualites-grid">
    <% if(actualites != null && !actualites.isEmpty()){ %>
        <% for(Actualite act : actualites){ 
            String img = act.getImage() != null ? Base64.getEncoder().encodeToString(act.getImage()) : null;
        %>
            <div class="actualite-item">
                <% if(img != null){ %>
                    <img class="actualite-img" src="data:image/jpeg;base64,<%= img %>">
                <% } %>
                <h3><%= act.getTitre() %></h3>
                <p><%= act.getDescription() %></p>
                
               <div class="actu-meta">
        <span class="meta-item">📍 <%= act.getNomVille() %></span>
        <span class="meta-item">📅 <%= act.getDatePublication() %></span>
    </div>
            </div>
        <% } %>
    <% } else { %>
        <p style="text-align:center; color:#777;">Aucune actualité trouvée.</p>
    <% } %>
</div>

</section>

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
