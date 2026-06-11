package controller;

import model.DAO.UtenteDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * CheckEmailAjaxServlet  –  PokerShop
 *
 * Endpoint AJAX per verificare se un'email è già registrata nel database.
 *
 * Richiesta:
 *   GET /check-email-ajax?email=mario.rossi@email.com
 *
 * Risposta JSON:
 *   { "disponibile": true  }   → email libera, l'utente può usarla
 *   { "disponibile": false }   → email già presente nel DB
 *   { "disponibile": false, "errore": "formato non valido" }  → input malformato
 *
 * Note di sicurezza:
 *  - La query è eseguita tramite PreparedStatement in UtenteDAO.doCheckEmail()
 *    → prevenzione SQL Injection.
 *  - Viene restituito solo un booleano, senza dettagli sugli account esistenti
 *    → nessuna information disclosure.
 *  - Il conteggio delle chiamate per IP può essere gestito a livello di filtro
 *    o reverse proxy per prevenire l'email enumeration su larga scala.
 */
@WebServlet("/check-email-ajax")
public class CheckEmailAjaxServlet extends HttpServlet {

    /**
     * Regex email lato server (stessa logica del client).
     * Previene l'interrogazione del DB per input palesemente non validi.
     */
    private static final String EMAIL_REGEX =
            "^[^\\s@]+@[^\\s@]+\\.[^\\s@]{2,}$";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Intestazioni risposta ────────────────────────────────────────────
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");   // non cachare: lo stato può cambiare

        PrintWriter out = response.getWriter();

        // ── Lettura e sanificazione del parametro ────────────────────────────
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            // Parametro assente o vuoto → formato non valido
            out.print("{\"disponibile\":false,\"errore\":\"parametro email mancante\"}");
            return;
        }

        email = email.trim();

        // Validazione formato via regex prima di colpire il DB
        if (!email.matches(EMAIL_REGEX)) {
            out.print("{\"disponibile\":false,\"errore\":\"formato non valido\"}");
            return;
        }

        // ── Interrogazione DB tramite DAO ────────────────────────────────────
        try {
            UtenteDAO utenteDAO = new UtenteDAO();
            boolean emailEsistente = utenteDAO.doCheckEmail(email);

            if (emailEsistente) {
                // Email già presente → non disponibile
                out.print("{\"disponibile\":false}");
            } else {
                // Email libera → disponibile
                out.print("{\"disponibile\":true}");
            }

        } catch (SQLException e) {
            // Errore DB: non esponiamo dettagli interni al client
            // Il form potrà comunque essere inviato; la validazione server-side
            // in RegistrazioneServlet è il controllo definitivo.
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"disponibile\":true,\"errore\":\"errore server temporaneo\"}");
        }
    }
}
