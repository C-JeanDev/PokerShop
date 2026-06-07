<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrazione – PokerShop</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #1a1a2e;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            padding: 40px 16px;
        }

        .container {
            background: #16213e;
            border: 1px solid #e63946;
            border-radius: 12px;
            padding: 40px;
            width: 100%;
            max-width: 520px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.5);
        }

        .logo {
            text-align: center;
            margin-bottom: 28px;
        }
        .logo h1 { color: #e63946; font-size: 1.8rem; letter-spacing: 2px; }
        .logo p  { color: #aaa; font-size: 0.9rem; margin-top: 4px; }

        .row {
            display: flex;
            gap: 14px;
        }
        .row .form-group { flex: 1; }

        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            color: #ccc;
            margin-bottom: 6px;
            font-size: 0.88rem;
        }
        .form-group input {
            width: 100%;
            padding: 11px 13px;
            background: #0f3460;
            border: 1px solid #333;
            border-radius: 6px;
            color: #fff;
            font-size: 0.95rem;
            transition: border-color 0.2s;
        }
        .form-group input:focus {
            outline: none;
            border-color: #e63946;
        }

        .btn-register {
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
            margin-top: 4px;
        }
        .btn-register:hover { background: #c1121f; }

        .error-box {
            background: rgba(230,57,70,0.15);
            border: 1px solid #e63946;
            border-radius: 6px;
            color: #e63946;
            padding: 10px 14px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #aaa;
            font-size: 0.9rem;
        }
        .login-link a { color: #e63946; text-decoration: none; }
        .login-link a:hover { text-decoration: underline; }

        .section-label {
            color: #e63946;
            font-size: 0.8rem;
            font-weight: bold;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin: 20px 0 10px;
            border-bottom: 1px solid #333;
            padding-bottom: 4px;
        }
    </style>
</head>
<body>

<%
    // Recupera i valori già inseriti per ripopolare il form in caso di errore
    java.util.Map<String, String[]> formData =
        (java.util.Map<String, String[]>) request.getAttribute("formData");

    // Helper inline per leggere i valori
    // uso una funzione nel scriptlet
%>

<div class="container">

    <div class="logo">
        <h1>♠ PokerShop</h1>
        <p>Crea il tuo account</p>
    </div>

    <%-- Errore --%>
    <% String errore = (String) request.getAttribute("errore"); %>
    <% if (errore != null) { %>
        <div class="error-box"><%= errore %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/registrazione" method="post">

        <div class="section-label">Dati personali</div>

        <div class="row">
            <div class="form-group">
                <label for="nome">Nome</label>
                <input type="text" id="nome" name="nome" placeholder="Mario"
                       value="<%= val(formData, "nome") %>" required>
            </div>
            <div class="form-group">
                <label for="cognome">Cognome</label>
                <input type="text" id="cognome" name="cognome" placeholder="Rossi"
                       value="<%= val(formData, "cognome") %>" required>
            </div>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="mario.rossi@email.com"
                   value="<%= val(formData, "email") %>" required>
        </div>

        <div class="row">
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>
            <div class="form-group">
                <label for="password2">Conferma password</label>
                <input type="password" id="password2" name="password2" placeholder="••••••••" required>
            </div>
        </div>

        <div class="section-label">Indirizzo</div>

        <div class="row">
            <div class="form-group" style="flex:2">
                <label for="indirizzo">Indirizzo</label>
                <input type="text" id="indirizzo" name="indirizzo" placeholder="Via Roma"
                       value="<%= val(formData, "indirizzo") %>" required>
            </div>
            <div class="form-group" style="flex:1">
                <label for="nCivico">N° civico</label>
                <input type="number" id="nCivico" name="nCivico" placeholder="10" min="1"
                       value="<%= val(formData, "nCivico") %>" required>
            </div>
        </div>

        <div class="row">
            <div class="form-group" style="flex:1">
                <label for="cap">CAP</label>
                <input type="text" id="cap" name="cap" placeholder="00100"
                       maxlength="5" pattern="\d{5}"
                       value="<%= val(formData, "cap") %>" required>
            </div>
            <div class="form-group" style="flex:2">
                <label for="citta">Città</label>
                <input type="text" id="citta" name="citta" placeholder="Roma"
                       value="<%= val(formData, "citta") %>" required>
            </div>
        </div>

        <button type="submit" class="btn-register">REGISTRATI</button>

    </form>

    <div class="login-link">
        Hai già un account? <a href="<%= request.getContextPath() %>/login">Accedi</a>
    </div>

</div>

</body>
</html>

<%!
    // Metodo helper per ripopolare i campi dopo un errore
    private String val(java.util.Map<String, String[]> map, String key) {
        if (map == null) return "";
        String[] vals = map.get(key);
        if (vals == null || vals.length == 0) return "";
        String v = vals[0];
        return v == null ? "" : v.replace("\"", "&quot;");
    }
%>
