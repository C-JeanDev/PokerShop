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
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #0f0f1a; color: #e0e0e0; display: flex; min-height: 100vh; }

        /* SIDEBAR */
        .sidebar {
            width: 220px;
            background: #16213e;
            border-right: 2px solid #e63946;
            display: flex;
            flex-direction: column;
            padding: 0;
            position: fixed;
            top: 0; left: 0; bottom: 0;
        }
        .sidebar-logo {
            padding: 24px 20px 20px;
            border-bottom: 1px solid #2a2a4a;
            text-align: center;
        }
        .sidebar-logo h2 { color: #e63946; font-size: 1.3rem; letter-spacing: 2px; }
        .sidebar-logo span { color: #aaa; font-size: 0.75rem; display: block; margin-top: 2px; }

        .sidebar nav { padding: 16px 0; flex: 1; }
        .sidebar nav a {
            display: block;
            padding: 12px 20px;
            color: #ccc;
            text-decoration: none;
            font-size: 0.9rem;
            border-left: 3px solid transparent;
            transition: all 0.15s;
        }
        .sidebar nav a:hover { background: #1e2d50; color: #fff; }
        .sidebar nav a.active { border-left-color: #e63946; background: #1e2d50; color: #fff; font-weight: bold; }
        .sidebar nav .nav-label {
            padding: 14px 20px 4px;
            color: #555;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .sidebar-footer {
            padding: 16px 20px;
            border-top: 1px solid #2a2a4a;
            font-size: 0.8rem;
            color: #888;
        }
        .sidebar-footer strong { color: #ccc; display: block; margin-bottom: 6px; }
        .sidebar-footer a { color: #e63946; text-decoration: none; font-size: 0.85rem; }

        /* MAIN CONTENT */
        .main { margin-left: 220px; padding: 30px; flex: 1; width: calc(100% - 220px); }

        .page-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 24px;
            color: #fff;
            border-bottom: 1px solid #2a2a4a;
            padding-bottom: 12px;
        }

        /* TABELLE */
        table { width: 100%; border-collapse: collapse; background: #16213e; border-radius: 8px; overflow: hidden; }
        th { background: #0f3460; color: #e63946; padding: 12px 14px; text-align: left; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 11px 14px; border-bottom: 1px solid #1e2d50; font-size: 0.9rem; color: #ccc; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #1a2744; }

        /* BADGE */
        .badge { padding: 2px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; }
        .badge-green  { background: rgba(34,197,94,0.15);  color: #22c55e; }
        .badge-red    { background: rgba(230,57,70,0.15);  color: #e63946; }
        .badge-orange { background: rgba(251,146,60,0.15); color: #fb923c; }
        .badge-blue   { background: rgba(59,130,246,0.15); color: #3b82f6; }

        /* BOTTONI */
        .btn { padding: 7px 16px; border-radius: 5px; border: none; cursor: pointer; font-size: 0.85rem; font-weight: bold; text-decoration: none; display: inline-block; transition: opacity 0.15s; }
        .btn:hover { opacity: 0.85; }
        .btn-primary { background: #e63946; color: #fff; }
        .btn-secondary { background: #0f3460; color: #ccc; }
        .btn-danger { background: rgba(230,57,70,0.2); color: #e63946; border: 1px solid #e63946; }
        .btn-sm { padding: 4px 10px; font-size: 0.8rem; }

        /* FORM */
        .card { background: #16213e; border: 1px solid #2a2a4a; border-radius: 8px; padding: 24px; max-width: 680px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; color: #aaa; font-size: 0.85rem; margin-bottom: 6px; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 10px 12px;
            background: #0f3460; border: 1px solid #2a2a4a;
            border-radius: 5px; color: #fff; font-size: 0.9rem;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none; border-color: #e63946;
        }
        .form-group textarea { resize: vertical; min-height: 80px; }
        .form-row { display: flex; gap: 16px; }
        .form-row .form-group { flex: 1; }
        .form-check { display: flex; align-items: center; gap: 8px; margin-top: 6px; }
        .form-check input { width: auto; }
        .form-check label { color: #ccc; margin: 0; }

        /* ALERT */
        .alert { padding: 10px 16px; border-radius: 6px; margin-bottom: 20px; font-size: 0.9rem; }
        .alert-success { background: rgba(34,197,94,0.1); border: 1px solid #22c55e; color: #22c55e; }
        .alert-danger  { background: rgba(230,57,70,0.1); border: 1px solid #e63946; color: #e63946; }

        /* TOP BAR */
        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .top-bar .page-title { margin-bottom: 0; border-bottom: none; padding-bottom: 0; }
    </style>
</head>
<body>

<div class="sidebar">
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
