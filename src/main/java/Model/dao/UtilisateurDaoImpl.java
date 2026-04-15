package Model.dao;

import Model.dao.UtilisateurDao;
import Model.javabeans.Utilisateur;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDaoImpl implements UtilisateurDao {

    private Connection connection;

    public UtilisateurDaoImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public void creer(Utilisateur user) throws SQLException {
        String sql = "INSERT INTO utilisateur (nom, prenom, email, motDePasse, telephone, role, ville_id, idSpecialiteTech) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getNom());
            ps.setString(2, user.getPrenom());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getMotDePasse()); 
            ps.setString(5, user.getTelephone());
            ps.setString(6, user.getRole());
            ps.setInt(7, user.getVille_Id());
            if(user.getIdSpecialiteTech() != null) ps.setInt(8, user.getIdSpecialiteTech());
            else ps.setNull(8, java.sql.Types.INTEGER);

            ps.executeUpdate();
        }
    }

    @Override
    public Utilisateur trouverParEmail(String email) throws SQLException {
        String sql = "SELECT * FROM utilisateur WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    Utilisateur user = new Utilisateur();
                    user.setIdUtilisateur(rs.getInt("idUtilisateur"));
                    user.setNom(rs.getString("nom"));
                    user.setPrenom(rs.getString("prenom"));
                    user.setEmail(rs.getString("email"));
                    user.setMotDePasse(rs.getString("motDePasse"));
                    user.setTelephone(rs.getString("telephone"));
                    user.setRole(rs.getString("role"));
                    user.setVille_Id(rs.getInt("ville_id"));
                    user.setIdSpecialiteTech(rs.getInt("idSpecialiteTech"));
                    if(rs.wasNull()) user.setIdSpecialiteTech(null);
                    return user;
                }
                return null;
            }
        }
    }
    
    @Override
    public Utilisateur trouverParEmailEtMotDePasse(String email, String motDePasse) throws Exception {
       
    	Utilisateur utilisateur = null;
        String sql = "SELECT * FROM utilisateur WHERE email = ? AND motDePasse = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
        	
            ps.setString(1, email);
            ps.setString(2, motDePasse);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    utilisateur = new Utilisateur();
                    utilisateur.setIdUtilisateur(rs.getInt("idUtilisateur"));
                    utilisateur.setNom(rs.getString("nom"));
                    utilisateur.setPrenom(rs.getString("prenom"));
                    utilisateur.setEmail(rs.getString("email"));
                    utilisateur.setRole(rs.getString("role"));
                    utilisateur.setVille_Id(rs.getInt("ville_id"));
                    utilisateur.setTelephone(rs.getString("telephone"));
                    if(rs.getInt("idUtilisateur")!=0) {
                    utilisateur.setIdSpecialiteTech(rs.getInt("IdSpecialiteTech"));
                    }
                }
            }
        }
        return utilisateur;
    }

	@Override
	public boolean updateUtilisateur(Utilisateur utilisateur) {
		boolean updated = false;
	    String sql = "UPDATE utilisateur SET nom = ?, prenom = ?, email = ?, telephone = ?, ville_id = ? WHERE idUtilisateur = ?";

	    try (PreparedStatement ps = connection.prepareStatement(sql)) {

	        ps.setString(1, utilisateur.getNom());
	        ps.setString(2, utilisateur.getPrenom());
	        ps.setString(3, utilisateur.getEmail());
	        ps.setString(4, utilisateur.getTelephone());
	        ps.setInt(5, utilisateur.getVille_Id()); 
	        ps.setInt(6, utilisateur.getIdUtilisateur());

	        int rows = ps.executeUpdate();
	        updated = (rows > 0);

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return updated;
	}
	@Override
	public List<Utilisateur> getTechniciensParVille(int idVille) {
	    List<Utilisateur> techniciens = new ArrayList<>();
	    String sql = "SELECT u.*, s.nomSpecialite FROM utilisateur u " +
	                 " JOIN specialite s ON u.idSpecialiteTech = s.idSpecialite " +
	                 "WHERE u.ville_Id = ? AND u.role = 'technicien'";
	    try (PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setInt(1, idVille);
	        ResultSet rs = ps.executeQuery();
	        while(rs.next()) {
	            Utilisateur u = new Utilisateur();
	            u.setIdUtilisateur(rs.getInt("idUtilisateur"));
	            u.setNom(rs.getString("nom"));
	            u.setPrenom(rs.getString("prenom"));
	            u.setNomSpec(rs.getString("nomSpecialite")); 
	            techniciens.add(u);
	        }
	    } catch(SQLException e) {
	        e.printStackTrace();
	    }
	    return techniciens;
	}
	@Override
	public void affecterTechniciens(int idSignalement, List<Utilisateur> techniciensAffectes, int idAgent) throws SQLException {
	    String sql = "INSERT INTO Affectation (idSignalementFK, idTechnicienFK, idAgentFK) VALUES (?, ?, ?)";
	    try (PreparedStatement ps = connection.prepareStatement(sql)) {

	        for (Utilisateur t : techniciensAffectes) {
	            ps.setInt(1, idSignalement);
	            ps.setInt(2, t.getIdUtilisateur());
	            ps.setInt(3, idAgent); 
	            ps.addBatch();
	        }

	        ps.executeBatch();
	    }
	    String sqlUpdate = "UPDATE Signalement SET idStatutFK = 2 WHERE idSignalement = ?";
	    try (PreparedStatement psUpdate = connection.prepareStatement(sqlUpdate)) {
	        psUpdate.setInt(1, idSignalement);
	        psUpdate.executeUpdate();
	    }
	}
	@Override
	public void updateAgent(Utilisateur agent) throws SQLException {
	    String sql = "UPDATE Utilisateur SET nom=?, prenom=?, email=?, ville_id=? WHERE idUtilisateur=?";
	    
	    try (PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setString(1, agent.getNom());
	        ps.setString(2, agent.getPrenom());
	        ps.setString(3, agent.getEmail());
	        ps.setInt(4, agent.getVille_Id());
	        ps.setInt(5, agent.getIdUtilisateur());
	        
	        ps.executeUpdate();
	    }
	}
	
	@Override
	public List<Utilisateur> getAllUtilisateurs() {
	    List<Utilisateur> utilisateurs = new ArrayList<>();
	    String sql = "SELECT u.idUtilisateur, u.nom, u.prenom, u.email, u.telephone, u.role, u.ville_id, v.nom as nomVille " +
	             "FROM utilisateur u " +
	             "LEFT JOIN ville v ON u.ville_id = v.idVille " +
	             "ORDER BY u.nom ASC";


	    try (PreparedStatement ps = connection.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            Utilisateur u = new Utilisateur();
	            u.setIdUtilisateur(rs.getInt("idUtilisateur"));
	            u.setNom(rs.getString("nom"));
	            u.setPrenom(rs.getString("prenom"));
	            u.setEmail(rs.getString("email"));
	            u.setTelephone(rs.getString("telephone"));
	            u.setRole(rs.getString("role"));
	            u.setVille_Id(rs.getInt("ville_id"));
	            u.setNomVille(rs.getString("nomVille")); 
	            utilisateurs.add(u);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return utilisateurs;
	}
	@Override
	public boolean supprimerUtilisateur(int idUtilisateur) {
	    String sql = "DELETE FROM utilisateur WHERE idUtilisateur = ?";
	    try (PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setInt(1, idUtilisateur);
	        return ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}




}