<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="controller.CarrelloServlet.RigaCarrello, model.bean.BeanProdotto, java.util.List, java.util.Map" %>
<%
    @SuppressWarnings("unchecked")
    List<RigaCarrello>  righe   = (List<RigaCarrello>)  request.getAttribute("righe");
    @SuppressWarnings("unchecked")
    Map<Integer,String> fotoMap = (Map<Integer,String>) request.getAttribute("fotoMap");
    Double  totale   = (Double)  request.getAttribute("totale");
    String  erroreDB = (String)  request.getAttribute("erroreDB");
    Boolean isGuest  = (Boolean) request.getAttribute("isGuest");
    if (isGuest == null) isGuest = false;

    // Parametri querystring per feedback post-ordine
    String ordinato  = request.getParameter("ordinato");
    String erroreQS  = request.getParameter("errore");
    boolean ordineOK = "1".equals(ordinato);

    if (righe   == null) righe   = new java.util.ArrayList<>();
    if (fotoMap == null) fotoMap = new java.util.HashMap<>();
    if (totale  == null) totale  = 0.0;

    int nArticoli = 0;
    for (RigaCarrello r : righe) nArticoli += r.getQuantita();
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrello – PokerShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/carrello.css">
</head>
<body>

<jsp:include page="/WEB-INF/fragments/header.jsp" />

<div class="page-title-bar">
    <h1>🛒 Il tuo carrello</h1>
    <p>
        <% if (righe.isEmpty()) { %>
            Il carrello è vuoto
        <% } else { %>
            <%= nArticoli %> articol<%= nArticoli == 1 ? "o" : "i" %> in <%= righe.size() %> prodott<%= righe.size() == 1 ? "o" : "i" %>
        <% } %>
    </p>
</div>

<% if (ordineOK) { %>
<div style="background:rgba(27,94,32,0.2);border:1px solid rgba(46,125,50,0.55);
            color:#A5D6A7;padding:16px 24px;display:flex;align-items:center;
            gap:14px;font-size:0.95rem;">
    <span style="font-size:1.4rem;">&#x2705;</span>
    <span>
        <strong>Ordine effettuato con successo!</strong>
        Il tuo ordine e' stato registrato e verra' elaborato a breve.
        Grazie per aver acquistato su PokerShop!
    </span>
</div>
<% } %>

<% if ("db".equals(erroreQS)) { %>
<div style="background:rgba(211,47,47,0.12);border:1px solid #D32F2F;
            color:#EF9A9A;padding:14px 24px;display:flex;align-items:center;
            gap:12px;font-size:0.9rem;">
    <span>&#x26A0; Si e' verificato un errore durante la creazione dell'ordine. Riprova piu' tardi.</span>
</div>
<% } %>
<% if ("carrello_vuoto".equals(erroreQS)) { %>
<div style="background:rgba(211,47,47,0.12);border:1px solid #D32F2F;
            color:#EF9A9A;padding:14px 24px;display:flex;align-items:center;
            gap:12px;font-size:0.9rem;">
    <span>&#x26A0; Il carrello e' vuoto: aggiungi almeno un prodotto prima di procedere.</span>
</div>
<% } %>

<% if (Boolean.TRUE.equals(isGuest)) { %>
<div style="background:rgba(212,175,55,0.1);border:1px solid rgba(212,175,55,0.35);
            color:#D4AF37;padding:13px 20px;display:flex;align-items:center;
            gap:12px;font-size:0.88rem;">
    <span style="font-size:1.1rem;">ℹ</span>
    <span>
        Stai navigando come ospite. Il carrello verrà perso alla chiusura del browser.
        <a href="<%= request.getContextPath() %>/login"
           style="color:#D4AF37;font-weight:700;margin-left:6px;text-decoration:underline;">
            Accedi</a> o
        <a href="<%= request.getContextPath() %>/registrazione"
           style="color:#D4AF37;font-weight:700;margin-left:2px;text-decoration:underline;">
            Registrati</a>
        per salvare il carrello.
    </span>
</div>
<% } %>

<% if (erroreDB != null) { %>
    <div style="max-width:1100px;margin:18px auto 0;padding:0 24px;">
        <div class="error-box">⚠ <%= erroreDB %></div>
    </div>
<% } %>

<div class="carrello-layout">

    <%-- ═══════════════════════════════════════════════════════════════
         COLONNA SINISTRA – Lista prodotti
         ═══════════════════════════════════════════════════════════════ --%>
    <div class="carrello-items">

        <% if (righe.isEmpty()) { %>
            <div class="cart-empty">
                <div class="cart-empty-icon">🛒</div>
                <p>Non hai ancora aggiunto nessun prodotto al carrello.</p>
                <a href="<%= request.getContextPath() %>/catalogo" class="btn-vai-catalogo">
                    Vai al catalogo
                </a>
            </div>

        <% } else {
            for (RigaCarrello riga : righe) {
                BeanProdotto p = riga.getProdotto();
                int qt         = riga.getQuantita();
                String foto    = fotoMap.get(p.getId());
                double totRiga = p.getPrezzoFinale() * qt;
                boolean sconto = p.getPrezzoListino() > p.getPrezzoFinale();
        %>
        <div class="cart-row">

            <%-- Immagine --%>
            <div class="cart-row-img">
                <% if (foto != null && !foto.isEmpty()) { %>
                    <img src="<%= request.getContextPath() %>/<%= foto %>"
                         alt="<%= p.getNome() %>" loading="lazy">
                <% } else { %>
                    <div class="cart-row-img-placeholder">♠</div>
                <% } %>
            </div>

            <%-- Info prodotto --%>
            <div class="cart-row-info">
                <div class="cart-row-nome">
                    <a href="<%= request.getContextPath() %>/prodotto?id=<%= p.getId() %>">
                        <%= p.getNome() %>
                    </a>
                </div>
                <div class="cart-row-prezzo-unit">
                    <% if (sconto) { %>
                        <span style="text-decoration:line-through;color:rgba(255,255,255,0.3);margin-right:6px;">
                            € <%= String.format("%.2f", p.getPrezzoListino()) %>
                        </span>
                    <% } %>
                    € <%= String.format("%.2f", p.getPrezzoFinale()) %> / pz
                </div>
                <div class="cart-row-prezzo-tot">
                    Totale: € <%= String.format("%.2f", totRiga) %>
                </div>
            </div>

            <%-- Quantità + rimuovi --%>
            <div class="cart-row-actions">

                <%-- Form aggiorna quantità --%>
                <form method="post" action="<%= request.getContextPath() %>/carrello"
                      class="cart-qty-form"
                      id="form-qty-<%= p.getId() %>">
                    <input type="hidden" name="azione"     value="aggiorna">
                    <input type="hidden" name="prodottoId" value="<%= p.getId() %>">

                    <button type="button" class="cart-qty-btn"
                            onclick="cambiaQtCarrello(<%= p.getId() %>, -1, <%= p.getQuantita() %>)"
                            <%= qt <= 1 ? "disabled" : "" %>>−</button>

                    <input type="number"
                           id="qty-<%= p.getId() %>"
                           name="quantita"
                           class="cart-qty-input"
                           value="<%= qt %>"
                           min="1"
                           max="<%= p.getQuantita() %>"
                           onchange="submitQtForm(<%= p.getId() %>)">

                    <button type="button" class="cart-qty-btn"
                            onclick="cambiaQtCarrello(<%= p.getId() %>, 1, <%= p.getQuantita() %>)"
                            <%= qt >= p.getQuantita() ? "disabled" : "" %>>+</button>
                </form>

                <%-- Form rimuovi --%>
                <form method="post" action="<%= request.getContextPath() %>/carrello">
                    <input type="hidden" name="azione"     value="rimuovi">
                    <input type="hidden" name="prodottoId" value="<%= p.getId() %>">
                    <button type="submit" class="btn-rimuovi">✕ Rimuovi</button>
                </form>

            </div>
        </div>
        <% } } %>
    </div>

    <%-- ═══════════════════════════════════════════════════════════════
         COLONNA DESTRA – Riepilogo ordine
         ═══════════════════════════════════════════════════════════════ --%>
    <div class="cart-summary">
        <h2>Riepilogo ordine</h2>

        <div class="summary-row">
            <span>Articoli (<%= nArticoli %>)</span>
            <span>€ <%= String.format("%.2f", totale) %></span>
        </div>
        <div class="summary-row">
            <span>Spedizione</span>
            <span><% if (righe.isEmpty()) { %>—<% } else { %>Gratuita<% } %></span>
        </div>

        <div class="summary-row total">
            <span>Totale</span>
            <span>€ <%= String.format("%.2f", totale) %></span>
        </div>

        <%-- Bottone procedi all'ordine --%>
        <% if (righe.isEmpty()) { %>
            <button class="btn-procedi" disabled>Procedi all'ordine</button>
        <% } else if (Boolean.TRUE.equals(isGuest)) { %>
            <%-- Ospite: manda al login con messaggio --%>
            <a href="<%= request.getContextPath() %>/login"
               class="btn-procedi"
               style="display:block;text-align:center;text-decoration:none;">
                Accedi per ordinare
            </a>
        <% } else { %>
            <form method="post" action="<%= request.getContextPath() %>/ordina"
                  style="margin:0;" id="form-ordina">
                <button type="submit" class="btn-procedi"
                        onclick="return confirm('Confermi l\'ordine?');">
                    Procedi all'ordine
                </button>
            </form>
        <% } %>

        <%-- Svuota carrello --%>
        <% if (!righe.isEmpty()) { %>
        <form method="post" action="<%= request.getContextPath() %>/carrello">
            <input type="hidden" name="azione" value="svuota">
            <button type="submit" class="btn-svuota">✕ Svuota carrello</button>
        </form>
        <% } %>
    </div>

</div>

<script>
(function () {
    "use strict";

    // Incrementa/decrementa la quantità e invia subito il form
    window.cambiaQtCarrello = function (prodottoId, delta, maxQt) {
        var input = document.getElementById("qty-" + prodottoId);
        if (!input) return;
        var val = parseInt(input.value, 10) || 1;
        val = Math.max(1, Math.min(maxQt, val + delta));
        input.value = val;
        submitQtForm(prodottoId);
    };

    // Invia il form di aggiornamento quantità
    window.submitQtForm = function (prodottoId) {
        var form = document.getElementById("form-qty-" + prodottoId);
        if (form) form.submit();
    };

})();
</script>

</body>
</html>
