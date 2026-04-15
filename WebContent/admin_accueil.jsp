<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, Model.javabeans.*"%>

<%
List<Actualite> actualites = (List<Actualite>) request.getAttribute("actualites");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin - Tableau de bord - CityReport</title>

<link rel="stylesheet" href="css/admin.css">
<style>
/* Bloc statistiques */

.stats-wrapper {
    background-color: #fff;
    padding: 1.5rem;
    margin: -2rem auto 1rem auto; /* marge en haut plus petite */
    border-radius: 10px;
    max-width: 1600px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.stats {
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
    gap: 1rem;
}

.stat-card {
    background-color: #84a98c;
    flex: 1 1 250px;
    padding: 1rem;
    border-radius: 10px;
    text-align: center;
    box-shadow: 0 2px 6px rgba(0,0,0,0.05);
}

.stat-card h3 {
    margin-bottom: 0.5rem;
    color: white;
    font-weight: bold;
}

.stat-card p {
    font-size: 1.5rem;
    font-weight: bold;
    color: white;
}

/* Actualités */
.actualites-section {
    max-width: 1600px;
    margin: 2rem auto;
}

.actu-card {
    background-color: #fff;
    padding: 1.5rem;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.05);
    margin-bottom: 2rem;
}

.actu-card h3 {
    margin-bottom: 1rem;
}

.actu-img {
    max-width: 100%;
    max-height:400px;
    border-radius: 10px;
    margin: 1rem 0;
}

.actu-meta {
    font-size: 0.9rem;
    color: #666;
    display: flex;
    gap: 1rem;
    margin-bottom: 1rem;
}

.voir-toutes {
    display: inline-block;
    padding: 0.5rem 1rem;
    background-color: #007BFF;
    color: #fff;
    text-decoration: none;
    border-radius: 5px;
}

.voir-toutes:hover {
    background-color: #0056b3;
}
.actu-card-header {
    display: flex;
    justify-content: space-between; /* titre à gauche, bouton à droite */
    align-items: center;
    margin-bottom: 1rem;
}

.btn-voir-toutes {
    padding: 0.3rem 0.8rem;
    background-color: #84a98c;
    color: #fff;
    border-radius: 5px;
    text-decoration: none;
    font-size: 0.85rem;
    transition: background-color 0.3s ease;
     font-weight: bold;
}

.btn-voir-toutes:hover {
    background-color: #84a98c;
}

</style>
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

<main>

    <!-- Statistiques en bloc blanc -->
    <div class="stats-wrapper">
        <div class="stats">
            <div class="stat-card">
                <h3>Signalements ce mois</h3>
                <p><%= request.getAttribute("sigMois") != null ? request.getAttribute("sigMois") : 0 %></p>
            </div>

            <div class="stat-card">
                <h3>Signalements traités</h3>
                <p><%= request.getAttribute("sigEnCours") != null ? request.getAttribute("sigEnCours") : 0 %></p>
            </div>

            <div class="stat-card">
                <h3>Nombre d'utilisateurs</h3>
                <p><%= request.getAttribute("users") != null ? request.getAttribute("users") : 0 %></p>
            </div>
        </div>
    </div>

    <!-- Actualité -->
    <section class="actualites-section">
       

        <%
        Actualite a = (Actualite) request.getAttribute("actualite");
        if (a != null) {
        %>

        <div class="actu-card">
    <div class="actu-card-header">
        <h3><%= a.getTitre() %></h3>
        <a href="AdminServlet?action=voirToutesActualites" class="btn-voir-toutes">Voir toutes les actualités</a>
    </div>

    <p><%= a.getDescription() %></p>

    <% if (a.getImage() != null && a.getImage().length > 0) { %>
        <img class="actu-img"
             src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(a.getImage()) %>"
             alt="Image de l'actualité" />
    <% } %>

    <div class="actu-meta">
        <span class="meta-item">📍 <%= a.getNomVille() %></span>
        <span class="meta-item">📅 <%= a.getDatePublication() %></span>
    </div>
</div>
        <% } else { %>
            <div class="actu-card" style="text-align: center; padding: 3rem;">
                <p style="color: #999;">Aucune actualité disponible.</p>
            </div>
        <% } %>
    </section>
</main>


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
