<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 – Accesso negato | PokerShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/error.css">
</head>
<body>

<%-- ── Header/Navbar ──────────────────────────────────────────────────────── --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- ── Error Content ──────────────────────────────────────────────────────── --%>
<main class="error-page">
    <div class="error-card error-403">

        <span class="error-suit">♦</span>

        <div class="error-code">403</div>
        <h1 class="error-title">Accesso negato</h1>

        <div class="error-divider"></div>

        <p class="error-description">
            Questa area è riservata. Non hai i permessi necessari<br>
            per vedere questo contenuto.
        </p>

        <div class="error-actions">
            <a href="<%= request.getContextPath() %>/login" class="btn-primary">Accedi</a>
            <a href="<%= request.getContextPath() %>/" class="btn-secondary">Torna alla Home</a>
        </div>

        <p class="error-footer-note">HTTP 403 · <%= request.getAttribute("javax.servlet.error.request_uri") != null ? request.getAttribute("javax.servlet.error.request_uri") : request.getRequestURI() %></p>
    </div>
</main>

</body>
</html>
