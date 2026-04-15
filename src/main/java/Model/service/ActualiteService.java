package Model.service;

import java.sql.Connection;

import Model.dao.ActualiteDAO;
import Model.dao.ActualiteDAOImpl;
import Model.dao.DAOFactory;

import Model.javabeans.*;
import java.util.*;



public class ActualiteService {

	private ActualiteDAO Actualitedao;

    public ActualiteService() throws Exception {
        Connection conn = DAOFactory.getConnection();
        Actualitedao = new ActualiteDAOImpl(conn);
    }
    public List<Actualite> getDernieresActualites(int idVille, int limit) throws Exception {
        return Actualitedao.getDernieresActualitesParVille(idVille, limit);
    }
    public List<Actualite> getActualitesParVille(int idVille) {
        return Actualitedao.getActualitesParVille(idVille);
    }
    public void ajouterActualite(String titre, String contenu, int idVille, byte[] imageBytes) {

        Actualite actualite = new Actualite();
        actualite.setTitre(titre);
        actualite.setDescription(contenu);
        actualite.setIdVille(idVille);
        actualite.setImage(imageBytes);

        Actualitedao.ajouterActualite(actualite);
    }

    public void modifierActualite(int idActualite, String titre, String contenu, byte[] imageBytes, boolean changeImage) {
        Actualite actualite = new Actualite();
        actualite.setIdActualite(idActualite);
        actualite.setTitre(titre);
        actualite.setDescription(contenu);
        if (changeImage) actualite.setImage(imageBytes);

        Actualitedao.modifierActualite(actualite, changeImage);
    }
    
    public Actualite getActualiteById(int id) {
    	return Actualitedao.getActualiteById(id);
    }
    public void supprimerActualite(int id) {
    	Actualitedao.supprimerActualite(id);
    }

    public List<Actualite> getAllActualites() {
        return Actualitedao.getAllActualites();
    }
   
    }

