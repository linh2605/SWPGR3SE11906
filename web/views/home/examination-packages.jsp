<%@ page import="java.util.List" %>
<%@ page import="models.ExaminationPackage" %>
<%@ page import="dal.ExaminationPackageDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gói Khám Sức Khỏe - G3 Hospital</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-list.css">
    </head>
    <body>
        <!-- Nhúng header và navbar -->
        <%@ include file="../layouts/header.jsp" %>

        <!-- Main Content -->
        <main>
            <div class="container">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mt-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Gói khám sức khỏe</li>
                    </ol>
                </nav>

                <!-- Page Title -->
                <div class="text-center mb-4">
                    <h1 style="color: #004d99; font-weight: 600;">Gói Khám Sức Khỏe</h1>
                    <p class="text-muted">Chọn gói khám phù hợp với nhu cầu của bạn</p>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <div class="row">
                        <div class="col-md-6">
                            <input type="text" class="search-box" id="searchInput" placeholder="Tìm kiếm gói khám...">
                        </div>
                        <div class="col-md-3">
                            <select class="filter-dropdown" id="priceFilter">
                                <option value="">Tất cả giá</option>
                                <option value="0-2000000">Dưới 2 triệu</option>
                                <option value="2000000-5000000">2 - 5 triệu</option>
                                <option value="5000000-10000000">5 - 10 triệu</option>
                                <option value="10000000+">Trên 10 triệu</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="filter-dropdown" id="durationFilter">
                                <option value="">Tất cả thời gian</option>
                                <option value="0-60">Dưới 1 giờ</option>
                                <option value="60-120">1 - 2 giờ</option>
                                <option value="120-180">2 - 3 giờ</option>
                                <option value="180+">Trên 3 giờ</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Package List -->
                <div class="package-list-container">
                    <div class="row" id="packageList">
                        <%
                            ExaminationPackageDAO packageDAO = new ExaminationPackageDAO();
                            List<ExaminationPackage> packages = packageDAO.getAll();
                            for (ExaminationPackage pkg : packages) {
                        %>
                        <div class="col-md-6 col-lg-4 package-item" 
                             data-name="<%= pkg.getName().toLowerCase() %>"
                             data-price="<%= pkg.getPrice() %>"
                             data-duration="<%= pkg.getDuration() %>">
                            <div class="package-card">
                                <img src="https://picsum.photos/600/400?random=<%= pkg.getPackageId() %>" class="package-image" alt="<%= pkg.getName() %>">
                                <div class="package-info">
                                    <h5 class="package-name"><%= pkg.getName() %></h5>
                                    <p class="text-muted mb-2"><%= pkg.getDescription() %></p>
                                    <p class="mb-2">
                                        <i class="bi bi-clock"></i> <%= pkg.getFormattedDuration() %>
                                    </p>
                                    <p class="mb-3">
                                        <strong style="color: #004d99;"><%= pkg.getFormattedPrice() %></strong>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/appointment?package_id=<%= pkg.getPackageId() %>" class="package-detail-btn">
                                        Đặt lịch ngay
                                    </a>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>

        <!-- Nhúng footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    </body>
</html> 