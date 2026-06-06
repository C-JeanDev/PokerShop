package model.DAO;

import model.bean.BeanFoto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FotoDAO {

    public void doSave(BeanFoto f) throws SQLException {
        String sql = "INSERT INTO foto (nome, _path, prodotto) VALUES (?, ?, ?)";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setString(1, f.getNome());
            ps.setString(2, f.getPath());
            ps.setInt(3, f.getProdottoId());
            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }

    public List<BeanFoto> doRetrieveByProdotto(int prodottoId) throws SQLException {
        String sql = "SELECT * FROM foto WHERE prodotto = ?";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanFoto> lista = new ArrayList<>();

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, prodottoId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
            	BeanFoto f = new BeanFoto();
                f.setNome(rs.getString("nome"));
                f.setPath(rs.getString("_path"));
                f.setProdottoId(rs.getInt("prodotto"));
                lista.add(f);
            }

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }

        return lista;
    }

    public void doDelete(String nomeFoto) throws SQLException {
        String sql = "DELETE FROM foto WHERE nome = ?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setString(1, nomeFoto);
            ps.executeUpdate();

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }
    }
}