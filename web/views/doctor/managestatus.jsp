<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="doctor-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    
    <!-- Thêm CSS cho các button -->
    <style>
        .btn-update {
            width: 100%; /* Đảm bảo tất cả button có cùng chiều rộng */
            text-align: center; /* Căn giữa văn bản trong button */
            margin: 5px 0; /* Khoảng cách giữa các button */
            padding: 10px 0; /* Đảm bảo button có chiều cao đồng đều */
        }
    </style>
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>

    <div class="content">
        <div class="container mt-5">
            <h2 class="mb-4">Danh sách bệnh nhân cần khám</h2>

            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <table class="table table-bordered table-hover">
                <thead class="table-primary">
                    <tr>
                        <th>Số thứ tự</th>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Trạng thái hiện tại</th>
                        <th>Cập nhật trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${patients}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td>${p.patientId}</td>
                            <td>${p.fullName}</td>
                            <td>${p.statusDescription}</td>
                            <td>
                                <form action="doctorupdate" method="post" class="d-flex gap-2">
                                    <input type="hidden" name="patientId" value="${p.patientId}" />
                                    
                                    <!-- Kiểm tra trạng thái của bệnh nhân -->
                                    <c:choose>
                                        <c:when test="${p.statusCode == 4}">
                                            <!-- Nếu trạng thái là "Đang khám", hiển thị 2 button -->
                                            <button type="submit" name="statusCode" value="5" class="btn btn-warning btn-sm btn-update">Đang chờ bệnh nhân xét nghiệm</button>
                                            <button type="submit" name="statusCode" value="9" class="btn btn-success btn-sm btn-update">Đã khám xong - Chờ thanh toán</button>
                                        </c:when>
                                        <c:when test="${p.statusCode == 8}">
                                            <!-- Nếu trạng thái là "Đã lấy kết quả xét nghiệm", chỉ cho phép chọn "Đang khám" -->
                                            <button type="submit" name="statusCode" value="4" class="btn btn-warning btn-sm btn-update">Đang khám</button>
                                        </c:when>
                                        <c:when test="${p.statusCode == 3}">
                                            <!-- Nếu trạng thái là "Đang đợi khám", chỉ cho phép chọn "Đang khám" -->
                                            <button type="submit" name="statusCode" value="4" class="btn btn-warning btn-sm btn-update">Đang khám</button>
                                        </c:when>
                                    </c:choose>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>
