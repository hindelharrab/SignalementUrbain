package Model.dao;

import java.sql.SQLException;
import java.util.List;

import Model.javabeans.Affectation;
import Model.javabeans.Signalement;

public interface AffectationDAO {
	List<Affectation> getAffectationsRejetees();
	void supprimerBySignalement(int idSignalement);
	void reaffecterTechniciens(int idSignalement, List<Integer> techniciensIds, int idAgent);
	List<Signalement> getSignalementsAffectes(int idTechnicien);
    boolean accepterAffectation(int idSignalement, int idTechnicien);
    boolean refuserAffectation(int idSignalement, int idTechnicien, String commentaire);
    void accepterSignalement(int idAffectation) throws SQLException;
}
