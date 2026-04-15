<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CityReport - Accueil</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- 🧭 Barre de navigation -->
<header class="navbar">
    <div class="logo">CityReport</div>
    <nav>
        <a href="accueil.jsp">Accueil</a>
        <a href="SignalementController?action=liste">Signalements</a>
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
        <a href="ajouterSignalement.jsp" class="btn-primary">Créer un signalement</a>
        <a href="carte.jsp" class="btn-secondary">Voir la carte</a>
      </div>
    </div>

    <div class="hero-card-container">
      <div class="hero-card solved">
        <div class="icon">🗑️</div>
        <div class="text">
          <h4>Problème résolu</h4>
          <p>Déchets ramassés – Rue de la Paix</p>
          <span class="status solved">Résolu en 2 jours</span>
        </div>
      </div>
      <div class="hero-card in-progress">
        <div class="icon">💡</div>
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
        <h3><c:out value="${stats.tempsResolution}" default="2.4"/> jours</h3>
        <p>Temps moyen de résolution</p>
    </div>
</section>

<!-- 🗂️ Types de signalements (Cards) -->
<section class="categories">
    <h2>Types de signalements</h2>
    <p>Découvrez les différentes catégories de problèmes signalés dans votre ville</p>

    <div class="category-type-grid">
        <div class="type-card" onclick="window.location.href='ajouterSignalement.jsp?type=eclairage'">
            <span class="type-icon">💡</span>
            <div class="type-count"><c:out value="${stats.eclairage}" default="156"/></div>
            <h4>Éclairage public</h4>
        </div>

        <div class="type-card" onclick="window.location.href='ajouterSignalement.jsp?type=route'">
            <span class="type-icon">🛣️</span>
            <div class="type-count"><c:out value="${stats.route}" default="243"/></div>
            <h4>Routes & Chaussée</h4>
        </div>

        <div class="type-card" onclick="window.location.href='ajouterSignalement.jsp?type=dechets'">
            <span class="type-icon">🗑️</span>
            <div class="type-count"><c:out value="${stats.dechets}" default="318"/></div>
            <h4>Déchets</h4>
        </div>

        <div class="type-card" onclick="window.location.href='ajouterSignalement.jsp?type=espaces-verts'">
            <span class="type-icon">🌳</span>
            <div class="type-count"><c:out value="${stats.espacesVerts}" default="187"/></div>
            <h4>Espaces verts</h4>
        </div>

        <div class="type-card" onclick="window.location.href='ajouterSignalement.jsp?type=mobilier'">
            <span class="type-icon">🪑</span>
            <div class="type-count"><c:out value="${stats.mobilier}" default="94"/></div>
            <h4>Mobilier urbain</h4>
        </div>

        <div class="type-card" onclick="window.location.href='ajouterSignalement.jsp?type=graffiti'">
            <span class="type-icon">🎨</span>
            <div class="type-count"><c:out value="${stats.graffiti}" default="72"/></div>
            <h4>Graffiti</h4>
        </div>
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
                <a href="ajouterSignalement.jsp?type=${categorie.nom}" class="btn-category">Signaler</a>
            </div>
        </c:forEach>

        <!-- Catégories statiques par défaut si pas de données -->
        <c:if test="${empty categories}">
            <div class="category-card">
                <img src="images/eclairage.svg" alt="Éclairage public" />
                <h3>Éclairage public</h3>
                <p>Lampadaires défectueux, éclairage insuffisant, pannes électriques</p>
                <a href="ajouterSignalement.jsp?type=eclairage" class="btn-category">Signaler</a>
            </div>

            <div class="category-card">
                <img src="images/route.svg" alt="Routes" />
                <h3>Routes & Chaussée</h3>
                <p>Nids-de-poule, fissures, signalisation routière endommagée</p>
                <a href="ajouterSignalement.jsp?type=route" class="btn-category">Signaler</a>
            </div>

            <div class="category-card">
                <img src="images/dechets.svg" alt="Déchets" />
                <h3>Déchets</h3>
                <p>Dépôts sauvages, poubelles débordantes, conteneurs endommagés</p>
                <a href="ajouterSignalement.jsp?type=dechets" class="btn-category">Signaler</a>
            </div>

            <div class="category-card">
                <img src="images/espaces-verts.svg" alt="Espaces verts" />
                <h3>Espaces verts</h3>
                <p>Arbres dangereux, espaces verts mal entretenus, végétation envahissante</p>
                <a href="ajouterSignalement.jsp?type=espaces-verts" class="btn-category">Signaler</a>
            </div>

            <div class="category-card">
                <img src="images/mobilier.svg" alt="Mobilier urbain" />
                <h3>Mobilier urbain</h3>
                <p>Bancs cassés, panneaux endommagés, équipements défectueux</p>
                <a href="ajouterSignalement.jsp?type=mobilier" class="btn-category">Signaler</a>
            </div>

            <div class="category-card">
                <img src="images/graffiti.svg" alt="Graffiti" />
                <h3>Graffiti & Vandalisme</h3>
                <p>Tags, dégradations, vandalisme sur bâtiments publics</p>
                <a href="ajouterSignalement.jsp?type=graffiti" class="btn-category">Signaler</a>
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
                    <li>📧 contact@cityreport.fr</li>
                    <li>📞 01 23 45 67 89</li>
                    <li>📍 123 Avenue de la République</li>
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
