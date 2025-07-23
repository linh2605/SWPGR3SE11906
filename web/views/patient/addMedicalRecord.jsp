<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../layouts/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm hồ sơ bệnh án - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        .form-section {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            padding: 30px;
        }
        .form-label {
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="container my-5">
        <div class="form-section">
            <h3 class="text-primary mb-4">📝 Thêm hồ sơ bệnh án</h3>

            <!-- Hiển thị thông báo -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/medicalRecord" method="post" class="row g-3">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="patientId" value="${patientId}">
                
                <div class="col-12">
                    <label class="form-label">Chẩn đoán</label>
                    <textarea name="diagnosis" class="form-control" rows="3" required></textarea>
                </div>
                <div class="col-12">
                    <label class="form-label">Phác đồ điều trị</label>
                    <textarea name="treatment" class="form-control" rows="3" required></textarea>
                </div>
                <div class="col-12">
                    <label class="form-label">Đơn thuốc</label>
                    <textarea name="prescription" class="form-control" rows="3"></textarea>
                </div>
                
                <div class="col-12 text-end">
                    <button type="submit" class="btn btn-primary">Lưu hồ sơ</button>
                    <a href="${pageContext.request.contextPath}/medicalRecord?action=list&patientId=${patientId}" class="btn btn-secondary">Quay lại</a>
                </div>
            </form>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
