<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../layouts/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu - G3 Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        body {
            background: linear-gradient(120deg, #f6f9fc, #e9eff5);
            font-family: 'Montserrat', sans-serif;
        }
        .card {
            max-width: 500px;
            margin: 50px auto;
            border-radius: 16px;
            border: none;
        }
        .card h4 {
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="container">
        <div class="card shadow-lg p-4">
            <h4 class="text-center text-primary mb-4">Đổi mật khẩu</h4>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/new-password" onsubmit="return validatePassword()">
                <div class="mb-3">
                    <label class="form-label">Mật khẩu cũ</label>
                    <input type="password" name="oldPassword" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu mới</label>
                    <input type="password" name="newPassword" id="newPassword" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nhập lại mật khẩu mới</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required>
                </div>

                <div id="passwordError" class="text-danger mb-3" style="display: none;"></div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Cập nhật mật khẩu</button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function validatePassword() {
        const password = document.getElementById("newPassword").value;
        const confirm = document.getElementById("confirmPassword").value;
        const errorDiv = document.getElementById("passwordError");

        const pattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

        if (!pattern.test(password)) {
            errorDiv.textContent = "Mật khẩu phải có ít nhất 8 ký tự và bao gồm cả chữ và số.";
            errorDiv.style.display = "block";
            return false;
        }

        if (password !== confirm) {
            errorDiv.textContent = "Mật khẩu xác nhận không khớp.";
            errorDiv.style.display = "block";
            return false;
        }

        errorDiv.style.display = "none";
        return true;
    }
</script>
</body>
</html>
