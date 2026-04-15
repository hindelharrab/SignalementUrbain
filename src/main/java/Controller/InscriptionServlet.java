package Controller;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import Model.service.*;
import Model.javabeans.*;
import java.sql.SQLException;
import Model.service.*;
import java.util.List;


@WebServlet("/inscription")
public class InscriptionServlet extends HttpServlet {

    private UtilisateurService utilisateurService;
    private VilleService villeService = new VilleService();
    private SpecialiteService specialiteService = new SpecialiteService();
    private NotificationService notificationService ;
    private StatistiqueService statService;
	 private ActualiteService actuService;
    
    @Override
    public void init() throws ServletException {
        try {
            utilisateurService = new UtilisateurService();
            notificationService = new NotificationService();
            statService = new StatistiqueService();
			actuService = new ActualiteService();
        } catch (SQLException e) {
            throw new ServletException("Erreur de connexion à la base", e);
        } catch (Exception e) {
			e.printStackTrace();
		}
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "PagePpl.jsp";

        switch (action) {
            case "formulaireInscp":
                afficherFormulaireInscription(request, response);
                break;
      
            default:
                response.sendRedirect("PagePpl.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	String action = request.getParameter("action");

        switch (action) {
            case "inscp":
                creerUtilisateur(request, response);
                break;
            case "login":
                login(request, response);
                break;
            case "logout":
                logout(request, response);
                break;
                
            default:
                response.sendRedirect("PagePpl.jsp");
        }
    }

    
    private void afficherFormulaireInscription(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Ville> villes = villeService.getAllVilles();
            List<Specialite> specialites = specialiteService.getAllSpecialites();
            request.setAttribute("villes", villes);
            request.setAttribute("specialites", specialites);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("inscription.jsp").forward(request, response);
    }
    
    private void creerUtilisateur(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String motDePasse = request.getParameter("motDePasse");
            String confirmation = request.getParameter("confirmationMotDePasse");
            String telephone = request.getParameter("telephone");
            String role = request.getParameter("role");
            int villeId = Integer.parseInt(request.getParameter("ville_id"));
            String specialiteIdStr = request.getParameter("idSpecialiteTech");

            Integer idSpecialite = null;
            if (specialiteIdStr != null && !specialiteIdStr.isEmpty()) {
                idSpecialite = Integer.parseInt(specialiteIdStr);
            }
            Utilisateur user = new Utilisateur(nom, prenom, email, motDePasse, telephone, role, villeId, idSpecialite);
            utilisateurService.creerUtilisateur(user);

            request.setAttribute("success", "Compte créé avec succès !");
            afficherFormulaireInscription(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la création du compte !");
            afficherFormulaireInscription(request, response);
        }
    }
    
    private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("password");

        try {
            Utilisateur utilisateur = utilisateurService.connecterUtilisateur(email, motDePasse);

            HttpSession session = request.getSession();
            session.setAttribute("utilisateur", utilisateur);

            if ("agent".equals(utilisateur.getRole())) {
            	ActualiteService actualiteService = new ActualiteService();
                SignalementService signalementService = new SignalementService();
               
                List<Actualite> actualites = actualiteService.getActualitesParVille(utilisateur.getVille_Id());
                List<Signalement> signalements = signalementService.getSignalementsParVille(utilisateur.getVille_Id());
                List<Utilisateur> techniciens = utilisateurService.getTechniciensParVille(utilisateur.getVille_Id());
                List<Notification> lastWeekNotifs = notificationService.getNotificationsLastWeek();
                request.setAttribute("notifications", lastWeekNotifs);
                HttpSession session1 = request.getSession();
                session.setAttribute("modeActualites", "resume"); 
                request.setAttribute("actualites", actualites);
                request.setAttribute("signalements", signalements);
                request.setAttribute("techniciens", techniciens);

                request.getRequestDispatcher("agent_accueil.jsp").forward(request, response);
                
            } else if ("technicien".equals(utilisateur.getRole())) {
            	session.setAttribute("technicien", utilisateur);

                response.sendRedirect("TechnicienServlet?action=accueil");
            } 
            if ("citoyen".equals(utilisateur.getRole())) {
               
                ActualiteService actualiteService = new ActualiteService();
                List<Actualite> actualites = actualiteService.getDernieresActualites(utilisateur.getVille_Id(), 5);
                
                SignalementService signalementService = new SignalementService();
                List<Signalement> signalements = signalementService.getSignalementsParCitoyen(utilisateur.getIdUtilisateur());

                System.out.println("Nombre de signalements récupérés : " + signalements.size());

                session.setAttribute("signalements", signalements);
                session.setAttribute("actualites", actualites);
                response.sendRedirect("citoyen_accueil.jsp");
            }
            if ("admin".equals(utilisateur.getRole())) {
            	 response.sendRedirect("AdminServlet?action=accueil");
            }

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("connexion.jsp").forward(request, response);
        }
    }
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("connexion.jsp");
    }
    
    @Override
    public void destroy() {
        if(utilisateurService != null) utilisateurService.closeConnection();
    }
}
