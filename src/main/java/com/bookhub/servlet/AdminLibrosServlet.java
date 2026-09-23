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

@WebServlet(name = "AdminLibrosServlet", urlPatterns = {"/admin/libros"})
public class AdminLibrosServlet extends HttpServlet {

    private final LibroDAO libroDAO = new LibroDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final AutorDAO autorDAO = new AutorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Libro> libros = libroDAO.listarTodos();
        List<Categoria> categorias = categoriaDAO.listarTodas();
        List<Autor> autores = autorDAO.listarTodos();

        request.setAttribute("libros", libros);
        request.setAttribute("categorias", categorias);
        request.setAttribute("autores", autores);

        request.getRequestDispatcher("/WEB-INF/views/admin/libros.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("eliminar".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("idLibro"));
                libroDAO.eliminar(id);
                response.sendRedirect(request.getContextPath() + "/admin/libros?msg=eliminado");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/libros?error=noSePudoEliminar");
            }
            return;
        }

        // Crear o Editar
        try {
            String titulo = request.getParameter("titulo");
            String isbn = request.getParameter("isbn");
            int idAutor = Integer.parseInt(request.getParameter("idAutor"));
            int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
            String editorial = request.getParameter("editorial");
            Integer anio = request.getParameter("anioPublicacion") != null && !request.getParameter("anioPublicacion").isEmpty()
                ? Integer.parseInt(request.getParameter("anioPublicacion")) : null;
            Integer paginas = request.getParameter("paginas") != null && !request.getParameter("paginas").isEmpty()
                ? Integer.parseInt(request.getParameter("paginas")) : null;
            int ejemplaresTotales = Integer.parseInt(request.getParameter("ejemplaresTotales"));
            String portadaUrl = request.getParameter("portadaUrl");
            String descripcion = request.getParameter("descripcion");
            boolean destacado = request.getParameter("destacado") != null;

            if ("editar".equalsIgnoreCase(action)) {
                int idLibro = Integer.parseInt(request.getParameter("idLibro"));
                Libro existente = libroDAO.buscarPorId(idLibro);
                if (existente != null) {
                    existente.setTitulo(titulo);
                    existente.setIsbn(isbn);
                    existente.setIdAutor(idAutor);
                    existente.setIdCategoria(idCategoria);
                    existente.setEditorial(editorial);
                    existente.setAnioPublicacion(anio);
                    existente.setPaginas(paginas);
                    int delta = ejemplaresTotales - existente.getEjemplaresTotales();
                    existente.setEjemplaresTotales(ejemplaresTotales);
                    existente.setEjemplaresDisponibles(Math.max(0, existente.getEjemplaresDisponibles() + delta));
                    existente.setPortadaUrl(portadaUrl);
                    existente.setDescripcion(descripcion);
                    existente.setDestacado(destacado);

                    libroDAO.actualizar(existente);
                    response.sendRedirect(request.getContextPath() + "/admin/libros?msg=actualizado");
                    return;
                }
            } else {
                // Crear nuevo
                Libro nuevo = new Libro();
                nuevo.setTitulo(titulo);
                nuevo.setIsbn(isbn);
                nuevo.setIdAutor(idAutor);
                nuevo.setIdCategoria(idCategoria);
                nuevo.setEditorial(editorial);
                nuevo.setAnioPublicacion(anio);
                nuevo.setPaginas(paginas);
                nuevo.setEjemplaresTotales(ejemplaresTotales);
                nuevo.setEjemplaresDisponibles(ejemplaresTotales);
                nuevo.setPortadaUrl(portadaUrl != null && !portadaUrl.trim().isEmpty() ? portadaUrl : "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600");
                nuevo.setDescripcion(descripcion);
                nuevo.setCalificacion(5.0);
                nuevo.setDestacado(destacado);

                libroDAO.insertar(nuevo);
                response.sendRedirect(request.getContextPath() + "/admin/libros?msg=creado");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/libros?error=errorOperacion");
        }
    }
}
