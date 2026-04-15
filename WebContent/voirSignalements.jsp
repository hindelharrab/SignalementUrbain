<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.javabeans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%
    List<Signalement> signalements = (List<Signalement>) request.getAttribute("signalements");
    Utilisateur citoyen = (Utilisateur) session.getAttribute("utilisateur");
    String nomComplet = citoyen != null ? citoyen.getNom() + " " + citoyen.getPrenom() : "Citoyen";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
    <title>Mes Signalements - CityReport</title>

    <link rel="stylesheet" href="css/citoyen.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

    <style>
        /* Grille 2 colonnes pour les signalements */
        .signalements-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .signalement-item {
            display: flex;
            background: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            align-items: flex-start;
            flex-direction: column;
        }
        .signalement-thumb {
            width: 100%;
            max-height: 200px;
            overflow: hidden;
            border-radius: 6px;
            margin-bottom: 10px;
        }
        .signalement-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .signalement-details {
            word-wrap: break-word;
        }
        .signalement-desc {
            margin: 0 0 10px 0;
            white-space: pre-wrap; /* Permet aux longues descriptions de se mettre sur plusieurs lignes */
        }
        .signalement-info {
    display: flex;
    justify-content: space-between; /* place les 2 éléments chacun d'un côté */
    align-items: center;
    width: 100%;
}

.signalement-info .info-badge:last-child {
    margin-left: auto; /* pousse la localisation à droite */
}
        .info-badge {
            display: inline-block;
            margin-right: 10px;
        }
       /* --- Bouton Modifier (remplace ton ancien) --- */
.btn-edit {
    background-color: #84a98c;
    border: none;
    padding: 10px 14px;
    border-radius: 6px;
    color: white;
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 6px;
}
.btn-edit:hover {
    opacity: 0.85;
}

/* --- Modal --- */
.modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.55); /* assombrit l'arrière plan */
    justify-content: center;
    align-items: center;
    z-index: 2000;
}
.modal-inner {
    background: white;
    width: 850px;
    max-width: 95%;
    padding: 30px;
    border-radius: 14px;
}

/* Formulaire du modal */
.form-row {
    display: flex;
    gap: 18px;
    margin-bottom: 15px;
}
.form-group {
    flex: 1;
    display: flex;
    flex-direction: column;
}
textarea, input, select {
    width: 100%;
    padding: 12px;
    border-radius: 6px;
    border: 1px solid #ced4da;
    background-color: #f8f9fa;
}
textarea:focus, input:focus, select:focus {
    border: 2px solid #84a98c;
}

/* Localisation champ + bouton */
.localisation-container {
    display: flex;
    gap: 8px;
    align-items: center;
}
.btn-location {
    background: #84a98c;
    color: white;
    border: none;
    padding: 12px 16px;
    border-radius: 6px;
    cursor: pointer;
    display: flex;
    align-items: center;
}

/* Footer modal buttons */
.modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 20px;
}
.btn-cancel {
    background: #6c757d;
    color: white;
    border: none;
    padding: 12px 16px;
    border-radius: 6px;
}
.btn-save {
    background: #84a98c;
    color: white;
    border: none;
    padding: 12px 16px;
    border-radius: 6px;
}
.select-modif {
    padding: 10px;
    border-radius: 6px;
    border: 1px solid #ced4da;
    background-color: #f8f9fa;
}

.btn-edit {
    background-color: #84a98c;
    padding: 12px 18px;
    border-radius: 6px;
    border: none;
    color: white;
    font-weight: 600;
    cursor: pointer;
}
.btn-edit:hover {
    opacity: 0.85;
}

/* reuse colors/layouts - green requested: #84a98c */
:root { --green: #84a98c; --green-light: rgba(132,169,140,0.12); --input-border:#ced4da; }

/* select + button top */
.select-modif { padding:10px 12px; border-radius:6px; border:1px solid var(--input-border); background:#fff; width:380px; }
.btn-edit { background:var(--green); color:#fff; border:none; padding:10px 14px; border-radius:8px; cursor:pointer; font-weight:600; }
.btn-open-modal { background:#2b7a61; color:#fff; border:none; padding:10px 14px; border-radius:8px; cursor:pointer; font-weight:600; }

/* Modal */
.modal {
    position: fixed; inset:0; background: rgba(0,0,0,0.5); display:flex; align-items:center; justify-content:center; z-index:2000;
}
.modal-inner {
    width:820px; max-width:95%; background:#fff; border-radius:12px; padding:22px; position:relative;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
}
.modal-close { position:absolute; right:14px; top:10px; border:none; background:transparent; font-size:18px; cursor:pointer; }

/* form layout (like your add page) */
.auth-box { max-width:900px; margin:0 auto; }
.form-row { display:flex; gap:14px; margin-bottom:14px; }
.form-group { flex:1; display:flex; flex-direction:column; }
.description { flex:2; }

/* inputs */
input[type="text"], input[type="file"], textarea, select {
    padding:10px; border-radius:8px; border:1px solid var(--input-border); background:#fbfdfb; font-size:14px;
}
input:focus, textarea:focus, select:focus {
    outline:none; border-color:var(--green); box-shadow:0 0 0 6px var(--green-light);
}

/* localisation button */
.localisation-container { display:flex; gap:10px; align-items:center; }
.btn-location { background:var(--green); color:#fff; border:none; padding:10px 12px; border-radius:8px; cursor:pointer; }

/* modal footer buttons */
.modal-footer { display:flex; justify-content:flex-end; gap:10px; margin-top:14px; }
.btn-cancel { background:#6c757d; color:white; border:none; padding:10px 12px; border-radius:8px; cursor:pointer; }
.btn-save { background:var(--green); color:white; border:none; padding:10px 12px; border-radius:8px; cursor:pointer; }

/* small responsive tweak */
@media (max-width:820px) {
    .modal-inner { padding:16px; width:95%; }
    .select-modif{ width:100%; }
    .form-row { flex-direction:column; }
}
/* ✅ Overlay flouté pour select */
.overlay-select {
    position: fixed;
    inset: 0;
     background: rgba(0,0,0,0.55);
    
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 3000;
}

/* ✅ Boîte centrée */
.select-box {
    background: #ffffff;
    padding: 25px;
    border-radius: 14px;
    width: 450px;
    text-align: center;
    box-shadow: 0px 8px 25px rgba(0,0,0,0.25);
    animation: fadeIn 0.25s ease-in-out;
}

.select-box h3 {
    margin-bottom: 15px;
    font-size: 20px;
    font-weight: 700;
    color: #2b463c;
}

/* ✅ Nouveau style du Select */
.select-modif {
    width: 100%;
    padding: 12px 14px;
    border-radius: 10px;
    border: 2px solid #84a98c;
    background: #f6fff9;
    font-size: 15px;
    cursor: pointer;
    transition: 0.25s;
}

.select-modif:focus {
    border-color: #52796f;
    outline: none;
}

/* ✅ Bouton "Modifier ce signalement" */
.btn-select-modifier {
    width: 100%;
    background: #84a98c;
    color: white;
    padding: 11px;
    border: none;
    border-radius: 10px;
    margin-top: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: 0.25s;
}

.btn-select-modifier:hover {
    background: #52796f;
}

/* ✅ Bouton fermer */
.btn-cancel-select {
    margin-top: 10px;
    background: #6d6d6d;
    color: white;
    border: none;
    padding: 10px;
    width: 100%;
    border-radius: 8px;
    cursor: pointer;
    transition: 0.25s;
}

.btn-cancel-select:hover {
    background: #4a4a4a;
}

/* ✅ Animation */
@keyframes fadeIn {
    from { opacity: 0; transform: scale(0.95); }
    to { opacity: 1; transform: scale(1); }
}

        
    </style>
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
               <!-- =========================
     Bouton "Modifier" + select
     ========================= -->
<div class="section-header-modern" style="display:flex; justify-content:space-between; align-items:center;">
    <div class="header-title">
        <h2>📍 Tous mes signalements</h2>
    </div>

    <div style="display:flex; gap:10px; align-items:center;">
        <button id="btnShowSelect" class="btn-edit" onclick="toggleSelect()"> Modifier un signalement</button>
    </div>
</div>

<!-- =========================
     Overlay centré Select signalement
     ========================= -->
<div id="overlaySelect" class="overlay-select" style="display:none;">
    <div class="select-box">
        <h3>Sélectionner un signalement</h3>

        <select id="select_signalement" class="select-modif" onchange="onSelectChange()">
            <option value="">Choisir un signalement</option>

            <% if (signalements != null) {
                for (Signalement s : signalements) {
                    String shortDescription = s.getDescription().length() > 40
                            ? s.getDescription().substring(0,40) + "..."
                            : s.getDescription();
            %>
                <option value="<%= s.getIdSignalement() %>"><%= shortDescription %></option>
            <% }} %>
        </select>

        <!-- bouton visible après sélection -->
        <button id="btnOpenModal" class="btn-select-modifier" style="display:none;" onclick="openEditModal()">
            Modifier ce signalement
        </button>

        <button class="btn-cancel-select" onclick="toggleSelect()">Fermer</button>
    </div>
</div>


                <div class="signalements-grid">
                    <%
                        if (signalements != null && !signalements.isEmpty()) {
                            for (Signalement s : signalements) {
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

<div id="modalEdit" class="modal" style="display:none;">
    <div class="modal-inner">
        <button class="modal-close" onclick="closeEditModal()" aria-label="Fermer">✕</button>
        <h2>Modifier le signalement</h2>

        <form id="editForm" action="CitoyenServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="modifierSignalement">
            <input type="hidden" id="modal_id_signalement" name="idSignalement">

            <div class="form-row">
                <div class="form-group description">
                    <label for="modal_description">Description</label>
                    <textarea id="modal_description" name="description" rows="5" required></textarea>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="modal_photo">Photo (nouvelle photo)</label>
                    <input id="modal_photo" type="file" name="photo" accept="image/*">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="modal_localisation">Localisation</label>
                    <div class="localisation-container">
                        <input id="modal_localisation" type="text" name="localisation" required>
                        <button type="button" class="btn-location" onclick="getLocationModal()">Localiser</button>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeEditModal()">Annuler</button>
                <button type="submit" class="btn-save">Enregistrer</button>
            </div>
        </form>
    </div>
</div>


<script>
var signalMap = {};
<% if (signalements != null) {
    for (Signalement s : signalements) {
        String desc = s.getDescription()==null? "": s.getDescription();
        String loc = s.getLocalisation()==null? "": s.getLocalisation();
        desc = desc.replace("\\","\\\\").replace("'", "\\'").replace("\"","\\\"").replace("\r"," ").replace("\n","\\n");
        loc = loc.replace("\\","\\\\").replace("'", "\\'").replace("\"","\\\"").replace("\r"," ").replace("\n","\\n");
%>
signalMap["<%= s.getIdSignalement() %>"] = {
    description: '<%= desc %>',
    localisation: '<%= loc %>'
};
<%  } } %>

function toggleSelect() {
    let overlay = document.getElementById("overlaySelect");
    overlay.style.display = (overlay.style.display === "none" || overlay.style.display === "") ? "flex" : "none";
    document.getElementById("btnOpenModal").style.display = "none";
}

function onSelectChange() {
    selectedSignalementId = document.getElementById("select_signalement").value;
    document.getElementById("btnOpenModal").style.display = selectedSignalementId ? "block" : "none";
}
// open modal and prefill fields from signalMap
function openEditModal(){
	 if (!selectedSignalementId) return;

	    // ✅ on ferme d’abord la liste (overlay)
	    toggleSelect();
    var sel = document.getElementById('select_signalement');
    var id = sel.value;
    if(!id) return alert('Sélectionnez un signalement d\'abord.');
    var data = signalMap[id];
    if(!data) return alert('Données introuvables');

    document.getElementById('modal_id_signalement').value = id;
    document.getElementById('modal_description').value = data.description;
    document.getElementById('modal_localisation').value = data.localisation;

    document.getElementById('modalEdit').style.display = 'flex';
}

function closeEditModal(){
    document.getElementById('modalEdit').style.display = 'none';
}

// localisation depuis modal
function getLocationModal(){
    if(!navigator.geolocation) { alert('Géolocalisation non supportée.'); return; }
    navigator.geolocation.getCurrentPosition(function(pos){
        var lat = pos.coords.latitude, lon = pos.coords.longitude;
        var url = "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=" + lat + "&lon=" + lon;
        fetch(url)
        .then(r => r.json())
        .then(data => {
            document.getElementById('modal_localisation').value = data.display_name || lat + ',' + lon;
        })
        .catch(e => alert('Erreur récupération adresse: ' + e));
    }, function(err){
        alert('Erreur localisation : ' + err.message);
    });
}

// fermer modal en clickant en dehors
window.addEventListener('click', function(e){
    var modal = document.getElementById('modalEdit');
    if(modal.style.display==='flex' && e.target === modal) closeEditModal();
});
function closeModal() {
    document.getElementById("modalEdit").style.display = "none";
}
</script>
</body>
</html>
