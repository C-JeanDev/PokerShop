<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanUtente" %>
<%
    // --- Protezione pagina: solo admin ---
    BeanUtente utente = null;
    HttpSession sess = request.getSession(false);
    if (sess != null) {
        utente = (BeanUtente) sess.getAttribute("utente");
    }

    if (utente == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    if (!utente.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin – PokerShop</title>
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
        header h1 { color: #e63946; }
        a { color: #e63946; text-decoration: none; }
        .content {
            max-width: 800px;
            margin: 60px auto;
            background: #16213e;
            border: 1px solid #e63946;
            border-radius: 10px;
            padding: 30px;
        }
        .badge-admin {
            background: #e63946;
            color: #fff;
            padding: 2px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-left: 8px;
        }
    </style>
</head>
<body>

<header>
    <h1>♠ PokerShop <span class="badge-admin">ADMIN</span></h1>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</header>

<div class="content">
    <h2>Dashboard Amministratore</h2>
    <p style="color:#aaa; margin-top:10px;">
        Benvenuto, <strong><%= utente.getNome() %> <%= utente.getCognome() %></strong>.
        Hai effettuato l'accesso come amministratore.
    </p>
    <hr style="border-color:#333; margin: 20px 0;">
    <p>Da qui puoi gestire prodotti, ordini e utenti del negozio.</p>
</div>

</body>
</html>
