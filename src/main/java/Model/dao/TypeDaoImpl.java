package Model.dao;

import Model.javabeans.Type;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TypeDaoImpl implements TypeDao {

    private Connection conn;

    public TypeDaoImpl(Connection connection) {
        this.conn = connection;
    }
   

    public List<Type> getAllTypes() throws Exception {
        List<Type> types = new ArrayList<>();
        String sql = "SELECT * FROM type_signalement"; 
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Type t = new Type(rs.getInt("idType"), rs.getString("nomType"));
                types.add(t);
            }
        }
        return types;
    }
}
