package controller.admin;

import model.DAO.CategoriaDAO;
import model.DAO.ProdottoDAO;
import model.bean.BeanCategoria;
import model.bean.BeanProdotto;
import model.bean.BeanUtente;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Gestisce tutte le operazioni CRUD sui prodotti dal pannello admin.
 * URL: /admin/prodotti
 *
 * Azioni (parametro "action"):
 *   list    → mostra tutti i prodotti
 *   new     → form nuovo prodotto
 *   save    → inserisce nuovo prodotto
 *   edit    → form modifica prodotto
 *   update  → aggiorna prodotto
 *   delete  → soft-delete (isActive = false)
 */
@WebServlet("/admin/prodotti")
public class AdminProdottiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            CategoriaDAO categoriaDAO = new CategoriaDAO();

            switch (action) {

                case "new":
                    request.setAttribute("categorie", categoriaDAO.doRetrieveAll());
                    request.getRequestDispatcher("/WEB-INF/views/admin/prodotto-form.jsp")
                           .forward(request, response);
                    break;

                case "edit":
                    int idEdit = Integer.parseInt(request.getParameter("id"));
                    BeanProdotto p = prodottoDAO.doRetrieveByKey(idEdit);
                    if (p == null) { response.sendRedirect(request.getContextPath() + "/admin/prodotti"); return; }
                    request.setAttribute("prodotto", p);
                    request.setAttribute("categorie", categoriaDAO.doRetrieveAll());
                    request.getRequestDispatcher("/WEB-INF/views/admin/prodotto-form.jsp")
                           .forward(request, response);
                    break;

                case "delete":
                    int idDel = Integer.parseInt(request.getParameter("id"));
                    prodottoDAO.doDelete(idDel);
                    response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=eliminato");
                    break;

                default: // list
                    List<BeanProdotto> lista = prodottoDAO.doRetrieveAll();
                    request.setAttribute("prodotti", lista);
                    request.getRequestDispatcher("/WEB-INF/views/admin/prodotti.jsp")
                           .forward(request, response);
                    break;
            }

        } catch (SQLException e) {
            request.setAttribute("errore", "Errore DB: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/prodotti.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();

            BeanProdotto p = new BeanProdotto();
            p.setNome(request.getParameter("nome").trim());
            p.setDescrizione(request.getParameter("descrizione").trim());
            p.setPrezzoListino(Double.parseDouble(request.getParameter("prezzoListino")));
            p.setPrezzoFinale(Double.parseDouble(request.getParameter("prezzoFinale")));
            p.setIva(Integer.parseInt(request.getParameter("iva")));
            p.setQuantita(Integer.parseInt(request.getParameter("qt")));
            p.setCategoriaId(Integer.parseInt(request.getParameter("categoria")));
            p.setActive("on".equals(request.getParameter("isActive")));

            if ("update".equals(action)) {
                p.setId(Integer.parseInt(request.getParameter("id")));
                prodottoDAO.doUpdate(p);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=aggiornato");
            } else {
                prodottoDAO.doSave(p);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=creato");
            }

        } catch (Exception e) {
            request.setAttribute("errore", "Errore: " + e.getMessage());
            try {
                request.setAttribute("categorie", new CategoriaDAO().doRetrieveAll());
            } catch (SQLException ignored) {}
            request.getRequestDispatcher("/WEB-INF/views/admin/prodotto-form.jsp").forward(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        BeanUtente utente = (session != null) ? (BeanUtente) session.getAttribute("utente") : null;
        if (utente == null || !utente.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
