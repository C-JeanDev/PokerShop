package controller;

import model.DAO.*;
import model.bean.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;
import java.util.*;

@WebServlet("/test")
public class ServletTestDelleDAO extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><body>");
        out.println("<h1>Test DAO</h1>");

        // --- UTENTI ---
        try {
            UtenteDAO utenteDAO = new UtenteDAO();
            List<BeanUtente> utenti = utenteDAO.doRetrieveAll();
            out.println("<h2>Utenti (" + utenti.size() + ")</h2><ul>");
            for (BeanUtente u : utenti) {
                out.println("<li>" + u.getEmail() + " — " + u.getNome() + " " + u.getCognome() +
                            " | admin: " + u.isAdmin() + "</li>");
            }
            out.println("</ul>");
        } catch (Exception e) {
            out.println("<p style='color:red'>Errore UtenteDAO: " + e.getMessage() + "</p>");
        }

        // --- CATEGORIE ---
        try {
            CategoriaDAO catDAO = new CategoriaDAO();
            List<BeanCategoria> categorie = catDAO.doRetrieveAll();
            out.println("<h2>Categorie (" + categorie.size() + ")</h2><ul>");
            for (BeanCategoria c : categorie) {
                out.println("<li>" + c.getId() + " — " + c.getNome() + "</li>");
            }
            out.println("</ul>");
        } catch (Exception e) {
            out.println("<p style='color:red'>Errore CategoriaDAO: " + e.getMessage() + "</p>");
        }

        // --- PRODOTTI ---
        try {
            ProdottoDAO prodDAO = new ProdottoDAO();
            List<BeanProdotto> prodotti = prodDAO.doRetrieveAll();
            out.println("<h2>Prodotti (" + prodotti.size() + ")</h2><ul>");
            for (BeanProdotto p : prodotti) {
                out.println("<li>" + p.getNome() + " | prezzo: " + p.getPrezzoFinale() +
                            " | attivo: " + p.isActive() + "</li>");
            }
            out.println("</ul>");
        } catch (Exception e) {
            out.println("<p style='color:red'>Errore ProdottoDAO: " + e.getMessage() + "</p>");
        }

        // --- ORDINI ---
        try {
            OrdineDAO ordineDAO = new OrdineDAO();
            List<BeanOrdine> ordini = ordineDAO.doRetrieveAll();
            out.println("<h2>Ordini (" + ordini.size() + ")</h2><ul>");
            for (BeanOrdine o : ordini) {
                out.println("<li>#" + o.getId() + " | " + o.getUtenteEmail() +
                            " | " + o.getData() + " | €" + o.getCostoTot() + "</li>");
            }
            out.println("</ul>");
        } catch (Exception e) {
            out.println("<p style='color:red'>Errore OrdineDAO: " + e.getMessage() + "</p>");
        }

        out.println("</body></html>");
    }
}