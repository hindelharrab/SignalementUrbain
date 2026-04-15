<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.util.Base64, Model.javabeans.*" %>

<%
    Utilisateur tech = (Utilisateur) session.getAttribute("technicien");
    if (tech == null) { response.sendRedirect("connexion.jsp"); return; }

    List<Signalement> signalements = (List<Signalement>) request.getAttribute("signalements");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Tous les Signalements Affectés - CityReport</title>
<link rel="stylesheet" href="css/style.css">

<style>
/* ===== Grille et cards ===== */
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
.signalements-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}
.signalement-item {
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    padding: 15px;
    display: flex;
    flex-direction: column;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.signalement-item:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.signalement-img {
    width: 100%;
    height: 180px;
    object-fit: cover;
    border-radius: 6px;
    margin-bottom: 10px;
}
.signalement-item p { color: #444; flex: 1; margin-bottom: 12px; font-size: 14px; }
.signalement-actions {
    display: flex;
    gap: 10px;
}
.signalement-actions button,
.signalement-actions a button {
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
.signalement-actions button:hover,
.signalement-actions a button:hover { background-color: #6b8f79; }

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
  max-width: 500px;
  background: white;
  border-radius: 12px;
  padding: 2rem;
  position: relative;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.modal-inner h3 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
}
textarea {
    width: 100%;
    height: 100px;
    padding: 0.75rem;
    border-radius: 8px;
    border: 2px solid #ddd;
    resize: vertical;
    font-size: 14px;
}
.modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 1.5rem;
}
.modal-footer button {
    background-color: #84a98c;
    color: white;
    font-weight: 600;
    border: none;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
}
.modal-footer button:hover { background-color: #6b8f79; }
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
        <h2>📋 Tous mes signalements affectés</h2>
    </div>

    <% if(signalements == null || signalements.isEmpty()){ %>
        <p>Aucun signalement affecté.</p>
    <% } else { %>
        <div class="signalements-grid">
        <% for(Signalement s : signalements){ 
            String img = s.getPhoto() != null ? Base64.getEncoder().encodeToString(s.getPhoto()) : null;
        %>
            <div class="signalement-item">
                <% if(img != null){ %>
                    <img class="signalement-img" src="data:image/jpeg;base64,<%= img %>">
                <% } %>
                <p><%= s.getDescription() %></p>
                <div class="signalement-actions">
                   <a href="TechnicienServlet?action=accepter&idSignalement=<%= s.getIdSignalement() %>&idAffectation=<%= s.getIdAffectation() %>">
                        <button>Accepter</button>
                    </a>
                    <button onclick="ouvrirModal(<%= s.getIdSignalement() %>)">Refuser</button>
                </div>
            </div>
        <% } %>
        </div>
    <% } %>
</section>

<!-- MODAL DE REFUS -->
<div id="modalRefus" class="modal">
    <div class="modal-inner">
        <h3>Raison du refus</h3>
        <form action="TechnicienServlet" method="post">
            <input type="hidden" name="action" value="refuser">
            <input type="hidden" id="idSignalementModal" name="idSignalement">
            <textarea name="commentaire" required></textarea>
            <div class="modal-footer">
                <button type="button" onclick="fermerModal()">Annuler</button>
                <button type="submit">Envoyer</button>
            </div>
        </form>
    </div>
</div>

<footer class="footer">
    <!-- Footer identique aux autres pages -->
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
        </div>
    </div>
</footer>

<script>
function ouvrirModal(id){
    document.getElementById("idSignalementModal").value = id;
    document.getElementById("modalRefus").style.display = "flex";
}
function fermerModal(){
    document.getElementById("modalRefus").style.display = "none";
}
</script>
</body>
</html>
