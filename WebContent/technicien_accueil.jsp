<%@ page language="java" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.util.Base64, Model.javabeans.*" %>

<%
    Utilisateur tech = (Utilisateur) session.getAttribute("technicien");
    if (tech == null) { response.sendRedirect("connexion.jsp"); return; }

    List<Signalement> signalements = (List<Signalement>) request.getAttribute("signalementsAffectes");
    List<Actualite> actualites = (List<Actualite>) request.getAttribute("actualites");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<title>Dashboard Technicien - CityReport</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/agent.css">
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

<section class="page-center">
    <div class="dashboard-box">

        <!-- Colonne Actualités -->
        <div class="actualites-box">
            <div class="section-header">
                <h2>Actualités</h2>
                <div style="display: flex; gap: 0.75rem;">
                    <button class="btn-action" onclick="window.location.href='TechnicienServlet?action=toutesActualites'">
                        Voir toutes
                    </button>
                </div>
            </div>
            <%
                if(actualites != null && !actualites.isEmpty()){
                    int countActu = 0;
                    for(Actualite a : actualites){
                        if(countActu >= 1) break; // Afficher seulement 1 actualité
                        String imgAct = null;
                        if(a.getImage() != null)
                            imgAct = Base64.getEncoder().encodeToString(a.getImage());
            %>
                <div class="actualite-item">
                    <div class="actualite-title"><%= a.getTitre() %></div>
                    <div><%= a.getDescription() %></div>
                    <% if(imgAct != null){ %>
                        <img class="actualite-img" src="data:image/jpeg;base64,<%= imgAct %>" alt="Image actualité" />
                    <% } %>
                </div>
            <%
                    countActu++;
                    }
                } else { 
            %>
                <p>Aucune actualité.</p>
            <%
                }
            %>
        </div>

        <!-- Colonne Signalements -->
        <div class="signalements-box">
            <div class="section-header">
                <h2>Vos signalements</h2>
                <button class="btn-action" onclick="window.location.href='TechnicienServlet?action=voirTous'">Voir tous</button>
            </div>
            <%
                if(signalements != null && !signalements.isEmpty()){
                    int countSig = 0;
                    for(Signalement s : signalements){
                        if(countSig >= 1) break; // Afficher seulement 1 signalement
                        String imgSig = null;
                        if(s.getPhoto() != null)
                            imgSig = Base64.getEncoder().encodeToString(s.getPhoto());
            %>
                <div class="signalement-item">
                    <% if(imgSig != null){ %>
                        <img class="signalement-img" src="data:image/jpeg;base64,<%= imgSig %>" alt="Photo signalement"/>
                    <% } %>
                    <div class="signalement-title"><%= s.getDescription() %></div>
                    
                    <div>Date : <%= s.getDateSignalement() %></div>
                    <div class="signalement-actions">
                        <a href="TechnicienServlet?action=accepter&idSignalement=<%= s.getIdSignalement() %>&idAffectation=<%= s.getIdAffectation() %>">
                            <button class="btn-action">Accepter</button>
                        </a>
                        <button class="btn-action" onclick="ouvrirModal(<%= s.getIdSignalement() %>)">Refuser</button>
                    </div>
                </div>
            <%
                    countSig++;
                    }
                } else { 
            %>
                <p>Aucun signalement affecté.</p>
            <%
                }
            %>
        </div>

    </div>
</section>

<!-- ============================== MODAL ============================== -->
<div id="modalRefus" class="modal">
    <div class="modal-inner">
        <h3>Raison du refus</h3>
        <form action="TechnicienServlet" method="post">
            <input type="hidden" name="action" value="refuser">
            <input type="hidden" id="idSignalementModal" name="idSignalement">
            <textarea name="commentaire" required style="width:100%; height:80px;"></textarea>
            <div class="modal-footer">
                <button type="submit" class="btn-action">Envoyer</button>
                <button type="button" class="btn-action" onclick="fermerModal()">Annuler</button>
            </div>
        </form>
    </div>
</div>

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
function ouvrirModal(id) {
    document.getElementById("idSignalementModal").value = id;
    document.getElementById("modalRefus").style.display = "flex";
}
function fermerModal() {
    document.getElementById("modalRefus").style.display = "none";
}
</script>

</body>
</html>
