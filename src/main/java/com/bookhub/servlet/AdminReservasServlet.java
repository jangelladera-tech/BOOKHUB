package com.bookhub.servlet;

import com.bookhub.beans.Reserva;
import com.bookhub.dao.ReservaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminReservasServlet", urlPatterns = {"/admin/reservas"})
public class AdminReservasServlet extends HttpServlet {

    private final ReservaDAO reservaDAO = new ReservaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Reserva> reservas = reservaDAO.listarTodas();
        request.setAttribute("reservas", reservas);
        request.getRequestDispatcher("/WEB-INF/views/admin/reservas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idReservaStr = request.getParameter("idReserva");

        if (idReservaStr != null) {
            try {
                int idReserva = Integer.parseInt(idReservaStr.trim());

                if ("completar".equalsIgnoreCase(action)) {
                    reservaDAO.completarReserva(idReserva);
                    response.sendRedirect(request.getContextPath() + "/admin/reservas?msg=reservaCompletada");
                    return;
                } else if ("cancelar".equalsIgnoreCase(action)) {
                    reservaDAO.cancelarReserva(idReserva, 0, true);
                    response.sendRedirect(request.getContextPath() + "/admin/reservas?msg=reservaCancelada");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/reservas");
    }
}
