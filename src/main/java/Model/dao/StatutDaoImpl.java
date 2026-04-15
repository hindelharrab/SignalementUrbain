package Model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StatutDaoImpl implements StatutDao {

	 private Connection conn;

	    public StatutDaoImpl(Connection conn) {
	        this.conn = conn;
	    }
	@Override 
	public String getNomStatutById(int idStatut) {
		String nom = "";
        String sql = "SELECT libelle FROM statut WHERE idStatut = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idStatut);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                nom = rs.getString("nomStatut");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nom;
	}

}
