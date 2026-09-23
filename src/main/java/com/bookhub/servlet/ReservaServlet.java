package com.bookhub.servlet;

import com.bookhub.beans.Reserva;
import com.bookhub.beans.Usuario;
import com.bookhub.dao.ReservaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "ReservaServlet", urlPatterns = {"/usuario/reservar"})
public class ReservaServlet extends HttpServlet {

    private final ReservaDAO reservaDAO = new ReservaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        int idUsuario = usuario.getIdUsuario();

        String action = request.getParameter("action");

        if ("cancelar".equalsIgnoreCase(action)) {
            String idReservaStr = request.getParameter("idReserva");
            if (idReservaStr != null) {
                try {
                    int idReserva = Integer.parseInt(idReservaStr.trim());
                    reservaDAO.cancelarReserva(idReserva, idUsuario, false);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/usuario/reservas?msg=cancelada");
            return;
        }

        // Crear nueva reserva
        String idLibroStr = request.getParameter("idLibro");
        if (idLibroStr != null) {
            try {
                int idLibro = Integer.parseInt(idLibroStr.trim());

                if (reservaDAO.existeReservaActiva(idUsuario, idLibro)) {
                    response.sendRedirect(request.getContextPath() + "/libro?id=" + idLibro + "&error=yaReservado");
                    return;
                }

                Reserva r = new Reserva();
                r.setIdUsuario(idUsuario);
                r.setIdLibro(idLibro);
                // Vence en 3 días hábiles
                r.setFechaVencimiento(Date.valueOf(LocalDate.now().plusDays(3)));
                r.setEstado("PENDIENTE");

                boolean creada = reservaDAO.crearReserva(r);
                if (creada) {
                    response.sendRedirect(request.getContextPath() + "/usuario/reservas?msg=reservaExitosa");
                    return;
                }
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/catalogo?error=errorReserva");
    }
}
