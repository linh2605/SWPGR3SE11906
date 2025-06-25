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
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>

        <div class="main">
            <%@ include file="../layouts/admin-side-bar.jsp" %>

            <div class="content">
                <div class="container mt-5">
                    <h2 class="mb-4"> Danh sách bệnh nhân cần xét nghiệm / chụp chiếu</h2>

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
                                                <select name="statusCode" class="form-select">
                                                    <c:forEach var="s" items="${statuses}">
                                                        <option value="${s.code}" ${s.code == p.statusCode ? "selected" : ""}>
                                                            ${s.description}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <button type="submit" class="btn btn-success btn-sm">Cập nhật</button>
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
