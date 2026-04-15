<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.javabeans.*, java.util.*" %>
<%
    List<Ville> villes = (List<Ville>) request.getAttribute("villes");
    Utilisateur agent = (Utilisateur) session.getAttribute("utilisateur");
    if (agent == null) {
        response.sendRedirect("connexion.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<title>Espace Agent - CityReport</title>
<link rel="stylesheet" href="css/style.css">

<style>
/* ===== Structure générale ===== */
.page-center {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    padding: 60px 10px 5px 10px;
}

.profile-box {
    width: 100%;
    max-width: 900px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 6px 25px rgba(0,0,0,0.08);
    padding: 32px;
}

.profile-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
}

.profile-header h1 {
    color: #264653;
    font-size: 24px;
    margin: 0;
}

.profile-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
    gap: 20px;
}

.info-card {
    background: #f8faf9;
    border-radius: 10px;
    padding: 16px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.info-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.btn-action {
    background-color: #84a98c;
    color: white;
    font-weight: 600;
    border: none;
    padding: 10px 18px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 14px;
    transition: background 0.2s ease, transform 0.2s ease;
}
.btn-action:hover {
    background-color: #6b8f79;
    transform: translateY(-1px);
}

/* ===== Modal ===== */
.modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.45);
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
    box-shadow: 0 10px 25px rgba(0,0,0,0.2);
}

.modal-inner h3 {
    font-size: 1.5rem;
    font-weight: 700;
    color: #264653;
    margin-bottom: 1.5rem;
}

.modal-inner label {
    font-weight: 600;
    margin-bottom: 0.5rem;
    display: block;
    color: #264653;
}

.modal-inner input,
.modal-inner select {
    padding: 0.75rem;
    width: 100%;
    border-radius: 8px;
    border: 1px solid #ccc;
    font-size: 1rem;
    margin-bottom: 1rem;
    background: #fff;
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 0.75rem;
    margin-top: 1rem;
}

.modal-close {
    position: absolute;
    top: 1rem;
    right: 1rem;
    font-size: 1.5rem;
    cursor: pointer;
    color: #888;
}
.modal-close:hover { color: #333; }
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

<section class="page-center">
    <div class="profile-box">
        <div class="profile-header">
            <h1>Mon espace agent</h1>
            <button id="openEdit" class="btn-action">Modifier mes informations</button>
        </div>

        <div class="profile-grid">
            <div class="info-card"><strong>Nom :</strong> <%= agent.getNom() %></div>
            <div class="info-card"><strong>Prénom :</strong> <%= agent.getPrenom() %></div>
            <div class="info-card"><strong>Email :</strong> <%= agent.getEmail() %></div>
            <div class="info-card">
                <strong>Ville :</strong>
                <%
                    if(villes != null) {
                        for(Ville v : villes){
                            if(v.getIdVille() == agent.getVille_Id()){ out.print(v.getNomVille()); break; }
                        }
                    }
                %>
            </div>
        </div>
    </div>
</section>

<!-- MODAL EDIT -->
<div id="modalEdit" class="modal">
    <div class="modal-inner">
        <span id="closeModal" class="modal-close">&times;</span>
        <h3>Modifier mes informations</h3>
        <form action="AgentServlet" method="post">
            <input type="hidden" name="action" value="modifierProfil">
            <label>Nom</label>
            <input type="text" name="nom" value="<%= agent.getNom() %>" required>
            <label>Prénom</label>
            <input type="text" name="prenom" value="<%= agent.getPrenom() %>" required>
            <label>Email</label>
            <input type="email" name="email" value="<%= agent.getEmail() %>" required>
            <label>Ville</label>
            <select name="idVilleFK" required>
                <option value="">-- Sélectionnez une ville --</option>
                <% if(villes != null){ for(Ville v : villes){ %>
                    <option value="<%= v.getIdVille() %>" <%= (v.getIdVille()==agent.getVille_Id())?"selected":"" %>><%= v.getNomVille() %></option>
                <% } } %>
            </select>
            <div class="modal-footer">
                <button type="button" class="btn-action" style="background:#aaa;" onclick="document.getElementById('modalEdit').style.display='none';">Annuler</button>
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
const modal = document.getElementById("modalEdit");
document.getElementById("openEdit").onclick = () => modal.style.display = "flex";
document.getElementById("closeModal").onclick = () => modal.style.display = "none";
window.onclick = e => { if(e.target === modal) modal.style.display = "none"; };
</script>

</body>
</html>
