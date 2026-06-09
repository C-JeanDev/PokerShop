package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DAO.CarrelloDAO;
import model.DAO.FotoDAO;
import model.DAO.ProdottoDAO;
import model.bean.BeanCarrello;
import model.bean.BeanFoto;
import model.bean.BeanProdottoCarrello;
import model.bean.BeanProdotto;
import model.bean.BeanUtente;

/**
 * CarrelloServlet – mostra e gestisce il carrello.
 *
 * Supporta due modalità:
 *   - Utente LOGGATO  → persistenza su DB tramite CarrelloDAO
 *   - Utente OSPITE   → persistenza temporanea in sessione HTTP
 *                        (List<BeanProdottoCarrello> con chiave "carrelloGuest")
 *
 * GET  /carrello                                        → mostra il carrello
 * POST /carrello  azione=aggiorna  prodottoId=X  quantita=N  → aggiorna quantità
 * POST /carrello  azione=rimuovi   prodottoId=X             → rimuove prodotto
 * POST /carrello  azione=svuota                             → svuota tutto
 */
@WebServlet("/carrello")
public class CarrelloServlet extends HttpServlet {

    // ════════════════════════════════════════════════════════════════════
    // GET – mostra il carrello
    // ════════════════════════════════════════════════════════════════════
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BeanUtente utente = getUtente(request);

        if (utente != null) {
            caricaCarrelloDB(request, utente);
        } else {
            caricaCarrelloGuest(request);
        }

        request.setAttribute("currentPage", "carrello");
        request.setAttribute("isGuest", utente == null);
        request.getRequestDispatcher("/WEB-INF/views/carrello.jsp")
               .forward(request, response);
    }

    // ════════════════════════════════════════════════════════════════════
    // POST – azioni sul carrello
    // ════════════════════════════════════════════════════════════════════
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String azione = request.getParameter("azione");
        BeanUtente utente = getUtente(request);

        if (utente != null) {
            gestisciAzioneDB(request, response, utente, azione);
        } else {
            gestisciAzioneGuest(request, azione);
            response.sendRedirect(request.getContextPath() + "/carrello");
        }
    }

    // ════════════════════════════════════════════════════════════════════
    // CARRELLO DB (utente loggato)
    // ════════════════════════════════════════════════════════════════════

    private void caricaCarrelloDB(HttpServletRequest request, BeanUtente utente) {
        try {
            CarrelloDAO carrelloDAO = new CarrelloDAO();
            BeanCarrello carrello = carrelloDAO.doRetrieveByUtente(utente.getEmail());

            if (carrello == null) {
                impostaCarrelloVuoto(request);
                return;
            }

            popolaRighe(request, carrelloDAO.doRetrieveProdotti(carrello.getId()));

        } catch (SQLException e) {
            request.setAttribute("erroreDB", "Impossibile caricare il carrello. Riprovare più tardi.");
            impostaCarrelloVuoto(request);
        }
    }

    private void gestisciAzioneDB(HttpServletRequest request, HttpServletResponse response,
                                  BeanUtente utente, String azione) throws IOException {
        try {
            CarrelloDAO carrelloDAO = new CarrelloDAO();
            BeanCarrello carrello  = carrelloDAO.doRetrieveByUtente(utente.getEmail());

            if (carrello != null) {
                if ("rimuovi".equals(azione)) {
                    int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
                    carrelloDAO.doRemoveProdotto(carrello.getId(), prodottoId);

                } else if ("aggiorna".equals(azione)) {
                    int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
                    int quantita   = Integer.parseInt(request.getParameter("quantita"));
                    if (quantita < 1) {
                        carrelloDAO.doRemoveProdotto(carrello.getId(), prodottoId);
                    } else {
                        carrelloDAO.doUpdateQuantita(carrello.getId(), prodottoId, quantita);
                    }

                } else if ("svuota".equals(azione)) {
                    carrelloDAO.doEmpty(carrello.getId());
                }
            }

        } catch (SQLException | NumberFormatException e) {
            // errore silenzioso: torna al carrello che mostrerà lo stato attuale
        }

        response.sendRedirect(request.getContextPath() + "/carrello");
    }

    // ════════════════════════════════════════════════════════════════════
    // CARRELLO GUEST (sessione)
    // ════════════════════════════════════════════════════════════════════

    private void caricaCarrelloGuest(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        @SuppressWarnings("unchecked")
        List<BeanProdottoCarrello> guest = (session != null)
                ? (List<BeanProdottoCarrello>) session.getAttribute("carrelloGuest")
                : null;

        if (guest == null || guest.isEmpty()) {
            impostaCarrelloVuoto(request);
            return;
        }

        popolaRighe(request, guest);
    }

    private void gestisciAzioneGuest(HttpServletRequest request, String azione) {
        HttpSession session = request.getSession(false);
        if (session == null) return;

        @SuppressWarnings("unchecked")
        List<BeanProdottoCarrello> guest =
                (List<BeanProdottoCarrello>) session.getAttribute("carrelloGuest");

        if (guest == null) return;

        try {
            if ("rimuovi".equals(azione)) {
                int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
                guest.removeIf(pc -> pc.getProdottoId() == prodottoId);

            } else if ("aggiorna".equals(azione)) {
                int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
                int quantita   = Integer.parseInt(request.getParameter("quantita"));
                if (quantita < 1) {
                    guest.removeIf(pc -> pc.getProdottoId() == prodottoId);
                } else {
                    for (BeanProdottoCarrello pc : guest) {
                        if (pc.getProdottoId() == prodottoId) {
                            pc.setQuantita(quantita);
                            break;
                        }
                    }
                }

            } else if ("svuota".equals(azione)) {
                guest.clear();
            }

        } catch (NumberFormatException ignored) {}
    }

    // ════════════════════════════════════════════════════════════════════
    // MERGE carrello guest → DB al login
    // Chiamato da LoginServlet dopo l'autenticazione riuscita.
    // ════════════════════════════════════════════════════════════════════

    /**
     * Trasferisce il carrello guest (in sessione) nel carrello DB dell'utente.
     * Deve essere chiamato da LoginServlet subito dopo aver impostato l'utente
     * in sessione. Dopo il merge, "carrelloGuest" viene rimosso dalla sessione.
     */
    public static void mergeGuestCarrello(HttpSession session, String emailUtente)
            throws SQLException {

        @SuppressWarnings("unchecked")
        List<BeanProdottoCarrello> guest =
                (List<BeanProdottoCarrello>) session.getAttribute("carrelloGuest");

        if (guest == null || guest.isEmpty()) return;

        CarrelloDAO carrelloDAO = new CarrelloDAO();

        BeanCarrello carrello = carrelloDAO.doRetrieveByUtente(emailUtente);
        if (carrello == null) {
            int nuovoId = carrelloDAO.doSave(emailUtente);
            carrello = new BeanCarrello();
            carrello.setId(nuovoId);
        }

        for (BeanProdottoCarrello pc : guest) {
            // doAddProdotto usa ON DUPLICATE KEY UPDATE qt = qt + ?
            // quindi i prodotti già presenti nel carrello DB vengono sommati
            carrelloDAO.doAddProdotto(carrello.getId(), pc.getProdottoId(), pc.getQuantita());
        }

        // Pulizia: rimuove il carrello guest dalla sessione
        session.removeAttribute("carrelloGuest");
    }

    // ════════════════════════════════════════════════════════════════════
    // UTILITY condivise
    // ════════════════════════════════════════════════════════════════════

    /**
     * Dato un elenco di BeanProdottoCarrello, carica i dati di ogni prodotto
     * e la prima foto, calcola il totale e imposta gli attributi di request.
     */
    private void popolaRighe(HttpServletRequest request,
                              List<BeanProdottoCarrello> righeRaw) {
        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            FotoDAO     fotoDAO    = new FotoDAO();

            List<RigaCarrello>   righe   = new ArrayList<>();
            Map<Integer, String> fotoMap = new HashMap<>();
            double totale = 0.0;

            for (BeanProdottoCarrello pc : righeRaw) {
                BeanProdotto p = prodottoDAO.doRetrieveByKey(pc.getProdottoId());
                if (p == null) continue;

                List<BeanFoto> fotos = fotoDAO.doRetrieveByProdotto(p.getId());
                fotoMap.put(p.getId(), fotos.isEmpty() ? null : fotos.get(0).getPath());

                totale += p.getPrezzoFinale() * pc.getQuantita();
                righe.add(new RigaCarrello(p, pc.getQuantita()));
            }

            request.setAttribute("righe",   righe);
            request.setAttribute("fotoMap", fotoMap);
            request.setAttribute("totale",  totale);

        } catch (SQLException e) {
            request.setAttribute("erroreDB", "Impossibile caricare i prodotti del carrello.");
            impostaCarrelloVuoto(request);
        }
    }

    private void impostaCarrelloVuoto(HttpServletRequest request) {
        request.setAttribute("righe",   new ArrayList<>());
        request.setAttribute("fotoMap", new HashMap<>());
        request.setAttribute("totale",  0.0);
    }

    private BeanUtente getUtente(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (BeanUtente) session.getAttribute("utente") : null;
    }

    // ════════════════════════════════════════════════════════════════════
    // Classe di supporto per la view
    // ════════════════════════════════════════════════════════════════════

    public static class RigaCarrello {
        private final BeanProdotto prodotto;
        private final int          quantita;

        public RigaCarrello(BeanProdotto prodotto, int quantita) {
            this.prodotto = prodotto;
            this.quantita = quantita;
        }
        public BeanProdotto getProdotto() { return prodotto; }
        public int          getQuantita() { return quantita; }
    }
}
