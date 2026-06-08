package controller.admin;

import model.DAO.OrdineDAO;
import model.DAO.UtenteDAO;
import model.bean.BeanUtente;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Mostra e filtra gli ordini nel pannello admin.
 * URL: /admin/ordini
 *
 * Parametri GET opzionali:
 *   dal, al    → filtro per intervallo di date (formato yyyy-MM-dd)
 *   cliente    → filtro per email cliente
 */
@WebServlet("/admin/ordini")
public class AdminOrdiniServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        String dal      = request.getParameter("dal");
        String al       = request.getParameter("al");
        String cliente  = request.getParameter("cliente");

        try {
            OrdineDAO ordineDAO   = new OrdineDAO();
            UtenteDAO utenteDAO   = new UtenteDAO();

            List ordini;

            // Filtro per date
            if (dal != null && !dal.isEmpty() && al != null && !al.isEmpty()) {
                Date dataDal = Date.valueOf(dal);
                Date dataAl  = Date.valueOf(al);
                ordini = ordineDAO.doRetrieveByDate(dataDal, dataAl);
                request.setAttribute("filtroDate", true);

            // Filtro per cliente
            } else if (cliente != null && !cliente.trim().isEmpty()) {
                ordini = ordineDAO.doRetrieveByCliente(cliente.trim());
                request.setAttribute("filtroCliente", cliente.trim());

            // Nessun filtro: tutti gli ordini
            } else {
                ordini = ordineDAO.doRetrieveAll();
            }

            // Passa anche la lista utenti per il select del filtro cliente
            request.setAttribute("ordini", ordini);
            request.setAttribute("utenti", utenteDAO.doRetrieveAll());

            // Ripassa i valori del filtro alla view per pre-popolare il form
            request.setAttribute("dal", dal);
            request.setAttribute("al", al);
            request.setAttribute("cliente", cliente);

            request.getRequestDispatcher("/WEB-INF/views/admin/ordini.jsp")
                   .forward(request, response);

        } catch (IllegalArgumentException e) {
            // Date.valueOf lancia questo se il formato è sbagliato
            request.setAttribute("errore", "Formato data non valido. Usa il selettore.");
            try {
                request.setAttribute("ordini", new OrdineDAO().doRetrieveAll());
                request.setAttribute("utenti", new UtenteDAO().doRetrieveAll());
            } catch (SQLException ignored) {}
            request.getRequestDispatcher("/WEB-INF/views/admin/ordini.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("errore", "Errore DB: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/ordini.jsp").forward(request, response);
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
