<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanUtente" %>
<%
    BeanUtente _utente = null;
    HttpSession _sess = request.getSession(false);
    if (_sess != null) {
        _utente = (BeanUtente) _sess.getAttribute("utente");
    }
    String _currentPage = (String) request.getAttribute("currentPage");
    if (_currentPage == null) _currentPage = "";
%>
<header>
    <a href="index.jsp" class="header-logo">♠ PokerShop</a>
    <nav class="header-nav">
        <a href="index.jsp" class="nav-link">Home</a>
        <a href="<%= request.getContextPath() %>/catalogo"
           class="nav-link <%= "catalogo".equals(_currentPage) ? "active" : "" %>">Catalogo</a>
        <a href="<%= request.getContextPath() %>/carrello"
           class="nav-link nav-icon <%= "carrello".equals(_currentPage) ? "active" : "" %>"
           title="Carrello">
            🛒 Carrello
        </a>
        <% if (_utente != null) { %>
            <% if (_utente.isAdmin()) { %>
                <a href="<%= request.getContextPath() %>/admin/dashboard"
                   class="nav-link nav-admin">⚙ Admin</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/logout" class="nav-link nav-user">
                👤 Logout 
            </a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/login"
               class="nav-link nav-cta <%= "login".equals(_currentPage) ? "active" : "" %>">Login</a>
        <% } %>
    </nav>
    <button class="nav-hamburger" id="navToggle" aria-label="Menu">☰</button>
</header>
<!-- Mobile Menu Overlay -->
<nav class="mobile-nav" id="mobileNav">
    <a href="<%= request.getContextPath() %>/index" class="mobile-nav-link">Home</a>
    <a href="<%= request.getContextPath() %>/catalogo" class="mobile-nav-link">Catalogo</a>
    <a href="<%= request.getContextPath() %>/carrello" class="mobile-nav-link">🛒 Carrello</a>
    <% if (_utente != null) { %>
        <% if (_utente.isAdmin()) { %>
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="mobile-nav-link mobile-admin">⚙ Admin</a>
        <% } %>
        <a href="<%= request.getContextPath() %>/logout" class="mobile-nav-link">Logout </a>
    <% } else { %>
        <a href="<%= request.getContextPath() %>/login" class="mobile-nav-link">Login</a>
    <% } %>
</nav>
<script>
    document.getElementById('navToggle').addEventListener('click', function () {
        var nav = document.getElementById('mobileNav');
        nav.classList.toggle('open');
    });

    // Controlla la sessione quando la pagina viene ripristinata dalla bfcache
    // (es. tasto indietro dopo logout). Se la sessione e' scaduta, ricarica la pagina
    // cosi' il server reindirizza correttamente.
    window.addEventListener('pageshow', function (e) {
        if (e.persisted) {
            fetch('<%= request.getContextPath() %>/session-check', { method: 'GET', credentials: 'same-origin' })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    if (!data.loggato) {
                        window.location.reload();
                    }
                })
                .catch(function () {
                    window.location.reload();
                });
        }
    });
</script>
