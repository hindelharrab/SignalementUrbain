package Model.service;

import Model.dao.SignalementDao;
import Model.dao.StatutDao;
import Model.dao.StatutDaoImpl;
import Model.dao.DAOFactory;
import Model.dao.SignalementDAOImpl;
import Model.javabeans.Signalement;
import java.sql.Connection;
import java.util.List;

public class SignalementService {

    private SignalementDao signalementDAO;
    private StatutDao statutDAO ;


    public SignalementService() throws Exception {
       
        Connection conn = DAOFactory.getConnection();
        this.signalementDAO = new SignalementDAOImpl(conn);
        this.statutDAO= new StatutDaoImpl(conn);
        
    }

  
    public List<Signalement> getSignalementsParCitoyen(int idCitoyen) throws Exception {
        return signalementDAO.getSignalementsParCitoyen(idCitoyen);
    }
    public List<Signalement> getSignalementsParVille(int villeId){
		return signalementDAO.getSignalementsParVille(villeId);
    	
    }
    public void ajouterSignalement(Signalement s) throws Exception {
    	signalementDAO.ajouterSignalement(s);
    }
    public Integer getTechnicienPourTypeVille(int idTypeFK, int idVilleFK) throws Exception {
        return signalementDAO.getTechnicienPourTypeVille(idTypeFK, idVilleFK);
    }
    public boolean modifierSignalement(Signalement s) {
        return signalementDAO.updateSignalement(s);
    }
    public void affecterTechniciens(int idSignalement, List<Integer> techniciensIds) {
    	signalementDAO.affecterTechniciens(idSignalement, techniciensIds);
    }
    public void modifierEtat(int idSignalement, int idStatutFK) {
    	signalementDAO.modifierEtat(idSignalement, idStatutFK);
    }
    public List<Signalement> getSignalementsParVilleAvecNomStatut(int idVille) {
        List<Signalement> liste = signalementDAO.getSignalementsParVille(idVille);
        for(Signalement s : liste){
            String nomStatut = statutDAO.getNomStatutById(s.getIdStatutFK());
            s.setNomStatut(nomStatut); 
        }

        return liste;
    }
    public List<Signalement> getSignalementsByStatut(int statut) {
    	return signalementDAO.getSignalementsByStatut(statut);
    }
    public void updateStatut(int idSignalement, int newStatut) {
    	signalementDAO.updateStatut(idSignalement,newStatut);
    }
    public Signalement getSignalementById(int id) {
    	return signalementDAO.getSignalementById(id);
    }
    public void supprimerSignalement(int id) {
    	signalementDAO.supprimerSignalement(id);
    }
    
}
