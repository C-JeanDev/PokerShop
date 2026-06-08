<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanUtente" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>PokerShop – Home</title>
   <link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/index.css">
</head>
<body>

<%
    // Recupera l'utente dalla sessione
    BeanUtente utente = null;
    HttpSession sess = request.getSession(false);
    if (sess != null) {
        utente = (BeanUtente) sess.getAttribute("utente");
    }
%>

<header>
    <h1>♠ PokerShop</h1>
    <nav>
        <a href="#">Prodotti</a>
        <a href="#">Categorie</a>
        <% if (utente != null) { %>
            <% if (utente.isAdmin()) { %>
                <a href="<%= request.getContextPath() %>/admin/dashboard">Admin</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/logout">Logout (<%= utente.getNome() %>)</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/login">Login</a>
        <% } %>
    </nav>
</header>

<div class="welcome">
    <% if (utente != null) { %>
        <h2>Bentornato, <%= utente.getNome() %> <%= utente.getCognome() %>! ♠</h2>
        <p>Esplora il nostro catalogo di prodotti per il poker.</p>
    <% } else { %>
        <h2>Benvenuto su PokerShop ♠</h2>
        <p>Effettua il <a href="<%= request.getContextPath() %>/login" >login</a> per accedere al tuo account.</p>
    <% } %>
</div>

</body>
</html>
