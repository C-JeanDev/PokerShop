<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="model.bean.BeanProdotto, model.bean.BeanCategoria, java.util.List, java.util.Map" %>
<%
    @SuppressWarnings("unchecked")
    List<BeanProdotto>           prodotti          = (List<BeanProdotto>)           request.getAttribute("prodotti");
    @SuppressWarnings("unchecked")
    List<BeanCategoria>          categorie         = (List<BeanCategoria>)          request.getAttribute("categorie");
    @SuppressWarnings("unchecked")
    Map<Integer, String>         fotoMap           = (Map<Integer, String>)         request.getAttribute("fotoMap");
    @SuppressWarnings("unchecked")
    Map<Integer, BeanCategoria>  catMap            = (Map<Integer, BeanCategoria>)  request.getAttribute("catMap");
    @SuppressWarnings("unchecked")
    Map<Integer, Integer>        countPerCategoria = (Map<Integer, Integer>)        request.getAttribute("countPerCategoria");
    Integer categoriaFiltro  = (Integer) request.getAttribute("categoriaFiltro");
    double  prezzoMin        = request.getAttribute("prezzoMin")              != null ? (double) request.getAttribute("prezzoMin")              : 0;
    double  prezzoMax        = request.getAttribute("prezzoMax")              != null ? (double) request.getAttribute("prezzoMax")              : 500;
    double  maxPrezzoDisp    = request.getAttribute("maxPrezzoDisponibile")   != null ? (double) request.getAttribute("maxPrezzoDisponibile")   : 500;
    String  sortParam        = (String) request.getAttribute("sortParam");
    String  erroreDB         = (String) request.getAttribute("erroreDB");
    if (prodotti          == null) prodotti          = new java.util.ArrayList<>();
    if (categorie         == null) categorie         = new java.util.ArrayList<>();
    if (fotoMap           == null) fotoMap           = new java.util.HashMap<>();
    if (catMap            == null) catMap            = new java.util.HashMap<>();
    if (countPerCategoria == null) countPerCategoria = new java.util.HashMap<>();
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo – PokerShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/catalogo.css">
</head>
<body>

<%-- ── Fragment Header/Navbar ─────────────────────────────────────────── --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- ── Page Title ──────────────────────────────────────────────────────── --%>
<div class="page-title-bar">
    <h1>♠ Catalogo Prodotti</h1>
    <p>Scopri la nostra selezione di attrezzature professionali per il poker</p>
</div>

<%-- ── Messaggio errore DB ─────────────────────────────────────────────── --%>
<% if (erroreDB != null) { %>
    <div style="background:rgba(211,47,47,0.12);border:1px solid #D32F2F;color:#D32F2F;
                padding:14px 20px;margin:20px;border-radius:8px;font-size:0.9rem;">
        ⚠ <%= erroreDB %>
    </div>
<% } %>

<div class="catalogo-layout">

    <%-- ═══════════════════════════════════════════════════════════════════
         SIDEBAR – Filtri
         ═══════════════════════════════════════════════════════════════════ --%>
    <aside class="sidebar">

        <form method="get" action="<%= request.getContextPath() %>/catalogo" id="filtroForm">

            <%-- Categorie --%>
            <div class="sidebar-section">
                <h3>Categoria</h3>
                <ul class="cat-list">
                    <li>
                        <button type="submit" name="categoria" value=""
                                class="<%= (categoriaFiltro == null) ? "active" : "" %>">
                            Tutte le categorie
                            <span class="cat-count"><%= prodotti.size() %></span>
                        </button>
                    </li>
                    <% for (BeanCategoria c : categorie) {
                        boolean isActive = (categoriaFiltro != null && categoriaFiltro == c.getId());
                        int cnt = countPerCategoria.getOrDefault(c.getId(), 0);
                    %>
                    <li>
                        <button type="submit" name="categoria" value="<%= c.getId() %>"
                                class="<%= isActive ? "active" : "" %>">
                            <%= c.getNome() %>
                            <span class="cat-count"><%= cnt %></span>
                        </button>
                    </li>
                    <% } %>
                </ul>
            </div>

            <%-- Hidden: mantieni categoria selezionata quando si filtra per prezzo --%>
            <% if (categoriaFiltro != null) { %>
                <input type="hidden" name="categoria" value="<%= categoriaFiltro %>">
            <% } %>

            <%-- Range Prezzo --%>
            <div class="sidebar-section">
                <h3>Prezzo (€)</h3>
                <div class="price-range-wrap">
                    <div class="price-inputs">
                        <input type="number" id="prezzoMin" name="prezzoMin"
                               value="<%= String.format("%.0f", prezzoMin) %>"
                               min="0" max="<%= String.format("%.0f", maxPrezzoDisp) %>"
                               step="1" placeholder="Min">
                        <span class="price-sep">–</span>
                        <input type="number" id="prezzoMax" name="prezzoMax"
                               value="<%= String.format("%.0f", prezzoMax) %>"
                               min="0" max="<%= String.format("%.0f", maxPrezzoDisp) %>"
                               step="1" placeholder="Max">
                    </div>
                    <div class="price-slider-row">
                        <input type="range" id="sliderMax" min="0"
                               max="<%= String.format("%.0f", maxPrezzoDisp) %>"
                               value="<%= String.format("%.0f", prezzoMax) %>"
                               oninput="document.getElementById('prezzoMax').value=this.value">
                        <div class="price-labels">
                            <span>€0</span>
                            <span>€<%= String.format("%.0f", maxPrezzoDisp) %></span>
                        </div>
                    </div>
                    <button type="submit" class="btn-filter">Filtra</button>
                    <a href="<%= request.getContextPath() %>/catalogo"
                       class="btn-reset" style="display:block;text-align:center;text-decoration:none;
                                                padding:9px;font-size:0.85rem;color:#757575;
                                                border:1px solid rgba(255,255,255,0.12);border-radius:7px;
                                                margin-top:6px;transition:all 0.2s;">
                        ✕ Azzera filtri
                    </a>
                </div>
            </div>

            <%-- Ordinamento --%>
            <div class="sidebar-section">
                <h3>Ordinamento</h3>
                <select name="sort" class="sort-select" onchange="this.form.submit()">
                    <option value=""      <%= (sortParam == null || sortParam.isEmpty())     ? "selected" : "" %>>Predefinito</option>
                    <option value="priceAsc"  <%= "priceAsc".equals(sortParam)  ? "selected" : "" %>>Prezzo ↑</option>
                    <option value="priceDesc" <%= "priceDesc".equals(sortParam) ? "selected" : "" %>>Prezzo ↓</option>
                    <option value="nameAsc"   <%= "nameAsc".equals(sortParam)   ? "selected" : "" %>>Nome A–Z</option>
                </select>
            </div>

        </form>
    </aside>

    <%-- ═══════════════════════════════════════════════════════════════════
         MAIN – Barra ricerca AJAX + Griglia prodotti
         ═══════════════════════════════════════════════════════════════════ --%>
    <main class="catalogo-main">

        <%-- ── Barra di ricerca AJAX ─────────────────────────────────────── --%>
        <div class="search-wrap" id="searchWrap">
            <span class="search-icon">🔍</span>
            <input type="text"
                   id="searchInput"
                   class="search-input"
                   placeholder="Cerca prodotti... (es. fiches, tavolo, mazzo)"
                   autocomplete="off"
                   aria-label="Cerca prodotti">
            <div class="search-suggestions" id="searchSuggestions" role="listbox"></div>
        </div>

        <%-- ── Barra risultati ──────────────────────────────────────────── --%>
        <div class="results-bar">
            <p class="results-count">
                <% if (categoriaFiltro != null || prezzoMin > 0 || prezzoMax < maxPrezzoDisp) { %>
                    Trovati <strong><%= prodotti.size() %></strong> prodotti con i filtri applicati
                <% } else { %>
                    <strong><%= prodotti.size() %></strong> prodotti disponibili
                <% } %>
            </p>
            <div class="active-filters">
                <% if (categoriaFiltro != null) {
                    // Trova nome categoria
                    String catName = "";
                    for (BeanCategoria c : categorie) {
                        if (c.getId() == categoriaFiltro) { catName = c.getNome(); break; }
                    }
                %>
                    <span class="filter-tag">
                        📂 <%= catName %>
                        <a href="<%= request.getContextPath() %>/catalogo<%= prezzoMin > 0 || prezzoMax < maxPrezzoDisp ? "?prezzoMin=" + (int)prezzoMin + "&prezzoMax=" + (int)prezzoMax : "" %>"><button type="button">✕</button></a>
                    </span>
                <% } %>
                <% if (prezzoMin > 0 || prezzoMax < maxPrezzoDisp) { %>
                    <span class="filter-tag">
                        💶 €<%= String.format("%.0f", prezzoMin) %> – €<%= String.format("%.0f", prezzoMax) %>
                        <% String urlSenzaPrezzo = (categoriaFiltro != null) ? "?categoria=" + categoriaFiltro : ""; %>
						<a href="<%= request.getContextPath() %>/catalogo<%= urlSenzaPrezzo %>"><button type="button">✕</button></a>
                    </span>
                <% } %>
            </div>
        </div>

        <%-- ── Griglia prodotti ────────────────────────────────────────── --%>
        <div class="products-grid" id="productsGrid">
            <% if (prodotti.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">🃏</div>
                    <p>Nessun prodotto trovato con i filtri selezionati.</p>
                </div>
            <% } else {
                for (BeanProdotto p : prodotti) {
                    String fotoPath = fotoMap.get(p.getId());
                    BeanCategoria cat = catMap.get(p.getId());
                    String catNome = (cat != null) ? cat.getNome() : "";
                    boolean sconto = p.getPrezzoListino() > p.getPrezzoFinale();
                    int scontoPerc = sconto ? (int)((1 - p.getPrezzoFinale()/p.getPrezzoListino())*100) : 0;
                    String stockClass = p.getQuantita() > 5 ? "" : p.getQuantita() > 0 ? "low" : "out";
                    String stockMsg   = p.getQuantita() > 5 ? "✓ Disponibile"
                                      : p.getQuantita() > 0 ? "⚠ Ultimi " + p.getQuantita()
                                      : "✗ Esaurito";
            %>
            <div class="prod-card">
                <div class="prod-card-img-wrap">
                    <% if (fotoPath != null && !fotoPath.isEmpty()) { %>
                        <img src="<%= request.getContextPath() %>/<%= fotoPath %>"
                             alt="<%= p.getNome() %>" loading="lazy">
                    <% } else { %>
                        ♠
                    <% } %>
                    <% if (sconto) { %>
                        <span class="prod-card-sconto">-<%= scontoPerc %>%</span>
                    <% } %>
                </div>
                <div class="prod-card-body">
                    <% if (!catNome.isEmpty()) { %>
                        <div class="prod-cat-badge"><%= catNome %></div>
                    <% } %>
                    <div class="prod-name"><%= p.getNome() %></div>
                    <div class="prod-stock <%= stockClass %>"><%= stockMsg %></div>
                    <div class="prod-desc"><%= p.getDescrizione() %></div>
                    <div class="prod-footer">
                        <div class="prod-price-wrap">
                            <% if (sconto) { %>
                                <div class="prod-price-listino">€ <%= String.format("%.2f", p.getPrezzoListino()) %></div>
                            <% } %>
                            <div class="prod-price-final">€ <%= String.format("%.2f", p.getPrezzoFinale()) %></div>
                        </div>
                        <%-- Bottone dettaglio: per ora non fa nulla, sarà implementato in seguito --%>
                        <button class="btn-prod-detail" disabled title="Funzionalità in arrivo">
                            Dettaglio
                        </button>
                    </div>
                </div>
            </div>
            <% } } %>
        </div>

    </main>
</div>

<%-- ═══════════════════════════════════════════════════════════════════════
     AJAX – Suggerimenti barra di ricerca
     Usa Fetch API con JSON (requisito checklist)
     ═══════════════════════════════════════════════════════════════════════ --%>
<script>
(function () {
    "use strict";

    var searchInput       = document.getElementById("searchInput");
    var suggestionsBox    = document.getElementById("searchSuggestions");
    var contextPath       = "<%= request.getContextPath() %>";
    var debounceTimer     = null;
    var currentController = null;   // per AbortController

    // ── Funzione debounced attivata ad ogni input ──────────────────────
    searchInput.addEventListener("input", function () {
        var q = this.value.trim();
        clearTimeout(debounceTimer);

        // Filtra la griglia in tempo reale ad ogni carattere digitato
        filterGridByName(q);

        if (q.length < 3) {
            hideSuggestions();
            return;
        }

        debounceTimer = setTimeout(function () {
            fetchSuggestions(q);
        }, 280);  // attendi 280ms dopo l'ultima digitazione
    });

    // ── Chiudi suggerimenti cliccando fuori ───────────────────────────
    document.addEventListener("click", function (e) {
        if (!document.getElementById("searchWrap").contains(e.target)) {
            hideSuggestions();
        }
    });

    // ── Navigazione tastiera ──────────────────────────────────────────
    searchInput.addEventListener("keydown", function (e) {
        var items = suggestionsBox.querySelectorAll(".suggestion-item");
        var active = suggestionsBox.querySelector(".suggestion-item.focused");
        var idx = Array.prototype.indexOf.call(items, active);

        if (e.key === "ArrowDown") {
            e.preventDefault();
            var next = idx < items.length - 1 ? idx + 1 : 0;
            setFocus(items, next);
        } else if (e.key === "ArrowUp") {
            e.preventDefault();
            var prev = idx > 0 ? idx - 1 : items.length - 1;
            setFocus(items, prev);
        } else if (e.key === "Enter" && active) {
            e.preventDefault();
            active.click();
        } else if (e.key === "Escape") {
            hideSuggestions();
        }
    });

    function setFocus(items, idx) {
        items.forEach(function (el) { el.classList.remove("focused"); });
        if (items[idx]) {
            items[idx].classList.add("focused");
            items[idx].scrollIntoView({ block: "nearest" });
        }
    }

    // ── Fetch suggerimenti dal server ─────────────────────────────────
    function fetchSuggestions(q) {
        // Annulla la richiesta precedente se ancora in volo
        if (currentController) currentController.abort();
        currentController = new AbortController();

        fetch(contextPath + "/ricerca-ajax?q=" + encodeURIComponent(q), {
            signal: currentController.signal
        })
        .then(function (res) {
            if (!res.ok) throw new Error("HTTP " + res.status);
            return res.json();
        })
        .then(function (data) {
            renderSuggestions(data.results, q);
        })
        .catch(function (err) {
            // Ignora errori da abort
            if (err.name !== "AbortError") {
                hideSuggestions();
            }
        });
    }

    // ── Render lista suggerimenti ─────────────────────────────────────
    function renderSuggestions(results, query) {
        suggestionsBox.innerHTML = "";

        if (!results || results.length === 0) {
            suggestionsBox.innerHTML =
                '<div class="suggestion-noresult">Nessun prodotto trovato per "' +
                escapeHtml(query) + '"</div>';
            suggestionsBox.classList.add("visible");
            return;
        }

        results.forEach(function (item) {
            var div = document.createElement("div");
            div.className = "suggestion-item";
            div.setAttribute("role", "option");
            div.setAttribute("tabindex", "-1");

            var imgHtml;
            if (item.foto && item.foto !== "") {
                imgHtml = '<div class="suggestion-img"><img src="' +
                    contextPath + "/" + escapeAttr(item.foto) +
                    '" alt="' + escapeAttr(item.nome) + '" loading="lazy"></div>';
            } else {
                imgHtml = '<div class="suggestion-img">♠</div>';
            }

            var nameHtml = highlightMatch(item.nome, query);

            div.innerHTML =
                imgHtml +
                '<div class="suggestion-info">' +
                    '<div class="suggestion-name">' + nameHtml + '</div>' +
                    '<div class="suggestion-cat">' + escapeHtml(item.categoria) + '</div>' +
                '</div>' +
                '<div class="suggestion-price">€ ' + parseFloat(item.prezzo).toFixed(2) + '</div>';

            // Al click: porta al catalogo filtrato per nome
            // (quando il dettaglio prodotto sarà implementato, si potrà navigare lì)
            div.addEventListener("click", function () {
                searchInput.value = item.nome;
                hideSuggestions();
                // Filtra la griglia lato client per il nome selezionato
                filterGridByName(item.nome);
            });

            suggestionsBox.appendChild(div);
        });

        suggestionsBox.classList.add("visible");
    }

    function hideSuggestions() {
        suggestionsBox.classList.remove("visible");
        suggestionsBox.querySelectorAll(".suggestion-item").forEach(function (el) {
            el.classList.remove("focused");
        });
    }

    // ── Filtra la griglia prodotti lato client per nome ────────────────
    // (filtro visivo rapido, senza round-trip al server)
    function filterGridByName(nome) {
        var cards = document.querySelectorAll(".prod-card");
        var query = nome.toLowerCase().trim();
        var counter = document.querySelector(".results-count");

        if (query === "") {
            cards.forEach(function (c) { c.style.display = ""; });
            if (counter) {
                counter.innerHTML = "<strong><%= prodotti.size() %></strong> prodotti disponibili";
            }
            return;
        }

        var visible = 0;
        cards.forEach(function (card) {
            var cardName = card.querySelector(".prod-name");
            if (cardName && cardName.textContent.toLowerCase().indexOf(query) !== -1) {
                card.style.display = "";
                visible++;
            } else {
                card.style.display = "none";
            }
        });

        // Aggiorna contatore risultati
        if (counter) {
            counter.innerHTML = "<strong>" + visible + "</strong> prodotti trovati per \"" +
                                 escapeHtml(nome) + "\"";
        }
    }

    // ── Utility ──────────────────────────────────────────────────────
    // ── Utility ──────────────────────────────────────────────────────
    function highlightMatch(text, query) {
        var safe = escapeHtml(text);
        var safeQ = escapeHtml(query);

        // MODIFICATO: Separati '$' e '{' per evitare conflitti con il motore EL di JSP
        var escaped = safeQ.replace(/[.*+?^$(){}|[\]\\]/g, "\\$&");

        var regex = new RegExp("(" + escaped + ")", "gi");

        return safe.replace(regex, '<strong style="color:#D4AF37">$1</strong>');
    }

    function escapeHtml(str) {
        return String(str)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;");
    }

    function escapeAttr(str) {
        return String(str).replace(/"/g, "&quot;").replace(/'/g, "&#39;");
    }

    // Sincronizza slider max con input number
    document.getElementById("sliderMax") && document.getElementById("sliderMax")
        .addEventListener("input", function () {
            document.getElementById("prezzoMax").value = this.value;
        });

    document.getElementById("prezzoMax") && document.getElementById("prezzoMax")
        .addEventListener("input", function () {
            var sl = document.getElementById("sliderMax");
            if (sl) sl.value = this.value;
        });

})();
</script>

</body>
</html>
