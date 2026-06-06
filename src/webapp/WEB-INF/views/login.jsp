<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – PokerShop</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #1a1a2e;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .login-container {
            background: #16213e;
            border: 1px solid #e63946;
            border-radius: 12px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
        }

        .login-logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-logo h1 {
            color: #e63946;
            font-size: 2rem;
            letter-spacing: 2px;
        }

        .login-logo p {
            color: #aaa;
            font-size: 0.9rem;
            margin-top: 4px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            color: #ccc;
            margin-bottom: 6px;
            font-size: 0.9rem;
        }

        .form-group input {
            width: 100%;
            padding: 12px 14px;
            background: #0f3460;
            border: 1px solid #333;
            border-radius: 6px;
            color: #fff;
            font-size: 1rem;
            transition: border-color 0.2s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #e63946;
        }

        .btn-login {
            width: 100%;
            padding: 13px;
            background: #e63946;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            letter-spacing: 1px;
            transition: background 0.2s;
            margin-top: 6px;
        }

        .btn-login:hover {
            background: #c1121f;
        }

        .error-box {
            background: rgba(230, 57, 70, 0.15);
            border: 1px solid #e63946;
            border-radius: 6px;
            color: #e63946;
            padding: 10px 14px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
            color: #aaa;
            font-size: 0.9rem;
        }

        .register-link a {
            color: #e63946;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
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
