package model.DAO;

import model.bean.BeanOrdine;
import model.bean.BeanProdottoOrdine;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrdineDAO {

    // Salva ordine e righe d'ordine in una transazione unica
    public void doSave(BeanOrdine o, List<BeanProdottoOrdine> righe) throws SQLException {
        String sqlOrdine = "INSERT INTO ordine (costoTot, _data, stato, utente) " +
                           "VALUES (?, ?, ?, ?)";
        String sqlRiga   = "INSERT INTO prodottiOrdine (ordine, prodotto, iva, prezzo, qt) " +
                           "VALUES (?, ?, ?, ?, ?)";

        Connection con = null;

        try {
            con = DBConnect.getConnection();
            con.setAutoCommit(false);

            int ordineId;
            PreparedStatement psOrdine = con.prepareStatement(sqlOrdine,
                                             Statement.RETURN_GENERATED_KEYS);
            psOrdine.setDouble(1, o.getCostoTot());
            psOrdine.setDate(2, new Date(System.currentTimeMillis()));
            psOrdine.setString(3, "NE");
            psOrdine.setString(4, o.getUtenteEmail());
            psOrdine.executeUpdate();

            ResultSet keys = psOrdine.getGeneratedKeys();
            keys.next();
            ordineId = keys.getInt(1);
            psOrdine.close();

            PreparedStatement psRiga = con.prepareStatement(sqlRiga);
            for (BeanProdottoOrdine r : righe) {
                psRiga.setInt(1, ordineId);
                psRiga.setInt(2, r.getProdottoId());
                psRiga.setInt(3, r.getIva());
                psRiga.setDouble(4, r.getPrezzo());
                psRiga.setInt(5, r.getQuantita());
                psRiga.addBatch();
            }
            psRiga.executeBatch();
            psRiga.close();

            con.commit();

        } catch (SQLException e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    // Storico ordini di un cliente
    public List<BeanOrdine> doRetrieveByUtente(String email) throws SQLException {
        String sql = "SELECT * FROM ordine WHERE utente = ? ORDER BY _data DESC";
        return eseguiLista(sql, email);
    }

    // Tutti gli ordini (admin)
    public List<BeanOrdine> doRetrieveAll() throws SQLException {
        String sql = "SELECT * FROM ordine ORDER BY _data DESC";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanOrdine> lista = new ArrayList<>();

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

    // Filtro per intervallo di date (admin)
    public List<BeanOrdine> doRetrieveByDate(Date da, Date a) throws SQLException {
        String sql = "SELECT * FROM ordine WHERE _data BETWEEN ? AND ? ORDER BY _data DESC";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanOrdine> lista = new ArrayList<>();

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setDate(1, da);
            ps.setDate(2, a);
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

    // Filtro per cliente (admin)
    public List<BeanOrdine> doRetrieveByCliente(String email) throws SQLException {
        String sql = "SELECT * FROM ordine WHERE utente = ? ORDER BY _data DESC";
        return eseguiLista(sql, email);
    }

    /**
     * Recupera le righe (prodotti) di un singolo ordine, join con prodotto per il nome.
     * Usato nella fattura dell'area riservata.
     */
    public List<BeanProdottoOrdine> doRetrieveRighe(int ordineId) throws SQLException {
        String sql = "SELECT po.ordine, po.prodotto, po.iva, po.prezzo, po.qt " +
                     "FROM prodottiOrdine po " +
                     "WHERE po.ordine = ?";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanProdottoOrdine> lista = new ArrayList<>();

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, ordineId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BeanProdottoOrdine r = new BeanProdottoOrdine();
                r.setOrdineId(rs.getInt("ordine"));
                r.setProdottoId(rs.getInt("prodotto"));
                r.setIva(rs.getInt("iva"));
                r.setPrezzo(rs.getDouble("prezzo"));
                r.setQuantita(rs.getInt("qt"));
                lista.add(r);
            }
        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
        return lista;
    }

    private List<BeanOrdine> eseguiLista(String sql, String param) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        List<BeanOrdine> lista = new ArrayList<>();

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setString(1, param);
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

    private BeanOrdine mapRow(ResultSet rs) throws SQLException {
        BeanOrdine o = new BeanOrdine();
        o.setId(rs.getInt("id"));
        o.setCostoTot(rs.getDouble("costoTot"));
        o.setData(rs.getDate("_data"));
        o.setStato(rs.getString("stato"));
        o.setUtenteEmail(rs.getString("utente"));
        return o;
    }
}