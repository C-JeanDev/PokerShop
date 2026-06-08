package controller.admin;

import model.DAO.OrdineDAO;
import model.DAO.ProdottoDAO;
import model.DAO.UtenteDAO;
import model.bean.BeanUtente;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        BeanUtente utente = (session != null) ? (BeanUtente) session.getAttribute("utente") : null;

        if (utente == null || !utente.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            request.setAttribute("nProdotti", new ProdottoDAO().doRetrieveAll().size());
            request.setAttribute("nUtenti",   new UtenteDAO().doRetrieveAll().size());
            request.setAttribute("nOrdini",   new OrdineDAO().doRetrieveAll().size());
        } catch (SQLException ignored) {}

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
               .forward(request, response);
    }
}
