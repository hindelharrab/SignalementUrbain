package Model.javabeans;

import java.io.Serializable;

public class Utilisateur implements Serializable {
    private int idUtilisateur;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasse;
    private String telephone;
    private String role;           
    private Integer ville_Id;       
    private Integer idSpecialiteTech; 
    private String nomSpec;
    private String nomVille;
    
    public Utilisateur() {}
    
    public Utilisateur(String nom, String prenom, String email, String motDePasse, String telephone, String role, Integer villeId, Integer idSpecialiteTech) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.telephone = telephone;
        this.role = role;
        this.ville_Id = villeId;
        this.idSpecialiteTech = idSpecialiteTech;
    }

    public int getIdUtilisateur() { return idUtilisateur; }
    public void setIdUtilisateur(int idUtilisateur) { this.idUtilisateur = idUtilisateur; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public void setNomSpec(String nomSpec) { this.nomSpec = nomSpec; }
    public String getNomSpec() { return nomSpec; }
    
    public void setNomVille(String nomVille) { this.nomVille = nomVille; }
    public String getNomVille() { return nomVille; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Integer getVille_Id() { return ville_Id; }
    public void setVille_Id(Integer villeId) { this.ville_Id = villeId; }

    public Integer getIdSpecialiteTech() { return idSpecialiteTech; }
    public void setIdSpecialiteTech(Integer idSpecialiteTech) { this.idSpecialiteTech = idSpecialiteTech; }
}