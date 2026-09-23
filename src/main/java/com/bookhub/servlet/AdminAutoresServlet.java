package com.bookhub.servlet;

import com.bookhub.beans.Autor;
import com.bookhub.dao.AutorDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAutoresServlet", urlPatterns = {"/admin/autores"})
public class AdminAutoresServlet extends HttpServlet {

    private final AutorDAO autorDAO = new AutorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Autor> autores = autorDAO.listarTodos();
        request.setAttribute("autores", autores);
        request.getRequestDispatcher("/WEB-INF/views/admin/autores.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("eliminar".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("idAutor"));
                autorDAO.eliminar(id);
                response.sendRedirect(request.getContextPath() + "/admin/autores?msg=eliminado");
                return;
            }

            String nombre = request.getParameter("nombre");
            String nacionalidad = request.getParameter("nacionalidad");
            String biografia = request.getParameter("biografia");
            String fotoUrl = request.getParameter("fotoUrl");

            if ("editar".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("idAutor"));
                Autor a = autorDAO.buscarPorId(id);
                if (a != null) {
                    a.setNombre(nombre);
                    a.setNacionalidad(nacionalidad);
                    a.setBiografia(biografia);
                    a.setFotoUrl(fotoUrl);
                    autorDAO.actualizar(a);
                    response.sendRedirect(request.getContextPath() + "/admin/autores?msg=actualizado");
                    return;
                }
            } else {
                Autor nuevo = new Autor();
                nuevo.setNombre(nombre);
                nuevo.setNacionalidad(nacionalidad);
                nuevo.setBiografia(biografia);
                nuevo.setFotoUrl(fotoUrl != null && !fotoUrl.trim().isEmpty() ? fotoUrl : "https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&q=80&w=300");
                autorDAO.insertar(nuevo);
                response.sendRedirect(request.getContextPath() + "/admin/autores?msg=creado");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/autores?error=errorOperacion");
        }
    }
}
