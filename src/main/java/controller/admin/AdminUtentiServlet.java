package controller.admin;

import model.DAO.UtenteDAO;
import model.bean.BeanUtente;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Gestisce la visualizzazione e l'eliminazione utenti dal pannello admin.
 * URL: /admin/utenti
 *
 * Azioni:
 *   list   → mostra tutti gli utenti
 *   delete → elimina un utente (con protezione: non si può eliminare se stessi)
 */
@WebServlet("/admin/utenti")
public class AdminUtentiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BeanUtente adminLoggato = getAdmin(request, response);
        if (adminLoggato == null) return;

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            UtenteDAO utenteDAO = new UtenteDAO();

            if ("delete".equals(action)) {
                String emailDa = request.getParameter("email");

                // Protezione: un admin non può eliminare se stesso
                if (adminLoggato.getEmail().equals(emailDa)) {
                    response.sendRedirect(request.getContextPath() + "/admin/utenti?msg=nopuoi");
                    return;
                }

                // La cascade nel DB elimina anche carrello, ordini e recensioni
                // Qui usiamo una DELETE diretta tramite un metodo che aggiungiamo a UtenteDAO
                utenteDAO.doDelete(emailDa);
                response.sendRedirect(request.getContextPath() + "/admin/utenti?msg=eliminato");

            } else {
                request.setAttribute("utenti", utenteDAO.doRetrieveAll());
                request.setAttribute("adminEmail", adminLoggato.getEmail());
                request.getRequestDispatcher("/WEB-INF/views/admin/utenti.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {
            request.setAttribute("errore", "Errore DB: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/utenti.jsp").forward(request, response);
        }
    }

    private BeanUtente getAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        BeanUtente utente = (session != null) ? (BeanUtente) session.getAttribute("utente") : null;
        if (utente == null || !utente.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return utente;
    }
}
