<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanProdotto, model.bean.BeanCategoria, java.util.List, java.util.Map" %>
<%
    @SuppressWarnings("unchecked")
    List<BeanProdotto>           topVenduti = (List<BeanProdotto>)           request.getAttribute("topVenduti");
    @SuppressWarnings("unchecked")
    Map<Integer, String>         fotoMap    = (Map<Integer, String>)         request.getAttribute("fotoMap");
    @SuppressWarnings("unchecked")
    Map<Integer, BeanCategoria>  catMap     = (Map<Integer, BeanCategoria>)  request.getAttribute("catMap");
    if (topVenduti == null) topVenduti = new java.util.ArrayList<>();
    if (fotoMap    == null) fotoMap    = new java.util.HashMap<>();
    if (catMap     == null) catMap     = new java.util.HashMap<>();
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PokerShop – Home</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
</head>
<body>

<%-- ── Fragment Header/Navbar ─────────────────────────────────────────── --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- ── Hero Section ─────────────────────────────────────────────────────── --%>
<section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-content">
        <h1>Il tuo negozio di <span>poker</span> online</h1>
        <p>Attrezzature professionali, fiches da torneo e mazzi da casinò.<br>
           Tutto ciò che ti serve per giocare al massimo livello.</p>
        <a href="<%= request.getContextPath() %>/catalogo" class="hero-btn">
            Scopri il Catalogo ♠
        </a>
    </div>
</section>

<%-- ── Chi Siamo ─────────────────────────────────────────────────────────── --%>
<section class="about-section">
    <span class="section-tag">Chi Siamo</span>
    <h2>La passione per il poker, dal 2015</h2>
    <p>
        PokerShop nasce dalla passione di 3 ragazzi appassionati del Texas Hold'em con
        l'obiettivo di portare la qualità del casinò direttamente a casa tua.
        Selezioniamo i migliori prodotti sul mercato: dai tavoli professionali con
        panno da torneo alle fiches in clay composite, fino ai mazzi utilizzati nei
        circuiti internazionali.
    </p>
    <p>
        Ogni prodotto è testato e scelto da giocatori esperti. La nostra priorità è
        offrirti un'esperienza di gioco autentica, che tu organizzi un home game
        tra amici o un torneo semi-professionale.
    </p>

    
</section>

<%-- ── Top Venduti ───────────────────────────────────────────────────────── --%>
<div class="section-divider"><h2>♠ I Più Venduti</h2></div>

<section class="top-venduti-section">
    <% if (topVenduti.isEmpty()) { %>
        <div class="no-products">
            <p>Nessun prodotto ancora disponibile. <a href="<%= request.getContextPath() %>/catalogo"
               style="color:#D4AF37;">Esplora il catalogo</a></p>
        </div>
    <% } else { %>
        <div class="top-grid">
            <% for (BeanProdotto p : topVenduti) {
                String fotoPath = fotoMap.get(p.getId());
                BeanCategoria cat = catMap.get(p.getId());
                String catNome = (cat != null) ? cat.getNome() : "";
                boolean sconto = p.getPrezzoListino() > p.getPrezzoFinale();
            %>
            <div class="product-card">
                <div class="product-card-img">
                    <% if (fotoPath != null && !fotoPath.isEmpty()) { %>
                        <img src="<%= request.getContextPath() %>/<%= fotoPath %>"
                             alt="<%= p.getNome() %>" loading="lazy">
                    <% } else { %>
                        ♠
                    <% } %>
                </div>
                <div class="product-card-body">
                    <div class="bestseller-badge">⭐ Più Venduto</div>
                    <% if (!catNome.isEmpty()) { %>
                        <div class="product-card-cat"><%= catNome %></div>
                    <% } %>
                    <div class="product-card-name"><%= p.getNome() %></div>
                    <div class="product-card-desc"><%= p.getDescrizione() %></div>
                    <div class="product-card-footer">
                        <div>
                            <% if (sconto) { %>
                                <span class="product-card-price">
                                    <span class="listino">€ <%= String.format("%.2f", p.getPrezzoListino()) %></span>
                                    € <%= String.format("%.2f", p.getPrezzoFinale()) %>
                                </span>
                            <% } else { %>
                                <span class="product-card-price">€ <%= String.format("%.2f", p.getPrezzoFinale()) %></span>
                            <% } %>
                        </div>
                        <%-- Link alla pagina di dettaglio prodotto --%>
                        <a href="<%= request.getContextPath() %>/prodotto?id=<%= p.getId() %>"
                           class="btn-detail">Dettaglio</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>

    <div style="text-align:center; margin-top: 40px;">
        <a href="<%= request.getContextPath() %>/catalogo" class="hero-btn">
            Vedi tutto il catalogo →
        </a>
    </div>
</section>

</body>
</html>
