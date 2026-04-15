<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@ page import="Model.javabeans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%
    List<Actualite> actualites = (List<Actualite>) session.getAttribute("actualites");
    List<Signalement> signalements = (List<Signalement>) session.getAttribute("signalements");
    String afficherToutParam = request.getParameter("tout");
    boolean afficherTout = "1".equals(afficherToutParam);
    Utilisateur citoyen = (Utilisateur) session.getAttribute("citoyen");
    String nomComplet = citoyen != null ? citoyen.getNom() + " " + citoyen.getPrenom() : "Citoyen";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Citoyen - CityReport</title>
  
    <link rel="stylesheet" href="css/citoyen.css">
      <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
</head>
<body>

<!-- Barre de navigation -->


<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
     <a href="citoyen_accueil.jsp">Accueil</a>
        <a href="apropos.jsp"> A propos</a>
        <a href="carte.jsp">Carte</a>
        <a href="inscription?action=logout">Se déconnecter</a>            
    </nav>
</header>



<!-- Actions rapides -->
<section class="actions-rapides">
    <div class="container-citoyen">
        <div class="actions-grid-modern">
            <form action="CitoyenServlet" method="get" class="action-form">
                <input type="hidden" name="action" value="ajouterSignalement">
                <button type="submit" class="action-btn primary-action">
                    <div class="action-icon-large">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M12 5v14"></path>
    <path d="M5 12h14"></path>
</svg>
 
                        </div>
                    <div class="action-text">
                        <h3>Ajouter un signalement</h3>
                    </div>
                </button>
            </form>

            <form action="CitoyenServlet" method="get" class="action-form">
                <input type="hidden" name="action" value="monEspace">
                <button type="submit" class="action-btn">
                    <div class="action-icon-large">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg> </div>
                    <div class="action-text">
                        <h3>Mon espace</h3>
                       
                    </div>
                </button>
            </form>

            <a href="CitoyenServlet?action=listeSignalements" class="action-btn">
                <div class="action-icon-large">
               <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M3 7h5l2 3h11v9H3z"></path>
    <path d="M3 7V5h6l2 2h10v2"></path>
</svg>

                     </div>
                <div class="action-text">
                    <h3>Mes signalements</h3>
                </div>
            </a>

            <a href="actualites.jsp" class="action-btn">
    <div class="action-icon-large">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M3 5h16a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5z"></path>
    <path d="M7 8h10"></path>
    <path d="M7 12h10"></path>
    <path d="M7 16h6"></path>
</svg>

    </div>
    <div class="action-text">
        <h3>Actualités</h3>
    </div>
</a>

        </div>
    </div>
</section>

<!-- Contenu principal -->
<section class="main-dashboard">
    <div class="container-citoyen">
        <div class="dashboard-grid">

            <!-- Colonne principale: Mes signalements -->
            <div class="dashboard-main">
                <div class="section-card">
                    <div class="section-header-modern">
                        <div class="header-title">
                            <h2>📍 Mes derniers signalements</h2>
                        
                        </div>
                    </div>

                    <div class="signalements-container">
                        <%
                            if (signalements != null && !signalements.isEmpty()) {
                                List<Signalement> signalementsAAfficher;
                                if (afficherTout) {
                                    signalementsAAfficher = signalements;
                                } else {
                                    int max = Math.min(signalements.size(), 2);
                                    signalementsAAfficher = signalements.subList(0, max);
                                }

                                for (Signalement s : signalementsAAfficher) {
                                    String base64Photo = "";
                                    if (s.getPhoto() != null) {
                                        base64Photo = Base64.getEncoder().encodeToString(s.getPhoto());
                                    }
                        %>
                                    <div class="signalement-item">
                                        <% if (!base64Photo.isEmpty()) { %>
                                            <div class="signalement-thumb">
                                                <img src="data:image/jpeg;base64,<%= base64Photo %>" alt="Photo">
                                            </div>
                                        <% } else { %>
                                            <div class="signalement-thumb no-image">
                                                <span>📷</span>
                                            </div>
                                        <% } %>

                                        <div class="signalement-details">
                                            <p class="signalement-desc"><%= s.getDescription() %></p>
                                            <div class="signalement-info">
                                                <span class="info-badge">📅 <%= s.getDateSignalement() %></span>
                                                 <%
                                                  String localisation = s.getLocalisation(); 
                                                  String localisationAffichee = localisation; 
                                                  if(localisation != null && localisation.contains(",")) {
                                                  String[] parts = localisation.split(",");
                                                  if(parts.length >= 2){
                                                  localisationAffichee = parts[0].trim() + ", " + parts[1].trim();
                                                  }
                                                  }%>

                                                <span class="info-badge">📍 <%= localisationAffichee %></span>
                                            </div>
                                        </div>
                                    </div>
                        <%
                                }

                                if (!afficherTout && signalements.size() > 2) {
                        %>
                                    <a href="CitoyenServlet?action=listeSignalements" class="btn-load-more link-as-button">
                                    Voir tous mes signalements
                                    </a>

                        <%
                                }
                            } else {
                        %>
                            <div class="empty-state-modern">
                                <div class="empty-icon">📭</div>
                                <h3>Aucun signalement</h3>
                                <p>Vous n'avez pas encore créé de signalement.</p>
                                <form action="CitoyenServlet" method="get">
                                    <input type="hidden" name="action" value="ajouterSignalement">
                                    <button type="submit" class="btn-create-first">Créer mon premier signalement</button>
                                </form>
                            </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>

            <!-- Sidebar: Actualités -->
            <div class="dashboard-sidebar">
                <div class="section-card">
                    <div class="section-header-modern">
                        <div class="header-title">
                            <h2>📰 Actualités</h2>
                        </div>
                    </div>

                    <div class="actualites-container">
                        <%
                            if (actualites != null && !actualites.isEmpty()) {
                            	int limite = Math.min(actualites.size(), 1);
                            	for (int i = 0; i < limite; i++) {
                            	    Actualite a = actualites.get(i);
                                    String base64Image = "";
                                    if (a.getImage() != null) {
                                        base64Image = Base64.getEncoder().encodeToString(a.getImage());
                                    }
                        %>
                                    <div class="actualite-item">
                                        <% if (!base64Image.isEmpty()) { %>
                                            <div class="actualite-thumb">
                                                <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Actualité">
                                            </div>
                                        <% } %>
                                        <div class="actualite-details">
                                            <h4><%= a.getTitre() %></h4>
                                            <p><%= a.getDescription() %></p>
                                            <span class="actualite-meta">publier le <%= a.getDatePublication() %></span>
                                        </div>
                                       
                                    </div>
                                     <% if (actualites != null && actualites.size() > 1) { %>
    <a href="CitoyenServlet?action=listeActualites" class="btn-load-more link-as-button" style="margin-top: 15px; text-align:center;">
        Voir toutes les actualités
    </a>
<% } %>
                        <%
                                }
                            } else {
                        %>
                            <div class="empty-state-modern">
                                <div class="empty-icon">📰</div>
                                <h3>Aucune actualité</h3>
                                <p>Revenez bientôt pour des nouvelles.</p>
                            </div>
                        <%
                            }
                        %>
                    </div>
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
