package Model.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

import Model.dao.DAOFactory;
import Model.dao.NotificationDAO;
import Model.dao.NotificationDaoImpl;
import Model.javabeans.Notification;

public class NotificationService {
    private NotificationDAO notificationDAO;

  

    public NotificationService() throws Exception {
    	  Connection conn = DAOFactory.getConnection();
    	 notificationDAO = new NotificationDaoImpl(conn);
	}

    public boolean ajouterNotification(Notification n) {
        return notificationDAO.addNotification(n);
    }

    public void supprimerAnciennesNotifications() {
        notificationDAO.deleteOldNotifications();
    }

    public void creerNotificationAccepterSignalement(String nom, String prenom, String description, int idTechnicien) {
        String[] mots = description.split("\\s+");
        String descLimitee = String.join(" ", java.util.Arrays.copyOfRange(mots, 0, Math.min(7, mots.length)));
        if (mots.length > 7) descLimitee += "...";

        String msg = nom + " " + prenom + " a accepté de traiter le signalement : " + descLimitee;

        Notification n = new Notification();
        n.setMessage(msg);
        n.setDateNotification(new Timestamp(System.currentTimeMillis()));
        n.setIdTechnicien(idTechnicien);

        ajouterNotification(n);
    }
  
    public void creerNotificationRefusSignalement(String nom, String prenom, String description, String commentaire, int idTechnicien) {
        String[] mots = description.split("\\s+");
        String descLimitee = String.join(" ", java.util.Arrays.copyOfRange(mots, 0, Math.min(7, mots.length)));
        if (mots.length > 7) descLimitee += "...";

        String msg = nom + " " + prenom + " a refusé de traiter le signalement : " + descLimitee
                     + " | Raison : " + commentaire;

        Notification n = new Notification();
        n.setMessage(msg);
        n.setDateNotification(new Timestamp(System.currentTimeMillis()));
        n.setIdTechnicien(idTechnicien);

        ajouterNotification(n);
    }
    public List<Notification> getNotificationsLastWeek() {
        return notificationDAO.getNotificationsLastWeek();
    }
}
