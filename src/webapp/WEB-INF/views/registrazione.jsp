<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrazione – PokerShop</title>
   <link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/registrazione.css">
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
