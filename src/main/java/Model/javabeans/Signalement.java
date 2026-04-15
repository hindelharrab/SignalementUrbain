package Model.javabeans;

import java.io.Serializable;
import java.util.Base64;
import java.util.Date;
public class Signalement  implements Serializable {
    private int idSignalement;
    private String description;
    private byte[] photo; 
    private String localisation;
    private Date dateSignalement;
    private int idCitoyenFK;
    private int idTypeFK;
    private int idStatutFK;
    private int idVilleFK;
    private Integer idTechnicienFK; 
    private String nomStatut;
    private String emailCitoyen;
    private int idAffectation;

  
    public Signalement() {}

    public Signalement(int idSignalement, String description, byte[] photo, String localisation,
                       Date dateSignalement, int idCitoyenFK, int idTypeFK, int idStatutFK,
                       int idVilleFK, Integer idTechnicienFK) {
        this.idSignalement = idSignalement;
        this.description = description;
        this.photo = photo;
        this.localisation = localisation;
        this.dateSignalement = dateSignalement;
        this.idCitoyenFK = idCitoyenFK;
        this.idTypeFK = idTypeFK;
        this.idStatutFK = idStatutFK;
        this.idVilleFK = idVilleFK;
        this.idTechnicienFK = idTechnicienFK;
       
    }

    public String getNomStatut(){return nomStatut; }
    public void setNomStatut(String nom){ this.nomStatut=nom;}
    
    public String getEmailCitoyen(){return emailCitoyen; }
    public void setEmailCitoyen(String EmailCitoyen){ this.emailCitoyen=EmailCitoyen;}
    
    public int getIdSignalement() { return idSignalement; }
    public void setIdSignalement(int idSignalement) { this.idSignalement = idSignalement; }
    
    public int getIdAffectation() { return idAffectation; }
    public void setIdAffectation(int idAffectation) { this.idAffectation = idAffectation; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public byte[] getPhoto() { return photo; }
    public void setPhoto(byte[] photo) { this.photo = photo; }

    public String getLocalisation() {return localisation;}
    public void setLocalisation(String localisation) { this.localisation=localisation;}

    public Date getDateSignalement() { return dateSignalement; }
    public void setDateSignalement(Date dateSignalement) { this.dateSignalement = dateSignalement; }

    public int getIdCitoyenFK() { return idCitoyenFK; }
    public void setIdCitoyenFK(int idCitoyenFK) { this.idCitoyenFK = idCitoyenFK; }

    public int getIdTypeFK() { return idTypeFK; }
    public void setIdTypeFK(int idTypeFK) { this.idTypeFK = idTypeFK; }

    public int getIdStatutFK() { return idStatutFK; }
    public void setIdStatutFK(int idStatutFK) { this.idStatutFK = idStatutFK; }

    public int getIdVilleFK() { return idVilleFK; }
    public void setIdVilleFK(int idVilleFK) { this.idVilleFK = idVilleFK; }

    public Integer getIdTechnicienFK() { return idTechnicienFK; }
    public void setIdTechnicienFK(Integer idTechnicienFK) { this.idTechnicienFK = idTechnicienFK; }
}

