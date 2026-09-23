package com.bookhub.dao;

import com.bookhub.beans.Devolucion;
import com.bookhub.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DevolucionDAO {

    private static final String BASE_SELECT =
        "SELECT d.*, p.id_usuario, l.titulo AS libro_titulo, " +
        "CONCAT(u.nombre, ' ', u.apellido) AS usuario_nombre " +
        "FROM devoluciones d " +
        "JOIN prestamos p ON d.id_prestamo = p.id_prestamo " +
        "JOIN usuarios u ON p.id_usuario = u.id_usuario " +
        "JOIN libros l ON p.id_libro = l.id_libro ";

    public List<Devolucion> listarTodas() {
        List<Devolucion> lista = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY d.fecha_devolucion DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearDevolucion(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodas devoluciones: " + e.getMessage());
        }
        return lista;
    }

    public List<Devolucion> listarPorUsuario(int idUsuario) {
        List<Devolucion> lista = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE p.id_usuario = ? ORDER BY d.fecha_devolucion DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearDevolucion(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en listarPorUsuario devoluciones: " + e.getMessage());
        }
        return lista;
    }

    public int contarDevoluciones() {
        String sql = "SELECT COUNT(*) FROM devoluciones";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error en contarDevoluciones: " + e.getMessage());
        }
        return 0;
    }

    private Devolucion mapearDevolucion(ResultSet rs) throws SQLException {
        Devolucion d = new Devolucion();
        d.setIdDevolucion(rs.getInt("id_devolucion"));
        d.setIdPrestamo(rs.getInt("id_prestamo"));
        d.setFechaDevolucion(rs.getTimestamp("fecha_devolucion"));
        d.setEstadoLibro(rs.getString("estado_libro"));
        d.setMulta(rs.getDouble("multa"));
        d.setObservaciones(rs.getString("observaciones"));
        d.setTituloLibro(rs.getString("libro_titulo"));
        d.setNombreUsuario(rs.getString("usuario_nombre"));
        return d;
    }
}
