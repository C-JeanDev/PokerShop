<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrazione – PokerShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/registrazione.css">

    <%-- CSS inline per i feedback di validazione lato client --%>
    <style>
        /* ── Campo con errore ──────────────────────────────────────────── */
        .input-error {
            border-color: #e53935 !important;
            box-shadow: 0 0 0 2px rgba(229, 57, 53, .20);
        }

        /* ── Messaggio di errore sotto il campo ───────────────────────── */
        .field-error {
            display: block;
            margin-top: 4px;
            font-size: .78rem;
            color: #e53935;
        }

        /* ── Feedback AJAX email ──────────────────────────────────────── */
        .email-feedback {
            display: block;
            margin-top: 4px;
            font-size: .78rem;
        }
        .email-checking { color: #888; }
        .email-ok       { color: #2e7d32; font-weight: 600; }
        .email-error    { color: #e53935; font-weight: 600; }
    </style>

    <%--
        Meta tag usato da validation.js per ricavare il context path
        senza hardcoding nell'URL della chiamata AJAX.
    --%>
    <meta name="contextPath" content="<%= request.getContextPath() %>">
</head>
<body>

<%
    // Recupera i valori già inseriti per ripopolare il form in caso di errore
    java.util.Map<String, String[]> formData =
        (java.util.Map<String, String[]>) request.getAttribute("formData");
%>

<div class="container">

    <div class="logo">
        <h1>♠ PokerShop</h1>
        <p>Crea il tuo account</p>
    </div>

    <%-- Errore proveniente dal server (visibile solo se la pagina viene ricaricata) --%>
    <% String errore = (String) request.getAttribute("errore"); %>
    <% if (errore != null) { %>
        <div class="error-box"><%= errore %></div>
    <% } %>

    <%--
        id="registrazioneForm" → aggancio usato da validation.js
        novalidate             → disabilita la validazione HTML5 nativa;
                                 la gestione è interamente in mano al JS.
    --%>
    <form id="registrazioneForm"
          action="<%= request.getContextPath() %>/registrazione"
          method="post"
          novalidate>

        <div class="section-label">Dati personali</div>

        <div class="row">
            <div class="form-group">
                <label for="nome">Nome *</label>
                <input type="text" id="nome" name="nome"
                       placeholder="Mario"
                       value="<%= val(formData, "nome") %>"
                       autocomplete="given-name"
                       required>
            </div>
            <div class="form-group">
                <label for="cognome">Cognome *</label>
                <input type="text" id="cognome" name="cognome"
                       placeholder="Rossi"
                       value="<%= val(formData, "cognome") %>"
                       autocomplete="family-name"
                       required>
            </div>
        </div>

        <%--
            Campo email:
            - La validazione formato avviene on-blur e on-input (regex JS).
            - La verifica disponibilità avviene in tempo reale via AJAX
              dopo 500 ms dall'ultima battitura (debounce) e anche on-blur.
        --%>
        <div class="form-group">
            <label for="email">Email *</label>
            <input type="email" id="email" name="email"
                   placeholder="mario.rossi@email.com"
                   value="<%= val(formData, "email") %>"
                   autocomplete="email"
                   required>
            <%-- Il feedback AJAX (.email-feedback) viene iniettato dinamicamente dal JS --%>
        </div>

        <div class="row">
            <div class="form-group">
                <label for="password">Password *</label>
                <input type="password" id="password" name="password"
                       placeholder="••••••••"
                       autocomplete="new-password"
                       required>
                <small class="hint">Min 8 caratteri, almeno una lettera e un numero.</small>
            </div>
            <div class="form-group">
                <label for="password2">Conferma password *</label>
                <input type="password" id="password2" name="password2"
                       placeholder="••••••••"
                       autocomplete="new-password"
                       required>
            </div>
        </div>

        <div class="section-label">Indirizzo</div>

        <div class="row">
            <div class="form-group" style="flex:2">
                <label for="indirizzo">Indirizzo *</label>
                <input type="text" id="indirizzo" name="indirizzo"
                       placeholder="Via Roma"
                       value="<%= val(formData, "indirizzo") %>"
                       autocomplete="street-address"
                       required>
            </div>
            <div class="form-group" style="flex:1">
                <label for="nCivico">N° civico *</label>
                <%--
                    Cambiato da type="number" a type="text" per supportare
                    civici con lettera (es. 12A) e gestire la validazione
                    interamente via regex JS + server.
                --%>
                <input type="text" id="nCivico" name="nCivico"
                       placeholder="10"
                       value="<%= val(formData, "nCivico") %>"
                       required>
            </div>
        </div>

        <div class="row">
            <div class="form-group" style="flex:1">
                <label for="cap">CAP *</label>
                <input type="text" id="cap" name="cap"
                       placeholder="00100"
                       maxlength="5"
                       value="<%= val(formData, "cap") %>"
                       autocomplete="postal-code"
                       required>
            </div>
            <div class="form-group" style="flex:2">
                <label for="citta">Città *</label>
                <input type="text" id="citta" name="citta"
                       placeholder="Roma"
                       value="<%= val(formData, "citta") %>"
                       autocomplete="address-level2"
                       required>
            </div>
        </div>

        <button type="submit" class="btn-register">REGISTRATI</button>

    </form>

    <div class="login-link">
        Hai già un account? <a href="<%= request.getContextPath() %>/login">Accedi</a>
    </div>

</div>

<%-- validation.js caricato in fondo al body: il DOM è già disponibile --%>
<script src="<%= request.getContextPath() %>/js/validation.js"></script>

</body>
</html>

<%!
    // Metodo helper per ripopolare i campi dopo un errore server-side
    private String val(java.util.Map<String, String[]> map, String key) {
        if (map == null) return "";
        String[] vals = map.get(key);
        if (vals == null || vals.length == 0) return "";
        String v = vals[0];
        return v == null ? "" : v.replace("\"", "&quot;");
    }
%>
