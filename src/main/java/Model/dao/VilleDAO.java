package Model.dao;

import java.util.List;
import Model.javabeans.Ville;
import Model.javabeans.Utilisateur;

public interface VilleDAO {
    List<Ville> getAllVilles() throws Exception;
    public Ville getVilleById(int idVille) throws Exception;
   
}
