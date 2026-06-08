<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanUtente, java.util.List" %>
<%@ include file="header.jsp" %>

<%
    List<BeanUtente> utenti   = (List<BeanUtente>) request.getAttribute("utenti");
    String adminEmail         = (String) request.getAttribute("adminEmail");
    String msg                = request.getParameter("msg");
    String errore             = (String) request.getAttribute("errore");
%>

<% if ("eliminato".equals(msg)) { %>
    <div class="alert alert-success">✓ Utente eliminato.</div>
<% } else if ("nopuoi".equals(msg)) { %>
    <div class="alert alert-danger">Non puoi eliminare il tuo stesso account.</div>
<% } %>
<% if (errore != null) { %><div class="alert alert-danger"><%= errore %></div><% } %>

<div class="page-title">Utenti registrati</div>

<table>
    <thead>
        <tr>
            <th>Email</th>
            <th>Nome</th>
            <th>Cognome</th>
            <th>Città</th>
            <th>Ruolo</th>
            <th>Azioni</th>
        </tr>
    </thead>
    <tbody>
    <% if (utenti != null) { for (BeanUtente u : utenti) { %>
        <tr>
            <td><%= u.getEmail() %></td>
            <td><%= u.getNome() %></td>
            <td><%= u.getCognome() %></td>
            <td><%= u.getCitta() %></td>
            <td>
                <% if (u.isAdmin()) { %>
                    <span class="badge badge-orange">Admin</span>
                <% } else { %>
                    <span class="badge badge-blue">Cliente</span>
                <% } %>
            </td>
            <td>
                <% if (!u.getEmail().equals(adminEmail)) { %>
                    <a href="<%= request.getContextPath() %>/admin/utenti?action=delete&email=<%= u.getEmail() %>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Eliminare definitivamente l\\'utente <%= u.getEmail() %>?')">
                        Elimina
                    </a>
                <% } else { %>
                    <span style="color:#555; font-size:0.8rem">Account corrente</span>
                <% } %>
            </td>
        </tr>
    <% } } %>
    </tbody>
</table>

<%@ include file="footer.jsp" %>
