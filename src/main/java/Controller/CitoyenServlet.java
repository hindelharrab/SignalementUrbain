package Controller;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import Model.javabeans.Signalement;
import Model.javabeans.Type;
import Model.javabeans.Utilisateur;
import Model.javabeans.Ville;
import Model.service.SignalementService;
import Model.service.TypeService;
import Model.service.UtilisateurService;
import Model.service.VilleService;
import Model.javabeans.Actualite;
import Model.service.ActualiteService;


@WebServlet("/CitoyenServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // max 5MB

public class CitoyenServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private SignalementService signalementService;
	private VilleService villeService = new VilleService();
    @Override
    public void init() throws ServletException {
        try {
            signalementService = new SignalementService();
        } catch (Exception e) {
            throw new ServletException("Impossible d'initialiser SignalementService", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        

        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect("citoyen_accueil.jsp");
            return;
        }

        try {
            switch (action) {

                case "modifierProfil": {
                    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");

                    if (utilisateur == null) {
                        response.sendRedirect("connexion.jsp");
                        return;
                    }

                    String nom = request.getParameter("nom");
                    String prenom = request.getParameter("prenom");
                    String email = request.getParameter("email");
                    String telephone = request.getParameter("telephone");
                    int idVille = Integer.parseInt(request.getParameter("idVilleFK"));

                    utilisateur.setNom(nom);
                    utilisateur.setPrenom(prenom);
                    utilisateur.setEmail(email);
                    utilisateur.setTelephone(telephone);
                    utilisateur.setVille_Id(idVille);

                    UtilisateurService utilisateurService = new UtilisateurService();
                    boolean success = utilisateurService.modifierProfil(utilisateur);

                    VilleService villeService = new VilleService();
                    Ville ville = villeService.getVilleById(idVille);
                    List<Ville> villes = villeService.getAllVilles();

                    request.setAttribute("ville", ville);
                    request.setAttribute("villes", villes);

                    if (success) {
                        session.setAttribute("utilisateur", utilisateur);
                        request.setAttribute("success", " Profil mis à jour avec succès !");
                    } else {
                        request.setAttribute("error", "Erreur lors de la mise à jour du profil.");
                    }

                    SignalementService signalementService = new SignalementService();
                    List<Signalement> signalements = signalementService.getSignalementsParCitoyen(utilisateur.getIdUtilisateur());
                    session.setAttribute("signalements", signalements);

                    request.getRequestDispatcher("citoyen_espace.jsp").forward(request, response);
                    break;
                }

                case "ajouterSignalement": {
                    String description = request.getParameter("description");
                    String localisation = request.getParameter("Localisation");
                    int idTypeFK = Integer.parseInt(request.getParameter("idTypeFK"));
                    int idVilleFK = Integer.parseInt(request.getParameter("idVilleFK"));
                    int idCitoyenFK = Integer.parseInt(request.getParameter("idCitoyenFK"));
                    int idStatutFK = Integer.parseInt(request.getParameter("idStatutFK"));

                    SignalementService signalementService = new SignalementService();
                    Integer idTechnicienFK = signalementService.getTechnicienPourTypeVille(idTypeFK, idVilleFK);

                    Part photoPart = request.getPart("photo");
                    byte[] photoBytes = null;
                    if (photoPart != null && photoPart.getSize() > 0) {
                        try (InputStream is = photoPart.getInputStream()) {
                            photoBytes = is.readAllBytes();
                        }
                    }

                    Signalement s = new Signalement();
                    s.setDescription(description);
                    s.setLocalisation(localisation);
                    s.setIdTypeFK(idTypeFK);
                    s.setIdVilleFK(idVilleFK);
                    s.setIdCitoyenFK(idCitoyenFK);
                    s.setIdStatutFK(idStatutFK);
                    s.setIdTechnicienFK(idTechnicienFK);
                    s.setPhoto(photoBytes);

                    signalementService.ajouterSignalement(s);

                    List<Signalement> signalements = signalementService.getSignalementsParCitoyen(idCitoyenFK);
                    session.setAttribute("signalements", signalements);

                    response.sendRedirect("citoyen_accueil.jsp");
                    break;
                }
                case "modifierSignalement":
                	  Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");

                      if (utilisateur == null) {
                          response.sendRedirect("connexion.jsp");
                          return;
                      }

                    try {
                        int id = Integer.parseInt(request.getParameter("idSignalement"));
                        String description = request.getParameter("description");
                        String localisation = request.getParameter("localisation");

                        Part filePart = request.getPart("photo");
                        byte[] photoBytes = null;
                        if (filePart != null && filePart.getSize() > 0) {
                            photoBytes = filePart.getInputStream().readAllBytes();
                        }

                        Signalement s = new Signalement();
                        s.setIdSignalement(id);
                        s.setDescription(description);
                        s.setLocalisation(localisation);
                        s.setPhoto(photoBytes);

                        SignalementService signalementService = new SignalementService();
                        boolean success = signalementService.modifierSignalement(s);

                        if (success) {
                        	 List<Signalement> signalements1 = signalementService.getSignalementsParCitoyen(utilisateur.getIdUtilisateur());

                             request.setAttribute("signalements", signalements1);

                             RequestDispatcher rd = request.getRequestDispatcher("voirSignalements.jsp");
                             rd.forward(request, response);
                        } else {
                            request.setAttribute("error", "Échec de la modification");
                            List<Signalement> signalements1 = signalementService.getSignalementsParCitoyen(utilisateur.getIdUtilisateur());

                            request.setAttribute("signalements", signalements1);

                            RequestDispatcher rd = request.getRequestDispatcher("voirSignalements.jsp");
                            rd.forward(request, response);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Erreur lors de la modification");
                        List<Signalement> signalements1 = signalementService.getSignalementsParCitoyen(utilisateur.getIdUtilisateur());

                        request.setAttribute("signalements", signalements1);

                        RequestDispatcher rd = request.getRequestDispatcher("voirSignalements.jsp");
                        rd.forward(request, response);
                    }
                    break;
                

                default: {
                    response.sendRedirect("citoyen_accueil.jsp");
                    break;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("citoyen_espace.jsp").forward(request, response);
        }
    }

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Utilisateur citoyen = (Utilisateur) session.getAttribute("utilisateur");
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.sendRedirect("citoyen_espace.jsp");
            return;
        }
        try {
            VilleService villeService = new VilleService();
            SignalementService signalementService = new SignalementService();

            switch (action) {

                case "monEspace":

                    Ville ville = null;
                    if (citoyen.getVille_Id() != 0) {
                        ville = villeService.getVilleById(citoyen.getVille_Id());
                    }
                    session.setAttribute("ville", ville);

                    List<Signalement> signalements = signalementService.getSignalementsParCitoyen(citoyen.getIdUtilisateur());
                    session.setAttribute("signalements", signalements);

                    List<Ville> villes = villeService.getAllVilles();
                    request.setAttribute("villes", villes);

                    request.getRequestDispatcher("citoyen_espace.jsp").forward(request, response);
                    break;

                case "ajouterSignalement":
                    if (citoyen == null) {
                        request.setAttribute("error", "Veuillez vous connecter pour signaler un problème.");
                        request.getRequestDispatcher("connexion.jsp").forward(request, response);
                        return;
                    }

                    try {
                        TypeService typeService = new TypeService();
                        List<Type> types = typeService.getAllTypes();
                        List<Ville> villesSignalement = villeService.getAllVilles();

                        request.setAttribute("villes", villesSignalement);
                        request.setAttribute("types", types);
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Erreur lors du chargement des données du formulaire.");
                    }

                    request.getRequestDispatcher("ajouterSignalement.jsp").forward(request, response);
                    break;
                 
                case "listeSignalements": {
                    if (citoyen == null) {
                        response.sendRedirect("connexion.jsp");
                        return;
                    }

                    List<Signalement> signalements1 = signalementService.getSignalementsParCitoyen(citoyen.getIdUtilisateur());

                    request.setAttribute("signalements", signalements1);

                    RequestDispatcher rd = request.getRequestDispatcher("voirSignalements.jsp");
                    rd.forward(request, response);
                    break;
                }
                case "listeActualites": {

                    if (citoyen == null) {
                        response.sendRedirect("connexion.jsp");
                        return;
                    }

                    int idVilleUtilisateur = citoyen.getVille_Id();

                    ActualiteService actualiteService = new ActualiteService();
                    List<Actualite> actualitesVille = actualiteService.getActualitesParVille(idVilleUtilisateur);

                    session.setAttribute("actualites", actualitesVille);

                    RequestDispatcher dispatcher = request.getRequestDispatcher("actualites.jsp");
                    dispatcher.forward(request, response);

                    break;
                }
                default:
                    response.sendRedirect("citoyen_espace.jsp");
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("citoyen_espace.jsp").forward(request, response);
        }
    }



    @Override
    public void destroy() {
        if (signalementService != null) {
            signalementService = null;
        }
    }

}
