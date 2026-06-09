<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="model.bean.BeanProdotto, model.bean.BeanFoto, java.util.List" %>
<%
    BeanProdotto prodotto  = (BeanProdotto) request.getAttribute("prodotto");
    @SuppressWarnings("unchecked")
    List<BeanFoto> foto    = (List<BeanFoto>) request.getAttribute("foto");
    Boolean sconto         = (Boolean)  request.getAttribute("sconto");
    Integer scontoPerc     = (Integer)  request.getAttribute("scontoPerc");
    String  erroreDB       = (String)   request.getAttribute("erroreDB");
    String  erroreParam    = request.getParameter("errore");

    if (foto     == null) foto     = new java.util.ArrayList<>();
    if (sconto   == null) sconto   = false;
    if (scontoPerc == null) scontoPerc = 0;
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= prodotto != null ? prodotto.getNome() + " – PokerShop" : "Prodotto non trovato – PokerShop" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dettaglio-prodotto.css">
</head>
<body>

<%-- ── Fragment Header/Navbar ─────────────────────────────────────────── --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- ── Messaggio errore DB ─────────────────────────────────────────────── --%>
<% if (erroreDB != null) { %>
    <div class="error-box">⚠ <%= erroreDB %></div>
<% } %>

<%-- ── Breadcrumb ─────────────────────────────────────────────────────── --%>
<div class="breadcrumb">
    <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
    <span>›</span>
    <a href="<%= request.getContextPath() %>/catalogo">Catalogo</a>
    <% if (prodotto != null) { %>
        <span>›</span>
        <span class="current"><%= prodotto.getNome() %></span>
    <% } %>
</div>

<%-- ── Contenuto principale ────────────────────────────────────────────── --%>
<% if (prodotto != null) {

    // Calcola stock status
    String stockClass = prodotto.getQuantita() > 5 ? "ok"
                      : prodotto.getQuantita() > 0 ? "low"
                      : "out";
    String stockMsg   = prodotto.getQuantita() > 5 ? "✓ Disponibile"
                      : prodotto.getQuantita() > 0 ? "⚠ Ultimi " + prodotto.getQuantita() + " pezzi"
                      : "✗ Esaurito";
    boolean esaurito  = prodotto.getQuantita() == 0;

    // Prima foto (per immagine principale iniziale)
    String primaFoto = foto.isEmpty() ? null : foto.get(0).getPath();
%>

<div class="dettaglio-layout">

    <%-- ═══════════════════════════════════════════════════════════════
         COLONNA SINISTRA – Galleria immagini
         ═══════════════════════════════════════════════════════════════ --%>
    <div class="gallery-col">

        <%-- Immagine principale --%>
        <div class="gallery-main">
            <% if (primaFoto != null) { %>
                <img id="mainImage"
                     src="<%= request.getContextPath() %>/<%= primaFoto %>"
                     alt="<%= prodotto.getNome() %>">
            <% } else { %>
                <div class="gallery-main-placeholder">♠</div>
            <% } %>

            <% if (sconto) { %>
                <div class="gallery-sconto-badge">-<%= scontoPerc %>%</div>
            <% } %>
        </div>

        <%-- Thumbnail strip (visibile solo se ci sono almeno 2 foto) --%>
        <% if (foto.size() > 1) { %>
        <div class="gallery-thumbs">
            <% for (int i = 0; i < foto.size(); i++) {
                BeanFoto f = foto.get(i);
            %>
            <div class="gallery-thumb <%= i == 0 ? "active" : "" %>"
                 data-src="<%= request.getContextPath() %>/<%= f.getPath() %>"
                 onclick="switchImage(this)"
                 title="Immagine <%= i + 1 %>">
                <img src="<%= request.getContextPath() %>/<%= f.getPath() %>"
                     alt="<%= prodotto.getNome() %> – immagine <%= i + 1 %>"
                     loading="lazy">
            </div>
            <% } %>
        </div>
        <% } %>

    </div>

    <%-- ═══════════════════════════════════════════════════════════════
         COLONNA DESTRA – Informazioni prodotto
         ═══════════════════════════════════════════════════════════════ --%>
    <div class="info-col">

        <%-- Categoria --%>
        <%-- (la categoria non è caricata in questa servlet per semplicità;
              se vuoi aggiungerla basta passarla come attributo come in CatalogoServlet) --%>

        <%-- Nome --%>
        <h1 class="info-nome"><%= prodotto.getNome() %></h1>

        <%-- Prezzi --%>
        <div class="info-price-wrap">
            <div class="info-price-final">€ <%= String.format("%.2f", prodotto.getPrezzoFinale()) %></div>
            <% if (sconto) { %>
                <div class="info-price-listino">€ <%= String.format("%.2f", prodotto.getPrezzoListino()) %></div>
            <% } %>
        </div>
        <div class="info-price-iva">IVA <%= prodotto.getIva() %>% inclusa</div>

        <%-- Disponibilità --%>
        <div class="info-stock <%= stockClass %>"><%= stockMsg %></div>

        <hr class="info-divider">

        <%-- Descrizione --%>
        <div class="info-desc-label">Descrizione</div>
        <div class="info-desc"><%= prodotto.getDescrizione() %></div>

        <%-- ── Sezione Aggiungi al Carrello ───────────────────────────── --%>
        <div class="add-to-cart-section">

            <%-- Messaggio errore (es. prodotto esaurito, errore DB) --%>
            <% if ("esaurito".equals(erroreParam)) { %>
                <div style="background:rgba(211,47,47,0.12);border:1px solid rgba(211,47,47,0.4);
                            color:#EF9A9A;padding:10px 14px;border-radius:7px;
                            font-size:0.85rem;margin-bottom:14px;">
                    ⚠ Prodotto esaurito, non è possibile aggiungerlo al carrello.
                </div>
            <% } else if ("db".equals(erroreParam)) { %>
                <div style="background:rgba(211,47,47,0.12);border:1px solid rgba(211,47,47,0.4);
                            color:#EF9A9A;padding:10px 14px;border-radius:7px;
                            font-size:0.85rem;margin-bottom:14px;">
                    ⚠ Errore del server. Riprovare più tardi.
                </div>
            <% } %>

            <form method="post"
                  action="<%= request.getContextPath() %>/aggiungi-al-carrello">

                <input type="hidden" name="prodottoId" value="<%= prodotto.getId() %>">

                <label for="quantita">Quantità</label>

                <div class="qty-control">
                    <button type="button" class="qty-btn" id="qtyMinus"
                            onclick="cambiaQt(-1)"
                            <%= esaurito ? "disabled" : "" %>
                            aria-label="Diminuisci quantità">−</button>

                    <input type="number" id="quantita" name="quantita" class="qty-input"
                           value="1" min="1"
                           max="<%= prodotto.getQuantita() %>"
                           <%= esaurito ? "disabled" : "" %>
                           aria-label="Quantità">

                    <button type="button" class="qty-btn" id="qtyPlus"
                            onclick="cambiaQt(1)"
                            <%= esaurito ? "disabled" : "" %>
                            aria-label="Aumenta quantità">+</button>
                </div>

                <button type="submit"
                        class="btn-add-cart"
                        id="btnAddCart"
                        <%= esaurito ? "disabled" : "" %>
                        title="<%= esaurito ? "Prodotto esaurito" : "Aggiungi al carrello" %>">
                    🛒 <%= esaurito ? "Prodotto esaurito" : "Aggiungi al carrello" %>
                </button>

            </form>

        </div>

    </div>
</div>

<% } %>

<%-- ── JavaScript ─────────────────────────────────────────────────────── --%>
<script>
(function () {
    "use strict";

    /* ── Galleria: cambio immagine principale al click sulla thumbnail ── */
    window.switchImage = function (thumb) {
        var mainImg = document.getElementById("mainImage");
        if (!mainImg) return;

        // Aggiorna src immagine principale con fade
        mainImg.style.opacity = "0";
        setTimeout(function () {
            mainImg.src = thumb.dataset.src;
            mainImg.style.opacity = "1";
        }, 120);

        // Aggiorna classe active sulle thumbnail
        document.querySelectorAll(".gallery-thumb").forEach(function (t) {
            t.classList.remove("active");
        });
        thumb.classList.add("active");
    };

    /* ── Controllo quantità ─────────────────────────────────────────── */
    var qtInput  = document.getElementById("quantita");
    var btnMinus = document.getElementById("qtyMinus");
    var btnPlus  = document.getElementById("qtyPlus");
    var maxQt    = qtInput ? parseInt(qtInput.max, 10) : 0;

    window.cambiaQt = function (delta) {
        if (!qtInput) return;
        var val = parseInt(qtInput.value, 10) || 1;
        val = Math.max(1, Math.min(maxQt, val + delta));
        qtInput.value = val;
        aggiornaBottoni(val);
    };

    // Gestione digitazione diretta
    if (qtInput) {
        qtInput.addEventListener("input", function () {
            var val = parseInt(this.value, 10);
            if (isNaN(val) || val < 1) val = 1;
            if (val > maxQt)           val = maxQt;
            this.value = val;
            aggiornaBottoni(val);
        });
    }

    function aggiornaBottoni(val) {
        if (btnMinus) btnMinus.disabled = (val <= 1);
        if (btnPlus)  btnPlus.disabled  = (val >= maxQt);
    }

    // Stato iniziale pulsanti
    if (qtInput && maxQt > 0) aggiornaBottoni(parseInt(qtInput.value, 10));

    /* ── Bottone Aggiungi al Carrello ────────────────────────────────
       La funzionalità sarà implementata nella prossima fase.
       Per ora il bottone è presente ma non esegue azioni.
    ─────────────────────────────────────────────────────────────────── */

})();
</script>

</body>
</html>
