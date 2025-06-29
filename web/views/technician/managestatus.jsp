<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Technician Dashboard - G3 Hospital</title>
    <meta http-equiv="Cache-Control" content="no-store" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    
    <!-- Thêm CSS cho các button để đảm bảo kích thước bằng nhau -->
    <style>
        .btn-update {
            width: 100%; /* Đảm bảo chiều rộng của tất cả các button là 100% */
            height: 40px; /* Đảm bảo chiều cao của tất cả các button bằng nhau */
            margin: 5px 0; /* Khoảng cách giữa các button */
            text-align: center; /* Căn giữa văn bản trong button */
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>

        <div class="content">
            <div class="container mt-5">
                <h2 class="mb-4">Danh sách bệnh nhân cần xét nghiệm / chụp chiếu</h2>

                <!-- Hiển thị thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <!-- Nếu có bệnh nhân -->
                <c:if test="${not empty patients}">
                    <table class="table table-bordered table-hover">
                        <thead class="table-primary">
                            <tr>
                                <th>STT</th>
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
                                        <form action="${pageContext.request.contextPath}/technicianupdate" method="post" class="d-flex gap-2">
                                            <input type="hidden" name="patientId" value="${p.patientId}" />

                                            <!-- Kiểm tra trạng thái của bệnh nhân để hiển thị các button phù hợp -->
                                            <c:choose>
                                                

                                                <c:when test="${p.statusCode == 5}">
                                                    <!-- Nếu trạng thái là "Chờ bệnh nhân xét nghiệm", chỉ cho phép chọn "Đang xét nghiệm" -->
                                                    <button type="submit" name="statusCode" value="6" class="btn btn-warning btn-sm btn-update">Đang xét nghiệm</button>
                                                </c:when>

                                                <c:when test="${p.statusCode == 6}">
                                                    <!-- Nếu trạng thái là "Đang xét nghiệm", chỉ cho phép chọn "Chờ lấy kết quả xét nghiệm" -->
                                                    <button type="submit" name="statusCode" value="7" class="btn btn-warning btn-sm btn-update">Chờ lấy kết quả xét nghiệm</button>
                                                </c:when>

                                                <c:when test="${p.statusCode == 7}">
                                                    <!-- Nếu trạng thái là "Chờ lấy kết quả xét nghiệm", chỉ cho phép chọn "Đã lấy kết quả xét nghiệm" -->
                                                    <button type="submit" name="statusCode" value="8" class="btn btn-warning btn-sm btn-update">Đã lấy kết quả xét nghiệm</button>
                                                </c:when>

                                                <c:otherwise>
                                                    <!-- Các trạng thái khác hiển thị button -->
                                                    <button type="submit" class="btn btn-success btn-sm btn-update">Cập nhật</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <!-- Nếu không có bệnh nhân -->
                <c:if test="${empty patients}">
                    <div class="alert alert-info">Không có bệnh nhân nào đang chờ xử lý.</div>
                </c:if>
            </div>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>
