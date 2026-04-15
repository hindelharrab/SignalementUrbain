<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.javabeans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>

<%
    List<Actualite> actualites = (List<Actualite>) session.getAttribute("actualites");
    Utilisateur citoyen = (Utilisateur) session.getAttribute("utilisateur");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Toutes les Actualités - CityReport</title>

    <link rel="stylesheet" href="css/citoyen.css">
    <link rel="stylesheet" href="css/actualite1.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

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

<section class="main-dashboard" style="margin-top: 40px;">
    <div class="container-citoyen">
        <div class="dashboard-main">

            <div class="section-card">
                <div class="section-header-modern">
                    <div class="header-title">
                        <h2>📰 Toutes les actualités</h2>
                    </div>
                </div>

                <div class="actualites-grid">
                    <%
                        if (actualites != null && !actualites.isEmpty()) {

                            for (Actualite a : actualites) {
                                String base64Image = "";
                                if (a.getImage() != null) {
                                    base64Image = Base64.getEncoder().encodeToString(a.getImage());
                                }
                    %>
                        <div class="actualite-item">

                            <% if (!base64Image.isEmpty()) { %>
                                <div class="actualite-thumb">
                                    <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Image actualité">
                                </div>
                            <% } %>

                            <div class="actualite-title"><%= a.getTitre() %></div>
                            <p class="actualite-desc"><%= a.getDescription() %></p>

                            <div class="actualite-info">
                                <span class="badge">📅 <%= a.getDatePublication() %></span>
                               
                            </div>
                        </div>
                    <%
                            }
                        } else {
                    %>

                    <div class="empty-state-modern">
                        <div class="empty-icon">📭</div>
                        <h3>Aucune actualité pour le moment</h3>
                    </div>

                    <%
                        }
                    %>
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
