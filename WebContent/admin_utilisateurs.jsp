<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, Model.javabeans.*" %>

<%
List<Utilisateur> utilisateurs = (List<Utilisateur>) request.getAttribute("utilisateurs");
List<Ville> villes = (List<Ville>) request.getAttribute("villes");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Gestion des utilisateurs - CityReport</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/citoyen.css">
<style>
:root {
  --primary-color: #64748b;
  --primary-dark: #475569;
  --primary-light: #e2e8f0;
  --secondary-color: #84a98c;
  --secondary-dark: #6b8e73;
  --text-dark: #334155;
  --text-medium: #64748b;
  --bg-light: #f8fafc;
  --bg-white: #ffffff;
  --border-color: #e2e8f0;
  --error-color: #ef4444;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}





/* Page Header */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1400px;
  margin: 2.5rem auto 2rem;
  padding: 0 1.5rem;
}

.page-header h2 {
  font-size: 1.8rem;
  font-weight: 800;
  color: var(--text-dark);
  margin: 0;
}

.page-header .btn-action {
  padding: 0.65rem 1.4rem;
  background: linear-gradient(135deg, var(--secondary-color) 0%, var(--secondary-dark) 100%);
  color: white;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-weight: 600;
  font-size: 0.9rem;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(132, 169, 140, 0.3);
}

.page-header .btn-action:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(132, 169, 140, 0.4);
}

/* Messages */
.message-container {
  max-width: 1400px;
  margin: 0 auto 1.5rem;
  padding: 0 1.5rem;
}

.success {
  background: #dcfce7;
  border: 2px solid #22c55e;
  color: #166534;
  padding: 1rem;
  border-radius: 10px;
  font-weight: 600;
}

.error {
  background: #fee2e2;
  border: 2px solid #ef4444;
  color: #991b1b;
  padding: 1rem;
  border-radius: 10px;
  font-weight: 600;
}

/* Users Grid */
.users-container {
  max-width: 1400px;
  margin: 0 auto 2rem;
  padding: 0 1.5rem;
}

.users-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
}

.user-card {
  background: var(--bg-white);
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  border: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  transition: all 0.3s ease;
}

.user-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
  border-color: var(--secondary-color);
}

.user-info {
  display: flex;
  flex-direction: column;
  gap: 0.8rem;
  margin-bottom: 1rem;
}

.user-info span {
  display: flex;
  justify-content: space-between;
  font-size: 0.95rem;
  color: var(--text-medium);
}

.user-info strong {
  color: var(--text-dark);
  font-weight: 600;
}

.user-actions {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid var(--border-color);
  display: flex;
  gap: 0.8rem;
}

.user-actions form {
  margin: 0;
  flex: 1;
}

.user-actions button {
  width: 100%;
  background: linear-gradient(135deg, var(--error-color) 0%, #dc2626 100%);
  color: white;
  border: none;
  padding: 0.65rem 1rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  font-size: 0.9rem;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
}

.user-actions button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(239, 68, 68, 0.4);
}

.empty-state {
  text-align: center;
  padding: 3rem 1rem;
  color: var(--text-medium);
}

.empty-state p {
  font-size: 1.1rem;
  margin: 0;
}

/* Modal */
.modal-overlay {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 1000;
  align-items: center;
  justify-content: center;
  animation: fadeIn 0.3s ease;
}

.modal-overlay.active {
  display: flex;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal-content {
  background: var(--bg-white);
  border-radius: 16px;
  padding: 1.5rem;
  width: 95%;
  max-width: 450px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  animation: slideUp 0.3s ease;
  max-height: auto;
  overflow-y: auto;
}

@keyframes slideUp {
  from {
    transform: translateY(30px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.4rem;
}

.modal-header h3 {
  font-size: 1.2rem;
  font-weight: 800;
  color: var(--text-dark);
  margin: 0;
}

.modal-close {
  width: 35px;
  height: 35px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--primary-light);
  border: none;
  border-radius: 50%;
  cursor: pointer;
  color: var(--text-medium);
  font-size: 1.5rem;
  transition: all 0.3s ease;
}

.modal-close:hover {
  background: var(--primary-color);
  color: white;
  transform: rotate(90deg);
}

.form-group {
  display: flex;
  flex-direction: column;
  margin-bottom: 0.8rem;
}

.form-group label {
  font-weight: 600;
  color: var(--text-dark);
  margin-bottom: 0.3rem;
  font-size: 0.95rem;
}

.form-group input,
.form-group select {
  padding: 0.5rem;
  border-radius: 10px;
  border: 2px solid var(--border-color);
  font-family: inherit;
  font-size: 0.80rem;
  color: var(--text-dark);
  transition: all 0.3s ease;
}

.form-group input:focus,
.form-group select:focus {
  outline: none;
  border-color: var(--secondary-color);
  box-shadow: 0 0 0 3px rgba(132, 169, 140, 0.15);
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 0.8rem;
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid var(--border-color);
}

.modal-footer button {
  padding: 0.7rem 1.4rem;
  border-radius: 10px;
  border: none;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 0.9rem;
}

.modal-footer .btn-submit {
  background: linear-gradient(135deg, var(--secondary-color) 0%, var(--secondary-dark) 100%);
  color: white;
  box-shadow: 0 2px 8px rgba(132, 169, 140, 0.3);
}

.modal-footer .btn-submit:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(132, 169, 140, 0.4);
}

.modal-footer .btn-cancel {
  background: var(--primary-light);
  color: var(--text-dark);
}

.modal-footer .btn-cancel:hover {
  background: var(--primary-color);
  color: white;
}

/* Responsive */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    gap: 1rem;
    align-items: flex-start;
  }

  .users-grid {
    grid-template-columns: 1fr;
  }

  .navbar {
    flex-direction: column;
    gap: 1rem;
  }

  .navbar nav {
    flex-wrap: wrap;
    gap: 1rem;
    width: 100%;
  }

  .modal-content {
    padding: 1.5rem;
  }
}
.page-container {
  max-width: 1300px;
  margin: 2rem auto;      /* centré avec espace en haut et bas */
  padding: 0.1rem;          /* espace intérieur */
  background: var(--bg-white); /* fond blanc */
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.08);
}

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

<div class="page-container">
  
  <div class="page-header">
    <h2>👥 Gestion des utilisateurs</h2>
    <button class="btn-action" onclick="openModal()">Ajouter un admin</button>
  </div>

  <div class="message-container">
    <% if(request.getAttribute("message") != null) { %>
      <p class="success"><%= request.getAttribute("message") %></p>
    <% } %>
    <% if(request.getAttribute("error") != null) { %>
      <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
  </div>

  <div class="users-container">
    <div class="users-grid">
      <% if(utilisateurs != null && !utilisateurs.isEmpty()) {
          for(Utilisateur u : utilisateurs) { %>
            <div class="user-card">
                <div class="user-info">
                    <span><strong>Nom:</strong> <%= u.getNom() %></span>
                    <span><strong>Prénom:</strong> <%= u.getPrenom() %></span>
                    <span><strong>Email:</strong> <%= u.getEmail() %></span>
                    <span><strong>Téléphone:</strong> <%= u.getTelephone() %></span>
                    <span><strong>Ville:</strong> <%= u.getNomVille() %></span>
                    <span><strong>Rôle:</strong> <%= u.getRole() %></span>
                </div>
                <div class="user-actions">
                    <form action="AdminServlet" method="post">
                        <input type="hidden" name="action" value="supprimerUtilisateur">
                        <input type="hidden" name="idUtilisateur" value="<%= u.getIdUtilisateur() %>">
                        <button type="submit" onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')">
                          Supprimer
                        </button>
                    </form>
                </div>
            </div>
      <%  }
      } else { %>
        <div class="empty-state" style="grid-column: 1 / -1;">
          <p>Aucun utilisateur trouvé.</p>
        </div>
      <% } %>
    </div>
  </div>

</div>


<!-- Modal Ajout Admin -->
<div id="modalAjout" class="modal-overlay">
  <div class="modal-content">
    <div class="modal-header">
      <h3>Ajouter un nouvel admin</h3>
      <button class="modal-close" onclick="closeModal()">&times;</button>
    </div>

    <form action="AdminServlet" method="post">
      <input type="hidden" name="action" value="ajouterAdmin">

      <div class="form-group">
        <label>Nom</label>
        <input type="text" name="nom" required>
      </div>

      <div class="form-group">
        <label>Prénom</label>
        <input type="text" name="prenom" required>
      </div>

      <div class="form-group">
        <label>Email</label>
        <input type="email" name="email" required>
      </div>

      <div class="form-group">
        <label>Téléphone</label>
        <input type="text" name="telephone" required>
      </div>

      <div class="form-group">
        <label>Mot de passe</label>
        <input type="password" name="motDePasse" required>
      </div>

      <div class="form-group">
        <label>Ville</label>
        <select name="ville_id" required>
          <option value="">-- Sélectionner une ville --</option>
          <% if(villes != null){
              for(Ville v : villes){ %>
                <option value="<%= v.getIdVille() %>"><%= v.getNomVille() %></option>
          <%  }
             } %>
        </select>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn-cancel" onclick="closeModal()">Annuler</button>
        <button type="submit" class="btn-submit">Ajouter admin</button>
      </div>
    </form>
  </div>
</div>

<!-- Footer -->
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
                    <li>contact@cityreport.fr</li>
                    <li>01 23 45 67 89</li>
                    <li>123 Avenue de la République</li>
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
function openModal() {
  document.getElementById("modalAjout").classList.add("active");
}

function closeModal() {
  document.getElementById("modalAjout").classList.remove("active");
}

window.onclick = function(event) {
  const modal = document.getElementById("modalAjout");
  if (event.target === modal) {
    closeModal();
  }
}
</script>

</body>
</html>
