package Model.dao;

import Model.javabeans.Signalement;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SignalementDAOImpl implements SignalementDao {
    private Connection conn;

    public SignalementDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<Signalement> getSignalementsParCitoyen(int idCitoyen) throws Exception {
        List<Signalement> signalements = new ArrayList<>();
        String sql = "SELECT * FROM signalement WHERE idCitoyenFK = ? ORDER BY dateSignalement DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCitoyen);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Signalement s = new Signalement(
                    rs.getInt("idSignalement"),
                    rs.getString("description"),
                    rs.getBytes("photo"),
                    rs.getString("localisation"),
                    rs.getDate("dateSignalement"),
                    rs.getInt("idCitoyenFK"),
                    rs.getInt("idTypeFK"),
                    rs.getInt("idStatutFK"),
                    rs.getInt("idVilleFK"),
                    (Integer) rs.getObject("idtechnicienFK")
                );
                signalements.add(s);
            }
        }
        return signalements;
    }

	@Override
	public void ajouterSignalement(Signalement s) throws Exception {
		String sql = "INSERT INTO signalement " +
                "(description, photo, localisation, idCitoyenFK, idTypeFK, idStatutFK, idVilleFK, idTechnicienFK, dateSignalement) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getDescription());
            ps.setBytes(2, s.getPhoto());
            ps.setString(3, s.getLocalisation());
            ps.setInt(4, s.getIdCitoyenFK());
            ps.setInt(5, s.getIdTypeFK());
            ps.setInt(6, s.getIdStatutFK());
            ps.setInt(7, s.getIdVilleFK());
            if (s.getIdTechnicienFK() != null) {
                ps.setInt(8, s.getIdTechnicienFK());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            ps.executeUpdate();
        }
	}
	@Override
	public Integer getTechnicienPourTypeVille(int idType, int idVille) throws SQLException {
	    Integer idTechnicien = null;
	    
	    String sql = "SELECT u.idUtilisateur " +
	                 "FROM utilisateur u " +
	                 "JOIN specialite s ON u.idSpecialiteTech = s.idSpecialite " +
	                 "JOIN type_signalement t ON s.nomSpecialite = t.nomType " +
	                 "WHERE u.role = 'technicien' AND u.ville_id = ? AND t.idType = ? " +
	                 "LIMIT 1"; 
	    
	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, idVille);
	        ps.setInt(2, idType);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            idTechnicien = rs.getInt("idUtilisateur");
	        }
	    }
	    return idTechnicien;
	}

	public boolean updateSignalement(Signalement s) {
	    String sqlWithPhoto = "UPDATE signalement SET description=?, localisation=?, photo=? WHERE idSignalement=?";
	    String sqlWithoutPhoto = "UPDATE signalement SET description=?, localisation=? WHERE idSignalement=?";
	    try {
	        if (s.getPhoto() != null) {
	            try (PreparedStatement ps = conn.prepareStatement(sqlWithPhoto)) {
	                ps.setString(1, s.getDescription());
	                ps.setString(2, s.getLocalisation());
	                ps.setBytes(3, s.getPhoto());
	                ps.setInt(4, s.getIdSignalement());
	                return ps.executeUpdate() > 0;
	            }
	        } else {
	            try (PreparedStatement ps = conn.prepareStatement(sqlWithoutPhoto)) {
	                ps.setString(1, s.getDescription());
	                ps.setString(2, s.getLocalisation());
	                ps.setInt(3, s.getIdSignalement());
	                return ps.executeUpdate() > 0;
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}

	@Override
	public List<Signalement> getSignalementsParVille(int idVille) {
        List<Signalement> signalements = new ArrayList<>();
        String sql = "SELECT s.*, st.libelle AS nomStatut " +
                "FROM signalement s " +
                "JOIN statut st ON s.idStatutFK = st.idStatut " +
                "WHERE s.idVilleFK = ? AND s.idStatutFK = 1 " +  
                "ORDER BY s.dateSignalement DESC";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVille);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Signalement sig = new Signalement();
                sig.setIdSignalement(rs.getInt("idSignalement"));
                sig.setDescription(rs.getString("description"));
                sig.setPhoto(rs.getBytes("photo"));
                sig.setLocalisation(rs.getString("localisation"));
                sig.setDateSignalement(rs.getDate("dateSignalement"));
                sig.setIdCitoyenFK(rs.getInt("idCitoyenFK"));
                sig.setIdTypeFK(rs.getInt("idTypeFK"));
                sig.setIdStatutFK(rs.getInt("idStatutFK"));
                sig.setIdVilleFK(rs.getInt("idVilleFK"));
                sig.setIdTechnicienFK((Integer) rs.getObject("idTechnicienFK"));
                sig.setNomStatut(rs.getString("nomStatut"));


                signalements.add(sig);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return signalements;
    }
	@Override
	public Signalement getSignalementById(int id) {
	    String sql = "SELECT * FROM signalement WHERE idSignalement = ?";
	    Signalement s = null;

	    try (PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, id);
	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            s = new Signalement();
	            s.setIdSignalement(rs.getInt("idSignalement"));
	            s.setDescription(rs.getString("description"));
	            s.setLocalisation(rs.getString("localisation"));
	            s.setIdStatutFK(rs.getInt("idStatutFK")); 
	            s.setDateSignalement(rs.getTimestamp("dateSignalement"));
	           
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return s;
	}

	@Override
    public void modifierEtat(int idSignalement, int idStatutFK) {
        String sql = "UPDATE signalement SET idStatutFK=? WHERE idSignalement=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idStatutFK); 
            ps.setInt(2, idSignalement);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

	@Override
    public void affecterTechniciens(int idSignalement, List<Integer> techniciensIds) {

        String deleteSQL = "DELETE FROM affectation WHERE idSignalementFK = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteSQL)) {
            ps.setInt(1, idSignalement);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String insertSQL = "INSERT INTO affectation (idSignalementFK, idTechnicienFK) VALUES (?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
            for (Integer idTech : techniciensIds) {
                ps.setInt(1, idSignalement);
                ps.setInt(2, idTech);
                ps.addBatch();
            }
            ps.executeBatch();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

	@Override
	public List<Signalement> getSignalementsByStatut(int statut) {
	    List<Signalement> list = new ArrayList<>();

	    String sql = "SELECT s.idSignalement, s.description, s.dateSignalement, s.photo, "
	               + "st.libelle "
	               + "FROM signalement s "
	               + "JOIN statut st ON s.idStatutFK = st.idStatut "
	               + "WHERE s.idStatutFK = ?";

	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, statut);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Signalement s = new Signalement();
	            s.setIdSignalement(rs.getInt("idSignalement"));
	            s.setDescription(rs.getString("description"));
	            s.setDateSignalement(rs.getDate("dateSignalement"));
	            s.setPhoto(rs.getBytes("photo"));
	            s.setNomStatut(rs.getString("libelle")); 

	            list.add(s);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	public void updateStatut(int idSignalement, int newStatut) {
	    String sql = "UPDATE signalement SET idStatutFK = ? WHERE idSignalement = ?";
	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, newStatut);
	        ps.setInt(2, idSignalement);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	@Override
	public void supprimerSignalement(int id) {
	    String sql = "DELETE FROM signalement WHERE idSignalement = ?";
	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, id);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

}
