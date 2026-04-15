package Model.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DAOFactory {

	private static String url;
    private static String username;
    private static String password;
    private static String driver;

    static {
        try {
        	//une classe qui sert a gerer des paires cle valeur
            Properties props = new Properties();
            //ClassLoader pour charger le fichier database.properties situe dans le classpath (souvent dans src/main/resources ou directement dans src)
            InputStream input = DAOFactory.class.getResourceAsStream("database.properties");
            //Charge le contenu du fichier dans l objet props
            props.load(input);

            url = props.getProperty("jdbc.url");
            username = props.getProperty("jdbc.username");
            password = props.getProperty("jdbc.password");
            driver = props.getProperty("jdbc.driver");

            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(url, username, password);
    }
}
