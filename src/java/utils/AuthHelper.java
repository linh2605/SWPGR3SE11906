package utils;

import com.auth0.jwt.interfaces.DecodedJWT;
import models.User;
import models.Role;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;

/**
 * Authentication helper class that supports both Session and JWT authentication
 */
public class AuthHelper {
    
    /**
     * Get current user's role ID from either JWT or session
     * @param request HTTP request
     * @return role ID or null if not authenticated
     */
    public static Integer getCurrentUserRoleId(HttpServletRequest request) {
        // Try JWT first
        String token = getJwtToken(request);
        if (token != null) {
            try {
                DecodedJWT jwt = JWTUtil.validateToken(token);
                return jwt.getClaim("roleId").asInt();
            } catch (Exception e) {
                // JWT invalid, fallback to session
                System.out.println("JWT validation failed: " + e.getMessage());
            }
        }
        
        // Fallback to session (existing behavior)
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (Integer) session.getAttribute("roleId");
        }
        
        return null;
    }
    
    /**
     * Get current user's ID from either JWT or session
     * @param request HTTP request
     * @return user ID or null if not authenticated
     */
    public static Integer getCurrentUserId(HttpServletRequest request) {
        // Try JWT first
        String token = getJwtToken(request);
        if (token != null) {
            try {
                DecodedJWT jwt = JWTUtil.validateToken(token);
                return jwt.getClaim("userId").asInt();
            } catch (Exception e) {
                // JWT invalid, fallback to session
                System.out.println("JWT validation failed: " + e.getMessage());
            }
        }
        
        // Fallback to session (existing behavior)
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (Integer) session.getAttribute("userId");
        }
        
        return null;
    }
    
    /**
     * Get current user object from either JWT or session
     * @param request HTTP request
     * @return User object or null if not authenticated
     */
    public static User getCurrentUser(HttpServletRequest request) {
        // Try JWT first
        String token = getJwtToken(request);
        if (token != null) {
            try {
                DecodedJWT jwt = JWTUtil.validateToken(token);
                User user = new User();
                user.setUserId(jwt.getClaim("userId").asInt());
                user.setUsername(jwt.getClaim("username").asString());
                user.setFullName(jwt.getClaim("fullName").asString());
                user.setEmail(jwt.getClaim("email").asString());
                
                // Create role object
                Role role = new Role();
                role.setRoleId(jwt.getClaim("roleId").asInt());
                role.setName(jwt.getClaim("roleName").asString());
                user.setRole(role);
                
                return user;
            } catch (Exception e) {
                // JWT invalid, fallback to session
                System.out.println("JWT validation failed: " + e.getMessage());
            }
        }
        
        // Fallback to session (existing behavior)
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        
        return null;
    }
    
    /**
     * Check if user is authenticated (either JWT or session)
     * @param request HTTP request
     * @return true if authenticated, false otherwise
     */
    public static boolean isAuthenticated(HttpServletRequest request) {
        return getCurrentUserId(request) != null;
    }
    
    /**
     * Check if user has specific role
     * @param request HTTP request
     * @param requiredRoleId required role ID
     * @return true if user has the role, false otherwise
     */
    public static boolean hasRole(HttpServletRequest request, int requiredRoleId) {
        Integer roleId = getCurrentUserRoleId(request);
        return roleId != null && roleId == requiredRoleId;
    }
    
    /**
     * Extract JWT token from request (cookie or header)
     * @param request HTTP request
     * @return JWT token string or null
     */
    private static String getJwtToken(HttpServletRequest request) {
        // Try cookie first (for web pages)
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("jwt_token".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        
        // Try header (for API calls)
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7);
        }
        
        return null;
    }
    
    /**
     * Get authentication source (JWT or SESSION)
     * @param request HTTP request
     * @return "JWT", "SESSION", or "NONE"
     */
    public static String getAuthSource(HttpServletRequest request) {
        String token = getJwtToken(request);
        if (token != null) {
            try {
                JWTUtil.validateToken(token);
                return "JWT";
            } catch (Exception e) {
                // JWT invalid, check session
            }
        }
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            return "SESSION";
        }
        
        return "NONE";
    }
} 