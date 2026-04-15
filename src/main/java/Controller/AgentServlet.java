package Controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import Model.javabeans.Actualite;
import Model.javabeans.Affectation;
import Model.javabeans.Notification;
import Model.javabeans.Signalement;
import Model.javabeans.Utilisateur;
import Model.javabeans.Ville;
import Model.service.ActualiteService;
import Model.service.AffectationService;
import Model.service.NotificationService;
import Model.service.SignalementService;
import Model.service.UtilisateurService;
import Model.service.VilleService;
import utils.EmailUtil;

@WebServlet("/AgentServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10) //  10MB max pour image
public class AgentServlet extends HttpServlet {

    private ActualiteService actualiteService ;
    private VilleService villeService ;
    private AffectationService affectationService ;
    private SignalementService signalementService ;
    private UtilisateurService utilisateurService ;
    private NotificationService notificationService ;
    
    public void init() throws ServletException {
        try {
        	actualiteService = new ActualiteService();
        	villeService = new VilleService();
            signalementService = new SignalementService();
            utilisateurService = new UtilisateurService();
            affectationService = new AffectationService();
            notificationService = new NotificationService();
        } catch (Exception e) {
            throw new ServletException("Impossible d'initialiser ", e);
        }
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String action = request.getParameter("action");
        Utilisateur agent = (Utilisateur) request.getSession().getAttribute("utilisateur");

        if (agent == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }
        if (action == null || action.isEmpty()) {
        	action="listeActualites";
            return;
        }

        switch (action != null ? action : "") {

            case "listeActualites":
                request.setAttribute("actualites",actualiteService.getActualitesParVille(agent.getVille_Id()));
                request.getRequestDispatcher("agent_accueil.jsp").forward(request, response);
                
                
                break;

            case "voirTousSignalements":
            	int idVille = agent.getVille_Id(); 
                request.setAttribute("signalements",signalementService.getSignalementsParVille(agent.getVille_Id()));
                List<Utilisateur> techniciens = utilisateurService.getTechniciensParVille(idVille);
                request.setAttribute("techniciens", techniciens);
                request.getRequestDispatcher("nouveaux_signalements.jsp").forward(request, response);
                break;

            case "modifierActualiteForm":
                int id = Integer.parseInt(request.getParameter("id"));
                Actualite act = actualiteService.getActualiteById(id);
                request.setAttribute("actMod", act);
                request.getRequestDispatcher("agent_accueil.jsp").forward(request, response);
                break;
                
            case "supprimerActualite":
                System.out.println(">>> DEBUG SUPPRESSION <<<");
                System.out.println("ID envoyé = " + request.getParameter("id"));

                int idSup = Integer.parseInt(request.getParameter("id"));
                actualiteService.supprimerActualite(idSup);

                List<Actualite> actualites3 = actualiteService.getActualitesParVille(agent.getVille_Id());
                request.getSession().setAttribute("actualites", actualites3);

                response.sendRedirect("AgentServlet?action=voirToutesActualites");
                break;
                
            case "voirToutesActualites":
            	HttpSession session = request.getSession();
                Utilisateur agentActu = (Utilisateur) session.getAttribute("utilisateur");
                List<Actualite> toutesActus = actualiteService.getActualitesParVille(agentActu.getVille_Id());
                request.setAttribute("listeActualites", toutesActus);
                request.getRequestDispatcher("liste_actualites.jsp").forward(request, response);
                break;
                
            case "voirEnCours":
                List<Signalement> enCours = signalementService.getSignalementsByStatut(2); 
                request.setAttribute("signalementsEnCours", enCours);
                request.getRequestDispatcher("SignalementsEnCours.jsp").forward(request, response);
                break;
               
            case "voirAffectationsRejetees":
                List<Affectation> affectations = affectationService.getAffectationsRejetees();
                HttpSession session1 = request.getSession();
                System.out.println("hhhh " + affectations);
                session1.setAttribute("affectations", affectations);
                
                List<Utilisateur> techniciens1 = utilisateurService.getTechniciensParVille(agent.getVille_Id());
                session1.setAttribute("techniciens", techniciens1);
                
                request.getRequestDispatcher("affectationsRejetees.jsp").forward(request, response);
                break;

            case "MonEspace":
               
		        try {
		        	 List<Ville> villes  = villeService.getAllVilles();
		        	 HttpSession session11 = request.getSession();
				        session11.setAttribute("agent", agent); 
		                request.setAttribute("villes", villes);
		        } catch (Exception e) {
			    // TODO Auto-generated catch block
			    e.printStackTrace();
		        }
		        
                request.getRequestDispatcher("agent_espace.jsp").forward(request, response);
                
                break;

            case "agentAccueil":
                Utilisateur agentAccueil = (Utilisateur) request.getSession().getAttribute("utilisateur");
                if (agentAccueil == null) {
                    response.sendRedirect("connexion.jsp");
                    return;
                }

                List<Actualite> actualitesAccueil = actualiteService.getActualitesParVille(agentAccueil.getVille_Id());
                List<Signalement> signalementsAccueil = signalementService.getSignalementsParVille(agentAccueil.getVille_Id());
                List<Utilisateur> techniciensAccueil = utilisateurService.getTechniciensParVille(agentAccueil.getVille_Id());
			List<Ville> villesAccueil;
			try {
				villesAccueil = villeService.getAllVilles();
				  request.setAttribute("villes", villesAccueil);

			} catch (Exception e) {
				e.printStackTrace();
			}

                request.setAttribute("actualites", actualitesAccueil);
                request.setAttribute("signalements", signalementsAccueil);
                request.setAttribute("techniciens", techniciensAccueil);
			    List<Notification> lastWeekNotifs = notificationService.getNotificationsLastWeek();
                request.setAttribute("notifications", lastWeekNotifs);
                 System.out.println(lastWeekNotifs);
                request.getRequestDispatcher("agent_accueil.jsp").forward(request, response);
                break;
         
            default:
            	
                request.getRequestDispatcher("agent_accueil.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        Utilisateur agent = (Utilisateur) request.getSession().getAttribute("utilisateur");

        if (agent == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }

        switch (action != null ? action : "") {

           
            case "ajouterActualite":

                String titre = request.getParameter("titre");
                String description = request.getParameter("contenu");

                Part imagePart = request.getPart("image");
                byte[] imageBytes = imagePart.getInputStream().readAllBytes();

                Actualite newAct = new Actualite();
                newAct.setTitre(titre);
                newAct.setDescription(description);
                newAct.setImage(imageBytes);
                newAct.setIdVille(agent.getVille_Id());

                actualiteService.ajouterActualite(titre,description,agent.getVille_Id(),imageBytes);
                List<Actualite> actualites2 = actualiteService.getActualitesParVille(agent.getVille_Id());
                request.getSession().setAttribute("actualites", actualites2);

                response.sendRedirect("AgentServlet?action=voirToutesActualites");
                break;

            case "modifierActualite":
            	
            	System.out.println(">>> DEBUG MODIFIER <<<");
            	System.out.println("ID envoyé = " + request.getParameter("id"));
            	System.out.println("Titre = " + request.getParameter("titre"));
            	System.out.println("Contenu = " + request.getParameter("contenu"));


                String idStr = request.getParameter("id");
                String idString = request.getParameter("id");

                if (idString == null || idString.isEmpty()) {
                    throw new ServletException("❌ ERREUR : ID non reçu dans la modification !");
                }

                int idMod = Integer.parseInt(idString);
                String titreMod = request.getParameter("titre");
                String contenuMod = request.getParameter("contenu");

                Part imagePart1 = request.getPart("image"); 
                byte[] updatedImage = null;
                boolean changeImage = false;

                if(imagePart1 != null && imagePart1.getSize() > 0){
                    updatedImage = imagePart1.getInputStream().readAllBytes();
                    changeImage = true;
                }

                actualiteService.modifierActualite(idMod, titreMod, contenuMod, updatedImage, changeImage);
                List<Actualite> actualites = actualiteService.getActualitesParVille(agent.getVille_Id());
                request.getSession().setAttribute("actualites", actualites);

                response.sendRedirect("AgentServlet?action=voirToutesActualites");
                break;

            case "affecterSignalement":
            	 int idSignalement = Integer.parseInt(request.getParameter("idSignalement"));
            	
            	String[] techniciensIds = request.getParameterValues("techniciens"); 
            	List<Utilisateur> techniciensAffectes = new ArrayList<>();

            	if (techniciensIds != null) {
            	    for (String idStr1 : techniciensIds) {
            	        int idTech = Integer.parseInt(idStr1);
            	        Utilisateur u = new Utilisateur();
            	        u.setIdUtilisateur(idTech);
            	        techniciensAffectes.add(u);
            	    }
            	}

            	int idAgent = agent.getIdUtilisateur();

			try {
				utilisateurService.affecterTechniciens(idSignalement, techniciensAffectes, idAgent);
			} catch (SQLException e) {
				
				e.printStackTrace();
			}
			response.sendRedirect("AgentServlet?action=voirTousSignalements");
                break;

            case "marquerResolue":
                int idSignalement1 = Integer.parseInt(request.getParameter("idSignalement"));
                signalementService.updateStatut(idSignalement1, 3); // statut = 3 = Résolu
                Signalement s = signalementService.getSignalementById(idSignalement1);

                if (s != null) {
                	String emailCitoyen = agent.getEmail(); 
                	 System.out.println(emailCitoyen);
                	EmailUtil.sendEmail(
                	    emailCitoyen,
                	    "Votre signalement est résolu",
                	    "Bonjour,\n\nLe signalement suivant a été marqué comme résolu :\n\n"
                	        + s.getDescription() + "\n\nMerci pour votre contribution.\nService municipal."
                	);

                    } else {
                        System.out.println("Impossible d'envoyer le mail : email manquant pour le citoyen.");
                    }

                    signalementService.supprimerSignalement(idSignalement1);
                
                response.sendRedirect("AgentServlet?action=voirEnCours");
                break;
            case "reaffecter":
                int idSignalement11 = Integer.parseInt(request.getParameter("idSignalement"));
                String[] techniciensIds1 = request.getParameterValues("techniciens");

                List<Integer> ids = new ArrayList<>();
                if (techniciensIds1 != null) {
                    for (String idTech : techniciensIds1) {
                        ids.add(Integer.parseInt(idTech));
                    }
                }

                int idAgent1 = agent.getIdUtilisateur();
                System.out.println("📌 Réaffectation => idSignalement=" + idSignalement11 + ", techniciens=" + techniciensIds1 + ", agent=" + idAgent1);

			affectationService.reaffecterTechniciens(idSignalement11, ids, idAgent1);

                response.sendRedirect("AgentServlet?action=voirAffectationsRejetees");
                break;


            case "modifierProfil":
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                String email = request.getParameter("email");
                int idVilleFK = Integer.parseInt(request.getParameter("idVilleFK"));
                if (agent == null) {
                    response.sendRedirect("connexion.jsp");
                    return;
                }

                agent.setNom(nom);
                agent.setPrenom(prenom);
                agent.setEmail(email);
                agent.setVille_Id(idVilleFK);
                
                HttpSession session11 = request.getSession();
                try {
                    utilisateurService.modifierAgent(agent);
                    session11.setAttribute("agent", agent);
                    List<Ville> villes  = villeService.getAllVilles();
		                request.setAttribute("villes", villes);
                    request.setAttribute("message", "Profil mis à jour avec succès !");
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("message", "Erreur lors de la mise à jour du profil !");
                } catch (Exception e) {
					e.printStackTrace();
				}
                request.getRequestDispatcher("agent_espace.jsp").forward(request, response);
                break;


            default:
                List<Actualite> actualites1 = actualiteService.getActualitesParVille(agent.getVille_Id());
                request.setAttribute("actualites", actualites1);
                
                List<Signalement> signalements = signalementService.getSignalementsParVille(agent.getVille_Id());
                request.setAttribute("signalements", signalements);

                request.getRequestDispatcher("agent_accueil.jsp").forward(request, response);
                break;

    }}
}
