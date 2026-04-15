<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.javabeans.*, java.util.*" %>

<%
    List<Signalement> signalements = (List<Signalement>) request.getAttribute("signalements");
    List<Utilisateur> techniciens = (List<Utilisateur>) request.getAttribute("techniciens");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<title>Nouveaux Signalements - CityReport</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/nvSign.css">
<style>
/* ---- Style du modal ---- */
.modal {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-inner {
  width: 100%;
  max-width: 700px;
  background: white;
  border-radius: var(--radius-lg, 10px);
  padding: 2rem;
  position: relative;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: var(--shadow-xl, 0 4px 20px rgba(0,0,0,0.2));
  animation: fadeIn 0.3s ease;
}

.modal-close {
  position: absolute;
  top: 1.25rem;
  right: 1.25rem;
  font-size: 1.75rem;
  cursor: pointer;
  color: var(--text-light, #999);
  transition: color 0.3s ease;
}

.modal-close:hover {
  color: var(--text-dark, #222);
}

.modal-inner h3 {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--text-dark, #264653);
  margin-bottom: 1.5rem;
}

/* Forms */
.form-row {
  display: flex;
  gap: 1.25rem;
  margin-bottom: 1.25rem;
}

.form-group {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.form-group label {
  font-weight: 600;
  color: var(--text-dark, #333);
  margin-bottom: 0.5rem;
  font-size: 0.95rem;
}

input,
textarea,
select {
  padding: 0.75rem;
  border-radius: var(--radius-md, 6px);
  border: 2px solid var(--border-color, #ccc);
  font-family: inherit;
  font-size: 1rem;
  transition: all 0.3s ease;
  background: white;
  color: var(--text-dark, #333);
}

input:focus,
textarea:focus,
select:focus {
  outline: none;
  border-color: var(--secondary-color, #84a98c);
  box-shadow: 0 0 0 3px rgba(132, 169, 140, 0.15);
}

textarea {
  resize: vertical;
  min-height: 120px;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
  margin-top: 1.5rem;
}

/* Checkboxes */
.modal-inner label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.75rem;
  font-weight: normal;
  cursor: pointer;
  color: var(--text-medium, #555);
}

.modal-inner input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

/* Animation */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

.btn-close {
    float: right;
    cursor: pointer;
    font-size: 20px;
    font-weight: bold;
}

/* ---- Grille signalements comme actualités ---- */
.signalements-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}
.signalement-item {
    display: flex;
    flex-direction: column;
    background: #fff;
    padding: 15px;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}
.signalement-thumb {
    width: 100%;
    max-height: 200px;
    border-radius: 6px;
    overflow: hidden;
    margin-bottom: 10px;
}
.signalement-thumb img {
    width: 100%;
    object-fit: cover;
}

.signalement-info {
    display: flex;
    justify-content: space-between;
    width: 100%;
}
.badge {
    display: inline-block;
    padding: 5px 10px;
    background: #e8e8e8;
    border-radius: 4px;
    font-size: 13px;
}
.btn-action {
    background-color: #84a98c;
    color: #fff;
    border: none;
    padding: 5px 10px;
    border-radius: 4px;
    cursor: pointer;
}
.btn-action:hover {
    background-color: #84a98c;
}
</style>
</head>
<body>

<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
       <a href="AgentServlet?action=agentAccueil">Accueil</a>
        <a href="AgentServlet?action=voirEnCours">Signalements en cours</a>
        <a href="AgentServlet?action=voirAffectationsRejetees">Affectations à revoir</a>
        <a href="AgentServlet?action=MonEspace">Mon espace</a>
        <a href="inscription?action=logout">Déconnexion</a>
    </nav>
</header>

<section class="main-dashboard" style="margin-top: 20px;">
    <div class="container-citoyen">
        <div class="dashboard-main">

            <!-- Section principale avec titre -->
            <div class="section-card">
                <div class="section-header-modern">
                    <div class="header-title">
                        <h2> Nouveaux signalements</h2>
                    </div>
                </div>

                <!-- Grille des signalements -->
                <div class="signalements-grid">
                    <% if(signalements != null && !signalements.isEmpty()) { %>
                        <% for(Signalement s : signalements) { 
                            String base64Image = "";
                            if(s.getPhoto() != null){
                                base64Image = java.util.Base64.getEncoder().encodeToString(s.getPhoto());
                            }
                        %>
                            <div class="signalement-item">
                                <% if(!base64Image.isEmpty()) { %>
                                    <div class="signalement-thumb">
                                        <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Photo signalement">
                                    </div>
                                <% } %>
                                <div class="signalement-title"><%= s.getDescription() %></div>
                               <%
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

<p class="signalement-desc">
    Statut : <strong><%= s.getNomStatut() %>
    <% if (!localisationCourte.isEmpty()) { %>
        à <%= localisationCourte %></strong>
    <% } %>
</p>

                                <div class="signalement-info">
                                    <span class="badge">📅 <%= s.getDateSignalement() %></span>
                                    <button class="btn-action" onclick="openModalAffectation(<%= s.getIdSignalement() %>)">
                                        Affecter
                                    </button>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="empty-state-modern">
                            <div class="empty-icon">📭</div>
                            <h3>Aucun nouveau signalement trouvé</h3>
                        </div>
                    <% } %>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- Modal Affectation -->
<div id="modalAffectation" class="modal">
    <div class="modal-inner">
        <span class="modal-close" onclick="fermerAffectation()">&times;</span>
        <h3>Affecter des techniciens</h3>
        <form action="AgentServlet" method="post">
            <input type="hidden" name="action" value="affecterSignalement">
            <input type="hidden" name="idSignalement" id="idSignalementHidden">

            <% for(Utilisateur t : techniciens) { %>
                <label>
                    <input type="checkbox" name="techniciens" value="<%= t.getIdUtilisateur() %>">
                    <%= t.getNom() %> <%= t.getPrenom() %> — <%= t.getNomSpec() != null ? t.getNomSpec() : "Sans spécialité" %>
                </label><br>
            <% } %>

            
            <div class="modal-footer">
        <button type="button" class="btn-action" style="background:#aaa;" onclick="fermerAffectation()">Annuler</button>
        <button type="submit" class="btn-action">Valider</button>
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
function openModalAffectation(idSignalement) {
    document.getElementById("idSignalementHidden").value = idSignalement;
    document.getElementById("modalAffectation").style.display = "flex";
}
function fermerAffectation(){
    document.getElementById("modalAffectation").style.display = "none";
}
window.addEventListener('pageshow', function(event) {
    // BFCache ou navigation "back/forward"
    if (event.persisted || (window.performance && window.performance.getEntriesByType("navigation")[0].type === "back_forward")) {
        window.location.reload();
    }
});
</script>

</body>
</html>
