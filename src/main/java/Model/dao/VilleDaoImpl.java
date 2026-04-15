package Model.dao;

import java.sql.*;
import java.util.*;
import Model.javabeans.Ville;
import Model.javabeans.Utilisateur;

public class VilleDaoImpl implements VilleDAO {
    private Connection connection;

    public VilleDaoImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public List<Ville> getAllVilles() throws SQLException {
        List<Ville> villes = new ArrayList<>();
        String sql = "SELECT * FROM ville";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Ville v = new Ville();
                v.setIdVille(rs.getInt("idVille"));
                v.setNomVille(rs.getString("nom"));
                villes.add(v);
            }
        }
        return villes;
    }
    @Override
    public Ville getVilleById(int idVille) throws Exception {
        String sql = "SELECT idVille, nom FROM ville WHERE idVille = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idVille);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Ville v = new Ville();
                    v.setIdVille(rs.getInt("idVille"));
                    v.setNomVille(rs.getString("nom"));
                    return v;
                }
            }
        }
        return null;
    }
    


}
