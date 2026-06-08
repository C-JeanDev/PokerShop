package controller;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// Questo filtro si applica a tutte le pagine dell'applicazione
@WebFilter("/*")
public class NoCacheFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Blocca la cache per impedire il recupero della pagina con il tasto indietro
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);

        // Continua l'esecuzione della richiesta
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}