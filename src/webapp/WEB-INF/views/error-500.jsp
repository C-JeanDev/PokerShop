<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 – Errore del server | PokerShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/error.css">
</head>
<body>

<%-- ── Header/Navbar ──────────────────────────────────────────────────────── --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- ── Error Content ──────────────────────────────────────────────────────── --%>
<main class="error-page">
    <div class="error-card error-500">

        <span class="error-suit">♣</span>

        <div class="error-code">500</div>
        <h1 class="error-title">Errore del server</h1>

        <div class="error-divider"></div>

        <p class="error-description">
            Qualcosa è andato storto dal nostro lato.<br>
            Stiamo lavorando per risolvere il problema. Riprova tra qualche minuto.
        </p>

        <div class="error-actions">
            <a href="<%= request.getContextPath() %>/" class="btn-primary">Torna alla Home</a>
            <a href="javascript:location.reload()" class="btn-secondary">Riprova</a>
        </div>

        <%-- Mostra il messaggio tecnico solo se presente (utile in sviluppo) --%>
        <%
            Throwable err = (Throwable) request.getAttribute("javax.servlet.error.exception");
            String errMsg = (err != null) ? err.getMessage() : null;
        %>
        <% if (errMsg != null && !errMsg.isEmpty()) { %>
            <p class="error-footer-note">HTTP 500 · <%= errMsg %></p>
        <% } else { %>
            <p class="error-footer-note">HTTP 500 · Internal Server Error</p>
        <% } %>
    </div>
</main>

</body>
</html>
