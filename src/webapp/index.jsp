<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanUtente" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>PokerShop – Home</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #1a1a2e; color: #fff; }
        header {
            background: #16213e;
            border-bottom: 2px solid #e63946;
            padding: 14px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header h1 { color: #e63946; font-size: 1.5rem; }
        header nav a {
            color: #ccc;
            text-decoration: none;
            margin-left: 20px;
            font-size: 0.95rem;
        }
        header nav a:hover { color: #e63946; }
        .welcome {
            max-width: 700px;
            margin: 80px auto;
            text-align: center;
        }
        .welcome h2 { font-size: 2rem; margin-bottom: 12px; }
        .welcome p  { color: #aaa; }
    </style>
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
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Admin</a>
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
        <p>Effettua il <a href="<%= request.getContextPath() %>/login" style="color:#e63946;">login</a> per accedere al tuo account.</p>
    <% } %>
</div>

</body>
</html>
