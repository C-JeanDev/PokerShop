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
  <link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/dashboardAdmin.css">
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
