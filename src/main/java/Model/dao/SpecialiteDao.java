package Model.dao;

import java.util.List;
import Model.javabeans.Specialite;

public interface SpecialiteDao {
    List<Specialite> getAllSpecialites() throws Exception;
}
