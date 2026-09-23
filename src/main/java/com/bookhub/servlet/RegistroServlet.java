package com.bookhub.servlet;

import com.bookhub.beans.Usuario;
import com.bookhub.dao.UsuarioDAO;
import com.bookhub.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/registro"})
public class RegistroServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String telefono = request.getParameter("telefono");

        // Validaciones básicas
        if (nombre == null || apellido == null || email == null || password == null ||
            nombre.trim().isEmpty() || apellido.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Todos los campos obligatorios deben ser completados.");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Las contraseñas no coinciden.");
            request.setAttribute("nombre", nombre);
            request.setAttribute("apellido", apellido);
            request.setAttribute("email", email);
            request.setAttribute("telefono", telefono);
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }

        // Verificar si email ya existe
        if (usuarioDAO.buscarPorEmail(email.trim()) != null) {
            request.setAttribute("error", "El correo electrónico ya se encuentra registrado.");
            request.setAttribute("nombre", nombre);
            request.setAttribute("apellido", apellido);
            request.setAttribute("telefono", telefono);
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }

        Usuario nuevo = new Usuario();
        nuevo.setNombre(nombre.trim());
        nuevo.setApellido(apellido.trim());
        nuevo.setEmail(email.trim().toLowerCase());
        nuevo.setPassword(PasswordUtil.hashPassword(password.trim()));
        nuevo.setTelefono(telefono != null ? telefono.trim() : "");
        nuevo.setIdRol(2); // 2: USUARIO
        nuevo.setNombreRol("USUARIO");
        nuevo.setEstado("ACTIVO");

        boolean creado = usuarioDAO.insertar(nuevo);
        if (creado) {
            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioLogueado", nuevo);
            response.sendRedirect(request.getContextPath() + "/usuario/dashboard?msg=bienvenido");
        } else {
            request.setAttribute("error", "Error interno al crear la cuenta. Intente nuevamente.");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        }
    }
}
