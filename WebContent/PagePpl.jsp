<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CityReport - Accueil</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    
</head>
<body>

<!-- 🧭 Barre de navigation -->
<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
        <a href="accueil.jsp">Accueil</a>
       
        <a href="carte.jsp">Carte</a>
        <a href="a_propos.jsp">À propos</a>
        <a href="connexion.jsp" class="btn-nav">Connexion</a>
    </nav>
</header>

<!-- 🎯 Bandeau principal -->
<section class="hero">
  <div class="hero-content">
    <div class="hero-text">
      <h2>Ensemble pour une ville meilleure</h2>
      <h1>Signalez les problèmes urbains en un clic</h1>
      <p>Aidez votre ville à résoudre rapidement les problèmes d'infrastructure.<br>
         Signalez, suivez et participez à l'amélioration de votre quartier.</p>
      <div class="hero-buttons">
        <a href="CitoyenServlet?action=ajouterSignalement" class="btn-primary">Créer un signalement</a>
        <a href="carte.jsp" class="btn-secondary">Voir la carte</a>
      </div>
    </div>

    <div class="hero-card-container">
      <div class="hero-card solved">
        
        <div class="text">
          <h4>Problème résolu</h4>
          <p>Déchets ramassés – Rue de la Paix</p>
          <span class="status solved">Résolu en 2 jours</span>
        </div>
      </div>
      <div class="hero-card in-progress">
        
        <div class="text">
          <h4>En cours</h4>
          <p>Lampadaire défectueux – Avenue Victor Hugo</p>
          <span class="status pending">Intervention prévue</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- 📊 Statistiques -->
<section class="stats">
    <div class="stat">
        <h3><c:out value="${stats.signalementsResolus}" default="1247"/></h3>
        <p>Signalements résolus</p>
    </div>
    <div class="stat">
        <h3><c:out value="${stats.citoyensActifs}" default="3580"/></h3>
        <p>Citoyens actifs</p>
    </div>
    <div class="stat">
        <h3><c:out value="${stats.tempsResolution}" default="2"/> jours</h3>
        <p>Temps moyen de résolution</p>
    </div>
</section>


<!-- 🗂️ Catégories détaillées (si vous avez des données de catégories) -->
<section class="categories" style="padding-top: 2rem;">
    <h2 style="margin-top: 3rem;">Catégories de signalements</h2>
    <p>Choisissez la catégorie correspondant au problème que vous souhaitez signaler</p>
    <div class="category-grid">
        <c:forEach var="categorie" items="${categories}">
            <div class="category-card">
                <img src="images/${categorie.icon}" alt="${categorie.nom}" />
                <h3>${categorie.nom}</h3>
                <p>${categorie.description}</p>
                <a  href="CitoyenServlet?action=ajouterSignalement?type=${categorie.nom}" class="btn-category">Signaler</a>
            </div>
        </c:forEach>

        <!-- Catégories statiques par défaut si pas de données -->
        <c:if test="${empty categories}">
            <div class="category-card">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" fill="none" stroke="#84a98c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <!-- Lampadaire -->
  <path d="M32 6v40" />
  <circle cx="32" cy="10" r="4" fill="#84a98c" />
  <path d="M32 46c0 6 4 10 8 10h-16c4 0 8-4 8-10z" fill="#84a98c" opacity="0.2" />
  <!-- Sol -->
  <path d="M16 56h32" stroke="#84a98c" />
</svg>

                <h3>Éclairage public</h3>
                <p>Lampadaires défectueux, éclairage insuffisant, pannes électriques</p>
                <a href="CitoyenServlet?action=ajouterSignalement" class="btn-category">Signaler</a>
            </div>
            

            <div class="category-card">
                 <svg xmlns="http://www.w3.org/2000/svg" 
         viewBox="0 0 64 64" 
         width="48" height="48" 
         fill="none" 
         stroke="#84a98c" 
         stroke-width="2" 
         stroke-linecap="round" 
         stroke-linejoin="round">
        <!-- Corps de la route -->
        <path d="M24 4h16l20 56H4z"/>
        <!-- Lignes centrales -->
        <path d="M32 4v10"/>
        <path d="M32 26v8"/>
        <path d="M32 46v8"/>
    </svg>
                <h3>Routes & Chaussée</h3>
                <p>Nids-de-poule, fissures, signalisation routière endommagée</p>
                <a href="CitoyenServlet?action=ajouterSignalement" class="btn-category">Signaler</a>
            </div>

            <div class="category-card">
                 <svg xmlns="http://www.w3.org/2000/svg" 
         viewBox="0 0 64 64" 
         width="48" height="48" 
         fill="none" 
         stroke="#84a98c" 
         stroke-width="2" 
         stroke-linecap="round" 
         stroke-linejoin="round">
        <!-- Corps de la poubelle -->
        <rect x="18" y="18" width="28" height="38" rx="2" />
        <!-- Couvercle -->
        <path d="M14 18h36" />
        <!-- Poignée du couvercle -->
        <path d="M26 10h12l2 8H24z" />
        <!-- Lignes intérieures -->
        <path d="M26 24v26" />
        <path d="M38 24v26" />
    </svg>
                <h3>Déchets</h3>
                <p>Dépôts sauvages, poubelles débordantes, conteneurs endommagés</p>
                <a href="CitoyenServlet?action=ajouterSignalement" class="btn-category">Signaler</a>
            </div>

            <div class="category-card">
                <svg xmlns="http://www.w3.org/2000/svg" 
         viewBox="0 0 64 64" 
         width="48" height="48" 
         fill="none" 
         stroke="#84a98c" 
         stroke-width="2" 
         stroke-linecap="round" 
         stroke-linejoin="round">
        <!-- Tronc -->
        <path d="M32 30v18" />
        <!-- Branches -->
        <path d="M32 30c-6-6-12-4-12 0" />
        <path d="M32 30c6-6 12-4 12 0" />
        <path d="M32 24c-4-6-8-4-8 0" />
        <path d="M32 24c4-6 8-4 8 0" />
        <!-- Feuillage léger -->
        <circle cx="32" cy="24" r="6" fill="#84a98c" opacity="0.2"/>
        <circle cx="32" cy="30" r="6" fill="#84a98c" opacity="0.2"/>
        <!-- Sol -->
        <path d="M16 50h32" stroke="#84a98c"/>
    </svg>
                <h3>Espaces verts</h3>
                <p>Arbres dangereux, espaces verts mal entretenus, végétation envahissante</p>
                <a href="CitoyenServlet?action=ajouterSignalement" class="btn-category">Signaler</a>
            </div>

            <div class="category-card">
                <svg xmlns="http://www.w3.org/2000/svg"
         viewBox="0 0 64 64"
         width="48" height="48"
         fill="none"
         stroke="#84a98c"
         stroke-width="2"
         stroke-linecap="round"
         stroke-linejoin="round">
        <!-- Banc -->
        <rect x="10" y="30" width="44" height="8" rx="2" />
        <path d="M14 38v16M50 38v16" />
        <path d="M10 30l4-10h36l4 10" />
    </svg>
                <h3>Mobilier urbain</h3>
                <p>Bancs cassés, panneaux endommagés, équipements défectueux</p>
                <a href="CitoyenServlet?action=ajouterSignalement" class="btn-category">Signaler</a>
            </div>

            <div class="category-card">
                <svg xmlns="http://www.w3.org/2000/svg"
         viewBox="0 0 64 64"
         width="48" height="48"
         fill="none"
         stroke="#84a98c"
         stroke-width="2"
         stroke-linecap="round"
         stroke-linejoin="round">
        <!-- Mur -->
        <rect x="12" y="30" width="40" height="20" rx="2" />
        <!-- Bombe de peinture stylisée -->
        <path d="M28 14h8v10h-8z" />
        <path d="M30 10h4v4h-4z" fill="#84a98c" />
        <!-- Détails -->
        <path d="M20 50l4-4M40 50l4-4" />
    </svg>
                <h3>Graffiti & Vandalisme</h3>
                <p>Tags, dégradations, vandalisme sur bâtiments publics</p>
                <a href="inscription?action=ajouterSignalement" class="btn-category">Signaler</a>
            </div>
        </c:if>
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

</body>
</html>
