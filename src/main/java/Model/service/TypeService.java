package Model.service;

import Model.dao.DAOFactory;
import Model.dao.TypeDao;
import Model.dao.TypeDaoImpl;
import Model.javabeans.Type;
import java.sql.Connection;
import java.util.List;

public class TypeService {

    private TypeDaoImpl typeDao;

    public TypeService() throws Exception {
        Connection conn = DAOFactory.getConnection();
        this.typeDao = new TypeDaoImpl(conn);
    }

    public List<Type> getAllTypes() throws Exception {
        return typeDao.getAllTypes();
    }
}
