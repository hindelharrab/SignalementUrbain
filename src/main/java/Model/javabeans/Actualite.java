package Model.javabeans;

import java.sql.Date;
import java.io.Serializable;

public class Actualite implements Serializable {
    private int idActualite;
    private String titre;
    private String description;
    private byte[] image; 
    private Date datePublication;
    private int idVille;
    private String nomVille;

    public Actualite()  {}

    public Actualite(int idActualite, String titre, String description, byte[] image, Date datePublication, int idVille) {
        this.idActualite = idActualite;
        this.titre = titre;
        this.description = description;
        this.image = image;
        this.datePublication = datePublication;
        this.idVille = idVille;
    }

    public int getIdActualite() { return idActualite; }
    public void setIdActualite(int idActualite) { this.idActualite = idActualite; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public byte[] getImage() { return image; }
    public void setImage(byte[] image) { this.image = image; }

    public Date getDatePublication() { return datePublication; }
    public void setDatePublication(Date datePublication) { this.datePublication = datePublication; }

    public int getIdVille() { return idVille; }
    public void setIdVille(int idVille) { this.idVille = idVille; }
    
    public String getNomVille() { return nomVille; }
    public void setNomVille(String nomVille) { this.nomVille = nomVille; }
}
