<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.javabeans.*, java.util.*" %>

<%
    List<Affectation> affectations = (List<Affectation>) session.getAttribute("affectations");
    List<Utilisateur> techniciens = (List<Utilisateur>) session.getAttribute("techniciens");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<title>Affectations Rejetées - CityReport</title>
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

/* ===== En-tête ===== */
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
.btn-action:hover {
    background-color: #6b8f79;
}

/* ===== Grille des affectations ===== */
.affectations-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}
.affectation-item {
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    padding: 15px;
    display: flex;
    flex-direction: column;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.affectation-item:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.affectation-item h3 {
    font-size: 16px;
    margin-bottom: 8px;
    color: #264653;
}
.affectation-item p {
    font-size: 14px;
    margin-bottom: 12px;
    color: #444;
}
.affectation-actions {
    display: flex;
    justify-content: flex-end;
}

/* ===== Modales ===== */
.modal {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.5);
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-inner {
  width: 100%;
  max-width: 600px;
  background: white;
  border-radius: var(--radius-lg);
  padding: 2rem;
  position: relative;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 25px rgba(0,0,0,0.2);
}

.modal-close {
  position: absolute;
  top: 1.25rem;
  right: 1.25rem;
  font-size: 1.75rem;
  cursor: pointer;
  color: #888;
  transition: color 0.3s ease;
}
.modal-close:hover {
  color: #333;
}

.modal-inner h3 {
  font-size: 1.5rem;
  font-weight: 700;
  color: #264653;
  margin-bottom: 1.5rem;
}

/* Forms */
.form-group {
  margin-bottom: 1rem;
  display: flex;
  flex-direction: column;
}
.form-group label {
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #264653;
}
.modal-inner input[type="checkbox"] {
  margin-right: 0.5rem;
}
.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
  margin-top: 1.5rem;
}
</style>
</head>
<body>

<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
      <a href="AgentServlet?action=agentAccueil">Accueil</a>
        <a href="AgentServlet?action=voirEnCours">Signalements en cours</a>
        <a href="AgentServlet?action=voirAffectationsRejetees" class="active">Affectations à revoir</a>
        <a href="AgentServlet?action=MonEspace">Mon espace</a>
        <a href="inscription?action=logout">Déconnexion</a>
        
    </nav>
</header>

<section class="section-card">
    <div class="section-header">
        <h2>🛠️ Affectations Rejetées</h2>
    </div>

    <div class="affectations-grid">
        <% if(affectations != null && !affectations.isEmpty()){ 
            for(Affectation a : affectations){ %>
                <div class="affectation-item">
                    <h3>Signalement</h3>
                    <p><%= a.getDescription() %></p>
                    <h3>Technicien</h3>
                    <p><%= a.getNomTechnicien() %></p>
                    <h3>Commentaire de rejet</h3>
                    <p><%= a.getCommentaire() %></p>
                    <div class="affectation-actions">
                        <button class="btn-action" onclick="openModalAffectation(<%= a.getIdSignalement() %>)">Ré-affecter</button>
                    </div>
                </div>
        <%  } 
           } else { %>
            <p>Aucune affectation rejetée trouvée.</p>
        <% } %>
    </div>
</section>

<!-- Modal ré-affectation -->
<div id="modalAffectation" class="modal">
    <div class="modal-inner">
        <span class="modal-close" onclick="fermerAffectation()">&times;</span>
        <h3>Ré-affecter un signalement</h3>

        <form action="AgentServlet" method="post">
            <input type="hidden" name="action" value="reaffecter">
            <input type="hidden" name="idSignalement" id="idSignalementHidden">

            <% if(techniciens != null && !techniciens.isEmpty()){ 
                for(Utilisateur t : techniciens){ %>
                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="techniciens" value="<%= t.getIdUtilisateur() %>">
                            <%= t.getNom() %> <%= t.getPrenom() %> — <%= t.getNomSpec() != null ? t.getNomSpec() : "Sans spécialité" %>
                        </label>
                    </div>
            <%  } 
               } else { %>
                <p>Aucun technicien disponible.</p>
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
function openModalAffectation(idSignalement){
    document.getElementById("idSignalementHidden").value = idSignalement;
    document.getElementById("modalAffectation").style.display = "flex";
}
function fermerAffectation(){
    document.getElementById("modalAffectation").style.display = "none";
}
</script>

</body>
</html>
