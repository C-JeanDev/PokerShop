package model.DAO;

import model.bean.BeanCategoria;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    public BeanCategoria doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM categoria WHERE id = ?";

        Connection con = null;
        PreparedStatement ps = null;
        BeanCategoria c = null;

        try {
            con = DBConnect.getConnection();
            ps  = con.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                c = mapRow(rs);
            }

        } finally {
            if (ps  != null) ps.close();
            if (con != null) con.close();
        }

        return c;
    }

    public List<BeanCategoria> doRetrieveAll() throws SQLException {
        String sql = "SELECT * FROM categoria";

        Connection con = null;
        PreparedStatement ps = null;
        List<BeanCategoria> lista = new ArrayList<>();

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

    private BeanCategoria mapRow(ResultSet rs) throws SQLException {
    	BeanCategoria c = new BeanCategoria();

        c.setId(rs.getInt("id"));
        c.setNome(rs.getString("nome"));

        return c;
    }
}