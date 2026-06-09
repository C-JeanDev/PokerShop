package controller;

import model.DAO.OrdineDAO;
import model.DAO.ProdottoDAO;
import model.DAO.UtenteDAO;
import model.bean.BeanOrdine;
import model.bean.BeanProdotto;
import model.bean.BeanProdottoOrdine;
import model.bean.BeanUtente;
import model.utils.PasswordUtils;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * AreaRiservataServlet – /area-riservata
 *
 * GET  → carica profilo utente + lista ordini con righe e nomi prodotto,
 *         forwarda a /WEB-INF/views/area-riservata.jsp
 *
 * POST → elabora la modifica del profilo (dati anagrafici + eventuale
 *         cambio password), aggiorna la sessione, redirect con ?aggiornato=1
 *
 * Accesso: solo utenti loggati (AuthFilter esteso o controllo interno).
 */
@WebServlet("/area-riservata")
public class AreaRiservataServlet extends HttpServlet {

    // ── GET ──────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verifica sessione
        HttpSession session = request.getSession(false);
        BeanUtente utente   = (session != null) ? (BeanUtente) session.getAttribute("utente") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            OrdineDAO   ordineDAO   = new OrdineDAO();
            ProdottoDAO prodottoDAO = new ProdottoDAO();

            // Lista ordini dell'utente, ordinati per data DESC
            List<BeanOrdine> ordini = ordineDAO.doRetrieveByUtente(utente.getEmail());

            // Per ogni ordine recupera le righe e per ogni riga il nome prodotto
            // Struttura: Map<ordineId, List<BeanProdottoOrdine>>
            Map<Integer, List<BeanProdottoOrdine>> righeMap = new LinkedHashMap<>();
            // Struttura: Map<prodottoId, nomeProdotto>
            Map<Integer, String> nomeProdottoMap = new HashMap<>();

            for (BeanOrdine o : ordini) {
                List<BeanProdottoOrdine> righe = ordineDAO.doRetrieveRighe(o.getId());
                righeMap.put(o.getId(), righe);

                for (BeanProdottoOrdine r : righe) {
                    int pid = r.getProdottoId();
                    if (!nomeProdottoMap.containsKey(pid)) {
                        BeanProdotto p = prodottoDAO.doRetrieveByKey(pid);
                        nomeProdottoMap.put(pid, p != null ? p.getNome() : "Prodotto #" + pid);
                    }
                }
            }

            request.setAttribute("utente",         utente);
            request.setAttribute("ordini",          ordini);
            request.setAttribute("righeMap",        righeMap);
            request.setAttribute("nomeProdottoMap", nomeProdottoMap);
            request.setAttribute("currentPage",     "area-riservata");

            // Messaggi di feedback
            String aggiornato = request.getParameter("aggiornato");
            String errore     = request.getParameter("errore");
            if ("1".equals(aggiornato)) request.setAttribute("msg_ok",    "Profilo aggiornato con successo!");
            if (errore != null)         request.setAttribute("msg_errore", errore);

            request.getRequestDispatcher("/WEB-INF/views/area-riservata.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Errore DB area riservata", e);
        }
    }

    // ── POST ─────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        BeanUtente utente   = (session != null) ? (BeanUtente) session.getAttribute("utente") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("modifica-profilo".equals(action)) {
            aggiornaProfilo(request, response, session, utente);
        } else {
            response.sendRedirect(request.getContextPath() + "/area-riservata");
        }
    }

    // ── Logica aggiornamento profilo ─────────────────────────────────────────

    private void aggiornaProfilo(HttpServletRequest request,
                                  HttpServletResponse response,
                                  HttpSession session,
                                  BeanUtente utente)
            throws IOException {

        String nome        = trim(request.getParameter("nome"));
        String cognome     = trim(request.getParameter("cognome"));
        String indirizzo   = trim(request.getParameter("indirizzo"));
        String nCivicoStr  = trim(request.getParameter("nCivico"));
        String cap         = trim(request.getParameter("cap"));
        String citta       = trim(request.getParameter("citta"));
        String pwNuova     = trim(request.getParameter("pwNuova"));
        String pwConferma  = trim(request.getParameter("pwConferma"));

        // Validazione campi obbligatori
        if (nome.isEmpty() || cognome.isEmpty() || indirizzo.isEmpty() ||
            nCivicoStr.isEmpty() || cap.isEmpty() || citta.isEmpty()) {
            redirect(response, request, "Tutti i campi anagrafici sono obbligatori.");
            return;
        }

        if (!cap.matches("\\d{5}")) {
            redirect(response, request, "Il CAP deve essere composto da 5 cifre.");
            return;
        }

        int nCivico;
        try {
            nCivico = Integer.parseInt(nCivicoStr);
        } catch (NumberFormatException e) {
            redirect(response, request, "Il numero civico non è valido.");
            return;
        }

        // Costruisce il bean aggiornato
        BeanUtente aggiornato = new BeanUtente();
        aggiornato.setEmail(utente.getEmail());
        aggiornato.setNome(nome);
        aggiornato.setCognome(cognome);
        aggiornato.setIndirizzo(indirizzo);
        aggiornato.setNCivico(nCivico);
        aggiornato.setCap(cap);
        aggiornato.setCitta(citta);
        aggiornato.setAdmin(utente.isAdmin());

        // Gestione cambio password (opzionale)
        boolean cambiaPassword = !pwNuova.isEmpty();
        if (cambiaPassword) {
           
            if (!pwNuova.equals(pwConferma)) {
                redirect(response, request, "Le due nuove password non coincidono.");
                return;
            }
            aggiornato.setPassword(PasswordUtils.hash(pwNuova));
        } else {
            // Nessuna modifica password: teniamo quella attuale
            aggiornato.setPassword(null);
        }

        try {
            UtenteDAO utenteDAO = new UtenteDAO();
            utenteDAO.doUpdate(aggiornato);

            // Aggiorna la sessione con i nuovi dati
            BeanUtente sessione = utenteDAO.doRetrieveByKey(utente.getEmail());
            session.setAttribute("utente", sessione);

            response.sendRedirect(request.getContextPath() + "/area-riservata?aggiornato=1");

        } catch (SQLException e) {
            redirect(response, request, "Errore durante il salvataggio. Riprova più tardi.");
        }
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request, String errore)
            throws IOException {
        response.sendRedirect(request.getContextPath() +
                "/area-riservata?errore=" + java.net.URLEncoder.encode(errore, "UTF-8"));
    }

    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }
}
