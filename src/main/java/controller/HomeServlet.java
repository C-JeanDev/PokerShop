package controller;

import model.DAO.FotoDAO;
import model.DAO.ProdottoDAO;
import model.DAO.CategoriaDAO;
import model.bean.BeanFoto;
import model.bean.BeanProdotto;
import model.bean.BeanCategoria;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * HomeServlet – gestisce la home page.
 * GET  /home  → carica i 3 prodotti più venduti e le relative foto,
 *               poi fa forward alla view home.jsp.
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	/* test dell' errore 403
    	if (true) { 
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return; 
        }*/
    	
    	/* test dell' errore 500
    	if (true) { 
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return; 
        }*/
        

        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            FotoDAO     fotoDAO     = new FotoDAO();
            CategoriaDAO catDAO     = new CategoriaDAO();

            // Recupera i 3 prodotti più venduti
            List<BeanProdotto> topVenduti = prodottoDAO.doRetrieveTopVenduti();

            // Per ogni prodotto recupera la prima foto e la categoria
            Map<Integer, String>        fotoMap = new HashMap<>();
            Map<Integer, BeanCategoria> catMap  = new HashMap<>();

            for (BeanProdotto p : topVenduti) {
                List<BeanFoto> foto = fotoDAO.doRetrieveByProdotto(p.getId());
                if (!foto.isEmpty()) {
                    fotoMap.put(p.getId(), foto.get(0).getPath());
                }
                BeanCategoria cat = catDAO.doRetrieveByKey(p.getCategoriaId());
                if (cat != null) {
                    catMap.put(p.getId(), cat);
                }
            }

            request.setAttribute("topVenduti", topVenduti);
            request.setAttribute("fotoMap",    fotoMap);
            request.setAttribute("catMap",     catMap);
            request.setAttribute("currentPage", "home");

        } catch (SQLException e) {
            // In caso di errore DB, passiamo comunque alla view con lista vuota
        	e.printStackTrace();
            request.setAttribute("topVenduti", new ArrayList<>());
            request.setAttribute("fotoMap",    new HashMap<>());
            request.setAttribute("catMap",     new HashMap<>());
            request.setAttribute("currentPage", "home");
        }

        request.getRequestDispatcher("/WEB-INF/views/home.jsp")
               .forward(request, response);
    }
}
