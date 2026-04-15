package Model.dao;

import java.util.List;

import Model.javabeans.Notification;

public interface NotificationDAO {
	boolean addNotification(Notification n);
	void deleteOldNotifications();
	List<Notification> getNotificationsLastWeek(); 
}
