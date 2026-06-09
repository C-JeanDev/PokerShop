package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DAO.CarrelloDAO;
import model.DAO.ProdottoDAO;
import model.bean.BeanCarrello;
import model.bean.BeanProdotto;
import model.bean.BeanProdottoCarrello;
import model.bean.BeanUtente;

/**
 * AggiungiAlCarrelloServlet – aggiunge un prodotto al carrello.
 *
 * POST /aggiungi-al-carrello
 *   Parametri: prodottoId (int), quantita (int)
 *
 * Utente LOGGATO  → salva nel DB tramite CarrelloDAO
 * Utente OSPITE   → salva in sessione (List<BeanProdottoCarrello> "carrelloGuest")
 *
 * In entrambi i casi, se il prodotto era già presente, la quantità viene sommata
 * (con il limite dello stock disponibile).
 */
@WebServlet("/aggiungi-al-carrello")
public class AggiungiAlCarrelloServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Lettura e validazione parametri ──────────────────────────────
        String prodottoIdParam = request.getParameter("prodottoId");
        String quantitaParam   = request.getParameter("quantita");

        int prodottoId;
        int quantita;

        try {
            prodottoId = Integer.parseInt(prodottoIdParam.trim());
            quantita   = Integer.parseInt(quantitaParam.trim());
            if (quantita < 1) quantita = 1;
        } catch (NumberFormatException | NullPointerException e) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }

        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();

            // ── Verifica prodotto ─────────────────────────────────────────
            BeanProdotto prodotto = prodottoDAO.doRetrieveByKey(prodottoId);

            if (prodotto == null || !prodotto.isActive()) {
                response.sendRedirect(request.getContextPath() + "/catalogo");
                return;
            }

            if (prodotto.getQuantita() == 0) {
                response.sendRedirect(request.getContextPath()
                        + "/prodotto?id=" + prodottoId + "&errore=esaurito");
                return;
            }

            // Limita la quantità allo stock disponibile
            if (quantita > prodotto.getQuantita()) {
                quantita = prodotto.getQuantita();
            }

            // ── Routing: utente loggato o ospite? ────────────────────────
            HttpSession session = request.getSession(false);
            BeanUtente utente = (session != null)
                    ? (BeanUtente) session.getAttribute("utente")
                    : null;

            if (utente != null) {
                // ── UTENTE LOGGATO: salva nel DB ──────────────────────────
                aggiungiDB(utente, prodottoId, quantita, prodotto.getQuantita());
            } else {
                // ── OSPITE: salva in sessione ─────────────────────────────
                aggiungiSessione(request, prodottoId, quantita, prodotto.getQuantita());
            }

            response.sendRedirect(request.getContextPath() + "/carrello");

        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath()
                    + "/prodotto?id=" + prodottoId + "&errore=db");
        }
    }

    // ── Aggiunta al carrello DB (utente loggato) ──────────────────────────
    private void aggiungiDB(BeanUtente utente, int prodottoId, int quantita, int stockMax)
            throws SQLException {

        CarrelloDAO carrelloDAO = new CarrelloDAO();

        BeanCarrello carrello = carrelloDAO.doRetrieveByUtente(utente.getEmail());
        if (carrello == null) {
            int nuovoId = carrelloDAO.doSave(utente.getEmail());
            carrello = new BeanCarrello();
            carrello.setId(nuovoId);
        }

        // doAddProdotto usa ON DUPLICATE KEY UPDATE qt = qt + ?
        // quindi somma automaticamente se già presente.
        // Però non conosce lo stockMax: per sicurezza aggiorniamo dopo se sfora.
        carrelloDAO.doAddProdotto(carrello.getId(), prodottoId, quantita);

        // Verifica che la qt totale non superi lo stock
        List<BeanProdottoCarrello> righe = carrelloDAO.doRetrieveProdotti(carrello.getId());
        for (BeanProdottoCarrello pc : righe) {
            if (pc.getProdottoId() == prodottoId && pc.getQuantita() > stockMax) {
                carrelloDAO.doUpdateQuantita(carrello.getId(), prodottoId, stockMax);
                break;
            }
        }
    }

    // ── Aggiunta al carrello in sessione (ospite) ─────────────────────────
    static void aggiungiSessione(HttpServletRequest request,
                                 int prodottoId, int quantita, int stockMax) {
        // getSession(true) crea la sessione se non esiste ancora
        HttpSession session = request.getSession(true);

        @SuppressWarnings("unchecked")
        List<BeanProdottoCarrello> guest =
                (List<BeanProdottoCarrello>) session.getAttribute("carrelloGuest");

        if (guest == null) {
            guest = new ArrayList<>();
            session.setAttribute("carrelloGuest", guest);
        }

        // Cerca se il prodotto è già nel carrello guest
        for (BeanProdottoCarrello pc : guest) {
            if (pc.getProdottoId() == prodottoId) {
                int nuovaQt = Math.min(pc.getQuantita() + quantita, stockMax);
                pc.setQuantita(nuovaQt);
                return;
            }
        }

        // Non trovato: aggiunge nuova riga
        BeanProdottoCarrello nuova = new BeanProdottoCarrello();
        nuova.setProdottoId(prodottoId);
        nuova.setQuantita(Math.min(quantita, stockMax));
        guest.add(nuova);
    }
}
