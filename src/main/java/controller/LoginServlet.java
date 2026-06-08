package controller;

import model.DAO.UtenteDAO;
import model.bean.BeanUtente;
import model.utils.PasswordUtils;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    /**
     * GET → mostra la pagina di login
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Se l'utente è già loggato, reindirizza alla home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("utente") != null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    /**
     * POST → elabora le credenziali
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // --- Validazione input base ---
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("errore", "Email e password sono obbligatori.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        email    = email.trim();
        password = password.trim();

        // --- Logica di autenticazione ---
        try {
            UtenteDAO utenteDAO = new UtenteDAO();
            BeanUtente utente   = utenteDAO.doRetrieveByKey(email);

            if (utente == null || !PasswordUtils.verify(password, utente.getPassword())) {
                // Credenziali errate: stesso messaggio generico per sicurezza
                request.setAttribute("errore", "Email o password non corretti.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            // --- Login riuscito: crea sessione ---
            HttpSession session = request.getSession(true);
            session.setAttribute("utente", utente);
            session.setMaxInactiveInterval(30 * 60); // 30 minuti

            // Reindirizza admin o utente normale
            if (utente.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }

        } catch (SQLException e) {
            request.setAttribute("errore", "Errore del server. Riprovare più tardi.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
