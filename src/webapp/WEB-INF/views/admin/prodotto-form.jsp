<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanProdotto, model.bean.BeanCategoria, java.util.List" %>
<%@ include file="header.jsp" %>

<%
    BeanProdotto p        = (BeanProdotto) request.getAttribute("prodotto");
    List<BeanCategoria> categorie = (List<BeanCategoria>) request.getAttribute("categorie");
    boolean isEdit        = (p != null);
    String errore         = (String) request.getAttribute("errore");
    String formAction     = request.getContextPath() + "/admin/prodotti";
%>

<div class="top-bar">
    <div class="page-title"><%= isEdit ? "Modifica prodotto" : "Nuovo prodotto" %></div>
    <a href="<%= request.getContextPath() %>/admin/prodotti" class="btn btn-secondary">← Torna alla lista</a>
</div>

<% if (errore != null) { %><div class="alert alert-danger"><%= errore %></div><% } %>

<div class="card">
    <form action="<%= formAction %>" method="post">
        <input type="hidden" name="action" value="<%= isEdit ? "update" : "save" %>">
        <% if (isEdit) { %><input type="hidden" name="id" value="<%= p.getId() %>"><% } %>

        <div class="form-group">
            <label>Nome prodotto</label>
            <input type="text" name="nome" required maxlength="30"
                   value="<%= isEdit ? p.getNome() : "" %>">
        </div>

        <div class="form-group">
            <label>Descrizione</label>
            <textarea name="descrizione" required maxlength="250"><%= isEdit ? p.getDescrizione() : "" %></textarea>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Prezzo listino (€)</label>
                <input type="number" name="prezzoListino" step="0.01" min="0" required
                       value="<%= isEdit ? p.getPrezzoListino() : "" %>">
            </div>
            <div class="form-group">
                <label>Prezzo finale (€)</label>
                <input type="number" name="prezzoFinale" step="0.01" min="0" required
                       value="<%= isEdit ? p.getPrezzoFinale() : "" %>">
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>IVA (%)</label>
                <input type="number" name="iva" min="0" max="100" required
                       value="<%= isEdit ? p.getIva() : "22" %>">
            </div>
            <div class="form-group">
                <label>Quantità</label>
                <input type="number" name="qt" min="0" required
                       value="<%= isEdit ? p.getQuantita() : "" %>">
            </div>
        </div>

        <div class="form-group">
            <label>Categoria</label>
            <select name="categoria" required>
                <% if (categorie != null) { for (BeanCategoria c : categorie) { %>
                    <option value="<%= c.getId() %>"
                        <%= (isEdit && p.getCategoriaId() == c.getId()) ? "selected" : "" %>>
                        <%= c.getNome() %>
                    </option>
                <% } } %>
            </select>
        </div>

        <div class="form-group">
            <div class="form-check">
                <input type="checkbox" name="isActive" id="isActive"
                       <%= (!isEdit || p.isActive()) ? "checked" : "" %>>
                <label for="isActive">Prodotto attivo (visibile ai clienti)</label>
            </div>
        </div>

        <button type="submit" class="btn btn-primary">
            <%= isEdit ? "Salva modifiche" : "Crea prodotto" %>
        </button>
    </form>
</div>

<%@ include file="footer.jsp" %>
