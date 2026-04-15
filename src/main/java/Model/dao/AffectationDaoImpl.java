package Model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.javabeans.Affectation;
import Model.javabeans.Signalement;

public class AffectationDaoImpl implements AffectationDAO{
	
	  private Connection conn;

	    public AffectationDaoImpl(Connection conn) {
	        this.conn = conn;
	    }

		@Override
		public List<Affectation> getAffectationsRejetees() {
		    List<Affectation> liste = new ArrayList<>();

		    String sql = "SELECT a.idAffectation, a.commentaire, a.idSignalementFK, " +
		                 "s.description, CONCAT(t.nom, ' ', t.prenom) AS nomTechnicien " +
		                 "FROM affectation a " +
		                 "JOIN signalement s ON a.idSignalementFK = s.idSignalement " +
		                 "JOIN Utilisateur t ON a.idTechnicienFK = t.idUtilisateur " +
		                 "WHERE a.commentaire IS NOT NULL";

		    try (PreparedStatement ps = conn.prepareStatement(sql);
		         ResultSet rs = ps.executeQuery()) {

		        while (rs.next()) {
		            Affectation a = new Affectation();
		            a.setIdAffectation(rs.getInt("idAffectation"));
		            a.setIdSignalement(rs.getInt("idSignalementFK")); 
		            a.setCommentaire(rs.getString("commentaire"));
		            a.setDescription(rs.getString("description"));
		            a.setNomTechnicien(rs.getString("nomTechnicien"));

		            liste.add(a);
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    }

		    return liste;
		}

		@Override
		public void supprimerBySignalement(int idAffectation) {
		    String sql = "DELETE FROM affectation WHERE idAffectation = ?";
		    try (PreparedStatement ps = conn.prepareStatement(sql)) {

		        ps.setInt(1, idAffectation);
		        ps.executeUpdate();

		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		}
		@Override
		public void reaffecterTechniciens(int idSignalement, List<Integer> techniciensIds, int idAgent) {

		    // 1️⃣ Supprimer les anciennes affectations
		    String deleteSQL = "DELETE FROM affectation WHERE idSignalementFK = ?";
		    try (PreparedStatement ps = conn.prepareStatement(deleteSQL)) {
		        ps.setInt(1, idSignalement);
		        ps.executeUpdate();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }

		    // 2️⃣ Réinsérer les nouvelles affectations
		    String insertSQL = "INSERT INTO affectation (idSignalementFK, idTechnicienFK, idAgentFK) VALUES (?, ?, ?)";
		    try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
		        for (Integer idTech : techniciensIds) {
		            ps.setInt(1, idSignalement);
		            ps.setInt(2, idTech);
		            ps.setInt(3, idAgent);
		            ps.addBatch();
		        }
		        ps.executeBatch();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		}

		@Override
		public List<Signalement> getSignalementsAffectes(int idTechnicien) {
	        List<Signalement> list = new ArrayList<>();

	        String sql = "SELECT s.idSignalement, s.description, s.dateSignalement, s.photo, a.idAffectation "
	                + "FROM affectation a "
	                + "JOIN signalement s ON a.idSignalementFK = s.idSignalement "
	                + "WHERE a.idTechnicienFK = ? AND a.commentaire IS NULL AND a.accepte = FALSE";

	        try (PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setInt(1, idTechnicien);
	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {
	                Signalement s = new Signalement();
	                s.setIdSignalement(rs.getInt("idSignalement"));
	                s.setDescription(rs.getString("description"));
	                s.setDateSignalement(rs.getDate("dateSignalement"));
	                s.setPhoto(rs.getBytes("photo"));
	                s.setIdAffectation(rs.getInt("idAffectation"));
	                list.add(s);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return list;
	    }


		@Override
		public boolean accepterAffectation(int idSignalement, int idTechnicien) {
	       
	        return true;
	    }

		@Override
		public boolean refuserAffectation(int idSignalement, int idTechnicien, String commentaire) {
	        String sql = "UPDATE affectation SET commentaire = ? WHERE idSignalementFK = ? AND idTechnicienFK = ?";
	        try (PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setString(1, commentaire);
	            ps.setInt(2, idSignalement);
	            ps.setInt(3, idTechnicien);
	            return ps.executeUpdate() > 0;
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return false;
	    }
		
		@Override
		public void accepterSignalement(int idAffectation) throws SQLException {
		    String sql = "UPDATE affectation SET accepte = TRUE WHERE idAffectation = ?";
		    try (PreparedStatement ps = conn.prepareStatement(sql)) {
		        ps.setInt(1, idAffectation);
		        ps.executeUpdate();
		    }
		}


}
