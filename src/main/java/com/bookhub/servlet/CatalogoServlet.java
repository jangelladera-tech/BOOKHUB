package com.bookhub.servlet;

import com.bookhub.beans.Autor;
import com.bookhub.beans.Categoria;
import com.bookhub.beans.Libro;
import com.bookhub.dao.AutorDAO;
import com.bookhub.dao.CategoriaDAO;
import com.bookhub.dao.LibroDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CatalogoServlet", urlPatterns = {"/catalogo"})
public class CatalogoServlet extends HttpServlet {

    private final LibroDAO libroDAO = new LibroDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final AutorDAO autorDAO = new AutorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        String catParam = request.getParameter("categoria");
        String autParam = request.getParameter("autor");

        Integer idCategoria = null;
        if (catParam != null && !catParam.trim().isEmpty()) {
            try { idCategoria = Integer.parseInt(catParam.trim()); } catch (NumberFormatException ignored) {}
        }

        Integer idAutor = null;
        if (autParam != null && !autParam.trim().isEmpty()) {
            try { idAutor = Integer.parseInt(autParam.trim()); } catch (NumberFormatException ignored) {}
        }

        List<Libro> libros = libroDAO.buscar(query, idCategoria, idAutor);
        List<Categoria> categorias = categoriaDAO.listarTodas();
        List<Autor> autores = autorDAO.listarTodos();

        request.setAttribute("libros", libros);
        request.setAttribute("categorias", categorias);
        request.setAttribute("autores", autores);
        request.setAttribute("q", query);
        request.setAttribute("categoriaSeleccionada", idCategoria);
        request.setAttribute("autorSeleccionado", idAutor);

        request.getRequestDispatcher("/WEB-INF/views/catalogo.jsp").forward(request, response);
    }
}
