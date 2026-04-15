<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.javabeans.*, java.util.*" %>
<%@ page import="com.google.gson.Gson" %>

<%
Gson gson = new Gson();
%>

<%
    Utilisateur agent = (Utilisateur) session.getAttribute("utilisateur");
    List<Ville> villes = (List<Ville>) request.getAttribute("villes");
    List<Signalement> signalements = (List<Signalement>) request.getAttribute("signalements");
    List<Actualite> actualites = (List<Actualite>) request.getAttribute("actualites");
    List<Utilisateur> techniciens = (List<Utilisateur>) request.getAttribute("techniciens");
    if (agent == null) {
        response.sendRedirect("connexion.jsp");
        return;
    }
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    List<Notification> latestNotifs = new ArrayList<>();
    if (notifications != null) {
        for (int i = 0; i < notifications.size(); i++) {
            latestNotifs.add(notifications.get(i));
        }
    }
%>


<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<title>Dashboard Agent - CityReport</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/agent.css">
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
        
        <!-- ========== Notifications ========== -->
        <div class="notif-wrapper" id="notifWrapper" style="margin-left:12px;">
            <button id="notifButton" aria-haspopup="true" aria-expanded="false" title="Notifications">
                <!-- cloche SVG -->
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                     viewBox="0 0 16 16" aria-hidden="true">
                  <path d="M8 16a2 2 0 0 0 1.985-1.75H6.015A2 2 0 0 0 8 16zm.104-14a2 2 0 0 0-1.208 0A1 1 0 0 0 6 2v.104a5.002 5.002 0 0 0-3 4.9v1.598l-.867 1.734A.5.5 0 0 0 2.5 11h11a.5.5 0 0 0 .433-.764L12 8.602V7.004a5.002 5.002 0 0 0-3-4.9V2a1 1 0 0 0-.896-.996z"/>
                </svg>

                <span id="notifCount">0</span>
            </button>

            <!-- modal (contenu rempli par JS) -->
            <div id="notifModal" role="dialog" aria-label="Notifications">
                <div class="notif-header">Notifications</div>
                <div id="notifContent" aria-live="polite" aria-atomic="true"></div>
               
            </div>
        </div>
        <!-- ========== /Notifications ========== -->
        
    </nav>
</header>

<%
String modeActu = (String) session.getAttribute("modeActualites");
if (modeActu == null) modeActu = "resume";
%>
<section class="page-center">
    <div class="dashboard-box">

        <!-- Colonne Actualités -->
        <div class="actualites-box">
            <div class="section-header">
                <h2>Actualités</h2>
                <div style="display: flex; gap: 0.75rem;">
                    <button class="btn-action" onclick="window.location.href='AgentServlet?action=voirToutesActualites'">
                        Voir toutes
                    </button>
                    <button class="btn-action" onclick="openModal('ajoutActualite')">Ajouter</button>
                </div>
            </div>
            <%
                if(actualites != null){
                    int countActu = 0;
                    for(Actualite act : actualites){
                        if("resume".equals(modeActu) && countActu >= 1) break;
            %>
                <div class="actualite-item">
                    <div class="actualite-title"><%= act.getTitre() %></div>
                    <div><%= act.getDescription() %></div>
                    <% if(act.getImage()!=null){ %>
                        <img class="actualite-img" src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(act.getImage()) %>" alt="Image actualité" />
                    <% } %>
                    <div class="actualite-actions">
                        <button class="btn-action"
                            data-id="<%= act.getIdActualite() %>"
                            data-titre="<%= act.getTitre().replace("\"", "&quot;").replace("'", "&#39;") %>"
                            data-contenu="<%= act.getDescription().replace("\"", "&quot;").replace("'", "&#39;") %>"
                            onclick="openModalModifier(this)">
                            Modifier
                        </button>
                        <button class="btn-action" onclick="supprimerActualite(<%= act.getIdActualite() %>)">
                            Supprimer
                        </button>
                    </div>
                </div>
            <%
                countActu++;
                    }
                }
            %>
        </div>

        <!-- Colonne Signalements -->
        <div class="signalements-box">
            <div class="section-header">
                <h2>Signalements citoyens</h2>
                <button class="btn-action" onclick="voirTousSignalements()">Voir tous</button>
            </div>
            <%
                if(signalements != null){
                    int countSig = 0;
                    for(Signalement sig : signalements){
                        if(countSig >= 1) break;
            %>
                <div class="signalement-item">
                    <% if(sig.getPhoto() != null){ %>
                        <img class="signalement-img"
                             src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(sig.getPhoto()) %>"
                             alt="Photo signalement" />
                    <% } %>
                    <div class="signalement-title"><%= sig.getDescription() %></div>
                    <div>Statut: <%= sig.getNomStatut() %></div>
                    <div>Date : <%= sig.getDateSignalement() %></div>
                    <div class="signalement-actions">
                        <button class="btn-action" onclick="ouvrirDetailsSignalement(<%= sig.getIdSignalement() %>)">
                            Affecter
                        </button>
                    </div>
                </div>
            <%
                countSig++;
                    }
                }
            %>
        </div>

    </div>
</section>

<!-- Modal Générique -->
<div id="modalGeneric" class="modal">
    <div class="modal-inner" id="modalContent">
        <span class="modal-close" onclick="closeModal()">&times;</span>
        <div id="modalBody"></div>
    </div>
</div>

<!-- Modal Affectation -->
<div id="modalGenericNum" class="modal">
    <div class="modal-inner">
        <span class="modal-close" onclick="closeModalclose()">&times;</span>
        <h3>Affecter techniciens</h3>
        <form id="affecterForm" action="AgentServlet" method="post">
            <input type="hidden" name="action" value="affecterSignalement">
            <input type="hidden" name="idSignalement" id="idSignalementInput">

            <% if(techniciens != null) {
                for(Utilisateur t : techniciens){
                    String spec = t.getNomSpec() != null ? t.getNomSpec() : "Sans spécialité";
            %>
                <label>
                    <input type="checkbox" name="techniciens" value="<%= t.getIdUtilisateur() %>">
                    <%= t.getNom() %> <%= t.getPrenom() %> - <%= spec %>
                </label>
            <%
                }
            } %>

            <div class="modal-footer">
                <button type="button" class="btn-action" onclick="closeModalclose()">Annuler</button>
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
function openModal(type, id=null){
    let body = document.getElementById("modalBody");
    if(type==='ajoutActualite'){
        body.innerHTML = `
            <h3>Ajouter une actualité</h3>
            <form action="AgentServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="ajouterActualite">
                <div class="form-row"><div class="form-group"><label>Titre</label><input name="titre" required></div></div>
                <div class="form-row"><div class="form-group"><label>Contenu</label><textarea name="contenu" rows="4" required></textarea></div></div>
                <div class="form-row"><div class="form-group"><label>Image</label><input type="file" name="image"></div></div>
                <div class="modal-footer">
                    <button type="button" class="btn-action" onclick="closeModal()">Annuler</button>
                    <button type="submit" class="btn-action">Enregistrer</button>
                </div>
            </form>
        `;
    }
    document.getElementById("modalGeneric").style.display='flex';
}

function closeModal(){ document.getElementById("modalGeneric").style.display='none'; }

function voirTousSignalements(){
    window.location.href = "AgentServlet?action=voirTousSignalements";
}

function ouvrirDetailsSignalement(id){
    document.getElementById('idSignalementInput').value = id;
    document.getElementById('modalGenericNum').style.display = 'flex';
}

function closeModalclose(){
    document.getElementById('modalGenericNum').style.display = 'none';
}

function supprimerActualite(id){
    if(confirm("Supprimer cette actualité ?")){
        window.location.href = "AgentServlet?action=supprimerActualite&id=" + id;
    }
}

function openModalModifier(btn) {
    const id = btn.getAttribute("data-id");
    const titre = btn.getAttribute("data-titre");
    const contenu = btn.getAttribute("data-contenu");

    const modalBody = document.getElementById("modalBody");
    modalBody.innerHTML = `
        <h3>Modifier l'actualité</h3>
        <form action="AgentServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="modifierActualite">
            <input type="hidden" name="id" id="idActu">

            <div class="form-row"><div class="form-group">
                <label>Titre</label>
                <input type="text" name="titre" id="inputTitre" required>
            </div></div>

            <div class="form-row"><div class="form-group">
                <label>Contenu</label>
                <textarea name="contenu" id="textareaContenu" rows="4" required></textarea>
            </div></div>

            <div class="form-row"><div class="form-group">
                <label>Image</label>
                <input type="file" name="image">
            </div></div>

            <div class="modal-footer">
                <button type="button" class="btn-action" onclick="closeModal()">Annuler</button>
                <button type="submit" class="btn-action">Enregistrer</button>
            </div>
        </form>
    `;

    document.getElementById("idActu").value = id;
    document.getElementById("inputTitre").value = titre;
    document.getElementById("textareaContenu").value = contenu;

    document.getElementById("modalGeneric").style.display = "flex";
}
window.addEventListener('pageshow', function(event) {
    // BFCache ou navigation "back/forward"
    if (event.persisted || (window.performance && window.performance.getEntriesByType("navigation")[0].type === "back_forward")) {
        window.location.reload();
    }
});


</script>
<!-- ====== script notifications (place en bas de la page) ====== -->
<script type="text/javascript">
/* données JSON from server (une seule déclaration) */
const notifData = <%= gson.toJson(latestNotifs) %> || [];

(function(){
    const wrapper = document.getElementById('notifWrapper');
    const btn = document.getElementById('notifButton');
    const modal = document.getElementById('notifModal');
    const content = document.getElementById('notifContent');
    const countEl = document.getElementById('notifCount');

    // affiche compteur
    countEl.innerText = notifData.length > 99 ? '99+' : String(notifData.length);

    // remplit contenu
    function renderNotifs(){
        content.innerHTML = '';
        if(!notifData || notifData.length === 0){
            const empty = document.createElement('div');
            empty.className = 'notif-item';
            empty.innerHTML = '<div class="msg">Aucune notification.</div>';
            content.appendChild(empty);
            return;
        }
        notifData.forEach(function(n){
            const div = document.createElement('div');
            div.className = 'notif-item';
            // utilise n.message (champ complet) si présent, sinon construit une phrase
            const message = (n.message && String(n.message).trim().length>0) ? n.message
                          : ((n.technicienNom ? (n.technicienNom + ' ' + (n.technicienPrenom||'')) : 'Quelqu\'un') 
                             + ' a effectué une action.');
            const dateTxt = n.dateNotification ? n.dateNotification : '';
            div.innerHTML = '<span class="msg">' + escapeHtml(message) + '</span>'
                          + (dateTxt ? ('<div class="date">' + escapeHtml(dateTxt) + '</div>') : '');
            content.appendChild(div);
        });
    }

    // simple escape pour éviter injection
    function escapeHtml(s){
        if(!s) return '';
        return String(s)
            .replace(/&/g,'&amp;')
            .replace(/</g,'&lt;')
            .replace(/>/g,'&gt;')
            .replace(/"/g,'&quot;')
            .replace(/'/g,'&#39;');
    }

    // positionnement : on utilise wrapper {position:relative} + modal {position:absolute; top:100%}
    // toggle
    function openModal(){
        modal.style.display = 'block';
        btn.setAttribute('aria-expanded','true');
    }
    function closeModal(){
        modal.style.display = 'none';
        btn.setAttribute('aria-expanded','false');
    }

    btn.addEventListener('click', function(e){
        e.stopPropagation(); // empêcher propagation pour le document click
        if(modal.style.display === 'block') closeModal(); else openModal();
    });

    // ferme quand on clique ailleurs
    document.addEventListener('click', function(e){
        if(!wrapper.contains(e.target)){
            closeModal();
        }
    });

    // rend initial
    renderNotifs();

    // OPTIONAL: si tu veux recharger les notifs périodiquement via AJAX, on peut ajouter code ici.
})();
</script>
</body>
</html>
