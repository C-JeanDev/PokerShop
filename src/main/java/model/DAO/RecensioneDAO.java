package model.DAO;

import model.bean.BeanRecensione;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RecensioneDAO {

    public void doSave(BeanRecensione r) throws SQLException {
        String sql = "INSERT INTO recensione (descrizione, _data, utente, prodotto) " +
                     "VALUES (?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setString(1, r.getDescrizione());
            ps.setDate(2, new Date(System.currentTimeMillis()));
            ps.setString(3, r.getUtenteEmail());
            ps.setInt(4, r.getProdottoId());
            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    public List<BeanRecensione> doRetrieveByProdotto(int prodottoId) throws SQLException {
        String sql = "SELECT * FROM recensione WHERE prodotto = ? ORDER BY _data DESC";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanRecensione> lista = new ArrayList<>();

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, prodottoId);

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

    private BeanRecensione mapRow(ResultSet rs) throws SQLException {
    	BeanRecensione r = new BeanRecensione();

        r.setId(rs.getInt("id"));
        r.setDescrizione(rs.getString("descrizione"));
        r.setData(rs.getDate("_data"));
        r.setUtenteEmail(rs.getString("utente"));
        r.setProdottoId(rs.getInt("prodotto"));

        return r;
    }
}