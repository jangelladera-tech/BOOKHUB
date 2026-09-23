package com.bookhub.servlet;

import com.bookhub.beans.Usuario;
import com.bookhub.dao.UsuarioDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUsuariosServlet", urlPatterns = {"/admin/usuarios"})
public class AdminUsuariosServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Usuario> usuarios = usuarioDAO.listarTodos();
        request.setAttribute("usuarios", usuarios);
        request.getRequestDispatcher("/WEB-INF/views/admin/usuarios.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario adminActual = (Usuario) session.getAttribute("usuarioLogueado");

        String action = request.getParameter("action");
        String idUsuarioStr = request.getParameter("idUsuario");

        if (idUsuarioStr != null) {
            try {
                int idUsuario = Integer.parseInt(idUsuarioStr.trim());

                // Evitar auto-bloqueo o auto-eliminación
                if (adminActual.getIdUsuario() == idUsuario) {
                    response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=noPuedeModificarPropioUsuario");
                    return;
                }

                if ("cambiarEstado".equalsIgnoreCase(action)) {
                    String nuevoEstado = request.getParameter("estado");
                    Usuario u = usuarioDAO.buscarPorId(idUsuario);
                    if (u != null && nuevoEstado != null) {
                        u.setEstado(nuevoEstado);
                        usuarioDAO.actualizar(u);
                        response.sendRedirect(request.getContextPath() + "/admin/usuarios?msg=estadoActualizado");
                        return;
                    }
                } else if ("eliminar".equalsIgnoreCase(action)) {
                    usuarioDAO.eliminar(idUsuario);
                    response.sendRedirect(request.getContextPath() + "/admin/usuarios?msg=usuarioEliminado");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
    }
}
