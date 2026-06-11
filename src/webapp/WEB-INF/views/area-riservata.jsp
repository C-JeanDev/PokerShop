<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanUtente, model.bean.BeanOrdine, model.bean.BeanProdottoOrdine,
                 java.util.List, java.util.Map" %>
<%
    BeanUtente utente = (BeanUtente) request.getAttribute("utente");
    @SuppressWarnings("unchecked")
    List<BeanOrdine> ordini = (List<BeanOrdine>) request.getAttribute("ordini");
    @SuppressWarnings("unchecked")
    Map<Integer, List<BeanProdottoOrdine>> righeMap =
        (Map<Integer, List<BeanProdottoOrdine>>) request.getAttribute("righeMap");
    @SuppressWarnings("unchecked")
    Map<Integer, String> nomeProdottoMap = (Map<Integer, String>) request.getAttribute("nomeProdottoMap");

    String msgOk     = (String) request.getAttribute("msg_ok");
    String msgErrore = (String) request.getAttribute("msg_errore");

    if (ordini          == null) ordini          = new java.util.ArrayList<>();
    if (righeMap        == null) righeMap        = new java.util.HashMap<>();
    if (nomeProdottoMap == null) nomeProdottoMap = new java.util.HashMap<>();

    // Mappa etichette stato ordine
    java.util.Map<String, String> statoLabel = new java.util.HashMap<>();
    statoLabel.put("NE", "Nuovo / In elaborazione");
    statoLabel.put("SP", "Spedito");
    statoLabel.put("CO", "Consegnato");
    statoLabel.put("AN", "Annullato");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PokerShop – Area Riservata</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/area-riservata.css">
</head>
<body>

<%-- ── Header ─────────────────────────────────────────────────────────────── --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<main class="ar-wrapper">

    <%-- ── Titolo pagina ──────────────────────────────────────────────────── --%>
    <div class="ar-hero">
        <span class="ar-hero-icon">♠</span>
        <div>
            <h1>Area Riservata</h1>
            <p>Benvenuto, <strong><%= utente.getNome() %> <%= utente.getCognome() %></strong></p>
        </div>
    </div>

    <%-- ── Messaggi di feedback ───────────────────────────────────────────── --%>
    <% if (msgOk != null) { %>
        <div class="ar-alert ar-alert-ok">✔ <%= msgOk %></div>
    <% } %>
    <% if (msgErrore != null) { %>
        <div class="ar-alert ar-alert-err">✖ <%= msgErrore %></div>
    <% } %>

    <%-- ═══════════════════════════════════════════════════════════════════════
         SEZIONE 1 – DATI PERSONALI
    ══════════════════════════════════════════════════════════════════════════ --%>
    <section class="ar-section">
        <h2 class="ar-section-title">♣ Dati Personali</h2>

        <%-- Vista sola-lettura --%>
        <div class="ar-info-grid" id="viewPanel">
            <div class="ar-info-item">
                <span class="ar-info-label">Nome</span>
                <span class="ar-info-value"><%= utente.getNome() %></span>
            </div>
            <div class="ar-info-item">
                <span class="ar-info-label">Cognome</span>
                <span class="ar-info-value"><%= utente.getCognome() %></span>
            </div>
            <div class="ar-info-item ar-full">
                <span class="ar-info-label">Email</span>
                <span class="ar-info-value"><%= utente.getEmail() %></span>
            </div>
            <div class="ar-info-item ar-full">
                <span class="ar-info-label">Indirizzo</span>
                <span class="ar-info-value">
                    <%= utente.getIndirizzo() %>, <%= utente.getNCivico() %>
                    – <%= utente.getCap() %> <%= utente.getCitta() %>
                </span>
            </div>
        </div>
        <button class="ar-btn ar-btn-outline" onclick="toggleEdit()">✏ Modifica Profilo</button>

        <%-- Form di modifica (nascosto inizialmente) --%>
        <form method="post" action="<%= request.getContextPath() %>/area-riservata"
              class="ar-form" id="editForm" style="display:none;">

            <input type="hidden" name="action" value="modifica-profilo">

            <div class="ar-form-grid">
                <div class="ar-form-group">
                    <label for="nome">Nome *</label>
                    <input type="text" id="nome" name="nome"
                           value="<%= utente.getNome() %>" required maxlength="30">
                </div>
                <div class="ar-form-group">
                    <label for="cognome">Cognome *</label>
                    <input type="text" id="cognome" name="cognome"
                           value="<%= utente.getCognome() %>" required maxlength="30">
                </div>
                <div class="ar-form-group">
                    <label for="indirizzo">Indirizzo (via/piazza) *</label>
                    <input type="text" id="indirizzo" name="indirizzo"
                           value="<%= utente.getIndirizzo() %>" required maxlength="30">
                </div>
                <div class="ar-form-group">
                    <label for="nCivico">N° Civico *</label>
                    <input type="number" id="nCivico" name="nCivico"
                           value="<%= utente.getNCivico() %>" required min="1">
                </div>
                <div class="ar-form-group">
                    <label for="cap">CAP *</label>
                    <input type="text" id="cap" name="cap"
                           value="<%= utente.getCap() %>" required pattern="[0-9]{5}" maxlength="5">
                </div>
                <div class="ar-form-group">
                    <label for="citta">Città *</label>
                    <input type="text" id="citta" name="citta"
                           value="<%= utente.getCitta() %>" required maxlength="20">
                </div>
            </div>

           <%-- Cambio password (opzionale) --%>
            <div class="ar-pw-section">
                <h3 class="ar-pw-title">🔒 Cambio Password <span class="ar-optional">(opzionale)</span></h3>
                <div class="ar-form-grid">
                    <div class="ar-form-group">
                        <label for="pwNuova">Nuova password</label>
                        <input type="password" id="pwNuova" name="pwNuova"
                               placeholder="Lascia vuoto per non cambiare" autocomplete="new-password">
                    </div>
                    <div class="ar-form-group">
                        <label for="pwConferma">Conferma nuova password</label>
                        <input type="password" id="pwConferma" name="pwConferma"
                               placeholder="Ripeti la nuova password" autocomplete="new-password">
                    </div>
                </div>
            </div>

            <div class="ar-form-actions">
                <button type="submit" class="ar-btn ar-btn-primary"
                        onclick="return confirm('Confermi il salvataggio delle modifiche al profilo?');">💾 Salva Modifiche</button>
                <button type="button" class="ar-btn ar-btn-ghost" onclick="toggleEdit()">Annulla</button>
            </div>
        </form>
    </section>

    <%-- ═══════════════════════════════════════════════════════════════════════
         SEZIONE 2 – FATTURE ORDINI
    ══════════════════════════════════════════════════════════════════════════ --%>
    <section class="ar-section">
        <h2 class="ar-section-title">♦ I Miei Ordini</h2>

        <% if (ordini.isEmpty()) { %>
            <div class="ar-empty">
                <span>🃏</span>
                <p>Non hai ancora effettuato ordini.</p>
                <a href="<%= request.getContextPath() %>/catalogo" class="ar-btn ar-btn-primary">
                    Vai al Catalogo →
                </a>
            </div>

        <% } else { %>
            <p class="ar-orders-count"><strong><%= ordini.size() %></strong>
               ordine<%= ordini.size() != 1 ? "i" : "" %> trovato<%= ordini.size() != 1 ? "i" : "" %></p>

            <% for (BeanOrdine ordine : ordini) {
                List<BeanProdottoOrdine> righe = righeMap.getOrDefault(ordine.getId(), new java.util.ArrayList<>());
                String statoStr = statoLabel.getOrDefault(ordine.getStato(), ordine.getStato());
                boolean isAnnullato = "AN".equals(ordine.getStato());
                boolean isConsegnato = "CO".equals(ordine.getStato());
                
                // FIX: Calcoliamo la classe CSS qui in Java per evitare problemi di parsing HTML con le virgolette
                String classeStato = isAnnullato ? "stato-an" : (isConsegnato ? "stato-co" : "stato-ne");
            %>

            <%-- ── Fattura ordine (con Accordion) ──────────────────────── --%>
            <article class="fattura" id="fattura-<%= ordine.getId() %>">

                <%-- Intestazione fattura cliccabile --%>
                <header class="fattura-header" onclick="toggleFattura('<%= ordine.getId() %>')">
                    <div class="fattura-logo">
                        <span class="fattura-toggle-icon">▼</span> ♠ PokerShop
                    </div>
                    <div class="fattura-meta">
                        <span class="fattura-num">Ordine #<%= ordine.getId() %></span>
                        <span class="fattura-data">
                            <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(ordine.getData()) %>
                        </span>
                        <%-- Usiamo la variabile calcolata per non rompere l'HTML --%>
                        <span class="fattura-stato <%= classeStato %>">
                            <%= statoStr %>
                        </span>
                    </div>
                </header>

                <%-- Contenitore nascosto --%>
                <div class="fattura-content">
                    <%-- Dati cliente nella fattura --%>
                    <div class="fattura-intestatario">
                        <div class="fattura-block">
                            <div class="fattura-block-title">INTESTATARIO</div>
                            <div class="fattura-block-body">
                                <strong><%= utente.getNome() %> <%= utente.getCognome() %></strong><br>
                                <%= utente.getEmail() %><br>
                                <%= utente.getIndirizzo() %>, <%= utente.getNCivico() %><br>
                                <%= utente.getCap() %> <%= utente.getCitta() %>
                            </div>
                        </div>
                        <div class="fattura-block">
                            <div class="fattura-block-title">VENDITORE</div>
                            <div class="fattura-block-body">
                                <strong>PokerShop S.r.l.</strong><br>
                                info@pokershop.it<br>
                                Via del Texas Hold'em, 21<br>
                                80100 Napoli (NA)
                            </div>
                        </div>
                    </div>

                    <%-- Tabella prodotti dell'ordine --%>
                    <div class="fattura-table-wrap">
                        <table class="fattura-table">
                            <thead>
                                <tr>
                                    <th class="col-prodotto">Prodotto</th>
                                    <th class="col-num">IVA</th>
                                    <th class="col-num">Prezzo unit.</th>
                                    <th class="col-num">Qt.</th>
                                    <th class="col-num">Totale</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (BeanProdottoOrdine riga : righe) {
                                    String nomeProd = nomeProdottoMap.getOrDefault(
                                        riga.getProdottoId(), "Prodotto #" + riga.getProdottoId());
                                    double totaleRiga = riga.getPrezzo() * riga.getQuantita();
                                %>
                                <tr>
                                    <td class="col-prodotto">
                                        <%= nomeProd %>
                                        <span class="fattura-pid">(id: <%= riga.getProdottoId() %>)</span>
                                    </td>
                                    <td class="col-num"><%= riga.getIva() %>%</td>
                                    <td class="col-num">€ <%= String.format("%.2f", riga.getPrezzo()) %></td>
                                    <td class="col-num"><%= riga.getQuantita() %></td>
                                    <td class="col-num fattura-riga-tot">
                                        € <%= String.format("%.2f", totaleRiga) %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                            <tfoot>
                                <tr class="fattura-footer-row">
                                    <td colspan="4" class="col-prodotto fattura-footer-label">
                                        TOTALE ORDINE (IVA incl.)
                                    </td>
                                    <td class="col-num fattura-total">
                                        € <%= String.format("%.2f", ordine.getCostoTot()) %>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <%-- Card responsive per mobile --%>
                    <div class="fattura-cards-mobile">
                        <% for (BeanProdottoOrdine riga : righe) {
                            String nomeProd = nomeProdottoMap.getOrDefault(
                                riga.getProdottoId(), "Prodotto #" + riga.getProdottoId());
                            double totaleRiga = riga.getPrezzo() * riga.getQuantita();
                        %>
                        <div class="fattura-card-row">
                            <div class="fattura-card-name"><%= nomeProd %></div>
                            <div class="fattura-card-detail">
                                <span>IVA <%= riga.getIva() %>%</span>
                                <span>× <%= riga.getQuantita() %></span>
                                <span>€ <%= String.format("%.2f", riga.getPrezzo()) %>/cad.</span>
                            </div>
                            <div class="fattura-card-tot">
                                Totale: <strong>€ <%= String.format("%.2f", totaleRiga) %></strong>
                            </div>
                        </div>
                        <% } %>
                        <div class="fattura-card-grandtot">
                            TOTALE ORDINE &nbsp;
                            <strong>€ <%= String.format("%.2f", ordine.getCostoTot()) %></strong>
                        </div>
                    </div>

                    <%-- Footer fattura --%>
                    <footer class="fattura-note">
                        Documento generato automaticamente da PokerShop · Ordine #<%= ordine.getId() %>
                        del <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(ordine.getData()) %>
                    </footer>

                </div> <%-- Fine .fattura-content --%>
            </article>
            <% } /* fine for ordini */ %>
        <% } /* fine else */ %>
    </section>

</main>

<script>
    function toggleEdit() {
        var viewPanel = document.getElementById('viewPanel');
        var editForm  = document.getElementById('editForm');
        var isHidden  = editForm.style.display === 'none';

        viewPanel.style.display = isHidden ? 'none' : 'grid';
        editForm.style.display  = isHidden ? 'block' : 'none';

        if (isHidden) {
            editForm.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    function toggleFattura(ordineId) {
        var fatturaElement = document.getElementById('fattura-' + ordineId);
        if (fatturaElement) {
            fatturaElement.classList.toggle('is-open');
        }
    }
</script>
</body>
</html>