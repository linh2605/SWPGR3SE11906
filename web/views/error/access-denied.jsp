<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = currentUser != null ? currentUser.getRole().getName() : "Guest";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Access Denied - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        .access-denied-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .access-denied-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 100%;
            overflow: hidden;
            animation: slideIn 0.5s ease-out;
        }
        .access-denied-header {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .access-denied-icon {
            font-size: 4rem;
            margin-bottom: 15px;
            opacity: 0.9;
        }
        .access-denied-body {
            padding: 40px 30px;
            text-align: center;
        }
        .role-badge {
            background: #667eea;
            color: white;
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 600;
            display: inline-block;
            margin: 15px 0;
        }
        .action-buttons {
            margin-top: 30px;
        }
        .btn-action {
            margin: 5px;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            color: white;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            color: white;
        }
        .btn-secondary-custom {
            background: #6c757d;
            color: white;
            border: none;
        }
        .btn-secondary-custom:hover {
            background: #5a6268;
            transform: translateY(-2px);
            color: white;
        }
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .divider {
            height: 1px;
            background: linear-gradient(to right, transparent, #dee2e6, transparent);
            margin: 25px 0;
        }
    </style>
</head>
<body>
    <div class="access-denied-container">
        <div class="access-denied-card">
            <div class="access-denied-header">
                <i class="bi bi-shield-exclamation access-denied-icon"></i>
                <h2 class="mb-0">Access Denied</h2>
                <p class="mb-0 mt-2 opacity-75">Không có quyền truy cập</p>
            </div>
                         <div class="access-denied-body">
                 <h3 class="text-dark mb-3">Oops! Trang này không dành cho bạn</h3>
                 <p class="text-muted mb-3">Bạn đang đăng nhập với vai trò:</p>
                 <div class="role-badge"><%= userRole %></div>
                 
                 <div class="divider"></div>
                 
                 <p class="text-muted">Trang này yêu cầu quyền truy cập khác. Vui lòng quay về trang chính của bạn hoặc liên hệ quản trị viên.</p>
                 
                 <div class="action-buttons">
                     <% if ("Patient".equals(userRole)) { %>
                         <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-primary-custom btn-action">
                             <i class="bi bi-calendar-check me-2"></i>Lịch Hẹn Của Tôi
                         </a>
                     <% } else if ("Doctor".equals(userRole)) { %>
                         <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn btn-primary-custom btn-action">
                             <i class="bi bi-person-badge me-2"></i>Dashboard Bác Sĩ
                         </a>
                     <% } else if ("Receptionist".equals(userRole)) { %>
                         <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn btn-primary-custom btn-action">
                             <i class="bi bi-calendar2-week me-2"></i>Quản Lý Lịch Hẹn
                         </a>
                     <% } else if ("Admin".equals(userRole)) { %>
                         <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary-custom btn-action">
                             <i class="bi bi-speedometer2 me-2"></i>Dashboard Admin
                         </a>
                     <% } %>
                     
                     <br>
                     <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary-custom btn-action">
                         <i class="bi bi-house me-2"></i>Trang Chủ
                     </a>
                 </div>
             </div>
         </div>
     </div>
 </body>
 </html> 