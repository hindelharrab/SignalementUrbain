package Model.service;

import java.sql.Connection;
import java.util.List;
import Model.dao.*;
import Model.javabeans.Ville;

public class VilleService {
    private DAOFactory daoFactory = new DAOFactory();

    public List<Ville> getAllVilles() throws Exception {
        try (Connection connection = DAOFactory.getConnection()) {
            VilleDAO villeDao = new VilleDaoImpl(connection);
            return villeDao.getAllVilles();
        }
    }
    public Ville getVilleById(int idVille) throws Exception {
    	 try (Connection connection = DAOFactory.getConnection()) {
             VilleDAO villeDao = new VilleDaoImpl(connection);
        return villeDao.getVilleById(idVille);
    }}
}
