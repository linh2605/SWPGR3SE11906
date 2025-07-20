

<%@ page import="models.Service" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="models.Specialty" %>
<%@ page import="models.Doctor" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    Service service = (Service) request.getAttribute("service");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết gói khám - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
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
                <form action="action" class="col-12">
                                    <h1>Chi tiết gói khám</h1>

                        <div class="mb-3">
                            <label class="form-label">Tên gói</label>
                            <input disabled type="text" name="name" value="<%= service.getName() %>" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Các bác sĩ phụ trách</label>
                            <input disabled type="text" name="name" value="<%= service.getDoctors().stream().map(d -> d.getUser().getFullName()).collect(Collectors.joining(", ")) %>" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea disabled name="description" class="form-control"><%= service.getDetail() %></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Giá</label>
                            <input disabled type="number" name="price" step="0.01" min="0" value="<%= service.getPrice() %>" class="form-control" required>
                        </div>
                        
                        <a href="<%=request.getContextPath()%>/appointment?package_id=<%=request.getParameter("id")%>">
                            <button type="button" class="btn btn-success">Đặt lịch khám ngay</button>
                        </a>

                </form>
            </div>
    </div>
</div>
<%@ include file="../layouts/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>
