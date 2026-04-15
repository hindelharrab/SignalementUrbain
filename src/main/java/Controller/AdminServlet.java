package Controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.javabeans.Actualite;
import Model.javabeans.Utilisateur;
import Model.javabeans.Ville;
import Model.service.ActualiteService;
import Model.service.StatistiqueService;
import Model.service.UtilisateurService;
import Model.service.VilleService;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	 private StatistiqueService statService;
	 private ActualiteService actuService;
	 private UtilisateurService utilisateurService ;
	 private VilleService villeService ;
	 
    public AdminServlet() {
        super();
    }
    @Override
    public void init() {
        try {
			statService = new StatistiqueService();
			actuService = new ActualiteService();
			villeService = new VilleService();
			utilisateurService = new UtilisateurService();
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
	
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) action = "accueil"; 

        switch (action) {

            case "accueil":
                request.setAttribute("sigMois", statService.getSignalementsThisMonth());
                request.setAttribute("sigEnCours", statService.getSignalementsEnCours());
                request.setAttribute("users", statService.getUtilisateurs());

                List<Actualite> actualites = actuService.getAllActualites();

                if (actualites != null && !actualites.isEmpty()) {
                    request.setAttribute("actualite", actualites.get(0));
                }

                request.getRequestDispatcher("admin_accueil.jsp").forward(request, response);
                break;

            case "voirToutesActualites":
                request.setAttribute("actualites", actuService.getAllActualites());
                request.getRequestDispatcher("admin_act.jsp").forward(request, response);
                break;

            case "gererUtilisateurs":
            	 List<Utilisateur> utilisateurs = utilisateurService.getAllUtilisateurs();
            	    
			List<Ville> villes;
			try {
				villes = villeService.getAllVilles();
				 request.setAttribute("villes", villes);
			} catch (Exception e) {
				
				e.printStackTrace();
			}
            	   
            	    request.setAttribute("utilisateurs", utilisateurs);
      	    
            	    request.getRequestDispatcher("admin_utilisateurs.jsp").forward(request, response);
            	    break;

            case "profil":
                Utilisateur admin = (Utilisateur) request.getSession().getAttribute("utilisateur");
			    List<Ville> villes1;
			try {
				villes1= villeService.getAllVilles();
				 request.setAttribute("villes", villes1);
			} catch (Exception e) {
				
				e.printStackTrace();
			}
                request.setAttribute("admin", admin);
                request.getRequestDispatcher("admin_profil.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("AdminServlet");
                break;
        }
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 String action = request.getParameter("action");
		    if (action == null) action = "";

		    switch(action) {
		        case "modifierProfil":
		            Utilisateur admin = (Utilisateur) request.getSession().getAttribute("utilisateur");

		            admin.setNom(request.getParameter("nom"));
		            admin.setPrenom(request.getParameter("prenom"));
		            admin.setVille_Id(Integer.parseInt(request.getParameter("ville_id"))); 
		            admin.setTelephone(request.getParameter("telephone"));
		            admin.setEmail(request.getParameter("email"));

		            boolean ok = utilisateurService.modifierProfil(admin);
		            if (ok) {
		                request.getSession().setAttribute("utilisateur", admin); 
		                request.setAttribute("message", "Profil mis à jour avec succès !");
		            } else {
		                request.setAttribute("error", "Erreur lors de la mise à jour du profil.");
		            }
		            List<Ville> villes;
					try {
						villes = villeService.getAllVilles();
						 request.setAttribute("villes", villes);
					} catch (Exception e) {
						
						e.printStackTrace();
					}
		            request.setAttribute("admin", admin);
		            request.getRequestDispatcher("admin_profil.jsp").forward(request, response);
		            break;
		          
		        case "ajouterAdmin":
		            String nom = request.getParameter("nom");
		            String prenom = request.getParameter("prenom");
		            String email = request.getParameter("email");
		            String telephone = request.getParameter("telephone");
		            String mdp = request.getParameter("motDePasse");
		            int ville_id = Integer.parseInt(request.getParameter("ville_id"));

		            Utilisateur newAdmin = new Utilisateur();
		            newAdmin.setNom(nom);
		            newAdmin.setPrenom(prenom);
		            newAdmin.setEmail(email);
		            newAdmin.setTelephone(telephone);
		            newAdmin.setMotDePasse(mdp);
		            newAdmin.setVille_Id(ville_id);
		            newAdmin.setRole("admin");

				try {
					utilisateurService.creerUtilisateur(newAdmin);
				} catch (SQLException e) {
				
					e.printStackTrace();
				} 
				 List<Ville> villes1;
					try {
						villes1 = villeService.getAllVilles();
						 request.setAttribute("villes", villes1);
					} catch (Exception e) {
						
						e.printStackTrace();
					}
		            request.setAttribute("utilisateurs", utilisateurService.getAllUtilisateurs());
		            request.getRequestDispatcher("admin_utilisateurs.jsp").forward(request, response);
		            break;
		            
		        case "supprimerUtilisateur":
		            int idUtilisateur = Integer.parseInt(request.getParameter("idUtilisateur"));
		            boolean deleted = utilisateurService.supprimerUtilisateur(idUtilisateur); 
		            if(deleted){
		                request.setAttribute("message", "Utilisateur supprimé avec succès !");
		            } else {
		                request.setAttribute("error", "Erreur lors de la suppression de l'utilisateur.");
		            }
		            List<Ville> villes11;
					try {
						villes11 = villeService.getAllVilles();
						 request.setAttribute("villes", villes11);
					} catch (Exception e) {
						
						e.printStackTrace();
					}

		            request.setAttribute("utilisateurs", utilisateurService.getAllUtilisateurs());
		            request.getRequestDispatcher("admin_utilisateurs.jsp").forward(request, response);
		            break;


		        default:
		            response.sendRedirect("AdminServlet?action=dashboard");
		    }
	}

}
