<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.util.*" %>
<%@ page import="models.*" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết bác sĩ - G3 Hospital Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="main">
        <%@include file="../layouts/admin-side-bar.jsp"%>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Chi tiết bác sĩ</h2>
                <a href="${pageContext.request.contextPath}/admin/doctor" class="btn btn-secondary">Quay lại</a>
            </div>

            <%
                Doctor doctor = (Doctor) request.getAttribute("doctor");
                User user = doctor.getUser();
                Specialty spec = doctor.getSpecialty();
            %>

            <% if (doctor != null) { %>
            <div class="card">
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h5 class="card-title">Thông tin cá nhân</h5>
                            <p><strong>Họ tên:</strong> <%= doctor.getUser().getFullName() %></p>
                            <p><strong>Giới tính:</strong> <%= doctor.getGender() %></p>
                            <p><strong>Ngày sinh:</strong> <%= doctor.getDob() %></p>
                            <p><strong>Email:</strong> <%= user.getEmail() %></p>
                            <p><strong>Số điện thoại:</strong> <%= user.getPhone() %></p>
                            <p><strong>Trạng thái tài khoản:</strong> <%= doctor.getStatus() %></p>
                            <p><strong>Ảnh đại diện:</strong><br>
                                <img src="<%= doctor.getImage_url().startsWith("http") ? doctor.getImage_url() : request.getContextPath() + "/" + doctor.getImage_url() %>" alt="Avatar" width="120" class="rounded">
                            </p>
                        </div>
                        <div class="col-md-6">
                            <h5 class="card-title">Thông tin nghề nghiệp</h5>
                            <p><strong>Chuyên khoa:</strong> <%= spec != null ? spec.getName() : "Không có" %></p>
                            <p><strong>Bằng cấp:</strong> <%= doctor.getDegree() %></p>
                            <p><strong>Kinh nghiệm:</strong> <%= doctor.getExperience() %></p>
                            <p><strong>Trạng thái hợp đồng:</strong> <%= doctor.getContract_status() %></p>
                            <p><strong>Ngày bắt đầu HĐ:</strong> <%= doctor.getContract_start_date() %></p>
                            <p><strong>Ngày kết thúc HĐ:</strong> <%= doctor.getContract_end_date() != null ? doctor.getContract_end_date() : "Không xác định" %></p>
                            <p><strong>Ngày tạo hồ sơ:</strong> <%= doctor.getCreated_at() %></p>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-12">
                            <h5 class="card-title">Dịch vụ đã đăng ký</h5>
                            <% List<Service> services = doctor.getServices(); %>
                            <% if (services != null && !services.isEmpty()) { %>
                            <ul>
                                <% for (Service s : services) { %>
                                <li><%= s.getName() %></li>
                                <% } %>
                            </ul>
                            <% } else { %>
                            <p class="text-muted">Chưa đăng ký dịch vụ nào.</p>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="alert alert-danger">Không tìm thấy thông tin bác sĩ.</div>
            <% } %>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>
