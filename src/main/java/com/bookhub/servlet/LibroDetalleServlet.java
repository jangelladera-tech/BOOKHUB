package com.bookhub.servlet;

import com.bookhub.beans.Libro;
import com.bookhub.beans.Usuario;
import com.bookhub.dao.LibroDAO;
import com.bookhub.dao.ReservaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LibroDetalleServlet", urlPatterns = {"/libro"})
public class LibroDetalleServlet extends HttpServlet {

    private final LibroDAO libroDAO = new LibroDAO();
    private final ReservaDAO reservaDAO = new ReservaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }

        try {
            int idLibro = Integer.parseInt(idParam.trim());
            Libro libro = libroDAO.buscarPorId(idLibro);

            if (libro == null) {
                response.sendRedirect(request.getContextPath() + "/catalogo?error=libroNoEncontrado");
                return;
            }

            // Comprobar si el usuario actual ya tiene reserva activa
            HttpSession session = request.getSession(false);
            boolean tieneReservaActiva = false;
            if (session != null && session.getAttribute("usuarioLogueado") != null) {
                Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
                tieneReservaActiva = reservaDAO.existeReservaActiva(u.getIdUsuario(), idLibro);
            }

            request.setAttribute("libro", libro);
            request.setAttribute("tieneReservaActiva", tieneReservaActiva);
            request.getRequestDispatcher("/WEB-INF/views/detalle-libro.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
        }
    }
}
