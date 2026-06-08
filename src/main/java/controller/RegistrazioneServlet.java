package controller;

import model.DAO.UtenteDAO;
import model.bean.BeanUtente;
import model.utils.PasswordUtils;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/registrazione")
public class RegistrazioneServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Se già loggato, manda alla home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("utente") != null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Leggi tutti i campi del form
        String nome      = request.getParameter("nome");
        String cognome   = request.getParameter("cognome");
        String email     = request.getParameter("email");
        String password  = request.getParameter("password");
        String password2 = request.getParameter("password2");
        String indirizzo = request.getParameter("indirizzo");
        String nCivicoStr= request.getParameter("nCivico");
        String cap       = request.getParameter("cap");
        String citta     = request.getParameter("citta");

        // --- Validazione ---
        if (isEmpty(nome) || isEmpty(cognome) || isEmpty(email) ||
            isEmpty(password) || isEmpty(password2) || isEmpty(indirizzo) ||
            isEmpty(nCivicoStr) || isEmpty(cap) || isEmpty(citta)) {

            request.setAttribute("errore", "Tutti i campi sono obbligatori.");
            request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp").forward(request, response);
            return;
        }

        if (!password.equals(password2)) {
            request.setAttribute("errore", "Le due password non coincidono.");
            request.setAttribute("formData", request.getParameterMap());
            request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp").forward(request, response);
            return;
        }

        if (!cap.matches("\\d{5}")) {
            request.setAttribute("errore", "Il CAP deve essere composto da 5 cifre.");
            request.setAttribute("formData", request.getParameterMap());
            request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp").forward(request, response);
            return;
        }

        int nCivico;
        try {
            nCivico = Integer.parseInt(nCivicoStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("errore", "Il numero civico non è valido.");
            request.setAttribute("formData", request.getParameterMap());
            request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp").forward(request, response);
            return;
        }

        // --- Controlla email già esistente ---
        try {
            UtenteDAO utenteDAO = new UtenteDAO();

            if (utenteDAO.doCheckEmail(email.trim())) {
                request.setAttribute("errore", "Questa email è già registrata.");
                request.setAttribute("formData", request.getParameterMap());
                request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp").forward(request, response);
                return;
            }

            // --- Crea il bean e salva ---
            BeanUtente utente = new BeanUtente();
            utente.setNome(nome.trim());
            utente.setCognome(cognome.trim());
            utente.setEmail(email.trim());
            utente.setPassword(PasswordUtils.hash(password));
            utente.setAdmin(false);           // i nuovi utenti non sono mai admin
            utente.setIndirizzo(indirizzo.trim());
            utente.setNCivico(nCivico);
            utente.setCap(cap.trim());
            utente.setCitta(citta.trim());

            utenteDAO.doSave(utente);
            

            // Redirect al login con messaggio di successo
            response.sendRedirect(request.getContextPath() + "/login?registrato=true");

        } catch (SQLException e) {
            request.setAttribute("errore", "Errore del server. Riprovare più tardi.");
            request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp").forward(request, response);
        }
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
