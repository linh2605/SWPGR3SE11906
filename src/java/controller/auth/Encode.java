package controller.auth;

import java.security.MessageDigest;
import java.util.Base64;

/**
 *
 * @author auiri
 */
public class Encode {

    public static String toSHA1(String str) {
        String salt = "asjrlkmcoewj@tjle; oxqskjhdjksjfljurVn";    
        String result = null;
        str = str + salt;

        try {
            byte[] dataBytes = str.getBytes("UTF-8");
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            byte[] digest = md.digest(dataBytes);
            result = Base64.getEncoder().encodeToString(digest); // Use the correct method here
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}
