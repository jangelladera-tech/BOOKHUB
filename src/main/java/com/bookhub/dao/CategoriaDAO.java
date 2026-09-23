package com.bookhub.dao;

import com.bookhub.beans.Categoria;
import com.bookhub.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    public List<Categoria> listarTodas() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(l.id_libro) AS total_libros FROM categorias c " +
                     "LEFT JOIN libros l ON c.id_categoria = l.id_categoria " +
                     "GROUP BY c.id_categoria ORDER BY c.nombre ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                c.setIcono(rs.getString("icono"));
                c.setTotalLibros(rs.getInt("total_libros"));
                lista.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodas categorias: " + e.getMessage());
        }
        return lista;
    }

    public Categoria buscarPorId(int id) {
        String sql = "SELECT * FROM categorias WHERE id_categoria = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Categoria c = new Categoria();
                    c.setIdCategoria(rs.getInt("id_categoria"));
                    c.setNombre(rs.getString("nombre"));
                    c.setDescripcion(rs.getString("descripcion"));
                    c.setIcono(rs.getString("icono"));
                    return c;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en buscarPorId categoria: " + e.getMessage());
        }
        return null;
    }

    public boolean insertar(Categoria c) {
        String sql = "INSERT INTO categorias (nombre, descripcion, icono) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            ps.setString(3, c.getIcono() != null ? c.getIcono() : "bi-bookmark-check");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en insertar categoria: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizar(Categoria c) {
        String sql = "UPDATE categorias SET nombre = ?, descripcion = ?, icono = ? WHERE id_categoria = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            ps.setString(3, c.getIcono());
            ps.setInt(4, c.getIdCategoria());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en actualizar categoria: " + e.getMessage());
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM categorias WHERE id_categoria = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en eliminar categoria: " + e.getMessage());
        }
        return false;
    }
}
