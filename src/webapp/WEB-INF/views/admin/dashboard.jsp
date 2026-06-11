<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanUtente" %>
<%@ include file="header.jsp" %>


<%
    BeanUtente utente = (BeanUtente) session.getAttribute("utente");
    int nProdotti = (Integer) request.getAttribute("nProdotti");
    int nUtenti   = (Integer) request.getAttribute("nUtenti");
    int nOrdini   = (Integer) request.getAttribute("nOrdini");
%>

<div class="page-title">Dashboard</div>

<div style="display:flex; gap:20px; margin-bottom:30px; flex-wrap:wrap;">

    <div style="background:#16213e; border:1px solid #0f3460; border-top:3px solid #e63946;
                border-radius:8px; padding:20px 28px; flex:1; min-width:160px;">
        <div style="color:#aaa; font-size:0.8rem; text-transform:uppercase; letter-spacing:1px;">Prodotti</div>
        <div style="font-size:2.2rem; font-weight:bold; color:#fff; margin:6px 0;"><%= nProdotti %></div>
        <a href="<%= request.getContextPath() %>/admin/prodotti" style="color:#e63946; font-size:0.85rem; text-decoration:none;">Gestisci →</a>
    </div>

    <div style="background:#16213e; border:1px solid #0f3460; border-top:3px solid #3b82f6;
                border-radius:8px; padding:20px 28px; flex:1; min-width:160px;">
        <div style="color:#aaa; font-size:0.8rem; text-transform:uppercase; letter-spacing:1px;">Utenti</div>
        <div style="font-size:2.2rem; font-weight:bold; color:#fff; margin:6px 0;"><%= nUtenti %></div>
        <a href="<%= request.getContextPath() %>/admin/utenti" style="color:#3b82f6; font-size:0.85rem; text-decoration:none;">Gestisci →</a>
    </div>

    <div style="background:#16213e; border:1px solid #0f3460; border-top:3px solid #22c55e;
                border-radius:8px; padding:20px 28px; flex:1; min-width:160px;">
        <div style="color:#aaa; font-size:0.8rem; text-transform:uppercase; letter-spacing:1px;">Ordini</div>
        <div style="font-size:2.2rem; font-weight:bold; color:#fff; margin:6px 0;"><%= nOrdini %></div>
        <a href="<%= request.getContextPath() %>/admin/ordini" style="color:#22c55e; font-size:0.85rem; text-decoration:none;">Visualizza →</a>
    </div>

</div>

<div style="color:#aaa; font-size:0.9rem;">
    Benvenuto, <strong style="color:#fff"><%= utente.getNome() %> <%= utente.getCognome() %></strong>.
    Usa la barra laterale per gestire i contenuti del sito.
</div>

<%@ include file="footer.jsp" %>
