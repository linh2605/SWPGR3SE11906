<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="technician-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hồ sơ kỹ thuật viên - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>

    <div class="container mt-5">
        <div class="card p-4 shadow-lg">
            <h4 class="text-primary mb-4">Hồ sơ kỹ thuật viên</h4>

            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/update-profile" enctype="multipart/form-data">
                <input type="hidden" name="roleId" value="4" />

                <div class="row">
                    <div class="col-md-3 text-center">
                        <img src="${profile.imageUrl}" class="img-thumbnail mb-3" style="max-width: 150px;">
                        <input type="file" name="imageFile" class="form-control">
                    </div>
                    <div class="col-md-9">
                        <div class="mb-3">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" name="fullName" class="form-control" value="${profile.fullName}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Giới tính</label>
                            <select name="gender" class="form-select" required>
                                <option value="Male" ${profile.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Female" ${profile.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ngày sinh</label>
                            <input type="date" name="dob" class="form-control" value="${profile.dob}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" value="${profile.phone}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" value="${profile.email}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ca làm</label>
                            <select name="shift" class="form-control" required>
    <option value="Ca sáng" ${profile.shift == 'Ca sáng' ? 'selected' : ''}>Ca sáng</option>
    <option value="Ca chiều" ${profile.shift == 'Ca chiều' ? 'selected' : ''}>Ca chiều</option>
    <option value="Ca tối" ${profile.shift == 'Ca tối' ? 'selected' : ''}>Ca tối</option>
</select>

                        </div>
                        <div class="mb-3">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-control" name="status" required>
    <option value="active" ${profile.status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
    <option value="inactive" ${profile.status == 'inactive' ? 'selected' : ''}>Tạm nghỉ</option>
</select>

                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/change-password" class="btn btn-outline-secondary">Đổi mật khẩu</a>
                            <button type="submit" class="btn btn-primary">Cập nhật hồ sơ</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>
</body>
</html>
