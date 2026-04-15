<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="Model.javabeans.Utilisateur"%>
<%@ page import="java.util.List"%>
<%@ page import="Model.javabeans.Ville"%>

<%
Utilisateur admin = (Utilisateur) request.getAttribute("admin");
List<Ville> villes = (List<Ville>) request.getAttribute("villes");

// Nom de la ville
String nomVille = "";
if (villes != null) {
    for (Ville v : villes) {
        if (v.getIdVille() == admin.getVille_Id()) {
            nomVille = v.getNomVille();
            break;
        }
    }
}
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Mon profil - Admin</title>
<link rel="stylesheet" href="css/admin.css">
<style>
:root { --vert:#84a98c; --vertClair:#dce8e1; }

.page-center {
    display:flex;
    justify-content:center;
    align-items:flex-start;
    padding:60px 10px 5px 30px;
    min-height:calc(90vh - 200px);
}
.profile-box {
    width:900px;
    max-width:95%;
    background:white;
    border-radius:14px;
    box-shadow:0 6px 25px rgba(0,0,0,0.08);
    padding:32px;
}
.profile-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:28px; }
.profile-header h2 { margin:0; font-size:24px; color:#222; }
.profile-grid { display:grid; grid-template-columns:1fr 1fr; gap:22px; }
.info-card { background:#f8faf9; border:1px solid var(--vertClair); padding:18px; border-radius:10px; }
.info-label { color:#666; font-size:13px; }
.info-value { font-size:16px; font-weight:600; padding-top:4px; }
.btn-action { padding:10px 18px; border-radius:8px; border:none; cursor:pointer; color:white; background:var(--vert); font-size:15px; font-weight:600; transition:opacity .2s; }
.btn-action:hover { opacity:0.85; }

.modal { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.45); justify-content:center; align-items:center; }
.modal-inner { width:500px; background:white; border-radius:12px; padding:28px; }
.modal-close { float:right; cursor:pointer; font-size:20px; }
.form-row { display:flex; gap:14px; margin-bottom:14px; }
.form-group{ flex:1; display:flex; flex-direction:column; }
.form-group.large { flex:2; }
input, select{ padding:11px; border-radius:6px; border:2px solid var(--vertClair); }
input:focus, select:focus{ outline:none; border-color:var(--vert)!important; box-shadow:0 0 0 3px rgba(132,169,140,0.25); }
.modal-footer{ display:flex; justify-content:flex-end; gap:10px; margin-top:20px; }
select { width:100%; box-sizing:border-box; }
.profile-grid .wide { grid-column: span 2; }
</style>
</head>
<body>
<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
       <a href="AdminServlet">Accueil</a>
       <a href="AdminServlet?action=gererUtilisateurs">Gérer utilisateurs</a>
       <a href="AdminServlet?action=profil">Mon profil</a>
       <a href="inscription?action=logout">Déconnexion</a>
    </nav>
</header>

<section class="page-center">
    <div class="profile-box">

        <div class="profile-header">
            <h2>Mon profil</h2>
            <button id="openEdit" class="btn-action">Modifier mon profil</button>
        </div>

        <div class="profile-grid">
            <div class="info-card"><span class="info-label">Nom</span><div class="info-value"><%= admin.getNom() %></div></div>
            <div class="info-card"><span class="info-label">Prénom</span><div class="info-value"><%= admin.getPrenom() %></div></div>
            <div class="info-card"><span class="info-label">Email</span><div class="info-value"><%= admin.getEmail() %></div></div>
            <div class="info-card"><span class="info-label">Téléphone</span><div class="info-value"><%= admin.getTelephone() %></div></div>
            <div class="info-card wide"><span class="info-label">Ville</span><div class="info-value"><%= nomVille %></div></div>
        </div>
    </div>
</section>

<!-- Modal -->
<div id="modalProfil" class="modal">
    <div class="modal-inner">
        <span class="modal-close" onclick="closeModal()">&times;</span>
        <h3>Modifier mon profil</h3>
        <form action="AdminServlet" method="post">
            <input type="hidden" name="action" value="modifierProfil">

            <div class="form-row">
                <div class="form-group">
                    <label>Nom :</label>
                    <input type="text" name="nom" value="<%= admin.getNom() %>" required>
                </div>
                <div class="form-group">
                    <label>Prénom :</label>
                    <input type="text" name="prenom" value="<%= admin.getPrenom() %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Email :</label>
                    <input type="email" name="email" value="<%= admin.getEmail() %>" required>
                </div>
                <div class="form-group">
                    <label>Téléphone :</label>
                    <input type="text" name="telephone" value="<%= admin.getTelephone() %>">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group large">
                    <label>Ville :</label>
                    <select name="ville_id" required>
                        <option value="">-- Sélectionnez une ville --</option>
                        <% for(Ville v : villes) { %>
                            <option value="<%= v.getIdVille() %>" <%= (v.getIdVille() == admin.getVille_Id() ? "selected" : "") %>><%= v.getNomVille() %></option>
                        <% } %>
                    </select>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" onclick="closeModal()" class="btn-action" style="background:#777;">Annuler</button>
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
const modal = document.getElementById("modalProfil");
document.getElementById("openEdit").onclick = () => modal.style.display = "flex";
function closeModal(){ modal.style.display="none"; }
window.onclick = e => { if(e.target===modal) modal.style.display="none"; };
</script>

</body>
</html>
