<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../layouts/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ bệnh án - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        .records-section {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            padding: 30px;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .btn-view {
            background-color: #0d6efd;
            color: #fff;
        }
        .btn-view:hover {
            background-color: #0b5ed7;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="container my-5">
        <div class="records-section">
            <h3 class="text-primary mb-4">📄 Danh sách hồ sơ bệnh án</h3>

            <c:choose>
                <c:when test="${not empty records}">
                    <table class="table table-hover table-bordered shadow-sm">
                        <thead class="table-dark">
                            <tr class="text-center">
                                <th>#</th>
                                <th>Ngày tạo</th>
                                <th>Bác sĩ phụ trách</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="record" items="${records}" varStatus="status">
                                <tr>
                                    <td class="text-center">${status.index + 1}</td>
                                    <td>${record.createdAt}</td>
                                    <td>${record.doctorFullName}</td>
                                    <td class="text-center">
                                        <a href="medicalRecord?action=view&recordId=${record.recordId}" class="btn btn-view btn-sm">
                                            Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center">
                        ⚠️ Bạn chưa có hồ sơ bệnh án nào.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>
