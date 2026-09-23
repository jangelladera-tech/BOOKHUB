package com.bookhub.servlet;

import com.bookhub.beans.Estadisticas;
import com.bookhub.beans.Prestamo;
import com.bookhub.beans.Reserva;
import com.bookhub.dao.DevolucionDAO;
import com.bookhub.dao.LibroDAO;
import com.bookhub.dao.PrestamoDAO;
import com.bookhub.dao.ReservaDAO;
import com.bookhub.dao.UsuarioDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final LibroDAO libroDAO = new LibroDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final PrestamoDAO prestamoDAO = new PrestamoDAO();
    private final ReservaDAO reservaDAO = new ReservaDAO();
    private final DevolucionDAO devolucionDAO = new DevolucionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Estadisticas stats = new Estadisticas();
        stats.setTotalLibros(libroDAO.contarTotalLibros());
        stats.setTotalUsuarios(usuarioDAO.contarUsuarios());
        stats.setPrestamosActivos(prestamoDAO.contarPrestamosActivos());
        stats.setReservasPendientes(reservaDAO.contarReservasPendientes());
        stats.setLibrosDisponibles(libroDAO.contarLibrosDisponibles());
        stats.setTotalDevoluciones(devolucionDAO.contarDevoluciones());

        List<Prestamo> prestamosRecientes = prestamoDAO.listarTodos();
        if (prestamosRecientes.size() > 5) {
            prestamosRecientes = prestamosRecientes.subList(0, 5);
        }

        List<Reserva> reservasRecientes = reservaDAO.listarTodas();
        if (reservasRecientes.size() > 5) {
            reservasRecientes = reservasRecientes.subList(0, 5);
        }

        request.setAttribute("stats", stats);
        request.setAttribute("prestamosRecientes", prestamosRecientes);
        request.setAttribute("reservasRecientes", reservasRecientes);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
