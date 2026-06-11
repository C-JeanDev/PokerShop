<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 – Pagina non trovata | PokerShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/error.css">
</head>
<body>

<%-- ── Header/Navbar ──────────────────────────────────────────────────────── --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- ── Error Content ──────────────────────────────────────────────────────── --%>
<main class="error-page">
    <div class="error-card error-404">

        <span class="error-suit">♠</span>

        <div class="error-code">404</div>
        <h1 class="error-title">Pagina non trovata</h1>

        <div class="error-divider"></div>

        <p class="error-description">
            Hai giocato una mano vincente, ma questa pagina non è nel mazzo.<br>
            Forse il link è scaduto, o la carta è stata già giocata.
        </p>

        <div class="error-actions">
            <a href="<%= request.getContextPath() %>/" class="btn-primary">Torna alla Home</a>
            <a href="<%= request.getContextPath() %>/catalogo" class="btn-secondary">Vai al Catalogo</a>
        </div>

        <p class="error-footer-note">HTTP 404 · <%= request.getAttribute("javax.servlet.error.request_uri") != null ? request.getAttribute("javax.servlet.error.request_uri") : request.getRequestURI() %></p>
    </div>
</main>

</body>
</html>
