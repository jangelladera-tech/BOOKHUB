package com.bookhub.servlet;

import com.bookhub.beans.Categoria;
import com.bookhub.dao.CategoriaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoriasServlet", urlPatterns = {"/admin/categorias"})
public class AdminCategoriasServlet extends HttpServlet {

    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Categoria> categorias = categoriaDAO.listarTodas();
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("/WEB-INF/views/admin/categorias.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("eliminar".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("idCategoria"));
                categoriaDAO.eliminar(id);
                response.sendRedirect(request.getContextPath() + "/admin/categorias?msg=eliminado");
                return;
            }

            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String icono = request.getParameter("icono");

            if ("editar".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("idCategoria"));
                Categoria c = categoriaDAO.buscarPorId(id);
                if (c != null) {
                    c.setNombre(nombre);
                    c.setDescripcion(descripcion);
                    c.setIcono(icono);
                    categoriaDAO.actualizar(c);
                    response.sendRedirect(request.getContextPath() + "/admin/categorias?msg=actualizado");
                    return;
                }
            } else {
                Categoria nueva = new Categoria();
                nueva.setNombre(nombre);
                nueva.setDescripcion(descripcion);
                nueva.setIcono(icono != null && !icono.trim().isEmpty() ? icono : "bi-bookmark-check");
                categoriaDAO.insertar(nueva);
                response.sendRedirect(request.getContextPath() + "/admin/categorias?msg=creado");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categorias?error=errorOperacion");
        }
    }
}
