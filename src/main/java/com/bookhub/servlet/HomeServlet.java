package com.bookhub.servlet;

import com.bookhub.beans.Autor;
import com.bookhub.beans.Categoria;
import com.bookhub.beans.Libro;
import com.bookhub.dao.AutorDAO;
import com.bookhub.dao.CategoriaDAO;
import com.bookhub.dao.LibroDAO;
import com.bookhub.dao.PrestamoDAO;
import com.bookhub.dao.UsuarioDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/index", "/home"})
public class HomeServlet extends HttpServlet {

    private final LibroDAO libroDAO = new LibroDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final AutorDAO autorDAO = new AutorDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final PrestamoDAO prestamoDAO = new PrestamoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Libros destacados
        List<Libro> librosDestacados = libroDAO.listarDestacados(6);
        // Categorías con conteo
        List<Categoria> categorias = categoriaDAO.listarTodas();
        // Autores destacados
        List<Autor> autoresDestacados = autorDAO.listarDestacados(4);

        // Métricas globales para el hero / stats
        int totalLibros = libroDAO.contarTotalLibros();
        int totalUsuarios = usuarioDAO.contarUsuarios();
        int prestamosActivos = prestamoDAO.contarPrestamosActivos();

        request.setAttribute("librosDestacados", librosDestacados);
        request.setAttribute("categorias", categorias);
        request.setAttribute("autoresDestacados", autoresDestacados);
        request.setAttribute("totalLibros", totalLibros);
        request.setAttribute("totalUsuarios", totalUsuarios);
        request.setAttribute("prestamosActivos", prestamosActivos);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
