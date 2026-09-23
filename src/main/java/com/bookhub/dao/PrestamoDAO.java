package com.bookhub.dao;

import com.bookhub.beans.Prestamo;
import com.bookhub.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrestamoDAO {

    private static final String BASE_SELECT =
        "SELECT p.*, u.nombre AS usuario_nombre, u.apellido AS usuario_apellido, u.email AS usuario_email, " +
        "l.titulo AS libro_titulo, l.portada_url AS libro_portada " +
        "FROM prestamos p " +
        "JOIN usuarios u ON p.id_usuario = u.id_usuario " +
        "JOIN libros l ON p.id_libro = l.id_libro ";

    public List<Prestamo> listarTodos() {
        List<Prestamo> lista = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY p.id_prestamo DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearPrestamo(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodos prestamos: " + e.getMessage());
        }
        return lista;
    }

    public List<Prestamo> listarPorUsuario(int idUsuario) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE p.id_usuario = ? ORDER BY p.fecha_prestamo DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearPrestamo(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en listarPorUsuario prestamos: " + e.getMessage());
        }
        return lista;
    }

    public Prestamo buscarPorId(int idPrestamo) {
        String sql = BASE_SELECT + "WHERE p.id_prestamo = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPrestamo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearPrestamo(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en buscarPorId prestamo: " + e.getMessage());
        }
        return null;
    }

    public boolean registrarPrestamo(Prestamo p) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Insertar el préstamo
            String sqlPrestamo = "INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, fecha_devolucion_esperada, estado, observaciones) " +
                                 "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sqlPrestamo, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, p.getIdUsuario());
                ps.setInt(2, p.getIdLibro());
                ps.setDate(3, p.getFechaPrestamo());
                ps.setDate(4, p.getFechaDevolucionEsperada());
                ps.setString(5, p.getEstado() != null ? p.getEstado() : "ACTIVO");
                ps.setString(6, p.getObservaciones());

                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        p.setIdPrestamo(rs.getInt(1));
                    }
                }
            }

            // 2. Disminuir ejemplares disponibles del libro
            String sqlLibro = "UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles - 1 " +
                              "WHERE id_libro = ? AND ejemplares_disponibles > 0";
            try (PreparedStatement ps = conn.prepareStatement(sqlLibro)) {
                ps.setInt(1, p.getIdLibro());
                int updated = ps.executeUpdate();
                if (updated == 0) {
                    conn.rollback();
                    return false; // No había ejemplares disponibles
                }
            }

            // 3. Si existía una reserva pendiente de este usuario para este libro, marcarla como COMPLETADA
            String sqlReserva = "UPDATE reservas SET estado = 'COMPLETADA' " +
                                "WHERE id_usuario = ? AND id_libro = ? AND estado = 'PENDIENTE'";
            try (PreparedStatement ps = conn.prepareStatement(sqlReserva)) {
                ps.setInt(1, p.getIdUsuario());
                ps.setInt(2, p.getIdLibro());
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.err.println("Error en registrarPrestamo: " + e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public boolean procesarDevolucion(int idPrestamo, String estadoLibro, double multa, String observaciones) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Obtener id_libro del préstamo
            int idLibro = 0;
            String sqlFind = "SELECT id_libro, estado FROM prestamos WHERE id_prestamo = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlFind)) {
                ps.setInt(1, idPrestamo);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        if ("DEVUELTO".equalsIgnoreCase(rs.getString("estado"))) {
                            return false; // Ya fue devuelto
                        }
                        idLibro = rs.getInt("id_libro");
                    } else {
                        return false;
                    }
                }
            }

            // 2. Actualizar estado del préstamo
            String sqlUpdatePrestamo = "UPDATE prestamos SET estado = 'DEVUELTO', fecha_devolucion_real = CURRENT_DATE " +
                                       "WHERE id_prestamo = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdatePrestamo)) {
                ps.setInt(1, idPrestamo);
                ps.executeUpdate();
            }

            // 3. Registrar registro de devolución
            String sqlDevolucion = "INSERT INTO devoluciones (id_prestamo, estado_libro, multa, observaciones) " +
                                   "VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sqlDevolucion)) {
                ps.setInt(1, idPrestamo);
                ps.setString(2, estadoLibro != null ? estadoLibro : "BUENO");
                ps.setDouble(3, multa);
                ps.setString(4, observaciones);
                ps.executeUpdate();
            }

            // 4. Reponer ejemplar disponible al libro
            String sqlLibro = "UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles + 1 WHERE id_libro = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlLibro)) {
                ps.setInt(1, idLibro);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.err.println("Error en procesarDevolucion: " + e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public int contarPrestamosActivos() {
        String sql = "SELECT COUNT(*) FROM prestamos WHERE estado = 'ACTIVO'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error en contarPrestamosActivos: " + e.getMessage());
        }
        return 0;
    }

    private Prestamo mapearPrestamo(ResultSet rs) throws SQLException {
        Prestamo p = new Prestamo();
        p.setIdPrestamo(rs.getInt("id_prestamo"));
        p.setIdUsuario(rs.getInt("id_usuario"));
        p.setNombreUsuario(rs.getString("usuario_nombre") + " " + rs.getString("usuario_apellido"));
        p.setEmailUsuario(rs.getString("usuario_email"));
        p.setIdLibro(rs.getInt("id_libro"));
        p.setTituloLibro(rs.getString("libro_titulo"));
        p.setPortadaLibro(rs.getString("libro_portada"));
        p.setFechaPrestamo(rs.getDate("fecha_prestamo"));
        p.setFechaDevolucionEsperada(rs.getDate("fecha_devolucion_esperada"));
        p.setFechaDevolucionReal(rs.getDate("fecha_devolucion_real"));
        p.setEstado(rs.getString("estado"));
        p.setObservaciones(rs.getString("observaciones"));
        return p;
    }
}
