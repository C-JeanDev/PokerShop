package model.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtils {

    private PasswordUtils() {}

    /**
     * Restituisce l'hash SHA-256 della stringa in input, in formato esadecimale.
     * Usato per salvare la password nel DB e per confrontarla al login.
     */
    public static String hash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(password.getBytes("UTF-8"));

            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();

        } catch (Exception e) {
            throw new RuntimeException("Errore durante l'hashing della password", e);
        }
    }

    /**
     * Confronta una password in chiaro con il suo hash salvato nel DB.
     */
    public static boolean verify(String passwordChiaro, String hashSalvato) {
        return hash(passwordChiaro).equals(hashSalvato);
    }
}
