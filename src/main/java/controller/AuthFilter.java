package controller;

import model.bean.BeanUtente;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Filtro di autenticazione.
 * Protegge tutte le URL sotto /admin/* e /area-riservata/*.
 * Se l'utente non è loggato viene reindirizzato a /login.
 * Se non è admin e prova ad accedere ad /admin/* viene rimandato alla home.
 */
@WebFilter(urlPatterns = {"/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest,
                         ServletResponse servletResponse,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        HttpSession session = request.getSession(false);
        BeanUtente utente   = (session != null) ? (BeanUtente) session.getAttribute("utente") : null;

        String requestURI = request.getRequestURI();

        // Non loggato → login
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Loggato ma non admin → home
        if (requestURI.startsWith(request.getContextPath() + "/admin") && !utente.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig filterConfig) {}
    @Override public void destroy() {}
}
