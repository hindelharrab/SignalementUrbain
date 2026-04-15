package Model.javabeans;

public class Specialite {
    private int idSpecialite;
    private String nomSpecialite;

   
    public Specialite() {}

    public Specialite(int idSpecialite, String nomSpecialite) {
        this.idSpecialite = idSpecialite;
        this.nomSpecialite = nomSpecialite;
    }

    public int getIdSpecialite() {
        return idSpecialite;
    }

    public void setIdSpecialite(int idSpecialite) {
        this.idSpecialite = idSpecialite;
    }

    public String getNomSpecialite() {
        return nomSpecialite;
    }

    public void setNomSpecialite(String nomSpecialite) {
        this.nomSpecialite = nomSpecialite;
    }

    
}
