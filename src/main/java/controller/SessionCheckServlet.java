package controller;

import java.io.IOException;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.bean.BeanUtente;

/**
 * SessionCheckServlet – endpoint leggero usato dal front-end per verificare
 * se la sessione utente è ancora attiva.
 *
 * GET /session-check → {"loggato": true}  se la sessione contiene "utente"
 *                    → {"loggato": false} altrimenti
 *
 * Usato da header.jsp sull'evento pageshow (back button / bfcache):
 * se la sessione è scaduta (es. dopo logout) la pagina viene ricaricata
 * così il server può reindirizzare correttamente.
 */
@WebServlet("/session-check")
public class SessionCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        // Nessuna cache: questa risposta deve sempre essere fresca
        response.setHeader("Cache-Control", "no-store");

        HttpSession session = request.getSession(false);
        boolean loggato = (session != null && session.getAttribute("utente") != null);

        response.getWriter().write("{\"loggato\":" + loggato + "}");
    }
}
