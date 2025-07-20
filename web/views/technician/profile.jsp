<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../layouts/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ kỹ thuật viên - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        .profile-section {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            padding: 30px;
        }
        .form-label {
            font-weight: 600;
        }
        .profile-avatar {
            width: 160px;
            height: 160px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #0d6efd;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="container my-5">
            <div class="profile-section">
                <h3 class="text-primary mb-4">Hồ sơ kỹ thuật viên</h3>

                <c:if test="${param.success eq 'true'}">
                    <div class="alert alert-success">Cập nhật thông tin thành công!</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/ProfileServlet" enctype="multipart/form-data">
                    <div class="row mb-4">
                        <div class="col-md-4 text-center mb-3">
                            <img src="${profile.imageUrl}" alt="Avatar" class="profile-avatar"
                                 onerror="this.src='https://www.svgrepo.com/show/452030/avatar-default.svg';">
                            <input type="hidden" name="existingImageUrl" value="${profile.imageUrl}">
                            <label class="form-label mt-3">Chọn ảnh mới</label>
                            <input type="file" class="form-control" name="avatarFile" accept="image/*">
                        </div>
                        <div class="col-md-8">
                            <div class="mb-3">
                                <label class="form-label">Họ và tên</label>
                                <input type="text" class="form-control" name="fullName" value="${profile.fullName}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giới tính</label>
                                <select class="form-select" name="gender" required>
                                    <option value="MALE" ${profile.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                                    <option value="FEMALE" ${profile.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                    <option value="OTHER" ${profile.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Ngày sinh</label>
                                <input type="date" class="form-control" name="dob" value="${profile.dob}">
                            </div>
                        </div>
                    </div>

                    <h5 class="text-muted">Thông tin liên hệ</h5>
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

                    <div class="d-flex justify-content-end mt-4">
                        <a href="${pageContext.request.contextPath}/new-password" class="btn btn-outline-secondary me-3">Đổi mật khẩu</a>
                        <button type="submit" class="btn btn-primary">Cập nhật hồ sơ</button>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="../layouts/footer.jsp" %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script></script>
</body>
</html>
