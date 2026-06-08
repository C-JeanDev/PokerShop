<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanOrdine, model.bean.BeanUtente, java.util.List" %>
<%@ include file="header.jsp" %>

<%
    List<BeanOrdine> ordini   = (List<BeanOrdine>) request.getAttribute("ordini");
    List<BeanUtente> utenti   = (List<BeanUtente>) request.getAttribute("utenti");
    String errore             = (String) request.getAttribute("errore");
    String filtroCliente      = (String) request.getAttribute("filtroCliente");
    String valDal             = request.getAttribute("dal")     != null ? (String) request.getAttribute("dal")     : "";
    String valAl              = request.getAttribute("al")      != null ? (String) request.getAttribute("al")      : "";
    String valCliente         = request.getAttribute("cliente") != null ? (String) request.getAttribute("cliente") : "";
    boolean filtroDateAttivo  = Boolean.TRUE.equals(request.getAttribute("filtroDate"));
%>

<% if (errore != null) { %><div class="alert alert-danger"><%= errore %></div><% } %>

<div class="page-title">Ordini</div>

<!-- ===== PANNELLO FILTRI ===== -->
<div style="background:#16213e; border:1px solid #2a2a4a; border-radius:8px; padding:20px; margin-bottom:24px;">
    <div style="color:#aaa; font-size:0.8rem; text-transform:uppercase; letter-spacing:1px; margin-bottom:14px;">🔍 Filtri</div>

    <!-- Filtro per date -->
    <form method="get" action="<%= request.getContextPath() %>/admin/ordini"
          style="display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; margin-bottom:14px;">
        <div>
            <label style="display:block; color:#aaa; font-size:0.8rem; margin-bottom:4px;">Dal</label>
            <input type="date" name="dal" value="<%= valDal %>"
                   style="padding:8px 10px; background:#0f3460; border:1px solid #2a2a4a; border-radius:5px; color:#fff; font-size:0.9rem;">
        </div>
        <div>
            <label style="display:block; color:#aaa; font-size:0.8rem; margin-bottom:4px;">Al</label>
            <input type="date" name="al" value="<%= valAl %>"
                   style="padding:8px 10px; background:#0f3460; border:1px solid #2a2a4a; border-radius:5px; color:#fff; font-size:0.9rem;">
        </div>
        <button type="submit" class="btn btn-primary">Filtra per date</button>
        <% if (filtroDateAttivo) { %>
            <a href="<%= request.getContextPath() %>/admin/ordini" class="btn btn-secondary">✕ Rimuovi filtro</a>
        <% } %>
    </form>

    <hr style="border-color:#2a2a4a; margin-bottom:14px;">

    <!-- Filtro per cliente -->
    <form method="get" action="<%= request.getContextPath() %>/admin/ordini"
          style="display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap;">
        <div>
            <label style="display:block; color:#aaa; font-size:0.8rem; margin-bottom:4px;">Cliente (email)</label>
            <select name="cliente"
                    style="padding:8px 10px; background:#0f3460; border:1px solid #2a2a4a; border-radius:5px; color:#fff; font-size:0.9rem; min-width:260px;">
                <option value="">-- Seleziona cliente --</option>
                <% if (utenti != null) { for (BeanUtente u : utenti) { %>
                    <option value="<%= u.getEmail() %>"
                        <%= u.getEmail().equals(valCliente) ? "selected" : "" %>>
                        <%= u.getNome() %> <%= u.getCognome() %> (<%= u.getEmail() %>)
                    </option>
                <% } } %>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Filtra per cliente</button>
        <% if (filtroCliente != null && !filtroCliente.isEmpty()) { %>
            <a href="<%= request.getContextPath() %>/admin/ordini" class="btn btn-secondary">✕ Rimuovi filtro</a>
        <% } %>
    </form>
</div>

<!-- ===== ETICHETTA FILTRO ATTIVO ===== -->
<% if (filtroDateAttivo) { %>
    <div class="alert alert-success" style="margin-bottom:16px;">
        Risultati dal <strong><%= valDal %></strong> al <strong><%= valAl %></strong>
        — <%= ordini != null ? ordini.size() : 0 %> ordini trovati.
    </div>
<% } else if (filtroCliente != null && !filtroCliente.isEmpty()) { %>
    <div class="alert alert-success" style="margin-bottom:16px;">
        Ordini del cliente <strong><%= filtroCliente %></strong>
        — <%= ordini != null ? ordini.size() : 0 %> ordini trovati.
    </div>
<% } %>

<!-- ===== TABELLA ORDINI ===== -->
<table>
    <thead>
        <tr>
            <th>#</th>
            <th>Cliente</th>
            <th>Data</th>
            <th>Totale</th>
            <th>Stato</th>
        </tr>
    </thead>
    <tbody>
    <% if (ordini != null && !ordini.isEmpty()) {
           for (BeanOrdine o : ordini) {
               String stato = o.getStato();
               String badgeClass = "badge-blue";
               String statoLabel = stato;
               if ("NE".equals(stato))      { badgeClass = "badge-orange"; statoLabel = "In elaborazione"; }
               else if ("SP".equals(stato)) { badgeClass = "badge-blue";   statoLabel = "Spedito"; }
               else if ("CO".equals(stato)) { badgeClass = "badge-green";  statoLabel = "Consegnato"; }
               else if ("AN".equals(stato)) { badgeClass = "badge-red";    statoLabel = "Annullato"; }
    %>
        <tr>
            <td><strong>#<%= o.getId() %></strong></td>
            <td><%= o.getUtenteEmail() %></td>
            <td><%= o.getData() %></td>
            <td><strong>€ <%= String.format("%.2f", o.getCostoTot()) %></strong></td>
            <td><span class="badge <%= badgeClass %>"><%= statoLabel %></span></td>
        </tr>
    <% } } else { %>
        <tr><td colspan="5" style="text-align:center; color:#555; padding:30px;">Nessun ordine trovato.</td></tr>
    <% } %>
    </tbody>
</table>

<%@ include file="footer.jsp" %>
