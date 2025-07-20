/**
 * JWT Token Manager
 * Handles automatic token refresh and authentication state
 */

class JWTManager {
    constructor() {
        this.refreshInterval = null;
        this.init();
    }
    
    init() {
        // Check if user is authenticated
        if (this.isAuthenticated()) {
            this.startAutoRefresh();
        }
    }
    
    /**
     * Check if user is authenticated by looking for JWT cookie
     */
    isAuthenticated() {
        return this.getJWTCookie() !== null;
    }
    
    /**
     * Get JWT token from cookie
     */
    getJWTCookie() {
        const cookies = document.cookie.split(';');
        for (let cookie of cookies) {
            const [name, value] = cookie.trim().split('=');
            if (name === 'jwt_token') {
                return value;
            }
        }
        return null;
    }
    
    /**
     * Start automatic token refresh
     */
    startAutoRefresh() {
        // Refresh token every 23 hours (for 24-hour tokens)
        // or every 3.5 hours (for 4-hour tokens)
        const refreshTime = 23 * 60 * 60 * 1000; // 23 hours in milliseconds
        
        this.refreshInterval = setInterval(() => {
            this.refreshToken();
        }, refreshTime);
        
        // Also refresh on page visibility change (when user returns to tab)
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.refreshToken();
            }
        });
    }
    
    /**
     * Stop automatic token refresh
     */
    stopAutoRefresh() {
        if (this.refreshInterval) {
            clearInterval(this.refreshInterval);
            this.refreshInterval = null;
        }
    }
    
    /**
     * Refresh JWT token
     */
    async refreshToken() {
        try {
            const response = await fetch('/ClinicManagementSystem/jwt/refresh', {
                method: 'GET',
                credentials: 'include' // Include cookies
            });
            
            if (response.ok) {
                console.log('JWT token refreshed successfully');
            } else {
                console.error('Failed to refresh JWT token');
                this.handleAuthFailure();
            }
        } catch (error) {
            console.error('Error refreshing JWT token:', error);
            this.handleAuthFailure();
        }
    }
    
    /**
     * Handle authentication failure
     */
    handleAuthFailure() {
        this.stopAutoRefresh();
        
        // Show notification to user
        this.showAuthNotification();
        
        // Redirect to login after a delay
        setTimeout(() => {
            window.location.href = '/ClinicManagementSystem/views/home/login.jsp';
        }, 3000);
    }
    
    /**
     * Show authentication notification
     */
    showAuthNotification() {
        // Create notification element
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #f44336;
            color: white;
            padding: 15px 20px;
            border-radius: 5px;
            z-index: 10000;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            font-family: Arial, sans-serif;
        `;
        notification.innerHTML = `
            <strong>Phiên đăng nhập đã hết hạn</strong><br>
            Bạn sẽ được chuyển đến trang đăng nhập trong 3 giây...
        `;
        
        document.body.appendChild(notification);
        
        // Remove notification after 3 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 3000);
    }
    
    /**
     * Logout user
     */
    logout() {
        this.stopAutoRefresh();
        window.location.href = '/ClinicManagementSystem/logout';
    }
}

// Initialize JWT Manager when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.jwtManager = new JWTManager();
});

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = JWTManager;
} 