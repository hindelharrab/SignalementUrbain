<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.javabeans.*, java.util.*" %>

<%
    List<Actualite> actualites = (List<Actualite>) request.getAttribute("listeActualites");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
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
.actualite-item h3 {
    color: black;
    font-size: 18px;
    margin-bottom: 8px;
}
.actualite-item p {
    font-size: 14px;
    color: #444;
    flex: 1;
    margin-bottom: 12px;
}
.actualite-actions {
    display: flex;
    gap: 10px;
}

/* ===== Modales ===== */
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
  border-radius: var(--radius-lg);
  padding: 2rem;
  position: relative;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: var(--shadow-xl);
}

.modal-close {
  position: absolute;
  top: 1.25rem;
  right: 1.25rem;
  font-size: 1.75rem;
  cursor: pointer;
  color: var(--text-light);
  transition: color 0.3s ease;
}

.modal-close:hover {
  color: var(--text-dark);
}

.modal-inner h3 {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--text-dark);
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
  color: var(--text-dark);
  margin-bottom: 0.5rem;
  font-size: 0.95rem;
}

input,
textarea,
select {
  padding: 0.75rem;
  border-radius: var(--radius-md);
  border: 2px solid var(--border-color);
  font-family: inherit;
  font-size: 1rem;
  transition: all 0.3s ease;
  background: white;
  color: var(--text-dark);
}

input:focus,
textarea:focus,
select:focus {
  outline: none;
  border-color: var(--secondary-color);
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

/* Checkboxes in modal */
.modal-inner label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.75rem;
  font-weight: normal;
  cursor: pointer;
  color: var(--text-medium);
}

.modal-inner input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}
@keyframes fadeIn {
    from {opacity: 0; transform: translateY(-10px);}
    to {opacity: 1; transform: translateY(0);}
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

<section class="section-card">
    <div class="section-header">
        <h2>📰 Toutes les actualités de votre ville</h2>
        <button class="btn-action" onclick="openModal('ajout')"> Ajouter</button>
    </div>

    <div class="actualites-grid">
        <% if(actualites != null && !actualites.isEmpty()){ %>
            <% for(Actualite act : actualites){ %>
                <div class="actualite-item">
                    <% if(act.getImage()!=null){ %>
                        <img class="actualite-img"
                             src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(act.getImage()) %>">
                    <% } %>
                    <h3><%= act.getTitre() %></h3>
                    <p><%= act.getDescription() %></p>
                    <div class="actualite-actions">
                        <button class="btn-action"
                            data-id="<%= act.getIdActualite() %>"
                            data-titre="<%= act.getTitre().replace("\"", "&quot;").replace("'", "&#39;") %>"
                            data-contenu="<%= act.getDescription().replace("\"", "&quot;").replace("'", "&#39;") %>"
                            onclick="openModalModifier(this)">
                            Modifier
                        </button>
                        <button class="btn-action" 
                            onclick="supprimerActualite(<%= act.getIdActualite() %>)">
                            Supprimer
                        </button>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <p>Aucune actualité trouvée.</p>
        <% } %>
    </div>
</section>

<!-- === Modal d’ajout === -->
<div id="modalAjout" class="modal">
    <div class="modal-inner">
        <span class="modal-close" onclick="closeModal('ajout')">&times;</span>
        <h3>Ajouter une actualité</h3>
        <form action="AgentServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="ajouterActualite">

            <div class="form-group">
                <label>Titre</label>
                <input name="titre" required>
            </div>

            <div class="form-group">
                <label>Contenu</label>
                <textarea name="contenu" rows="4" required></textarea>
            </div>

            <div class="form-group">
                <label>Image</label>
                <input type="file" name="image">
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-action" style="background:#aaa;" onclick="closeModal('ajout')">Annuler</button>
                <button type="submit" class="btn-action">Enregistrer</button>
            </div>
        </form>
    </div>
</div>

<!-- === Modal de modification === -->
<div id="modalModif" class="modal">
    <div class="modal-inner">
        <span class="modal-close" onclick="closeModal('modif')">&times;</span>
        <h3>Modifier une actualité</h3>
        <form action="AgentServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="modifierActualite">
            <input type="hidden" name="id" id="idActu">

            <div class="form-group">
                <label>Titre</label>
                <input type="text" name="titre" id="inputTitre" required>
            </div>

            <div class="form-group">
                <label>Contenu</label>
                <textarea name="contenu" id="textareaContenu" rows="4" required></textarea>
            </div>

            <div class="form-group">
                <label>Image</label>
                <input type="file" name="image">
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-action" style="background:#aaa;" onclick="closeModal('modif')">Annuler</button>
                <button type="submit" class="btn-action">Enregistrer</button>
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
function openModal(type){
    document.getElementById(type === 'ajout' ? 'modalAjout' : 'modalModif').style.display = 'flex';
}
function closeModal(type){
    document.getElementById(type === 'ajout' ? 'modalAjout' : 'modalModif').style.display = 'none';
}
function supprimerActualite(id){
    if(confirm("Supprimer cette actualité ?")){
        window.location.href = "AgentServlet?action=supprimerActualite&id=" + id;
    }
}
function openModalModifier(btn){
    const id = btn.dataset.id;
    const titre = btn.dataset.titre;
    const contenu = btn.dataset.contenu;
    document.getElementById("idActu").value = id;
    document.getElementById("inputTitre").value = titre;
    document.getElementById("textareaContenu").value = contenu;
    openModal('modif');
}
</script>

</body>
</html>
