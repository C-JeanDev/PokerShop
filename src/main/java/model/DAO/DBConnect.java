package model.DAO;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBConnect {

    private static DataSource ds;

    static {
        try {
            // contesto iniziale JNDI
            Context initCtx = new InitialContext();
            Context envCtx  = (Context) initCtx.lookup("java:comp/env");

            // lookup del DataSource
            ds = (DataSource) envCtx.lookup("jdbc/pokerShop");

        } catch (NamingException e) {
            throw new RuntimeException("Errore inizializzazione DataSource: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }
}