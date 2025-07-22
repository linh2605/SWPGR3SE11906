package filter;

import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.AccountStatus;
import models.User;
import java.io.IOException;

@WebFilter("/*")
public class AccountStatusFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Bỏ qua các trang không cần kiểm tra
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Danh sách các URL không cần kiểm tra trạng thái tài khoản
        String[] excludedPaths = {
            "/login",
            "/register", 
            "/forgot-password",
            "/reset-password",
            "/assets/",
            "/images/",
            "/css/",
            "/js/",
            "/favicon.ico",
            "/error/",
            "/views/home/login.jsp",
            "/views/home/register.jsp",
            "/views/home/forgot_password.jsp",
            "/views/error/"
        };
        
        // Kiểm tra xem có phải URL được loại trừ không
        boolean isExcluded = false;
        for (String excludedPath : excludedPaths) {
            if (requestURI.contains(excludedPath)) {
                isExcluded = true;
                break;
            }
        }
        
        // Nếu là URL được loại trừ hoặc chưa đăng nhập, cho phép tiếp tục
        if (isExcluded || session == null || session.getAttribute("user") == null) {
            chain.doFilter(request, response);
            return;
        }
        
        // Kiểm tra trạng thái tài khoản
        User user = (User) session.getAttribute("user");
        if (user != null) {
            AccountStatus accountStatus = UserDAO.checkAccountStatus(user.getUserId());
            
            if (!accountStatus.isActive()) {
                // Tài khoản bị vô hiệu hóa, đăng xuất và chuyển hướng
                session.invalidate();
                
                // Lưu thông tin lỗi vào session mới
                HttpSession newSession = httpRequest.getSession(true);
                newSession.setAttribute("error", accountStatus.getMessage());
                newSession.setAttribute("accountDisabled", true);
                newSession.setAttribute("contactPhone", "0976054728");
                newSession.setAttribute("contactEmail", "admin@g3hospital.com");
                
                // Chuyển hướng về trang login
                httpResponse.sendRedirect(contextPath + "/login");
                return;
            }
        }
        
        // Tài khoản hoạt động bình thường, cho phép tiếp tục
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Không cần dọn dẹp gì
    }
} 