package Model.dao;

import java.util.List;

import Model.javabeans.Actualite;


public interface ActualiteDAO {
    List<Actualite> getDernieresActualitesParVille(int idVille, int limit) throws Exception;
    public List<Actualite> getActualitesParVille(int idVille);
    public Actualite getActualiteById(int id);
    void ajouterActualite(Actualite actualite);
    void modifierActualite(Actualite actualite, boolean updateImage);
    void supprimerActualite(int id);
    List<Actualite> getAllActualites();
    
}
