<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.util.Base64, Model.javabeans.*" %>

<%
    Utilisateur tech = (Utilisateur) session.getAttribute("technicien");
    if (tech == null) { response.sendRedirect("connexion.jsp"); return; }

    List<Actualite> actualites = (List<Actualite>) request.getAttribute("actualites");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Toutes les Actualités - CityReport</title>
<link rel="stylesheet" href="css/style.css">

<style>
/* ===== Structure générale ===== */
.section-card {
    background: #fff;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    margin: 40px auto;
    width: 95%;
    max-width: 1300px;
}
.section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
}
.section-header h2 {
    color: #264653;
    margin: 0;
}
.btn-action {
    background-color: #84a98c;
    color: white;
    font-weight: 600;
    border: none;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 14px;
    transition: background 0.2s ease;
}
.btn-action:hover { background-color: #6b8f79; }

/* ===== Grille des actualités ===== */
.actualites-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}
.actualite-item {
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    padding: 15px;
    display: flex;
    flex-direction: column;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.actualite-item:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.actualite-img {
    width: 100%;
    height: 180px;
    border-radius: 6px;
    object-fit: cover;
    margin-bottom: 10px;
}
.actualite-item h3 { color: black; font-size: 18px; margin-bottom: 8px; }
.actualite-item p { font-size: 14px; color: #444; flex: 1; margin-bottom: 12px; }
</style>
</head>

<body>
<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
       <a href="TechnicienServlet?action=accueil">Accueil</a>
       <a href="TechnicienServlet?action=monEspace">Mon espace</a>
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
                </div>
            <% } %>
        <% } else { %>
            <p>Aucune actualité trouvée.</p>
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
