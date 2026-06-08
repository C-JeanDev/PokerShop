package model.DAO;

import model.bean.BeanUtente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UtenteDAO {

    // Registrazione nuovo utente
    public void doSave(BeanUtente u) throws SQLException {
        String sql = "INSERT INTO utente (email, nome, cognome, _password, isAdmin, " +
                     "indirizzo, _ncivico, cap, citta) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);

            ps.setString(1, u.getEmail());
            ps.setString(2, u.getNome());
            ps.setString(3, u.getCognome());
            ps.setString(4, u.getPassword());
            ps.setBoolean(5, u.isAdmin());
            ps.setString(6, u.getIndirizzo());
            ps.setInt(7, u.getNCivico());
            ps.setString(8, u.getCap());
            ps.setString(9, u.getCitta());

            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    // Recupera utente per email (usato nel login)
    public BeanUtente doRetrieveByKey(String email) throws SQLException {
        String sql = "SELECT * FROM utente WHERE email = ?";

        Connection con = null;
        PreparedStatement ps = null;
        BeanUtente u = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                u = mapRow(rs);
            }

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }

        return u;
    }

    // Recupera tutti gli utenti (area admin, filtro ordini per cliente)
    public List<BeanUtente> doRetrieveAll() throws SQLException {
        String sql = "SELECT * FROM utente";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanUtente> lista = new ArrayList<>();

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapRow(rs));
            }

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }

        return lista;
    }

    // Controlla se una email esiste già (usato nell'AJAX di registrazione)
    public boolean doCheckEmail(String email) throws SQLException {
        String sql = "SELECT 1 FROM utente WHERE email = ?";

        Connection con = null;
        PreparedStatement ps = null;
        boolean esiste = false;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();
            esiste = rs.next();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }

        return esiste;
    }

    // Elimina un utente per email (admin)
    public void doDelete(String email) throws SQLException {
        String sql = "DELETE FROM utente WHERE email = ?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    // Mappa una riga del ResultSet in un oggetto Utente
    private BeanUtente mapRow(ResultSet rs) throws SQLException {
        BeanUtente u = new BeanUtente();

        u.setEmail(rs.getString("email"));
        u.setNome(rs.getString("nome"));
        u.setCognome(rs.getString("cognome"));
        u.setPassword(rs.getString("_password"));
        u.setAdmin(rs.getBoolean("isAdmin"));
        u.setIndirizzo(rs.getString("indirizzo"));
        u.setNCivico(rs.getInt("_ncivico"));
        u.setCap(rs.getString("cap"));
        u.setCitta(rs.getString("citta"));

        return u;
    }
}