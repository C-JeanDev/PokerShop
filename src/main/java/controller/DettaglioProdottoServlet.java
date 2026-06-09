package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DAO.FotoDAO;
import model.DAO.ProdottoDAO;
import model.bean.BeanFoto;
import model.bean.BeanProdotto;

/**
 * DettaglioProdottoServlet – mostra la pagina di dettaglio di un singolo prodotto.
 *
 * GET /prodotto?id=42
 *   → carica il prodotto con quell'id e tutte le sue foto,
 *     poi fa forward a /WEB-INF/views/dettaglio-prodotto.jsp
 *
 * Se l'id è assente, non è un numero, o il prodotto non esiste / non è attivo,
 * l'utente viene reindirizzato al catalogo con un messaggio di errore.
 */
@WebServlet("/prodotto")
public class DettaglioProdottoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // ── Validazione parametro id ──────────────────────────────────────
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }

        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            FotoDAO     fotoDAO    = new FotoDAO();

            // ── Carica prodotto ───────────────────────────────────────────
            BeanProdotto prodotto = prodottoDAO.doRetrieveByKey(id);

            // Prodotto inesistente o disattivato (soft-deleted)
            if (prodotto == null || !prodotto.isActive()) {
                response.sendRedirect(request.getContextPath() + "/catalogo");
                return;
            }

            // ── Carica tutte le foto del prodotto ─────────────────────────
            List<BeanFoto> foto = fotoDAO.doRetrieveByProdotto(id);

            // ── Calcola sconto ────────────────────────────────────────────
            boolean sconto     = prodotto.getPrezzoListino() > prodotto.getPrezzoFinale();
            int     scontoPerc = sconto
                    ? (int) ((1 - prodotto.getPrezzoFinale() / prodotto.getPrezzoListino()) * 100)
                    : 0;

            // ── Attributi per la view ─────────────────────────────────────
            request.setAttribute("prodotto",    prodotto);
            request.setAttribute("foto",        foto);
            request.setAttribute("sconto",      sconto);
            request.setAttribute("scontoPerc",  scontoPerc);
            request.setAttribute("currentPage", "catalogo");  // evidenzia "Catalogo" nel nav

        } catch (SQLException e) {
            request.setAttribute("erroreDB",
                    "Impossibile caricare il prodotto. Riprovare più tardi.");
            request.setAttribute("prodotto", null);
            request.setAttribute("foto",     new ArrayList<>());
        }

        request.getRequestDispatcher("/WEB-INF/views/dettaglio-prodotto.jsp")
               .forward(request, response);
    }
}
