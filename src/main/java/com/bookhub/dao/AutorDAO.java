package com.bookhub.dao;

import com.bookhub.beans.Autor;
import com.bookhub.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AutorDAO {

    public List<Autor> listarTodos() {
        List<Autor> lista = new ArrayList<>();
        String sql = "SELECT a.*, COUNT(l.id_libro) AS total_libros FROM autores a " +
                     "LEFT JOIN libros l ON a.id_autor = l.id_autor " +
                     "GROUP BY a.id_autor ORDER BY a.nombre ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Autor a = new Autor();
                a.setIdAutor(rs.getInt("id_autor"));
                a.setNombre(rs.getString("nombre"));
                a.setNacionalidad(rs.getString("nacionalidad"));
                a.setBiografia(rs.getString("biografia"));
                a.setFotoUrl(rs.getString("foto_url"));
                a.setTotalLibros(rs.getInt("total_libros"));
                lista.add(a);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodos autores: " + e.getMessage());
        }
        return lista;
    }

    public List<Autor> listarDestacados(int limite) {
        List<Autor> lista = new ArrayList<>();
        String sql = "SELECT a.*, COUNT(l.id_libro) AS total_libros FROM autores a " +
                     "LEFT JOIN libros l ON a.id_autor = l.id_autor " +
                     "GROUP BY a.id_autor ORDER BY total_libros DESC, a.nombre ASC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Autor a = new Autor();
                    a.setIdAutor(rs.getInt("id_autor"));
                    a.setNombre(rs.getString("nombre"));
                    a.setNacionalidad(rs.getString("nacionalidad"));
                    a.setBiografia(rs.getString("biografia"));
                    a.setFotoUrl(rs.getString("foto_url"));
                    a.setTotalLibros(rs.getInt("total_libros"));
                    lista.add(a);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en listarDestacados autores: " + e.getMessage());
        }
        return lista;
    }

    public Autor buscarPorId(int id) {
        String sql = "SELECT * FROM autores WHERE id_autor = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Autor a = new Autor();
                    a.setIdAutor(rs.getInt("id_autor"));
                    a.setNombre(rs.getString("nombre"));
                    a.setNacionalidad(rs.getString("nacionalidad"));
                    a.setBiografia(rs.getString("biografia"));
                    a.setFotoUrl(rs.getString("foto_url"));
                    return a;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en buscarPorId autor: " + e.getMessage());
        }
        return null;
    }

    public boolean insertar(Autor a) {
        String sql = "INSERT INTO autores (nombre, nacionalidad, biografia, foto_url) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getNombre());
            ps.setString(2, a.getNacionalidad());
            ps.setString(3, a.getBiografia());
            ps.setString(4, a.getFotoUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en insertar autor: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizar(Autor a) {
        String sql = "UPDATE autores SET nombre = ?, nacionalidad = ?, biografia = ?, foto_url = ? WHERE id_autor = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getNombre());
            ps.setString(2, a.getNacionalidad());
            ps.setString(3, a.getBiografia());
            ps.setString(4, a.getFotoUrl());
            ps.setInt(5, a.getIdAutor());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en actualizar autor: " + e.getMessage());
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM autores WHERE id_autor = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en eliminar autor: " + e.getMessage());
        }
        return false;
    }
}
