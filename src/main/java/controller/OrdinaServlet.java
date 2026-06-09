package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DAO.CarrelloDAO;
import model.DAO.OrdineDAO;
import model.DAO.ProdottoDAO;
import model.bean.BeanCarrello;
import model.bean.BeanOrdine;
import model.bean.BeanProdotto;
import model.bean.BeanProdottoCarrello;
import model.bean.BeanProdottoOrdine;
import model.bean.BeanUtente;

/**
 * OrdinaServlet – gestisce il "Procedi all'ordine".
 *
 * POST /ordina → crea l'ordine nel DB, svuota il carrello,
 *                reindirizza al carrello con parametro ?ordinato=1
 *
 * Solo utenti loggati: AuthFilter (o il controllo interno) rimanda al login
 * se la sessione è assente o non contiene "utente".
 */
@WebServlet("/ordina")
public class OrdinaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Verifica che l'utente sia loggato ─────────────────────────
        HttpSession session = request.getSession(false);
        BeanUtente utente = (session != null)
                ? (BeanUtente) session.getAttribute("utente")
                : null;

        if (utente == null) {
            // Ospite: manda al login, poi torna al carrello
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            CarrelloDAO carrelloDAO = new CarrelloDAO();
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            OrdineDAO   ordineDAO   = new OrdineDAO();

            // ── 2. Recupera il carrello dell'utente ──────────────────────
            BeanCarrello carrello = carrelloDAO.doRetrieveByUtente(utente.getEmail());

            if (carrello == null) {
                // Carrello non esiste in DB: torna al carrello con errore
                response.sendRedirect(request.getContextPath() + "/carrello?errore=carrello_vuoto");
                return;
            }

            List<BeanProdottoCarrello> righeCarrello =
                    carrelloDAO.doRetrieveProdotti(carrello.getId());

            if (righeCarrello == null || righeCarrello.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/carrello?errore=carrello_vuoto");
                return;
            }

            // ── 3. Costruisce le righe d'ordine e calcola il totale ──────
            List<BeanProdottoOrdine> righeOrdine = new ArrayList<>();
            double costoTotale = 0.0;

            for (BeanProdottoCarrello pc : righeCarrello) {
                BeanProdotto p = prodottoDAO.doRetrieveByKey(pc.getProdottoId());
                if (p == null) continue; // prodotto rimosso nel frattempo

                BeanProdottoOrdine riga = new BeanProdottoOrdine();
                riga.setProdottoId(p.getId());
                riga.setIva(p.getIva());
                riga.setPrezzo(p.getPrezzoFinale());   // prezzo storico al momento dell'ordine
                riga.setQuantita(pc.getQuantita());
                righeOrdine.add(riga);

                costoTotale += p.getPrezzoFinale() * pc.getQuantita();
            }

            if (righeOrdine.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/carrello?errore=carrello_vuoto");
                return;
            }

            // ── 4. Crea il bean ordine ───────────────────────────────────
            BeanOrdine ordine = new BeanOrdine();
            ordine.setCostoTot(costoTotale);
            ordine.setUtenteEmail(utente.getEmail());
            // stato e data vengono impostati dal DAO ("NE" e oggi)

            // ── 5. Salva ordine + righe in transazione (OrdineDAO) ───────
            ordineDAO.doSave(ordine, righeOrdine);

            // ── 6. Svuota il carrello ────────────────────────────────────
            carrelloDAO.doEmpty(carrello.getId());

            // ── 7. Reindirizza al carrello con flag "ordinato" ───────────
            response.sendRedirect(request.getContextPath() + "/carrello?ordinato=1");

        } catch (SQLException e) {
            // Errore DB: torna al carrello con messaggio di errore generico
            response.sendRedirect(request.getContextPath() + "/carrello?errore=db");
        }
    }

    /** GET non supportato: reindirizza al carrello */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/carrello");
    }
}
