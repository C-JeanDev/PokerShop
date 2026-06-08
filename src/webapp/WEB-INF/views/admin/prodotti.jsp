<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanProdotto, java.util.List" %>
<%@ include file="header.jsp" %>

<%
    List<BeanProdotto> prodotti = (List<BeanProdotto>) request.getAttribute("prodotti");
    String msg    = request.getParameter("msg");
    String errore = (String) request.getAttribute("errore");
%>

<% if ("creato".equals(msg)) { %>
    <div class="alert alert-success">✓ Prodotto creato con successo.</div>
<% } else if ("aggiornato".equals(msg)) { %>
    <div class="alert alert-success">✓ Prodotto aggiornato.</div>
<% } else if ("eliminato".equals(msg)) { %>
    <div class="alert alert-success">✓ Prodotto disattivato.</div>
<% } %>
<% if (errore != null) { %><div class="alert alert-danger"><%= errore %></div><% } %>

<div class="top-bar">
    <div class="page-title">Prodotti</div>
    <a href="<%= request.getContextPath() %>/admin/prodotti?action=new" class="btn btn-primary">+ Nuovo prodotto</a>
</div>

<table>
    <thead>
        <tr>
            <th>#</th>
            <th>Nome</th>
            <th>Prezzo finale</th>
            <th>IVA</th>
            <th>Qtà</th>
            <th>Stato</th>
            <th>Azioni</th>
        </tr>
    </thead>
    <tbody>
    <% if (prodotti != null) { for (BeanProdotto p : prodotti) { %>
        <tr>
            <td><%= p.getId() %></td>
            <td><strong><%= p.getNome() %></strong><br>
                <small style="color:#666"><%= p.getDescrizione().length() > 50 ? p.getDescrizione().substring(0,50) + "…" : p.getDescrizione() %></small>
            </td>
            <td>€ <%= String.format("%.2f", p.getPrezzoFinale()) %></td>
            <td><%= p.getIva() %>%</td>
            <td><%= p.getQuantita() %></td>
            <td>
                <% if (p.isActive()) { %>
                    <span class="badge badge-green">Attivo</span>
                <% } else { %>
                    <span class="badge badge-red">Disattivo</span>
                <% } %>
            </td>
            <td>
                <a href="<%= request.getContextPath() %>/admin/prodotti?action=edit&id=<%= p.getId() %>"
                   class="btn btn-secondary btn-sm">Modifica</a>
                <a href="<%= request.getContextPath() %>/admin/prodotti?action=delete&id=<%= p.getId() %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Disattivare il prodotto?')">Elimina</a>
            </td>
        </tr>
    <% } } %>
    </tbody>
</table>

<%@ include file="footer.jsp" %>
