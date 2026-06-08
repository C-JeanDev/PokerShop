package controller;

import model.DAO.CategoriaDAO;
import model.DAO.FotoDAO;
import model.DAO.ProdottoDAO;
import model.bean.BeanCategoria;
import model.bean.BeanFoto;
import model.bean.BeanProdotto;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

/**
 * RicercaAjaxServlet – endpoint AJAX per i suggerimenti nella barra di ricerca.
 *
 * GET /ricerca-ajax?q=testo  → risponde con JSON
 *
 * Risposta:
 * {
 *   "results": [
 *     {
 *       "id":       1,
 *       "nome":     "Mazzo Carte Bicycle",
 *       "categoria":"mazzi di carte",
 *       "prezzo":   5.99,
 *       "foto":     "img/products/bicycle.jpg"  // o "" se assente
 *     },
 *     ...
 *   ]
 * }
 *
 * Requisiti checklist soddisfatti:
 *  ✔ AJAX: barra di ricerca con suggerimenti (ALMENO 1)
 *  ✔ Fetch API con JSON per comunicazioni asincrone (OBBLIGATORIO)
 *  ✔ Prevenzione SQL Injection – usa PreparedStatement in ProdottoDAO.doSearchByNome()
 */
@WebServlet("/ricerca-ajax")
public class RicercaAjaxServlet extends HttpServlet {

    private static final int MAX_RISULTATI = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        // Anti-cache per i suggerimenti in tempo reale
        response.setHeader("Cache-Control", "no-store");

        String query = request.getParameter("q");
        PrintWriter out = response.getWriter();

        // Query vuota o troppo corta → risposta vuota
        if (query == null || query.trim().length() < 3) {
            out.print("{\"results\":[]}");
            return;
        }

        query = query.trim();

        try {
            ProdottoDAO  prodottoDAO = new ProdottoDAO();
            FotoDAO      fotoDAO     = new FotoDAO();
            CategoriaDAO catDAO      = new CategoriaDAO();

            List<BeanProdotto> risultati = prodottoDAO.doSearchByNome(query);

            StringBuilder json = new StringBuilder("{\"results\":[");
            int count = 0;

            for (BeanProdotto p : risultati) {
                if (count >= MAX_RISULTATI) break;

                // Prima foto
                String foto = "";
                List<BeanFoto> fotos = fotoDAO.doRetrieveByProdotto(p.getId());
                if (!fotos.isEmpty()) foto = fotos.get(0).getPath();

                // Nome categoria
                String catNome = "";
                BeanCategoria cat = catDAO.doRetrieveByKey(p.getCategoriaId());
                if (cat != null) catNome = cat.getNome();

                if (count > 0) json.append(",");
                json.append("{");
                json.append("\"id\":").append(p.getId()).append(",");
                json.append("\"nome\":\"").append(escapeJson(p.getNome())).append("\",");
                json.append("\"categoria\":\"").append(escapeJson(catNome)).append("\",");
                json.append("\"prezzo\":").append(String.format("%.2f", p.getPrezzoFinale())).append(",");
                json.append("\"foto\":\"").append(escapeJson(foto)).append("\"");
                json.append("}");
                count++;
            }

            json.append("]}");
            out.print(json.toString());

        } catch (SQLException e) {
            // In caso di errore DB, risposta vuota (non interrompiamo l'UX)
            out.print("{\"results\":[],\"error\":\"Errore DB\"}");
        }
    }

    /**
     * Escape minimale per i valori stringa JSON.
     * Previene injection lato JSON.
     */
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
