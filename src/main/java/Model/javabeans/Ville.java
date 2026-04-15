package Model.javabeans;

public class Ville {
    private int idVille;
    private String nom;

    public Ville() {}

    public Ville(int idVille, String nomVille) {
        this.idVille = idVille;
        this.nom = nomVille;
    }

   
    public int getIdVille() {
        return idVille;
    }

    public void setIdVille(int idVille) {
        this.idVille = idVille;
    }

    public String getNomVille() {
        return nom;
    }

    public void setNomVille(String nomVille) {
        this.nom = nomVille;
    }

    
}
