package model.DAO;

import model.bean.BeanCarrello;
import model.bean.BeanProdottoCarrello;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CarrelloDAO {

    // Crea un carrello per un utente e restituisce l'id generato
    public int doSave(String emailUtente) throws SQLException {
        String sql = "INSERT INTO carrello (utente) VALUES (?)";

        Connection con = null;
        PreparedStatement ps = null;
        int idGenerato = -1;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, emailUtente);
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                idGenerato = keys.getInt(1);
            }

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }

        return idGenerato;
    }

    // Recupera il carrello di un utente
    public BeanCarrello doRetrieveByUtente(String emailUtente) throws SQLException {
        String sql = "SELECT * FROM carrello WHERE utente = ?";

        Connection con = null;
        PreparedStatement ps = null;
        BeanCarrello c = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setString(1, emailUtente);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                c = new BeanCarrello();
                c.setId(rs.getInt("id"));
                c.setUtenteEmail(rs.getString("utente"));
            }

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }

        return c;
    }

    // Aggiunge un prodotto al carrello
    public void doAddProdotto(int carrelloId, int prodottoId, int quantita) throws SQLException {
        String sql = "INSERT INTO prodottiCarrello (carrello, prodotto, qt) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE qt = qt + ?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, carrelloId);
            ps.setInt(2, prodottoId);
            ps.setInt(3, quantita);
            ps.setInt(4, quantita);
            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    // Modifica la quantità di un prodotto nel carrello
    public void doUpdateQuantita(int carrelloId, int prodottoId, int quantita) throws SQLException {
        String sql = "UPDATE prodottiCarrello SET qt = ? WHERE carrello = ? AND prodotto = ?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, quantita);
            ps.setInt(2, carrelloId);
            ps.setInt(3, prodottoId);
            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    // Rimuove un prodotto dal carrello
    public void doRemoveProdotto(int carrelloId, int prodottoId) throws SQLException {
        String sql = "DELETE FROM prodottiCarrello WHERE carrello = ? AND prodotto = ?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, carrelloId);
            ps.setInt(2, prodottoId);
            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    // Recupera tutti i prodotti nel carrello
    public List<BeanProdottoCarrello> doRetrieveProdotti(int carrelloId) throws SQLException {
        String sql = "SELECT * FROM prodottiCarrello WHERE carrello = ?";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanProdottoCarrello> lista = new ArrayList<>();

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, carrelloId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
            	BeanProdottoCarrello pc = new BeanProdottoCarrello();
                pc.setCarrelloId(rs.getInt("carrello"));
                pc.setProdottoId(rs.getInt("prodotto"));
                pc.setQuantita(rs.getInt("qt"));
                lista.add(pc);
            }

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }

        return lista;
    }

    // Svuota il carrello dopo la conferma ordine
    public void doEmpty(int carrelloId) throws SQLException {
        String sql = "DELETE FROM prodottiCarrello WHERE carrello = ?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, carrelloId);
            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }
}