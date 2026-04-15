package Model.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import Model.dao.AffectationDAO;
import Model.dao.AffectationDaoImpl;
import Model.dao.DAOFactory;
import Model.dao.SignalementDAOImpl;
import Model.dao.SignalementDao;
import Model.dao.StatutDao;
import Model.dao.StatutDaoImpl;
import Model.javabeans.Affectation;
import Model.javabeans.Signalement;

public class AffectationService {

	 private AffectationDAO affectationDAO;
	  


	    public AffectationService() throws Exception {
	        Connection conn = DAOFactory.getConnection();
	        this.affectationDAO = new AffectationDaoImpl(conn);
	    }
	    
	    public void supprimerBySignalement(int idSignalement) {
	    	affectationDAO.supprimerBySignalement(idSignalement);
	    }
	    public List<Affectation> getAffectationsRejetees() {
	    	return affectationDAO.getAffectationsRejetees();
	    }
	    public void reaffecterTechniciens(int idSignalement, List<Integer> techniciensIds, int idAgent) {
	    	affectationDAO.reaffecterTechniciens(idSignalement,techniciensIds,idAgent );
	    }
	    public List<Signalement> getSignalementsAffectes(int idTechnicien) {
	        return affectationDAO.getSignalementsAffectes(idTechnicien);
	    }

	    public boolean accepter(int idSignalement, int idTechnicien) {
	        return affectationDAO.accepterAffectation(idSignalement, idTechnicien);
	    }

	    public boolean refuser(int idSignalement, int idTechnicien, String commentaire) {
	        return affectationDAO.refuserAffectation(idSignalement, idTechnicien, commentaire);
	    }
	    public void accepterSignalement(int idAffectation) {
	        try {
	            affectationDAO.accepterSignalement(idAffectation);
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    
	
}
