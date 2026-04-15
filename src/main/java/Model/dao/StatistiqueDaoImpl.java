package Model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StatistiqueDaoImpl implements StatistiqueDAO{

	  private Connection conn;

	 public StatistiqueDaoImpl(Connection conn) {
	        this.conn = conn;
	 }

	@Override
	public int countSignalementsThisMonth() {
		String sql = "SELECT COUNT(*) FROM signalement WHERE MONTH(dateSignalement)=MONTH(CURRENT_DATE()) AND YEAR(dateSignalement)=YEAR(CURRENT_DATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if(rs.next()) return rs.getInt(1);
        } catch(Exception e){ e.printStackTrace(); }
        return 0;
	}

	@Override
	public int countSignalementsEnCours() {
		 String sql = "SELECT COUNT(*) FROM signalement WHERE idStatutFK = 2";

	        try (PreparedStatement ps = conn.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {

	            if (rs.next()) return rs.getInt(1);

	        } catch (Exception e) { e.printStackTrace(); }

	        return 0;
	}

	@Override
	public int countUtilisateurs() {
		String sql = "SELECT COUNT(*) FROM utilisateur";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) { e.printStackTrace(); }

        return 0;
	}

}
