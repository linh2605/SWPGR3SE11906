<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>

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

            /* Ẩn thông báo update ckeditor */
            .cke_notifications_area
            {
                display: none !important;
            }
            /* config độ dài tối thiểu của ckeditor */
            .cke_contents {
                min-height: 500px !important;
            }
        </style>
    </head>

    <body>
        <!-- Nhúng header và navbar -->
        <%@ include file="../layouts/header.jsp" %>

        <main>
            <section class="doctor-list-container">
                <div class="container">
                    <form method="POST" action="${pageContext.request.contextPath}/news/edit" enctype="multipart/form-data">
                        <input type="hidden" name="newsID" value="${n.newsID}"/>

                        <div class="row">
                            <div class="col-md-12">
                                <c:if test="${param.success eq 'true'}">
                                    <div class="alert alert-success mb-3 p-3 d-flex flex-column align-items-center justify-content-center"
                                         >Cập nhật bài viết thành công!</div>
                                </c:if>
                                <c:if test="${param.success eq 'false'}">
                                    <div class="alert alert-danger mb-3 p-3 d-flex flex-column align-items-center justify-content-center"
                                         >Cập nhật bài viết thất bại!</div>
                                </c:if>
                                <div class="row" id="doctor-grid">
                                    <div class="col-md-12 doctor-item">
                                        <div class="doctor-card">
                                            <div class="p-3">

                                                <div class="row">
                                                    <div class="doctor-info">
                                                        <div class="row">
                                                            <div class="col-3">
                                                                <img src="${n.imagePreview}" 
                                                                     alt="Image preview" 
                                                                     class="doctor-image"
                                                                     onerror="this.src='https://www.svgrepo.com/show/506507/image.svg';">
                                                                <!-- Giữ imageUrl cũ -->
                                                                <input type="hidden" name="existingImageUrl" value="${n.imagePreview}">

                                                                <label class="form-label mt-3 justify-content-center gap-2 d-flex">Chọn ảnh minh họa mới</label>
                                                                <input type="file" class="form-control justify-content-center gap-2 d-flex" name="imageFile" accept="image/*">
                                                            </div>  
                                                            <div class="col-7">
                                                                <label class="form-label">Tiêu đề:</label>
                                                                <input type="text" class="form-control doctor-name" name="title" value="${n.title}" required>

                                                                <label class="form-label">Tác giả:</label>
                                                                <input type="text" class="form-control text-muted mb-2" name="createdBy" value="${n.createdBy.fullName}" readonly>
                                                                <input type="hidden" name="createdByID" value="${n.createdBy.userId}"/>

                                                                <label class="form-label">Đăng ngày:</label>
                                                                <input type="datetime-local" class="form-control text-muted mb-2" name="createdAt" value="${n.createdAt}" readonly>

                                                                <label class="form-label">Cập nhật lần cuối:</label>
                                                                <input type="datetime-local" class="form-control text-muted mb-2" name="updatedAt" value="${n.updatedAt}" readonly>
                                                            </div>
                                                            <div class="col-2 doctor-info">
                                                                <button 
                                                                    type="submit"
                                                                    class="btn btn-warning quick-action-btn justify-content-center gap-2 mt-2 d-flex w-100">
                                                                    Cập nhật<i class="bi bi-file-check"> </i></button>

                                                                <a href="javascript:history.back()" 
                                                                   class="btn btn-primary quick-action-btn justify-content-center gap-2 mt-2 d-flex w-100">
                                                                    Quay lại<i class="bi bi-arrow-return-left"></i>
                                                                </a>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <label class="form-label mt-0">Nội dung chính:</label>
                                                            <textarea
                                                                class="form-control text-muted mb-2" 
                                                                name="shortDescription" 
                                                                rows="3" 
                                                                required>${n.shortDescription}</textarea>

                                                            <label class="form-label mt-3">Nội dung bài viết:</label>
                                                            <textarea 
                                                                id="description"
                                                                class="form-control text-muted mb-2" 
                                                                name="description" 
                                                                rows="20" 
                                                                style="font-size: 1.2rem" 
                                                                required>${n.description}</textarea>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
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

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
        <script>
            CKEDITOR.replace('description', {
                language: 'vi',
                width: '100%'
            });
        </script>
    </body>
</html>
