package Model.dao;

import Model.javabeans.Utilisateur;
import java.sql.SQLException;
import java.util.List;

public interface UtilisateurDao {
    void creer(Utilisateur user) throws SQLException;
    Utilisateur trouverParEmail(String email) throws SQLException;
    Utilisateur trouverParEmailEtMotDePasse(String email, String motDePasse) throws Exception;
    public boolean updateUtilisateur(Utilisateur utilisateur);
    List<Utilisateur> getTechniciensParVille(int idVille);
    void affecterTechniciens(int idSignalement, List<Utilisateur> techniciensAffectes, int idAgent) throws SQLException;
    public void updateAgent(Utilisateur agent) throws SQLException;
    List<Utilisateur> getAllUtilisateurs();
    boolean supprimerUtilisateur(int idUtilisateur);
}