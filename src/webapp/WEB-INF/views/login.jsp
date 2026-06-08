<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – PokerShop</title>
    <link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/login.css">
    
</head>
<body>

<div class="login-container">

    <div class="login-logo">
        <h1>♠ PokerShop</h1>
        <p>Accedi al tuo account</p>
    </div>

    <%-- Messaggio di errore (impostato dalla servlet) --%>
    <% String errore = (String) request.getAttribute("errore"); %>
    <% if (errore != null) { %>
        <div class="error-box">
            <%= errore %>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="post">

        <div class="form-group">
            <label for="email">Email</label>
            <input
                type="email"
                id="email"
                name="email"
                placeholder="es. mario.rossi@email.com"
                value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                required
                autofocus
            >
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input
                type="password"
                id="password"
                name="password"
                placeholder="••••••••"
                required
            >
        </div>

        <button type="submit" class="btn-login">ACCEDI</button>

    </form>

    <div class="register-link">
        Non hai un account? <a href="<%= request.getContextPath() %>/registrazione">Registrati</a>
    </div>

</div>

</body>
</html>
