<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.bean.BeanUtente" %>
<%
    BeanUtente _admin = (BeanUtente) session.getAttribute("utente");
    String _currentUri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin – PokerShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-layout.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboardAdmin.css">
</head>
<body>

<button type="button" class="sidebar-toggle" id="sidebarToggle" aria-label="Apri menu">☰</button>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="sidebar" id="adminSidebar">
    <div class="sidebar-logo">
        <h2>♠ ADMIN</h2>
        <span>PokerShop Panel</span>
    </div>
    <nav>
        <div class="nav-label">Gestione</div>
        <a href="<%= request.getContextPath() %>/admin/prodotti"
           class="<%= _currentUri.contains("/admin/prodotti") ? "active" : "" %>">
            📦 Prodotti
        </a>
        <a href="<%= request.getContextPath() %>/admin/utenti"
           class="<%= _currentUri.contains("/admin/utenti") ? "active" : "" %>">
            👤 Utenti
        </a>
        <a href="<%= request.getContextPath() %>/admin/ordini"
           class="<%= _currentUri.contains("/admin/ordini") ? "active" : "" %>">
            📋 Ordini
        </a>
        <div class="nav-label">Sito</div>
        <a href="<%= request.getContextPath() %>/index.jsp">🏠 Vai al sito</a>
    </nav>
    <div class="sidebar-footer">
        <strong><%= _admin != null ? _admin.getNome() + " " + _admin.getCognome() : "" %></strong>
        <a href="<%= request.getContextPath() %>/logout">Esci →</a>
    </div>
</div>

<div class="main">
