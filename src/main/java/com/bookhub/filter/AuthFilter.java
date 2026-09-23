package com.bookhub.filter;

import com.bookhub.beans.Usuario;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/usuario/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();

        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        // 1. Si no está logueado, redirigir a login
        if (usuario == null) {
            response.sendRedirect(contextPath + "/login?error=debeIniciarSesion");
            return;
        }

        // 2. Si la ruta es administrativa (/admin/*) y no es admin, denegar acceso
        if (uri.startsWith(contextPath + "/admin") && !usuario.esAdmin()) {
            response.sendRedirect(contextPath + "/index?error=accesoDenegado");
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {}
}
