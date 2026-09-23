package com.bookhub.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utilidad para el hash seguro de contraseñas de usuarios.
 */
public class PasswordUtil {

    /**
     * Aplica el algoritmo SHA-256 a la contraseña plana.
     * @param password Contraseña sin cifrar
     * @return Cadena hexadecimal con el hash SHA-256
     */
    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al calcular hash de contraseña", e);
        }
    }
}
