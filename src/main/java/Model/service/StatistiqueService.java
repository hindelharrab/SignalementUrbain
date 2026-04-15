package Model.service;

import java.sql.Connection;

import Model.dao.DAOFactory;
import Model.dao.SignalementDAOImpl;
import Model.dao.StatistiqueDAO;
import Model.dao.StatistiqueDaoImpl;

public class StatistiqueService {

	private StatistiqueDAO dao;

    public StatistiqueService() throws Exception {
    	 Connection conn = DAOFactory.getConnection();
         this.dao = new StatistiqueDaoImpl(conn);
       
    }

    public int getSignalementsThisMonth() {
        return dao.countSignalementsThisMonth();
    }

    public int getSignalementsEnCours() {
        return dao.countSignalementsEnCours();
    }

    public int getUtilisateurs() {
        return dao.countUtilisateurs();
    }
}
