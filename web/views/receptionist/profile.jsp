<%-- 
    Document   : profile
    Created on : 24 thg 6, 2025, 05:14:46
    Author     : auiri
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hồ sơ nhân viên lễ tân - G3 Hospital</title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="../layouts/header.jsp" %>
            
            <div class="d-flex">
                <%@ include file="../layouts/receptionist-side-bar.jsp" %>
                
                <div class="content">
                    <div class="container-fluid mt-5">
                        <div class="profile-section">
                            <h3>Hồ sơ cá nhân</h3>

                            <c:if test="${param.success eq 'true'}">
                                <div class="alert alert-success">Cập nhật thông tin thành công!</div>
                            </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/ProfileServlet" enctype="multipart/form-data">
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="profile-avatar-container">
                                    <img src="${profile.imageUrl}" alt="Avatar" class="profile-avatar"
                                         onerror="this.src='https://www.svgrepo.com/show/452030/avatar-default.svg';">
                                    <input type="hidden" name="existingImageUrl" value="${profile.imageUrl}">
                                    <label class="form-label">Chọn ảnh mới</label>
                                    <input type="file" class="form-control" name="avatarFile" accept="image/*">
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="mb-3">
                                    <label class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" name="fullName" value="${profile.fullName}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Giới tính</label>
                                    <!-- Debug: ${profile.gender} -->
                                    <select class="form-select" name="gender" required>
                                        <option value="MALE" ${profile.gender == 'MALE' || profile.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                        <option value="FEMALE" ${profile.gender == 'FEMALE' || profile.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                        <option value="OTHER" ${profile.gender == 'OTHER' || profile.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" name="dob" value="${profile.dob}">
                                </div>
                            </div>
                        </div>

                        <h5>Thông tin liên hệ</h5>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" value="${profile.email}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input type="text" class="form-control" name="phone" value="${profile.phone}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ca làm việc</label>
                                <select name="shift" class="form-control" required>
    <option value="Ca sáng" ${profile.shift == 'Ca sáng' ? 'selected' : ''}>Ca sáng</option>
    <option value="Ca chiều" ${profile.shift == 'Ca chiều' ? 'selected' : ''}>Ca chiều</option>
    <option value="Ca tối" ${profile.shift == 'Ca tối' ? 'selected' : ''}>Ca tối</option>
</select>

                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Trạng thái</label>
                                <select class="form-control" name="status" required>
    <option value="active" ${profile.status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
    <option value="inactive" ${profile.status == 'inactive' ? 'selected' : ''}>Tạm nghỉ</option>
</select>

                            </div>
                        </div>

                        <div class="profile-actions">
                            <a href="${pageContext.request.contextPath}/new-password" class="btn btn-outline-secondary">Đổi mật khẩu</a>
                            <button type="submit" class="btn btn-primary">Cập nhật hồ sơ</button>
                        </div>
                    </form>
                </div>
                    </div>
                </div>
            </div>

            <%@ include file="../layouts/footer.jsp" %>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>
    </body>
</html>

