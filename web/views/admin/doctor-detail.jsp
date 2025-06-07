<%@ page import="models.Doctor" %>
<%@ page import="models.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    User user = doctor.getUser();
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết bác sĩ - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
        }

        .card-profile {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 2px solid #eaeaea;
        }

        .card-profile img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 20px;
        }

        .info-box {
            background: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: bold;
            border-bottom: 2px solid #ccc;
            margin-bottom: 15px;
            padding-bottom: 5px;
        }

        .info-item {
            margin-bottom: 10px;
        }

        .icon-circle {
            width: 24px;
            height: 24px;
            display: inline-block;
            text-align: center;
            border-radius: 50%;
            background-color: #007bff;
            color: #fff;
            margin-right: 5px;
        }

        .icon-green {
            background-color: #28a745;
        }

        .contact-icon {
            width: 18px;
            height: 18px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>

    <div class="main">
        <div class="content">
            <h2>Thông tin chi tiết về bác sĩ <%= user.getFullname() %></h2>
            <div class="container mt-5">
                <div class="row mt-4">
                    <!-- Professional Info -->
                    <div class="col-md-6">
                        <div class="info-box">
                            <div class="section-title"><span class="icon-circle">👨‍⚕️</span>Thông tin chuyên môn:</div>
                            <div class="info-item">Chuyên khoa: <%= doctor.getSpecialty().getName() %></div>
                            <div class="info-item">Bằng cấp: <%= doctor.getDegree() %></div>
                            <div class="info-item">Kinh nghiệm: <%= doctor.getExperience() %></div>
                            <div class="info-item">Trạng thái: <%= doctor.getStatus().name() %></div>
                            <div class="info-item">Ngày thêm vào hệ thống: <%= sdf.format(doctor.getCreated_at()) %></div>
                        </div>
                    </div>

                    <!-- Personal Info -->
                    <div class="col-md-6">
                        <div class="info-box">
                            <div class="section-title"><span class="icon-circle icon-green">🧾</span>Thông tin định danh:</div>
                            <div class="info-item">Họ và tên: <%= user.getFullname() %></div>
                            <div class="info-item">Ngày sinh: <%= sdf.format(doctor.getDob()) %></div>
                            <div class="info-item">Giới tính: <%= doctor.getGender().name() %></div>
                            <div class="info-item">Doctor ID: <%= doctor.getDoctor_id() %></div>
                            <div class="info-item">SĐT liên lạc: <%= user.getPhone() %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>
