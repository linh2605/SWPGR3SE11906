<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-list.css">

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/favicon.svg" />

        <title>${n.title} - Hệ thống Quản lý Phòng khám</title>
        <style>
            /* Fix header overlap issue */
            body {
                padding-top: 0;
                font-family: 'Montserrat', sans-serif !important;
            }

            main {
                margin-top: 20px;
            }

            .page-btn.active {
                background-color: #004D99;
                color: white;
            }

            .doctor-list-container {
                padding: 60px 0;
                background-color: #f8f9fa;
            }

            .doctor-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                margin-bottom: 30px;
                overflow: hidden;
            }

            .doctor-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .doctor-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
            }

            .doctor-name {
                font-size: 1.2rem;
                font-weight: 600;
                color: #004d99;
                margin-bottom: 10px;
                text-decoration: none;
            }

            .doctor-name:hover {
                color: #0066cc;
                text-decoration: none;
            }

            .doctor-info {
                padding: 20px;
            }

            .doctor-detail-btn {
                background-color: #004d99;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 20px;
                text-decoration: none;
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }

            .doctor-detail-btn:hover {
                background-color: #003366;
                color: white;
                text-decoration: none;
            }

            .specialty-filter {
                background: white;
                border-radius: 15px;
                padding: 20px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }

            .filter-tab {
                background: #f8f9fa;
                border: 2px solid #e9ecef;
                color: #495057;
                padding: 10px 15px;
                margin: 5px;
                border-radius: 25px;
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-block;
            }

            .filter-tab.active,
            .filter-tab:hover {
                background: #004d99;
                color: white;
                border-color: #004d99;
                text-decoration: none;
            }

            .banner-section {
                background: linear-gradient(rgba(0,77,153,0.7), rgba(0,77,153,0.7)),
                    url('${pageContext.request.contextPath}/assets/pexels-photo-5327590.png');
                background-size: cover;
                background-position: center;
                color: white;
                padding: 100px 0;
                text-align: center;
            }

            .banner-title {
                font-size: 3rem;
                font-weight: 700;
                margin-bottom: 20px;
            }

            .search-box {
                background: white;
                border-radius: 25px;
                padding: 5px;
                margin: 20px 0;
            }

            .search-input {
                border: none;
                padding: 10px 20px;
                border-radius: 20px;
                width: 100%;
                outline: none;
            }

            .breadcrumb {
                background: transparent;
                padding: 0;
                margin: 20px 0;
            }

            .breadcrumb-item a {
                color: white;
                text-decoration: none;
            }

            .breadcrumb-item.active {
                color: #ffd700;
            }

            /* Map section styling */
            .map-section {
                margin: 40px 0;
            }

            #map {
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
        </style>
    </head>

    <body>
        <!-- Nhúng header và navbar -->
        <%@ include file="../layouts/header.jsp" %>

        <c:set var="userRole" value="${empty sessionScope.user ? 'Guest' : sessionScope.user.role.name}" />
        <c:set var="defaultImage" value="${pageContext.request.contextPath}/assets/default-image.svg" />

        <main>
            <section class="doctor-list-container">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="row" id="doctor-grid">
                                <div class="col-md-12 doctor-item">
                                    <div class="doctor-card">
                                        <div class="p-3">
                                            <div class="row">
                                                <div class="doctor-info">
                                                    <div class="row">
                                                        <div class="col-3">
                                                            <img src="${not empty n.imagePreview ? n.imagePreview : defaultImage}" 
                                                                 alt="imagePreview" 
                                                                 class="doctor-image"/>
                                                        </div>
                                                        <div class="col-8">
                                                            <p class="doctor-name" style="font-size: 1.5rem">
                                                                ${n.title}
                                                            </p>
                                                            <p class="text-muted mb-0">
                                                                Tác giả: ${n.createdBy.fullName}
                                                            </p>
                                                            <p class="text-muted mb-0">
                                                                Đăng ngày: ${n.formattedCreatedAt}
                                                            </p>
                                                            <p class="text-muted mb-2">
                                                                Cập nhật lần cuối: ${n.formattedUpdatedAt}
                                                            </p>
                                                            <p class="text-muted mb-2">
                                                                ${n.shortDescription}
                                                            </p>
                                                        </div>
                                                        <div class="col-1 doctor-info">
                                                            <a href="javascript:history.back()" 
                                                               class="btn btn-primary quick-action-btn justify-content-center gap-2 mt-2 d-flex">
                                                                <i class="bi bi-arrow-return-left me-1"></i>
                                                            </a>
                                                            <c:if test="${fn:contains('doctor receptionist admin technician', userRole)}">
                                                                <a href="${pageContext.request.contextPath}/news/edit?id=${n.newsID}" 
                                                                   class="btn btn-warning quick-action-btn justify-content-center gap-2 mt-2 d-flex">
                                                                    <i class="bi bi-pen"></i>
                                                                </a>
                                                                <button type="button"
                                                                        class="btn btn-danger quick-action-btn justify-content-center gap-2 mt-2 d-flex w-100"
                                                                        data-bs-toggle="modal"
                                                                        data-bs-target="#confirmDeleteModal"
                                                                        onclick="prepareDelete(${n.newsID})">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <p class="text-muted mb-2" style="font-size: 1.2rem">
                                                            ${n.description}
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Map Section -->
            <section class="map-section">
                <div class="container">
                    <div class="text-center mb-4">
                        <h3>Vị trí phòng khám</h3>
                        <p class="text-muted">Tìm hiểu vị trí các cơ sở y tế của chúng tôi</p>
                    </div>
                    <div id="map" style="height: 300px; width: 100%;"></div>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Modal delete news -->
        <div class="modal fade" 
             id="confirmDeleteModal" 
             tabindex="-1" 
             aria-labelledby="confirmDeleteLabel" 
             aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form action="${pageContext.request.contextPath}/news/delete" 
                          method="POST">
                        <div class="modal-header py-2 px-3">
                            <h6 class="modal-title" id="confirmDeleteLabel">Xác nhận xóa bài viết</h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                        </div>
                        <div class="modal-body">
                            Bạn có chắc chắn muốn xóa bài viết này không?
                        </div>
                        <input type="hidden" name="newsID" id="deleteNewsID">
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary quick-action-btn" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-danger quick-action-btn">Xóa</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
        <script>
                                                                            function prepareDelete(newsID) {
                                                                                document.getElementById('deleteNewsID').value = newsID;
                                                                            }
        </script>

    </body>
</html>
