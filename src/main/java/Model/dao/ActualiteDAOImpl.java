package Model.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import Model.javabeans.Actualite;


public class ActualiteDAOImpl implements ActualiteDAO {
    private Connection conn;

    public ActualiteDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<Actualite> getDernieresActualitesParVille(int idVille, int limit) throws Exception {
        List<Actualite> actualites = new ArrayList<>();
        String sql = "SELECT * FROM actualite WHERE idVille = ? ORDER BY datePublication DESC LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVille);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Actualite a = new Actualite(
                    rs.getInt("idActualite"),
                    rs.getString("titre"),
                    rs.getString("description"),
                    rs.getBytes("image"),
                    rs.getDate("datePublication"),
                    rs.getInt("idVille")
                );
                actualites.add(a);
            }
        }
        return actualites;
    }
    public List<Actualite> getActualitesParVille(int idVille) {
        List<Actualite> list = new ArrayList<>();

        String sql = "SELECT * FROM actualite WHERE idVille = ? ORDER BY datePublication DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVille);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Actualite actualite = new Actualite();
                actualite.setIdActualite(rs.getInt("idActualite"));
                actualite.setTitre(rs.getString("titre"));
                actualite.setDescription(rs.getString("description"));
                actualite.setDatePublication(rs.getDate("datePublication"));
                actualite.setImage(rs.getBytes("image"));
                list.add(actualite);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Actualite getActualiteById(int id) {
        String sql = "SELECT * FROM actualite WHERE idActualite = ?";
        Actualite a = null;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a = new Actualite();
                a.setIdActualite(rs.getInt("idActualite"));
                a.setTitre(rs.getString("titre"));
                a.setDescription(rs.getString("description"));
                a.setDatePublication(rs.getDate("datePublication"));
                a.setIdVille(rs.getInt("idVille"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return a;
    }

    @Override
    public void ajouterActualite(Actualite actualite) {
    	String sql = "INSERT INTO actualite (titre, description, datePublication, image, idVille) VALUES (?, ?, NOW(), ?, ?)";

    	try (PreparedStatement ps = conn.prepareStatement(sql)) {
    	    ps.setString(1, actualite.getTitre());
    	    ps.setString(2, actualite.getDescription());
    	    
    	    if (actualite.getImage() != null) {
    	        ps.setBytes(3, actualite.getImage());   
    	    } else {
    	        ps.setNull(3, java.sql.Types.BLOB);
    	    }

    	    ps.setInt(4, actualite.getIdVille());
    	    ps.executeUpdate();
    	} catch (SQLException e) {
    	    e.printStackTrace();
    	}

    }

    @Override
    public void modifierActualite(Actualite actualite, boolean updateImage) {
        String sql = updateImage ?
                "UPDATE actualite SET titre=?, description=?, image=? WHERE idActualite=?" :
                "UPDATE actualite SET titre=?, description=? WHERE idActualite=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, actualite.getTitre());
            ps.setString(2, actualite.getDescription());

            if(updateImage){
                ps.setBytes(3, actualite.getImage());
                ps.setInt(4, actualite.getIdActualite());
            } else {
                ps.setInt(3, actualite.getIdActualite());
            }

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void supprimerActualite(int id) {
        String sql = "DELETE FROM actualite WHERE idActualite=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

	@Override
	public List<Actualite> getAllActualites() {
		List<Actualite> list = new ArrayList<>();

		String sql = """
			    SELECT a.*, v.nom
			    FROM actualite a
			    JOIN ville v ON a.idVille = v.idVille
			    ORDER BY a.DatePublication DESC
			""";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Actualite a = new Actualite();
                a.setIdActualite(rs.getInt("idActualite"));
                a.setTitre(rs.getString("titre"));
                a.setDescription(rs.getString("description"));
                a.setIdVille(rs.getInt("IdVille"));
                a.setImage(rs.getBytes("image"));
                a.setDatePublication(rs.getDate("DatePublication"));
                a.setNomVille(rs.getString("nom"));

                list.add(a);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
	
	}



