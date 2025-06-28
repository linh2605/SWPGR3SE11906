<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="receptionist-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Receptionist Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>

        <div class="content">
            <div class="container mt-5">
                <h2 class="mb-4">Danh sách bệnh nhân đang chờ</h2>

                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <table class="table table-bordered table-hover">
                    <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Trạng thái hiện tại</th>
                        <th>Cập nhật trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${patients}">
                        <tr>
                            <td>${p.patientId}</td>
                            <td>${p.fullName}</td>
                            <td>${p.statusDescription}</td>
                            <td>
                                <form action="receptionistuplate" method="post" class="d-flex gap-2">
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
            </div>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>
