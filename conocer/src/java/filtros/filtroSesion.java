/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package filtros;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class filtroSesion implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // No crea una nueva sesión si no existe

        // Obtener la URL solicitada
        String url = httpRequest.getRequestURI();

        // Permitir el acceso a las páginas públicas (como login.jsp)
        if (url.endsWith("login.jsp") || url.endsWith("ValidarUsuarios")) {
            chain.doFilter(request, response); // Continuar con la solicitud
            return;
        }

        // Validar si hay una sesión activa
        if (session == null || session.getAttribute("usuario") == null) {
            httpResponse.sendRedirect("login.jsp"); // Redirigir a login si no hay sesión
            return;
        }

        // Continuar con la solicitud si la sesión es válida
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Limpieza al destruir el filtro, si es necesaria
    }
    
}
