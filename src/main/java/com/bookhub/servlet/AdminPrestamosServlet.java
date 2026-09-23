package com.bookhub.servlet;

import com.bookhub.beans.Devolucion;
import com.bookhub.beans.Libro;
import com.bookhub.beans.Prestamo;
import com.bookhub.beans.Usuario;
import com.bookhub.dao.DevolucionDAO;
import com.bookhub.dao.LibroDAO;
import com.bookhub.dao.PrestamoDAO;
import com.bookhub.dao.UsuarioDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "AdminPrestamosServlet", urlPatterns = {"/admin/prestamos"})
public class AdminPrestamosServlet extends HttpServlet {

    private final PrestamoDAO prestamoDAO = new PrestamoDAO();
    private final DevolucionDAO devolucionDAO = new DevolucionDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final LibroDAO libroDAO = new LibroDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Prestamo> prestamos = prestamoDAO.listarTodos();
        List<Devolucion> devoluciones = devolucionDAO.listarTodas();

        // Para el modal de nuevo préstamo: usuarios activos y libros con ejemplares disponibles
        List<Usuario> usuarios = usuarioDAO.listarTodos().stream()
                .filter(u -> "ACTIVO".equalsIgnoreCase(u.getEstado()))
                .collect(Collectors.toList());

        List<Libro> librosDisponibles = libroDAO.listarTodos().stream()
                .filter(Libro::isDisponible)
                .collect(Collectors.toList());

        request.setAttribute("prestamos", prestamos);
        request.setAttribute("devoluciones", devoluciones);
        request.setAttribute("usuarios", usuarios);
        request.setAttribute("librosDisponibles", librosDisponibles);

        request.getRequestDispatcher("/WEB-INF/views/admin/prestamos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("crear".equalsIgnoreCase(action)) {
                int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
                int idLibro = Integer.parseInt(request.getParameter("idLibro"));
                int dias = 14;
                try {
                    dias = Integer.parseInt(request.getParameter("diasPrestamo"));
                } catch (Exception ignored) {}

                String observaciones = request.getParameter("observaciones");

                Prestamo p = new Prestamo();
                p.setIdUsuario(idUsuario);
                p.setIdLibro(idLibro);
                p.setFechaPrestamo(Date.valueOf(LocalDate.now()));
                p.setFechaDevolucionEsperada(Date.valueOf(LocalDate.now().plusDays(dias)));
                p.setEstado("ACTIVO");
                p.setObservaciones(observaciones);

                boolean registrado = prestamoDAO.registrarPrestamo(p);
                if (registrado) {
                    response.sendRedirect(request.getContextPath() + "/admin/prestamos?msg=prestamoCreado");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/prestamos?error=noDisponible");
                }
                return;

            } else if ("devolver".equalsIgnoreCase(action)) {
                int idPrestamo = Integer.parseInt(request.getParameter("idPrestamo"));
                String estadoLibro = request.getParameter("estadoLibro");
                double multa = 0.0;
                try {
                    multa = Double.parseDouble(request.getParameter("multa"));
                } catch (Exception ignored) {}

                String obs = request.getParameter("observaciones");

                boolean procesado = prestamoDAO.procesarDevolucion(idPrestamo, estadoLibro, multa, obs);
                if (procesado) {
                    response.sendRedirect(request.getContextPath() + "/admin/prestamos?msg=devolucionRegistrada");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/prestamos?error=errorDevolucion");
                }
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/prestamos?error=errorOperacion");
        }
    }
}
