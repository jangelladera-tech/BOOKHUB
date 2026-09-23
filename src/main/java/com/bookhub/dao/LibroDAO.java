package com.bookhub.dao;

import com.bookhub.beans.Libro;
import com.bookhub.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LibroDAO {

    private static final String BASE_SELECT = 
        "SELECT l.*, a.nombre AS autor_nombre, c.nombre AS categoria_nombre " +
        "FROM libros l " +
        "JOIN autores a ON l.id_autor = a.id_autor " +
        "JOIN categorias c ON l.id_categoria = c.id_categoria ";

    public List<Libro> listarTodos() {
        List<Libro> lista = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY l.id_libro DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearLibro(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodos libros: " + e.getMessage());
        }
        return lista;
    }

    public List<Libro> listarDestacados(int limite) {
        List<Libro> lista = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE l.destacado = TRUE ORDER BY l.calificacion DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearLibro(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en listarDestacados: " + e.getMessage());
        }
        return lista;
    }

    public List<Libro> buscar(String query, Integer idCategoria, Integer idAutor) {
        List<Libro> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT).append("WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(l.titulo) LIKE ? OR LOWER(a.nombre) LIKE ? OR LOWER(l.isbn) LIKE ?) ");
            String q = "%" + query.trim().toLowerCase() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }

        if (idCategoria != null && idCategoria > 0) {
            sql.append("AND l.id_categoria = ? ");
            params.add(idCategoria);
        }

        if (idAutor != null && idAutor > 0) {
            sql.append("AND l.id_autor = ? ");
            params.add(idAutor);
        }

        sql.append("ORDER BY l.calificacion DESC, l.id_libro DESC");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearLibro(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en buscar libros: " + e.getMessage());
        }
        return lista;
    }

    public Libro buscarPorId(int id) {
        String sql = BASE_SELECT + "WHERE l.id_libro = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearLibro(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en buscarPorId libro: " + e.getMessage());
        }
        return null;
    }

    public boolean insertar(Libro l) {
        String sql = "INSERT INTO libros (titulo, isbn, id_autor, id_categoria, editorial, anio_publicacion, " +
                     "paginas, ejemplares_totales, ejemplares_disponibles, portada_url, descripcion, calificacion, destacado) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, l.getTitulo());
            ps.setString(2, l.getIsbn());
            ps.setInt(3, l.getIdAutor());
            ps.setInt(4, l.getIdCategoria());
            ps.setString(5, l.getEditorial());
            ps.setObject(6, l.getAnioPublicacion());
            ps.setObject(7, l.getPaginas());
            ps.setInt(8, l.getEjemplaresTotales());
            ps.setInt(9, l.getEjemplaresDisponibles());
            ps.setString(10, l.getPortadaUrl());
            ps.setString(11, l.getDescripcion());
            ps.setDouble(12, l.getCalificacion());
            ps.setBoolean(13, l.isDestacado());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        l.setIdLibro(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error en insertar libro: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizar(Libro l) {
        String sql = "UPDATE libros SET titulo = ?, isbn = ?, id_autor = ?, id_categoria = ?, editorial = ?, " +
                     "anio_publicacion = ?, paginas = ?, ejemplares_totales = ?, ejemplares_disponibles = ?, " +
                     "portada_url = ?, descripcion = ?, calificacion = ?, destacado = ? WHERE id_libro = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, l.getTitulo());
            ps.setString(2, l.getIsbn());
            ps.setInt(3, l.getIdAutor());
            ps.setInt(4, l.getIdCategoria());
            ps.setString(5, l.getEditorial());
            ps.setObject(6, l.getAnioPublicacion());
            ps.setObject(7, l.getPaginas());
            ps.setInt(8, l.getEjemplaresTotales());
            ps.setInt(9, l.getEjemplaresDisponibles());
            ps.setString(10, l.getPortadaUrl());
            ps.setString(11, l.getDescripcion());
            ps.setDouble(12, l.getCalificacion());
            ps.setBoolean(13, l.isDestacado());
            ps.setInt(14, l.getIdLibro());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en actualizar libro: " + e.getMessage());
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM libros WHERE id_libro = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en eliminar libro: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizarDisponibilidad(int idLibro, int cambio) {
        String sql = "UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles + (?) " +
                     "WHERE id_libro = ? AND (ejemplares_disponibles + (?)) >= 0";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cambio);
            ps.setInt(2, idLibro);
            ps.setInt(3, cambio);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en actualizarDisponibilidad: " + e.getMessage());
        }
        return false;
    }

    public int contarTotalLibros() {
        String sql = "SELECT COUNT(*) FROM libros";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error en contarTotalLibros: " + e.getMessage());
        }
        return 0;
    }

    public int contarLibrosDisponibles() {
        String sql = "SELECT SUM(ejemplares_disponibles) FROM libros";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error en contarLibrosDisponibles: " + e.getMessage());
        }
        return 0;
    }

    private Libro mapearLibro(ResultSet rs) throws SQLException {
        Libro l = new Libro();
        l.setIdLibro(rs.getInt("id_libro"));
        l.setTitulo(rs.getString("titulo"));
        l.setIsbn(rs.getString("isbn"));
        l.setIdAutor(rs.getInt("id_autor"));
        l.setNombreAutor(rs.getString("autor_nombre"));
        l.setIdCategoria(rs.getInt("id_categoria"));
        l.setNombreCategoria(rs.getString("categoria_nombre"));
        l.setEditorial(rs.getString("editorial"));
        l.setAnioPublicacion((Integer) rs.getObject("anio_publicacion"));
        l.setPaginas((Integer) rs.getObject("paginas"));
        l.setEjemplaresTotales(rs.getInt("ejemplares_totales"));
        l.setEjemplaresDisponibles(rs.getInt("ejemplares_disponibles"));
        l.setPortadaUrl(rs.getString("portada_url"));
        l.setDescripcion(rs.getString("descripcion"));
        l.setCalificacion(rs.getDouble("calificacion"));
        l.setDestacado(rs.getBoolean("destacado"));
        l.setFechaIngreso(rs.getTimestamp("fecha_ingreso"));
        return l;
    }
}
