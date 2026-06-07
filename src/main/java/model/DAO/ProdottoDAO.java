package model.DAO;

import model.bean.BeanProdotto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProdottoDAO {

    // Inserimento nuovo prodotto (admin)
    public void doSave(BeanProdotto p) throws SQLException {
        String sql = "INSERT INTO prodotto (nome, prezzoListino, prezzoFinale, " +
                     "descrizione, iva, isActive, qt, categoria) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);

            ps.setString(1, p.getNome());
            ps.setDouble(2, p.getPrezzoListino());
            ps.setDouble(3, p.getPrezzoFinale());
            ps.setString(4, p.getDescrizione());
            ps.setInt(5, p.getIva());
            ps.setBoolean(6, p.isActive());
            ps.setInt(7, p.getQuantita());
            ps.setInt(8, p.getCategoriaId());

            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    // Modifica prodotto (admin)
    public void doUpdate(BeanProdotto p) throws SQLException {
        String sql = "UPDATE prodotto SET nome=?, prezzoListino=?, prezzoFinale=?, " +
                     "descrizione=?, iva=?, isActive=?, qt=?, categoria=? WHERE id=?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);

            ps.setString(1, p.getNome());
            ps.setDouble(2, p.getPrezzoListino());
            ps.setDouble(3, p.getPrezzoFinale());
            ps.setString(4, p.getDescrizione());
            ps.setInt(5, p.getIva());
            ps.setBoolean(6, p.isActive());
            ps.setInt(7, p.getQuantita());
            ps.setInt(8, p.getCategoriaId());
            ps.setInt(9, p.getId());

            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    // Soft delete: imposta isActive = false (non cancella fisicamente
    // perché i prodotti potrebbero essere presenti in ordini storici)
    public void doDelete(int id) throws SQLException {
        String sql = "UPDATE prodotto SET isActive = false WHERE id = ?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    // Recupera singolo prodotto per id
    public BeanProdotto doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM prodotto WHERE id = ?";

        Connection con = null;
        PreparedStatement ps = null;
        BeanProdotto p = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p = mapRow(rs);
            }

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }

        return p;
    }

    // Tutti i prodotti attivi (catalogo cliente)
    public List<BeanProdotto> doRetrieveAllActive() throws SQLException {
        String sql = "SELECT * FROM prodotto WHERE isActive = true";
        return eseguiLista(sql);
    }

    // Tutti i prodotti (area admin)
    public List<BeanProdotto> doRetrieveAll() throws SQLException {
        String sql = "SELECT * FROM prodotto";
        return eseguiLista(sql);
    }

    // Ricerca per nome (AJAX barra di ricerca)
    public List<BeanProdotto> doSearchByNome(String query) throws SQLException {
        String sql = "SELECT * FROM prodotto WHERE isActive = true AND nome LIKE ?";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanProdotto> lista = new ArrayList<>();

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setString(1, "%" + query + "%");

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

    // Metodo privato di supporto per query senza parametri
    private List<BeanProdotto> eseguiLista(String sql) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        List<BeanProdotto> lista = new ArrayList<>();

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

    private BeanProdotto mapRow(ResultSet rs) throws SQLException {
    	BeanProdotto p = new BeanProdotto();

        p.setId(rs.getInt("id"));
        p.setNome(rs.getString("nome"));
        p.setPrezzoListino(rs.getDouble("prezzoListino"));
        p.setPrezzoFinale(rs.getDouble("prezzoFinale"));
        p.setDescrizione(rs.getString("descrizione"));
        p.setIva(rs.getInt("iva"));
        p.setActive(rs.getBoolean("isActive"));
        p.setQuantita(rs.getInt("qt"));
        p.setCategoriaId(rs.getInt("categoria"));

        return p;
    }
    
    public List<BeanProdotto> doRetrieveTopVenduti() throws SQLException {
        String sql = "SELECT p.* " +
                     "FROM prodotto p " +
                     "JOIN prodottiOrdine po ON p.id = po.prodotto " +
                     "WHERE p.isActive = true " +
                     "GROUP BY p.id " +
                     "ORDER BY SUM(po.qt) DESC " +
                     "LIMIT 3";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanProdotto> lista = new ArrayList<>();

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
}