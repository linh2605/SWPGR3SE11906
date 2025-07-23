<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../layouts/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xem hồ sơ bệnh án - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        .record-detail {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            padding: 30px;
        }
        .record-label {
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="container my-5">
        <div class="record-detail">
            <h3 class="text-primary mb-4">📄 Chi tiết hồ sơ bệnh án</h3>

            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="mb-3">
                <span class="record-label">Ngày tạo:</span>
                ${medicalRecord.createdAt}
            </div>
            <div class="mb-3">
                <span class="record-label">Bác sĩ phụ trách:</span>
                ${medicalRecord.doctorFullName}
            </div>
            <div class="mb-3">
                <span class="record-label">Chẩn đoán:</span>
                <p>${medicalRecord.diagnosis}</p>
            </div>
            <div class="mb-3">
                <span class="record-label">Phác đồ điều trị:</span>
                <p>${medicalRecord.treatment}</p>
            </div>
            <div class="mb-3">
                <span class="record-label">Đơn thuốc:</span>
                <p>${medicalRecord.prescription}</p>
            </div>

            <div class="text-end">
                <a href="${pageContext.request.contextPath}/medicalRecord?action=list&patientId=${medicalRecord.patientId}" class="btn btn-secondary">Quay lại danh sách</a>
            </div>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
