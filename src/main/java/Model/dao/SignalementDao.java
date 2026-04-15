package Model.dao;

import Model.javabeans.Signalement;
import java.util.List;

public interface SignalementDao {
    List<Signalement> getSignalementsParCitoyen(int idCitoyen) throws Exception;
    public void ajouterSignalement(Signalement s) throws Exception;
    Integer getTechnicienPourTypeVille(int idTypeFK, int idVilleFK) throws Exception;
    public boolean updateSignalement(Signalement s) ;
    List<Signalement> getSignalementsParVille(int villeId);
    Signalement getSignalementById(int id);
    public void modifierEtat(int idSignalement, int idStatutFK);
    void affecterTechniciens(int idSignalement, List<Integer> techniciensIds);
    List<Signalement> getSignalementsByStatut(int statut);
    void updateStatut(int idSignalement, int newStatut);
    void supprimerSignalement(int id);
}
