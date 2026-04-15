package Model.service;

import java.sql.Connection;
import java.util.List;
import Model.dao.*;
import Model.javabeans.Specialite;

public class SpecialiteService {
    public List<Specialite> getAllSpecialites() throws Exception {
        try (Connection connection = DAOFactory.getConnection()) {
            SpecialiteDao specialiteDao = new SpecialiteDaoImpl(connection);
            return specialiteDao.getAllSpecialites();
        }
    }
}
