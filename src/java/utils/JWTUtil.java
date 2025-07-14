package utils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.JWTVerifier;
import models.User;

import java.util.Date;

/**
 * JWT Utility class for creating and validating JSON Web Tokens
 */
public class JWTUtil {
    
    // Secret key for signing JWTs (In production, use environment variable)
    private static final String SECRET = "your-clinic-secret-key-2024-change-this-in-production";
    
    // Token expiration times
    private static final long DEFAULT_EXPIRATION_TIME = 24 * 60 * 60 * 1000; // 24 hours
    private static final long PATIENT_EXPIRATION_TIME = 4 * 60 * 60 * 1000; // 4 hours for patients
    
    // Algorithm for signing
    private static final Algorithm ALGORITHM = Algorithm.HMAC512(SECRET);
    
    /**
     * Generate JWT token for a user with default expiration (24 hours)
     * @param user User object containing user information
     * @return JWT token string
     */
    public static String generateToken(User user) {
        return generateTokenWithExpiration(user, getExpirationTimeForRole(user.getRole().getRoleId()));
    }
    
    /**
     * Generate JWT token for a user with custom expiration time
     * @param user User object containing user information
     * @param expirationTime Custom expiration time in milliseconds
     * @return JWT token string
     */
    public static String generateTokenWithExpiration(User user, long expirationTime) {
        try {
            return JWT.create()
                    .withClaim("userId", user.getUserId())
                    .withClaim("roleId", user.getRole().getRoleId())
                    .withClaim("roleName", user.getRole().getName())
                    .withClaim("username", user.getUsername())
                    .withClaim("fullName", user.getFullName())
                    .withClaim("email", user.getEmail())
                    .withIssuedAt(new Date())
                    .withExpiresAt(new Date(System.currentTimeMillis() + expirationTime))
                    .withIssuer("clinic-management-system")
                    .sign(ALGORITHM);
        } catch (JWTCreationException e) {
            throw new RuntimeException("Error creating JWT token", e);
        }
    }
    
    /**
     * Get expiration time based on user role
     * @param roleId User's role ID
     * @return Expiration time in milliseconds
     */
    private static long getExpirationTimeForRole(int roleId) {
        if (roleId == 1) { // Patient role
            return PATIENT_EXPIRATION_TIME; // 4 hours
        } else {
            return DEFAULT_EXPIRATION_TIME; // 24 hours for admin, doctor, receptionist, technician
        }
    }
    
    /**
     * Validate and decode JWT token
     * @param token JWT token string
     * @return DecodedJWT object containing claims
     * @throws JWTVerificationException if token is invalid
     */
    public static DecodedJWT validateToken(String token) throws JWTVerificationException {
        try {
            JWTVerifier verifier = JWT.require(ALGORITHM)
                    .withIssuer("clinic-management-system")
                    .build();
            return verifier.verify(token);
        } catch (JWTVerificationException e) {
            throw e; // Re-throw to be handled by caller
        }
    }
    
    /**
     * Extract user ID from JWT token
     * @param token JWT token string
     * @return user ID or null if token is invalid
     */
    public static Integer extractUserId(String token) {
        try {
            DecodedJWT decodedJWT = validateToken(token);
            return decodedJWT.getClaim("userId").asInt();
        } catch (JWTVerificationException e) {
            return null;
        }
    }
    
    /**
     * Extract role ID from JWT token
     * @param token JWT token string
     * @return role ID or null if token is invalid
     */
    public static Integer extractRoleId(String token) {
        try {
            DecodedJWT decodedJWT = validateToken(token);
            return decodedJWT.getClaim("roleId").asInt();
        } catch (JWTVerificationException e) {
            return null;
        }
    }
    
    /**
     * Check if token is expired
     * @param token JWT token string
     * @return true if token is expired, false otherwise
     */
    public static boolean isTokenExpired(String token) {
        try {
            DecodedJWT decodedJWT = validateToken(token);
            return decodedJWT.getExpiresAt().before(new Date());
        } catch (JWTVerificationException e) {
            return true; // Consider invalid token as expired
        }
    }
} 