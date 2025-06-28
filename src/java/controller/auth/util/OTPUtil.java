/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.auth.util;

/**
 *
 * @author auiri
 */
import java.util.Random;

public class OTPUtil {
    public static String generateOTP() {
        Random rand = new Random();
        return String.format("%06d", rand.nextInt(999999));
    }
}
