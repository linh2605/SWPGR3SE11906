<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.util.*, models.*" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết bệnh nhân - G3 Hospital Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="main">
        <%@ include file="../layouts/admin-side-bar.jsp" %>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Chi tiết bệnh nhân</h2>
                <a href="<%= request.getContextPath() %>/admin/patient" class="btn btn-secondary">Quay lại</a>
            </div>

            <%
                Patient patient = (Patient) request.getAttribute("patient");
                User user = patient != null ? patient.getUser() : null;
            %>

            <% if (patient != null && user != null) { %>
            <div class="card">
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h5 class="card-title">Thông tin cá nhân</h5>
                            <p><strong>Họ tên:</strong> <%= user.getFullName() %></p>
                            <p><strong>Giới tính:</strong> <%= patient.getGender() %></p>
                            <p><strong>Ngày sinh:</strong> <%= patient.getDate_of_birth() %></p>
                            <p><strong>Email:</strong> <%= user.getEmail() %></p>
                            <p><strong>Số điện thoại:</strong> <%= user.getPhone() %></p>
                            <p><strong>Trạng thái tài khoản:</strong> <%= patient.getStatus_code() == 1 ? "Active" : "Inactive" %></p>
                            <p><strong>Ngày tạo hồ sơ:</strong> <%= patient.getCreated_at() %></p>
                        </div>
                        <div class="col-md-6">
                            <h5 class="card-title">Thông tin tài khoản</h5>
                            <p><strong>Username:</strong> <%= user.getUsername() %></p>
                            <p><strong>Vai trò:</strong> <%= user.getRole() != null ? user.getRole().getName() : "N/A" %></p>
                            <p><strong>Avatar:</strong><br>
                                <%
                                    String img = patient.getImage_url();
                                    String imgSrc = (img != null && img.startsWith("http")) ? img
                                            : (img != null && !img.isEmpty()) ? request.getContextPath() + "/assets/" + img
                                            : request.getContextPath() + "/assets/default-avatar.jpg";
                                %>
                                <img src="<%= imgSrc %>" alt="Avatar" width="120" class="rounded">
                            </p>
                            <p><strong>Địa chỉ:</strong> <%= patient.getAddress() != null ? patient.getAddress() : "Chưa cung cấp" %></p>
                        </div>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="alert alert-danger">Không tìm thấy thông tin bệnh nhân.</div>
            <% } %>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>
