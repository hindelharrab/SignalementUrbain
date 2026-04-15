<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.javabeans.*, java.util.*" %>

<%
    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
    List<Ville> villes = (List<Ville>) request.getAttribute("villes");

    if (utilisateur == null) {
        response.sendRedirect("connexion.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon espace - CityReport</title>

    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/auth.css">

    <style>
        :root {
            --vert: #84a98c;
            --vertClair: #dce8e1;
        }

        .page-center {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 60px 10px 5px 30px; /* 🟢 un peu plus bas */
            min-height: calc(90vh - 200px);
        }

        .profile-box {
            width: 1000px;
            max-width: 95%;
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 6px 25px rgba(0,0,0,0.08);
            padding: 32px;
        }

        .profile-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
        }

        .profile-title h1 {
            margin: 0;
            font-size: 26px;
            color: #222;
        }

        .profile-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
        }

        .info-card {
            background: #f8faf9;
            border: 1px solid var(--vertClair);
            padding: 18px;
            border-radius: 10px;
        }

        .info-label { color:#666; font-size: 13px; }
        .info-value { font-size: 16px; font-weight: 600; padding-top: 4px; }

        .btn-action {
            padding: 10px 18px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            color: white;
            background: var(--vert);
            font-size: 15px;
            font-weight: 600;
            transition: opacity .2s;
        }
        .btn-action:hover { opacity: 0.85; }

        .modal {
            display:none; position:fixed; inset:0;
            background: rgba(0,0,0,0.45);
            justify-content:center; align-items:center;
        }
        .modal-inner {
            width: 700px; /* un peu plus large pour Ville */
            background: white;
            border-radius: 12px;
            padding: 28px;
        }
        .modal-close { float:right; cursor:pointer; font-size:20px; }

        .form-row { display:flex; gap:14px; margin-bottom:14px; }
        .form-group{ flex:1; display:flex; flex-direction:column; }
        .form-group.large { flex:2; } /* champ Ville plus large */

        input, select{
            padding: 11px;
            border-radius: 6px;
            border:2px solid var(--vertClair);
        }
        input:focus, select:focus{
            outline:none;
            border-color:var(--vert)!important;
            box-shadow: 0 0 0 3px rgba(132,169,140,0.25);
        }

        .modal-footer{ display:flex; justify-content:flex-end; gap:10px; margin-top:20px; }

        /* Select plein largeur */
        select { width: 100%; box-sizing:border-box; }
        /* Pour faire occuper 2 colonnes à un élément dans le grid */
.profile-grid .wide {
    grid-column: span 2;
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


<section class="page-center">
    <div class="profile-box">

        <div class="profile-header">
            <div>
                <div class="profile-title"><h1>Mon espace personnel</h1></div>
            </div>

            <div style="display:flex; gap:10px;">
                <form action="CitoyenServlet" method="get">
                    <input type="hidden" name="action" value="listeActualites">
                    <button class="btn-action">Voir les actualités</button>
                </form>

                <button id="openEdit" class="btn-action">Modifier mes informations</button>
            </div>
        </div>

        <div class="profile-grid">
            <div class="info-card">
                <span class="info-label">Nom</span>
                <div class="info-value"><%= utilisateur.getNom() %></div>
            </div>

            <div class="info-card">
                <span class="info-label">Prénom</span>
                <div class="info-value"><%= utilisateur.getPrenom() %></div>
            </div>

            <div class="info-card">
                <span class="info-label">Email</span>
                <div class="info-value"><%= utilisateur.getEmail() %></div>
            </div>

            <div class="info-card">
                <span class="info-label">Téléphone</span>
                <div class="info-value">
                    <%= (utilisateur.getTelephone() == null || utilisateur.getTelephone().isEmpty()) ? "—" : utilisateur.getTelephone() %>
                </div>
            </div>

            <div class="info-card wide">
                <span class="info-label">Ville</span>
                <div class="info-value">
                    <%
                        if (villes != null) {
                            for (Ville v : villes) {
                                if (v.getIdVille() == utilisateur.getVille_Id()) { out.print(v.getNomVille()); break; }
                            }
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- MODAL EDIT -->
<div id="modalEdit" class="modal">
    <div class="modal-inner">
        <span id="closeModal" class="modal-close">&times;</span>

        <h3>Modifier mes informations</h3>

        <form action="CitoyenServlet" method="post">
            <input type="hidden" name="action" value="modifierProfil">

            <div class="form-row">
                <div class="form-group">
                    <label>Nom</label>
                    <input name="nom" type="text" value="<%= utilisateur.getNom() %>" required>
                </div>
                <div class="form-group">
                    <label>Prénom</label>
                    <input name="prenom" type="text" value="<%= utilisateur.getPrenom() %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Email</label>
                    <input name="email" type="email" value="<%= utilisateur.getEmail() %>" required>
                </div>
                <div class="form-group">
                    <label>Téléphone</label>
                    <input name="telephone" type="text" value="<%= utilisateur.getTelephone() %>">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group large">
                    <label>Ville</label>
                    <select name="idVilleFK" required>
                        <option value="">-- Sélectionnez une ville --</option>
                        <%
                            if (villes != null) {
                                for (Ville v : villes) {
                        %>
                            <option value="<%= v.getIdVille() %>"
                                <%= (utilisateur.getVille_Id() == v.getIdVille()) ? "selected" : "" %>>
                                <%= v.getNomVille() %>
                            </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" id="cancelBtn" class="btn-action" style="background:#777;">Annuler</button>
                <button type="submit" class="btn-action">Enregistrer</button>
            </div>
        </form>
    </div>
</div>


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


<script>
    const modal = document.getElementById("modalEdit");
    document.getElementById("openEdit").onclick = () => modal.style.display = "flex";
    document.getElementById("closeModal").onclick = () => modal.style.display = "none";
    document.getElementById("cancelBtn").onclick = () => modal.style.display = "none";
    window.onclick = e => { if (e.target === modal) modal.style.display = "none"; };
</script>

</body>
</html>
