package Model.service;

import Model.dao.UtilisateurDaoImpl;
import Model.javabeans.Utilisateur;
import Model.dao.DAOFactory;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class UtilisateurService {

    private UtilisateurDaoImpl utilisateurDao;
    private Connection connection;

    public UtilisateurService() throws SQLException {
        try {
            this.connection = DAOFactory.getConnection();
            this.utilisateurDao = new UtilisateurDaoImpl(connection);
        } catch (Exception e) {
            throw new SQLException("Impossible de se connecter à la base", e);
        }
    }

    public void creerUtilisateur(Utilisateur user) throws SQLException {
        if(user.getNom() == null || user.getPrenom() == null || user.getEmail() == null || user.getMotDePasse() == null) {
            throw new IllegalArgumentException("Les champs obligatoires ne doivent pas être vides !");
        }

      
        utilisateurDao.creer(user);
    }

    public Utilisateur trouverParEmail(String email) throws SQLException {
        return utilisateurDao.trouverParEmail(email);
    }

    public void closeConnection() {
        try {
            if(connection != null && !connection.isClosed()) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public Utilisateur connecterUtilisateur(String email, String motDePasse) throws Exception {
        if (email == null || email.isEmpty() || motDePasse == null || motDePasse.isEmpty()) {
            throw new Exception("Email et mot de passe sont obligatoires");
        }
        Utilisateur utilisateur = utilisateurDao.trouverParEmailEtMotDePasse(email, motDePasse);

        if (utilisateur == null) {
            throw new Exception("Email ou mot de passe incorrect");
        }
        return utilisateur;
    }
    
    public boolean modifierProfil(Utilisateur utilisateur) {
        return utilisateurDao.updateUtilisateur(utilisateur);
    }
    
    public List<Utilisateur> getTechniciensParVille(int idVille) {
    	 return utilisateurDao.getTechniciensParVille(idVille);
    }
    public void affecterTechniciens(int idSignalement, List<Utilisateur> techniciensAffectes, int idAgent) throws SQLException {
    	utilisateurDao.affecterTechniciens(idSignalement, techniciensAffectes, idAgent);
    }
    public void modifierAgent(Utilisateur agent) throws SQLException {
        utilisateurDao.updateAgent(agent);
    }

	public List<Utilisateur> getAllUtilisateurs() {
		return utilisateurDao.getAllUtilisateurs();
	}
	public boolean supprimerUtilisateur(int idUtilisateur) {
	    return utilisateurDao.supprimerUtilisateur(idUtilisateur);
	}

}
