package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DAO.CategoriaDAO;
import model.DAO.FotoDAO;
import model.DAO.ProdottoDAO;
import model.bean.BeanCategoria;
import model.bean.BeanFoto;
import model.bean.BeanProdotto;
/**
 * CatalogoServlet – gestisce il catalogo prodotti.
 *
 * GET /catalogo                    → tutti i prodotti attivi
 * GET /catalogo?categoria=1        → filtra per categoria
 * GET /catalogo?prezzoMin=0&prezzoMax=50 → filtra per range prezzo
 * GET /catalogo?sort=priceAsc      → ordinamento
 *
 * I parametri possono essere combinati.
 */
@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Lettura parametri filtro ──────────────────────────────────────
        String categoriaParam = request.getParameter("categoria");   // id categoria (opzionale)
        String prezzoMinParam = request.getParameter("prezzoMin");
        String prezzoMaxParam = request.getParameter("prezzoMax");
        String sortParam      = request.getParameter("sort");        // priceAsc|priceDesc|nameAsc

        Integer categoriaFiltro = null;
        if (categoriaParam != null && !categoriaParam.trim().isEmpty()) {
            try { categoriaFiltro = Integer.parseInt(categoriaParam.trim()); }
            catch (NumberFormatException ignored) {}
        }

        double prezzoMin = 0;
        double prezzoMax = Double.MAX_VALUE;
        if (prezzoMinParam != null && !prezzoMinParam.trim().isEmpty()) {
            try { prezzoMin = Double.parseDouble(prezzoMinParam.trim()); }
            catch (NumberFormatException ignored) {}
        }
        if (prezzoMaxParam != null && !prezzoMaxParam.trim().isEmpty()) {
            try { prezzoMax = Double.parseDouble(prezzoMaxParam.trim()); }
            catch (NumberFormatException ignored) {}
        }

        try {
            ProdottoDAO  prodottoDAO = new ProdottoDAO();
            CategoriaDAO catDAO      = new CategoriaDAO();
            FotoDAO      fotoDAO     = new FotoDAO();

            // ── Tutte le categorie (per la sidebar) ───────────────────────
            List<BeanCategoria> categorie = catDAO.doRetrieveAll();

            // ── Prodotti filtrati ─────────────────────────────────────────
            List<BeanProdotto> tutti = prodottoDAO.doRetrieveAllActive();
            List<BeanProdotto> prodotti = new ArrayList<>();

            // Conteggio prodotti per categoria (per i badge nella sidebar)
            Map<Integer, Integer> countPerCategoria = new HashMap<>();
            for (BeanCategoria c : categorie) countPerCategoria.put(c.getId(), 0);
            for (BeanProdotto p : tutti) {
                countPerCategoria.merge(p.getCategoriaId(), 1, Integer::sum);
            }

            // Applica filtri
            for (BeanProdotto p : tutti) {
                boolean okCat   = (categoriaFiltro == null || p.getCategoriaId() == categoriaFiltro);
                boolean okPrice = (p.getPrezzoFinale() >= prezzoMin &&
                                   (prezzoMax == Double.MAX_VALUE || p.getPrezzoFinale() <= prezzoMax));
                if (okCat && okPrice) prodotti.add(p);
            }

            // ── Ordinamento ───────────────────────────────────────────────
            if ("priceAsc".equals(sortParam)) {
                prodotti.sort(Comparator.comparingDouble(BeanProdotto::getPrezzoFinale));
            } else if ("priceDesc".equals(sortParam)) {
                prodotti.sort(Comparator.comparingDouble(BeanProdotto::getPrezzoFinale).reversed());
            } else if ("nameAsc".equals(sortParam)) {
                prodotti.sort(Comparator.comparing(BeanProdotto::getNome));
            }
            // default: ordinamento DB (per id)

            // ── Foto (prima immagine per ogni prodotto) ───────────────────
            Map<Integer, String>        fotoMap = new HashMap<>();
            Map<Integer, BeanCategoria> catMap  = new HashMap<>();
            // Costruisci mappa categoria per id
            Map<Integer, BeanCategoria> catById = new HashMap<>();
            for (BeanCategoria c : categorie) catById.put(c.getId(), c);

            for (BeanProdotto p : prodotti) {
                List<BeanFoto> foto = fotoDAO.doRetrieveByProdotto(p.getId());
                if (!foto.isEmpty()) fotoMap.put(p.getId(), foto.get(0).getPath());
                catMap.put(p.getId(), catById.get(p.getCategoriaId()));
            }

            // ── Prezzo massimo disponibile (per lo slider) ────────────────
            double maxPrezzoDisponibile = tutti.stream()
                    .mapToDouble(BeanProdotto::getPrezzoFinale)
                    .max().orElse(500.0);

            // ── Forward alla view ─────────────────────────────────────────
            request.setAttribute("prodotti",              prodotti);
            request.setAttribute("categorie",             categorie);
            request.setAttribute("fotoMap",               fotoMap);
            request.setAttribute("catMap",                catMap);
            request.setAttribute("countPerCategoria",     countPerCategoria);
            request.setAttribute("categoriaFiltro",       categoriaFiltro);
            request.setAttribute("prezzoMin",             prezzoMin);
            request.setAttribute("prezzoMax",             prezzoMax == Double.MAX_VALUE ? maxPrezzoDisponibile : prezzoMax);
            request.setAttribute("maxPrezzoDisponibile",  maxPrezzoDisponibile);
            request.setAttribute("sortParam",             sortParam);
            request.setAttribute("currentPage",           "catalogo");

        } catch (SQLException e) {
            request.setAttribute("erroreDB", "Impossibile caricare il catalogo. Riprovare più tardi.");
            request.setAttribute("prodotti",   new ArrayList<>());
            request.setAttribute("categorie",  new ArrayList<>());
            request.setAttribute("fotoMap",    new HashMap<>());
            request.setAttribute("catMap",     new HashMap<>());
            request.setAttribute("currentPage", "catalogo");
        }

        request.getRequestDispatcher("/WEB-INF/views/catalogo.jsp")
               .forward(request, response);
    }
}
