<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="header">
    <!-- Thêm script để truyền thông tin user -->
<c:choose>
    <c:when test="${not empty sessionScope.user}">
        <script>
            window.user = {
                userId: "${sessionScope.user.userId}",
                username: "${sessionScope.user.username}",
                fullName: "${sessionScope.user.fullName}",
                email: "${sessionScope.user.email}",
                phone: "${sessionScope.user.phone}",
                roleId: "${sessionScope.user.role.roleId}",
                roleName: "${sessionScope.user.role.name}"
            };
            window.roleId = "${sessionScope.role_id != null ? sessionScope.role_id : ''}";
            window.contextPath = '${pageContext.request.contextPath}';
        </script>
    </c:when>
    <c:otherwise>
        <script>
            window.user = null;
            window.roleId = "";
            window.contextPath = '${pageContext.request.contextPath}';
        </script>
    </c:otherwise>
</c:choose>
    
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/views/home/index.jsp">
                <img src="${pageContext.request.contextPath}/assets/FAUGET MEDICAL.png" alt="G3 Hospital Logo">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <!-- Guest -->
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/info/about_us.jsp">Giới thiệu</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/home/doctor-list.jsp">Bác sĩ</a></li>
                            <li class="nav-item"><a class="nav-link" href="#">Chuyên khoa</a></li>
                            <li class="nav-item"><a class="nav-link" href="#">Tư vấn sức khỏe</a></li>
                            <li class="nav-item"><a class="nav-link" href="#">Bài viết</a></li>
                            <li class="nav-item"><a class="nav-link" href="#">Thư viện media</a></li>
                        </c:when>
                        <c:when test="${sessionScope.user.role.roleId == 1}">
                            <!-- Patient -->
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/info/about_us.jsp">Giới thiệu</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/home/doctor-list.jsp">Bác sĩ</a></li>
                            <li class="nav-item"><a class="nav-link" href="#">Chuyên khoa</a></li>
                            <li class="nav-item"><a class="nav-link" href="#">Tư vấn sức khỏe</a></li>
                            <li class="nav-item"><a class="nav-link" href="#">Bài viết</a></li>
                            <li class="nav-item"><a class="nav-link" href="#">Thư viện media</a></li>
                        </c:when>
                        <c:when test="${sessionScope.user.role.roleId == 2}">
                            <!-- Doctor -->
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/doctor/dashboard.jsp">Dashboard</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/doctor-schedule">Lịch làm việc</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/appointment/doctorDashboard.jsp">Lịch hẹn</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/doctor-schedule?action=exceptions">Ngoại lệ</a></li>
                        </c:when>
                        <c:when test="${sessionScope.user.role.roleId == 3}">
                            <!-- Receptionist -->
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/receptionist/dashboard.jsp">Dashboard</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/appointment/receptionistDashboard.jsp">Quản lý lịch hẹn</a></li>
                        </c:when>
                        <c:when test="${sessionScope.user.role.roleId == 4}">
                            <!-- Admin -->
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/doctor">Quản lý bác sĩ</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/patient">Quản lý bệnh nhân</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/admin/working-schedules.jsp">Quản lý lịch làm việc</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/shifts">Quản lý ca</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/admin/schedule-exceptions.jsp">Duyệt ngoại lệ</a></li>
                        </c:when>
                    </c:choose>
                </ul>
                <div class="d-flex align-items-center">
                    <span class="hotline me-3">Hỗ trợ tư vấn: 0976054728</span>
                    
                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <!-- Chưa đăng nhập -->
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary">
                                Đăng ký / Đăng nhập
                            </a>
                        </c:when>
                        <c:otherwise>
                            <!-- Đã đăng nhập -->
                            <div class="dropdown">
                                <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <img src="${pageContext.request.contextPath}/assets/default-avatar.jpg" alt="Avatar" class="rounded-circle me-2" style="width: 32px; height: 32px; object-fit: cover;">
                                    <span class="text-dark">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user.fullName}">
                                                ${sessionScope.user.fullName}
                                            </c:when>
                                            <c:otherwise>
                                                ${sessionScope.user.username}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.role.roleId == 4}">
                                            <!-- Menu cho Admin -->
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">Về trang Dashboard</a></li>
                                        </c:when>
                                        <c:when test="${sessionScope.user.role.roleId == 2}">
                                            <!-- Menu cho Doctor -->
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/doctor/dashboard.jsp">Dashboard</a></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/appointment/doctorDashboard.jsp">Lịch hẹn</a></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctor-schedule">Lịch làm việc</a></li>
                                        </c:when>
                                        <c:when test="${sessionScope.user.role.roleId == 3}">
                                            <!-- Menu cho Receptionist -->
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/receptionist/dashboard.jsp">Dashboard</a></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/appointment/receptionistDashboard.jsp">Quản lý lịch hẹn</a></li>
                                        </c:when>
                                        <c:when test="${sessionScope.user.role.roleId == 1}">
                                            <!-- Menu cho Patient -->
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/patient/profile.jsp">Hồ sơ cá nhân</a></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/appointment/appointments.jsp">Lịch hẹn của tôi</a></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/patient/medical-records.jsp">Hồ sơ bệnh án</a></li>
                                        </c:when>
                                    </c:choose>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
</header>
