package Model.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Timestamp;
import java.util.Date;

import Model.javabeans.Notification;



public class NotificationDaoImpl implements NotificationDAO {
	
	
	private Connection conn;

    public NotificationDaoImpl(Connection conn) {
        this.conn = conn;
    }
    
	@Override
	public boolean addNotification(Notification n) {
	    String sql = "INSERT INTO notification(message, dateNotification, idTechnicienFK) VALUES (?, ?, ?)";
	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, n.getMessage());

	        // On utilise Timestamp pour DATETIME
	        Date dateNotif = n.getDateNotification();
	        if (dateNotif != null) {
	            ps.setTimestamp(2, new Timestamp(dateNotif.getTime()));
	        } else {
	            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
	        }

	        ps.setInt(3, n.getIdTechnicien());
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}

	@Override
	public void deleteOldNotifications() {
        String sql = "DELETE FROM notification WHERE dateNotification < NOW() - INTERVAL 3 MONTH";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
	
	@Override
    public List<Notification> getNotificationsLastWeek() {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE dateNotification >= NOW() - INTERVAL 7 DAY ORDER BY dateNotification DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
          
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Notification n = new Notification();
                n.setIdNotification(rs.getInt("idNotification"));
                n.setMessage(rs.getString("message"));
                n.setDateNotification(rs.getTimestamp("dateNotification"));
                list.add(n);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

}
