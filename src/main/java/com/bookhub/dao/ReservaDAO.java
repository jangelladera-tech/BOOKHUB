package com.bookhub.dao;

import com.bookhub.beans.Reserva;
import com.bookhub.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {

    private static final String BASE_SELECT =
        "SELECT r.*, u.nombre AS usuario_nombre, u.apellido AS usuario_apellido, u.email AS usuario_email, " +
        "l.titulo AS libro_titulo, l.portada_url AS libro_portada " +
        "FROM reservas r " +
        "JOIN usuarios u ON r.id_usuario = u.id_usuario " +
        "JOIN libros l ON r.id_libro = l.id_libro ";

    public List<Reserva> listarTodas() {
        List<Reserva> lista = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY r.id_reserva DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearReserva(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodas reservas: " + e.getMessage());
        }
        return lista;
    }

    public List<Reserva> listarPorUsuario(int idUsuario) {
        List<Reserva> lista = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE r.id_usuario = ? ORDER BY r.fecha_reserva DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearReserva(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en listarPorUsuario reservas: " + e.getMessage());
        }
        return lista;
    }

    public boolean existeReservaActiva(int idUsuario, int idLibro) {
        String sql = "SELECT COUNT(*) FROM reservas WHERE id_usuario = ? AND id_libro = ? AND estado = 'PENDIENTE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idLibro);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en existeReservaActiva: " + e.getMessage());
        }
        return false;
    }

    public boolean crearReserva(Reserva r) {
        String sql = "INSERT INTO reservas (id_usuario, id_libro, fecha_vencimiento, estado) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getIdUsuario());
            ps.setInt(2, r.getIdLibro());
            ps.setDate(3, r.getFechaVencimiento());
            ps.setString(4, r.getEstado() != null ? r.getEstado() : "PENDIENTE");

            int filas = ps.executeUpdate();
            if (filas > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        r.setIdReserva(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error en crearReserva: " + e.getMessage());
        }
        return false;
    }

    public boolean cancelarReserva(int idReserva, int idUsuario, boolean esAdmin) {
        String sql = esAdmin 
            ? "UPDATE reservas SET estado = 'CANCELADA' WHERE id_reserva = ?" 
            : "UPDATE reservas SET estado = 'CANCELADA' WHERE id_reserva = ? AND id_usuario = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idReserva);
            if (!esAdmin) {
                ps.setInt(2, idUsuario);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en cancelarReserva: " + e.getMessage());
        }
        return false;
    }

    public boolean completarReserva(int idReserva) {
        String sql = "UPDATE reservas SET estado = 'COMPLETADA' WHERE id_reserva = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idReserva);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en completarReserva: " + e.getMessage());
        }
        return false;
    }

    public int contarReservasPendientes() {
        String sql = "SELECT COUNT(*) FROM reservas WHERE estado = 'PENDIENTE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error en contarReservasPendientes: " + e.getMessage());
        }
        return 0;
    }

    private Reserva mapearReserva(ResultSet rs) throws SQLException {
        Reserva r = new Reserva();
        r.setIdReserva(rs.getInt("id_reserva"));
        r.setIdUsuario(rs.getInt("id_usuario"));
        r.setNombreUsuario(rs.getString("usuario_nombre") + " " + rs.getString("usuario_apellido"));
        r.setEmailUsuario(rs.getString("usuario_email"));
        r.setIdLibro(rs.getInt("id_libro"));
        r.setTituloLibro(rs.getString("libro_titulo"));
        r.setPortadaLibro(rs.getString("libro_portada"));
        r.setFechaReserva(rs.getTimestamp("fecha_reserva"));
        r.setFechaVencimiento(rs.getDate("fecha_vencimiento"));
        r.setEstado(rs.getString("estado"));
        return r;
    }
}
