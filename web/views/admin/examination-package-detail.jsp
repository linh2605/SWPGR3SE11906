
<%@ page import="models.ExaminationPackage" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    ExaminationPackage examinationPackage = (ExaminationPackage) request.getAttribute("examinationPackage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết gói khám - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
        }
        .info-box {
            background: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin: 30px auto;
            max-width: 600px;
        }
        .section-title {
            font-size: 1.5rem;
            font-weight: bold;
            border-bottom: 2px solid #ccc;
            margin-bottom: 20px;
            padding-bottom: 10px;
        }
        .info-item {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="main">
        <div class="content">
            <div class="container">
                <div class="info-box">
                    <div class="section-title">Chi tiết gói khám: <%= examinationPackage.getName() %></div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/examination-manage">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="<%= examinationPackage.getExaminationPackageId() %>">

                        <div class="mb-3">
                            <label class="form-label">Tên gói</label>
                            <input type="text" name="name" value="<%= examinationPackage.getName() %>" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea name="description" class="form-control"><%= examinationPackage.getDescription() %></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Giá</label>
                            <input type="number" name="price" step="0.01" min="0" value="<%= examinationPackage.getPrice() %>" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Thời lượng (phút)</label>
                            <input type="number" name="duration" min="1" value="<%= examinationPackage.getDuration() %>" class="form-control" required>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/admin/examination-manage" class="btn btn-secondary">Quay lại</a>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>
