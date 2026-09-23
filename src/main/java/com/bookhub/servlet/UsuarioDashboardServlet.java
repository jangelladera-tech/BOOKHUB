package com.bookhub.servlet;

import com.bookhub.beans.Devolucion;
import com.bookhub.beans.Prestamo;
import com.bookhub.beans.Reserva;
import com.bookhub.beans.Usuario;
import com.bookhub.dao.DevolucionDAO;
import com.bookhub.dao.PrestamoDAO;
import com.bookhub.dao.ReservaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UsuarioDashboardServlet", urlPatterns = {
    "/usuario/dashboard",
    "/usuario/prestamos",
    "/usuario/reservas",
    "/usuario/devoluciones"
})
public class UsuarioDashboardServlet extends HttpServlet {

    private final PrestamoDAO prestamoDAO = new PrestamoDAO();
    private final ReservaDAO reservaDAO = new ReservaDAO();
    private final DevolucionDAO devolucionDAO = new DevolucionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        int idUsuario = usuario.getIdUsuario();

        String servletPath = request.getServletPath();

        switch (servletPath) {
            case "/usuario/prestamos": {
                List<Prestamo> prestamos = prestamoDAO.listarPorUsuario(idUsuario);
                request.setAttribute("prestamos", prestamos);
                request.getRequestDispatcher("/WEB-INF/views/usuario/prestamos.jsp").forward(request, response);
                break;
            }
            case "/usuario/reservas": {
                List<Reserva> reservas = reservaDAO.listarPorUsuario(idUsuario);
                request.setAttribute("reservas", reservas);
                request.getRequestDispatcher("/WEB-INF/views/usuario/reservas.jsp").forward(request, response);
                break;
            }
            case "/usuario/devoluciones": {
                List<Devolucion> devoluciones = devolucionDAO.listarPorUsuario(idUsuario);
                request.setAttribute("devoluciones", devoluciones);
                request.getRequestDispatcher("/WEB-INF/views/usuario/devoluciones.jsp").forward(request, response);
                break;
            }
            case "/usuario/dashboard":
            default: {
                List<Prestamo> prestamos = prestamoDAO.listarPorUsuario(idUsuario);
                List<Reserva> reservas = reservaDAO.listarPorUsuario(idUsuario);
                List<Devolucion> devoluciones = devolucionDAO.listarPorUsuario(idUsuario);

                long prestamosActivos = prestamos.stream().filter(p -> "ACTIVO".equalsIgnoreCase(p.getEstado())).count();
                long reservasPendientes = reservas.stream().filter(r -> "PENDIENTE".equalsIgnoreCase(r.getEstado())).count();

                request.setAttribute("prestamosActivos", prestamosActivos);
                request.setAttribute("reservasPendientes", reservasPendientes);
                request.setAttribute("totalDevoluciones", devoluciones.size());
                request.setAttribute("ultimosPrestamos", prestamos.size() > 5 ? prestamos.subList(0, 5) : prestamos);

                request.getRequestDispatcher("/WEB-INF/views/usuario/dashboard.jsp").forward(request, response);
                break;
            }
        }
    }
}
