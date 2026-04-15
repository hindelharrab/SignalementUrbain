package Controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.javabeans.Actualite;
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

@WebServlet("/TechnicienServlet")
public class TechnicienServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	private AffectationService affectationService;
	private ActualiteService actualiteService;
	private SignalementService signalementService;
	private UtilisateurService utilisateurService;
	private VilleService villeService;
	private NotificationService notificationService;
	
    public TechnicienServlet() {
        super();
       
    }
    public void init() throws ServletException {
        try {
        	  affectationService = new AffectationService();
        	  actualiteService = new ActualiteService();
        	  signalementService = new SignalementService();
        	  villeService = new VilleService();
        	  utilisateurService= new UtilisateurService();
        	  notificationService = new NotificationService();
        	  
        } catch (SQLException e) {
            throw new ServletException("Erreur ", e);
        } catch (Exception e) {
			e.printStackTrace();
		}
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		
        HttpSession session = request.getSession();
        Utilisateur tech = (Utilisateur) session.getAttribute("technicien");

        if (tech == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }

        switch(action) {

            case "accueil":
                List<Signalement> affectes = affectationService.getSignalementsAffectes(tech.getIdUtilisateur());
                request.setAttribute("signalementsAffectes", affectes);

			List<Actualite> actualites;
			try {
				actualites = new ActualiteService().getActualitesParVille(tech.getVille_Id());
				request.setAttribute("actualites", actualites);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
                
                request.getRequestDispatcher("technicien_accueil.jsp").forward(request, response);
                break;

            
            case "accepter":
                int idSig = Integer.parseInt(request.getParameter("idSignalement"));
                Utilisateur tech1111 = (Utilisateur) session.getAttribute("technicien");
                int idAffectation = Integer.parseInt(request.getParameter("idAffectation"));
                
                affectationService.accepterSignalement(idAffectation);

                Signalement s = signalementService.getSignalementById(idSig);
                String[] mots = s.getDescription().split("\\s+");
                String descLimitee = String.join(" ", Arrays.copyOfRange(mots, 0, Math.min(7, mots.length)));
                if (mots.length > 7) descLimitee += "...";

                String msg = tech1111.getNom() + " " + tech1111.getPrenom() + " a accepté de traiter le signalement : " + descLimitee;

                Notification n = new Notification();
                n.setMessage(msg);
                n.setDateNotification(new Timestamp(System.currentTimeMillis()));
                n.setIdTechnicien(tech1111.getIdUtilisateur());

                notificationService.ajouterNotification(n);

                response.sendRedirect("TechnicienServlet?action=voirTous");
                break;


            case "refuser":
                int idRefuser = Integer.parseInt(request.getParameter("idSignalement"));
                String commentaire = request.getParameter("commentaire");
                affectationService.refuser(idRefuser, tech.getIdUtilisateur(), commentaire);
                response.sendRedirect("TechnicienServlet?action=voirTous");
                break;
            
            case "toutesActualites":
                    Utilisateur tech1 = (Utilisateur) request.getSession().getAttribute("technicien");

                    if (tech1 == null) {
                        response.sendRedirect("connexion.jsp");
                        return;
                    }

                    int idVille = tech1.getVille_Id(); 

                    List<Actualite> actualites1 = actualiteService.getActualitesParVille(idVille);
                    request.setAttribute("actualites", actualites1);

                    request.getRequestDispatcher("technicien_actualites.jsp").forward(request, response);
                break;
                
            case "voirTous" :
                    Utilisateur tech11 = (Utilisateur) request.getSession().getAttribute("technicien");

                    if (tech11 == null) {
                        response.sendRedirect("connexion.jsp");
                        return;
                    }

                    int idTechnicien = tech11.getIdUtilisateur(); 
                    List<Signalement> signalements = affectationService.getSignalementsAffectes(idTechnicien);
                    request.setAttribute("signalements", signalements);

                    request.getRequestDispatcher("technicien_signalements.jsp").forward(request, response);
                   break;
            case "monEspace":
                Utilisateur tech111 = (Utilisateur) request.getSession().getAttribute("technicien");
                if (tech111 == null) {
                    response.sendRedirect("connexion.jsp");
                    return;
                }

			List<Ville> villes;
			try {
				villes = villeService.getAllVilles();
                request.setAttribute("villes", villes);
			} catch (Exception e) {
				e.printStackTrace();
			}

                request.getRequestDispatcher("technicien_espace.jsp").forward(request, response);
                break;
             
            case "modifier":
                Utilisateur t = (Utilisateur) session.getAttribute("technicien");

                t.setNom(request.getParameter("nom"));
                t.setPrenom(request.getParameter("prenom"));
                t.setEmail(request.getParameter("email"));
                t.setTelephone(request.getParameter("telephone"));
                t.setVille_Id(Integer.parseInt(request.getParameter("ville")));

                utilisateurService.modifierProfil(t);

                session.setAttribute("technicien", t); 

                response.sendRedirect("TechnicienServlet?action=monEspace");
                break;

        }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
		doGet(request, response);
	}

}
