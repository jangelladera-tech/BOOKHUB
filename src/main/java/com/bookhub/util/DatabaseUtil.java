package com.bookhub.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Utilidad para la gestión centralizada de conexiones JDBC a MySQL.
 */
public class DatabaseUtil {

    private static String url;
    private static String user;
    private static String password;
    private static String driver;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DatabaseUtil.class.getClassLoader().getResourceAsStream("db.properties");
            if (is != null) {
                props.load(is);
                url = props.getProperty("db.url");
                user = props.getProperty("db.user");
                password = props.getProperty("db.password");
                driver = props.getProperty("db.driver");
            } else {
                // Configuración predeterminada si no encuentra db.properties
                driver = "com.mysql.cj.jdbc.Driver";
                url = "jdbc:mysql://localhost:3306/bookhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";
                user = "root";
                password = "";
            }
            Class.forName(driver);
        } catch (Exception e) {
            System.err.println("Error al inicializar el driver JDBC: " + e.getMessage());
        }
    }

    /**
     * Obtiene una nueva conexión activa con la base de datos MySQL.
     * @return Connection activa
     * @throws SQLException si ocurre un error de conexión
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Cierra de forma segura una conexión JDBC.
     * @param conn conexión a cerrar
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar conexión: " + e.getMessage());
            }
        }
    }
}
