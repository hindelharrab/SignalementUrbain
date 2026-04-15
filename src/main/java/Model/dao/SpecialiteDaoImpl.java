package Model.dao;

import java.sql.*;
import java.util.*;
import Model.javabeans.Specialite;

public class SpecialiteDaoImpl implements SpecialiteDao {
    private Connection connection;

    public SpecialiteDaoImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public List<Specialite> getAllSpecialites() throws SQLException {
        List<Specialite> list = new ArrayList<>();
        String sql = "SELECT * FROM specialite";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Specialite s = new Specialite();
                s.setIdSpecialite(rs.getInt("idSpecialite"));
                s.setNomSpecialite(rs.getString("nomSpecialite"));
                list.add(s);
            }
        }
        return list;
    }
}
