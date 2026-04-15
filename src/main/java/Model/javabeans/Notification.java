package Model.javabeans;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Notification {
    private int idNotification;
    private String message;
    private Timestamp dateNotification;
    private int idTechnicien;
    
    public void Notification() {}

    public int getIdNotification() { return idNotification; }
    public void setIdNotification(int idNotification) { this.idNotification = idNotification; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getDateNotification() { return dateNotification; }
    public void setDateNotification(Timestamp localDateTime) { this.dateNotification = localDateTime; }

    public int getIdTechnicien() { return idTechnicien; }
    public void setIdTechnicien(int idTechnicien) { this.idTechnicien = idTechnicien; }
}
