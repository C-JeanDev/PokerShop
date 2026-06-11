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
    <%-- Meglio usare il context path anche per la home per evitare problemi di routing --%>
    <a href="<%= request.getContextPath() %>/" class="header-logo">♠ PokerShop</a>
    
    <nav class="header-nav">
        <a href="<%= request.getContextPath() %>/" class="nav-link">Home</a>
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
            
            <%-- NUOVO: Link all'Area Riservata --%>
            <a href="<%= request.getContextPath() %>/area-riservata" 
               class="nav-link nav-user <%= "area-riservata".equals(_currentPage) ? "active" : "" %>">
                👤 Ciao, <%= _utente.getNome() %>
            </a>
            
            <a href="<%= request.getContextPath() %>/logout" class="nav-link nav-logout"
               onclick="return confirm('Sei sicuro di voler effettuare il logout?');">
                🚪 Logout 
            </a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/login"
               class="nav-link nav-cta <%= "login".equals(_currentPage) ? "active" : "" %>">Login</a>
        <% } %>
    </nav>
    <button class="nav-hamburger" id="navToggle" aria-label="Menu">☰</button>
</header>

<nav class="mobile-nav" id="mobileNav">
    <a href="<%= request.getContextPath() %>/" class="mobile-nav-link">Home</a>
    <a href="<%= request.getContextPath() %>/catalogo" class="mobile-nav-link">Catalogo</a>
    <a href="<%= request.getContextPath() %>/carrello" class="mobile-nav-link">🛒 Carrello</a>
    
    <% if (_utente != null) { %>
        <% if (_utente.isAdmin()) { %>
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="mobile-nav-link mobile-admin">⚙ Admin</a>
        <% } %>
        
        <%-- NUOVO: Link all'Area Riservata (Mobile) --%>
        <a href="<%= request.getContextPath() %>/area-riservata" class="mobile-nav-link">👤 Area Riservata</a>
        
        <a href="<%= request.getContextPath() %>/logout" class="mobile-nav-link"
           onclick="return confirm('Sei sicuro di voler effettuare il logout?');">🚪 Logout </a>
    <% } else { %>
        <a href="<%= request.getContextPath() %>/login" class="mobile-nav-link">Login</a>
    <% } %>
</nav>

<script>
    document.getElementById('navToggle').addEventListener('click', function () {
        var nav = document.getElementById('mobileNav');
        nav.classList.toggle('open');
    });
</script>