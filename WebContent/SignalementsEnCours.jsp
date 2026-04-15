<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.javabeans.*, java.util.*" %>

<%
    List<Signalement> signalements = (List<Signalement>) request.getAttribute("signalementsEnCours");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<title>Signalements en cours - Agent</title>
<link rel="stylesheet" href="css/style.css">

<style>
/* Section principale centrée */
.section-card {
    background: #fff;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    margin: 40px auto;
    max-width: 1300px;
}

/* Grille des signalements */
.signalements-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(325px, 1fr));
    gap: 20px;
    margin-top: 25px;
}

/* Chaque signalement */
.signalement-item {
    display: flex;
    flex-direction: column;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    padding: 15px;
}

/* Image */
.signalement-thumb img {
    width: 100%;
    max-height: 200px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 10px;
}

/* Titre + desc */
.signalement-title {
    font-size: 15px;
    font-weight: 500;
    margin-bottom: 6px;
}
.signalement-desc {
    font-size: 15px;
    color: #333;
    margin-bottom: 10px;
}
.signalement-desc  {
       color: #555;
}

/* Date + bouton */
.signalement-info {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 8px;
}
.badge {
    background: #f1f1f1;
    padding: 6px 10px;
    border-radius: 6px;
    font-size: 14px;
}
.btn-action {
    background-color: #84a98c;
    color: #fff;
    border: none;
    padding: 10px 20px;
    font-weight: 600;
    border-radius: 10px;
    cursor: pointer;
}
.btn-action:hover {
    background-color: #84a98c;
}
/* Centrage du titre */
h2 {
    text-align: left;
    margin-top: 10px;
    color: #333;
}
</style>
</head>

<body>

<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
        <a href="AgentServlet?action=agentAccueil">Accueil</a>
        <a href="AgentServlet?action=voirEnCours" class="active">Signalements en cours</a>
        <a href="AgentServlet?action=voirAffectationsRejetees">Affectations à revoir</a>
        <a href="AgentServlet?action=MonEspace">Mon espace</a>
        <a href="inscription?action=logout">Déconnexion</a>
        
    </nav>
</header>

<section class="section-card">
    <h2> Signalements en cours</h2>

    <div class="signalements-grid">
        <% if(signalements != null && !signalements.isEmpty()) { %>
            <% for(Signalement s : signalements) { 
                String base64Image = "";
                if(s.getPhoto() != null){
                    base64Image = java.util.Base64.getEncoder().encodeToString(s.getPhoto());
                }

                String localisation = s.getLocalisation();
                String localisationCourte = "";
                if (localisation != null && !localisation.isEmpty()) {
                    String[] parties = localisation.split(",");
                    if (parties.length >= 2) {
                        localisationCourte = parties[0].trim() + ", " + parties[1].trim();
                    } else {
                        localisationCourte = parties[0].trim();
                    }
                }
            %>
                <div class="signalement-item">
                    <% if(!base64Image.isEmpty()) { %>
                        <div class="signalement-thumb">
                            <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Photo signalement">
                        </div>
                    <% } %>

                    <div class="signalement-title"><%= s.getDescription() %></div>

                    <p class="signalement-desc">
                        Statut : <strong><%= s.getNomStatut() %></strong>
                        <% if (!localisationCourte.isEmpty()) { %>
                            à <%= localisationCourte %>
                        <% } %>
                    </p>

                    <div class="signalement-info">
                        <span class="badge">📅 <%= s.getDateSignalement() %></span>

                        <form action="AgentServlet" method="post" style="margin:0;">
                            <input type="hidden" name="action" value="marquerResolue">
                            <input type="hidden" name="idSignalement" value="<%= s.getIdSignalement() %>">
                            <button type="submit" class="btn-action">Marquer comme résolu</button>
                        </form>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="empty-state-modern" style="text-align:center;">
                <div class="empty-icon" style="font-size:40px;">📭</div>
                <h3>Aucun signalement en cours</h3>
            </div>
        <% } %>
    </div>
</section>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-main">
            <div class="footer-section">
                <h3>CityReport</h3>
                <p>Plateforme citoyenne pour signaler et suivre les problèmes urbains.</p>
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
        </div>
    </div>
</footer>

</body>
</html>
