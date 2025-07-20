<%-- 
    Document   : list
    Created on : May 26, 2025, 8:29:00 AM
    Author     : tuan
--%>
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

        <title>Bài viết - Hệ thống Quản lý Phòng khám</title>
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
        <c:set var="userId" value="${empty sessionScope.user ? 0 : sessionScope.user.userId}" />
        <c:set var="userRoleId" value="${empty sessionScope.user ? 0 : sessionScope.user.role.roleId}" />
        <c:set var="defaultImage" value="${pageContext.request.contextPath}/assets/default-image.svg" />
        


        <main>
            <!-- Banner Section -->
            <section class="banner-section">
                <div class="container">
                    <h1 class="banner-title">Danh sách bài viết</h1>

                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb justify-content-center">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/">
                                    <i class="bi bi-house-door"></i> Trang chủ 
                                </a>
                            </li>
                            <i class="bi bi-chevron-right" style="font-size: 0.8rem"> </i>
                            <li class="breadcrumb-item active" aria-current="page">
                                Danh sách bài viết
                            </li>
                        </ol>
                    </nav>

                    <!-- Search Box -->
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <div class="search-box">
                                <input type="text" 
                                       id="doctor-search" 
                                       class="search-input" 
                                       placeholder="Tìm kiếm bài viết...">
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Doctor List Section -->
            <section class="doctor-list-container" style="padding: 10px 0 !important">
                <div class="container">
                    <div class="row mb-3">
                        <!-- Doctor Grid -->
                        <div class="col-md-12">
                            <c:if test="${param.addSuccess eq 'true'}">
                                <div class="alert alert-success my-3 p-3 d-flex flex-column align-items-center justify-content-center"
                                     >Đăng bài viết thành công!</div>
                            </c:if>
                            <c:if test="${param.deleteSuccess eq 'true'}">
                                <div class="alert alert-success my-3 p-3 d-flex flex-column align-items-center justify-content-center"
                                     >Xoá viết thành công!</div>
                            </c:if>
                            <c:if test="${param.deleteSuccess eq 'false'}">
                                <div class="alert alert-danger my-3 p-3 d-flex flex-column align-items-center justify-content-center"
                                     >Xoá viết thất bại: Lỗi hệ thống!</div>
                            </c:if>

                            <!-- Navigation buttons for staff -->
                            <div style="background-color: #f8f9fa; border-radius: 10px; padding: 15px; margin-bottom: 20px;">
                                <c:if test="${userRoleId >= 2 and userRoleId <= 5}">
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <div>
                                            <!-- Back to Dashboard button -->
                                            <c:choose>
                                                <c:when test="${userRoleId eq 4}">
                                                    <button onclick="window.location.href='${pageContext.request.contextPath}/admin/dashboard'" 
                                                            style="background-color: #004d99; color: white; padding: 12px 24px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer;">
                                                        ← Quay lại Dashboard
                                                    </button>
                                                </c:when>
                                                <c:when test="${userRoleId eq 2}">
                                                    <button onclick="window.location.href='${pageContext.request.contextPath}/doctor/dashboard'" 
                                                            style="background-color: #004d99; color: white; padding: 12px 24px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer;">
                                                        ← Quay lại Dashboard
                                                    </button>
                                                </c:when>
                                                <c:when test="${userRoleId eq 3}">
                                                    <button onclick="window.location.href='${pageContext.request.contextPath}/receptionist/dashboard'" 
                                                            style="background-color: #004d99; color: white; padding: 12px 24px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer;">
                                                        ← Quay lại Dashboard
                                                    </button>
                                                </c:when>
                                                <c:when test="${userRoleId eq 5}">
                                                    <button onclick="window.location.href='${pageContext.request.contextPath}/technician/dashboard'" 
                                                            style="background-color: #004d99; color: white; padding: 12px 24px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer;">
                                                        ← Quay lại Dashboard
                                                    </button>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/news/create" 
                                               class="btn btn-success btn-lg">
                                                <i class="bi bi-plus-lg"></i> Thêm bài viết
                                            </a>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="row" id="doctor-grid">
                                <c:choose>
                                    <c:when test="${not empty newsList}">
                                        <c:forEach var="n" items="${newsList}">
                                            <div class="col-md-12 doctor-item">
                                                <div class="doctor-card">
                                                    <div class="p-3">
                                                        <div class="row">
                                                            <div class="col-3 doctor-info">
                                                                <img src="${not empty n.imagePreview ? n.imagePreview : defaultImage}" 
                                                                     alt="${d.user.fullName}" 
                                                                     class="doctor-image"/>
                                                            </div>
                                                            <div class="col-8 doctor-info">
                                                                <a href="${pageContext.request.contextPath}/news/view?id=${n.newsID}" 
                                                                   class="doctor-name">
                                                                    ${n.title}
                                                                </a>
                                                                <br/>
                                                                <small class="text-muted">
                                                                    Tác giả: ${n.createdBy.fullName}
                                                                </small>
                                                                <br/>
                                                                <small class="text-muted">
                                                                    Đăng ngày: ${n.formattedCreatedAt}
                                                                </small>
                                                                <p class="text-muted mb-2">
                                                                    ${n.shortDescription}
                                                                </p>


                                                            </div>
                                                            <div class="col-1 d-flex flex-column align-items-center">
                                                                <a href="${pageContext.request.contextPath}/news/view?id=${n.newsID}" 
                                                                   class="btn btn-primary quick-action-btn gap-2 mt-2 d-flex">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
                                                                <c:if test="${userRoleId >= 2 and userRoleId <= 5}">
                                                                    <a href="${pageContext.request.contextPath}/news/edit?id=${n.newsID}" 
                                                                       class="btn btn-warning quick-action-btn gap-2 mt-2 d-flex">
                                                                        <i class="bi bi-pen"></i>
                                                                    </a>
                                                                    <button type="button"
                                                                            class="btn btn-danger quick-action-btn gap-2 mt-2 d-flex"
                                                                            data-bs-toggle="modal"
                                                                            data-bs-target="#confirmDeleteModal"
                                                                            onclick="prepareDelete(${n.newsID})">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12">
                                            <div class="alert alert-info text-center">
                                                <i class="bi bi-info-circle"></i>
                                                <h5>Không có bài viết nào được tìm thấy</h5>
                                                <p class="mb-0">Hiện tại bài viết nào trong hệ thống.</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Pagination -->
                            <div id="pagination-container" class="mt-4 text-center">
                                <!-- Pagination will be generated by JavaScript -->
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
                                                                                document.addEventListener('DOMContentLoaded', function () {
                                                                                    const allDoctors = Array.from(document.querySelectorAll('.doctor-item'));
                                                                                    const paginationContainer = document.getElementById('pagination-container');
                                                                                    const searchInput = document.getElementById('doctor-search');

                                                                                    const doctorsPerPage = 4; // 4 bài 1 trang
                                                                                    let currentPage = 1;
                                                                                    let currentKeyword = '';

                                                                                    function normalize(str) {
                                                                                        return str.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
                                                                                    }

                                                                                    function getFilteredDoctors() {
                                                                                        return allDoctors.filter(doc => {
                                                                                            const docSpecId = doc.getAttribute('data-specialist-id');
                                                                                            const name = doc.querySelector('.doctor-name')?.textContent || '';
                                                                                            const matchKeyword = currentKeyword === '' || normalize(name).includes(normalize(currentKeyword));
                                                                                            return matchKeyword;
                                                                                        });
                                                                                    }

                                                                                    function renderDoctors() {
                                                                                        const filteredDoctors = getFilteredDoctors();
                                                                                        const totalPages = Math.ceil(filteredDoctors.length / doctorsPerPage);
                                                                                        if (currentPage > totalPages && totalPages > 0) {
                                                                                            currentPage = 1;
                                                                                        }

                                                                                        const start = (currentPage - 1) * doctorsPerPage;
                                                                                        const end = start + doctorsPerPage;

                                                                                        // Hide all doctors
                                                                                        allDoctors.forEach(doc => doc.style.display = 'none');

                                                                                        // Show filtered doctors for current page
                                                                                        filteredDoctors.slice(start, end).forEach(doc => doc.style.display = 'block');

                                                                                        renderPagination(totalPages);
                                                                                    }

                                                                                    function renderPagination(totalPages) {
                                                                                        paginationContainer.innerHTML = '';

                                                                                        if (totalPages <= 1)
                                                                                            return;

                                                                                        const pagination = document.createElement('nav');
                                                                                        const ul = document.createElement('ul');
                                                                                        ul.className = 'pagination justify-content-center';

                                                                                        // Previous button
                                                                                        const prevLi = document.createElement('li');
                                                                                        prevLi.className = 'page-item ' + (currentPage === 1 ? 'disabled' : '');
                                                                                        const prevLink = document.createElement('a');
                                                                                        prevLink.className = 'page-link';
                                                                                        prevLink.innerHTML = '<i class="bi bi-chevron-left"></i>';
                                                                                        prevLink.href = '#';
                                                                                        if (currentPage > 1) {
                                                                                            prevLink.addEventListener('click', (e) => {
                                                                                                e.preventDefault();
                                                                                                currentPage--;
                                                                                                renderDoctors();
                                                                                            });
                                                                                        }
                                                                                        prevLi.appendChild(prevLink);
                                                                                        ul.appendChild(prevLi);

                                                                                        // Page numbers
                                                                                        for (let i = 1; i <= totalPages; i++) {
                                                                                            const li = document.createElement('li');
                                                                                            li.className = 'page-item ' + (i === currentPage ? 'active' : '');
                                                                                            const link = document.createElement('a');
                                                                                            link.className = 'page-link';
                                                                                            link.textContent = i;
                                                                                            link.href = '#';
                                                                                            link.addEventListener('click', (e) => {
                                                                                                e.preventDefault();
                                                                                                currentPage = i;
                                                                                                renderDoctors();
                                                                                            });
                                                                                            li.appendChild(link);
                                                                                            ul.appendChild(li);
                                                                                        }

                                                                                        // Next button
                                                                                        const nextLi = document.createElement('li');
                                                                                        nextLi.className = 'page-item ' + (currentPage === totalPages ? 'disabled' : '');
                                                                                        const nextLink = document.createElement('a');
                                                                                        nextLink.className = 'page-link';
                                                                                        nextLink.innerHTML = '<i class="bi bi-chevron-right"></i>';
                                                                                        nextLink.href = '#';
                                                                                        if (currentPage < totalPages) {
                                                                                            nextLink.addEventListener('click', (e) => {
                                                                                                e.preventDefault();
                                                                                                currentPage++;
                                                                                                renderDoctors();
                                                                                            });
                                                                                        }
                                                                                        nextLi.appendChild(nextLink);
                                                                                        ul.appendChild(nextLi);

                                                                                        pagination.appendChild(ul);
                                                                                        paginationContainer.appendChild(pagination);
                                                                                    }

                                                                                    // Search handler
                                                                                    searchInput.addEventListener('input', function () {
                                                                                        currentKeyword = this.value;
                                                                                        currentPage = 1;
                                                                                        renderDoctors();
                                                                                    });
                                                                                    renderDoctors();

                                                                                    // Initialize map
                                                                                    if (typeof L !== 'undefined') {
                                                                                        const map = L.map('map').setView([21.0285, 105.8542], 13);
                                                                                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                                                                                            attribution: '© OpenStreetMap contributors'
                                                                                        }).addTo(map);

                                                                                        L.marker([21.0285, 105.8542]).addTo(map)
                                                                                                .bindPopup('Hệ thống Quản lý Phòng khám')
                                                                                                .openPopup();
                                                                                    }

                                                                                    // Initial render
                                                                                    renderDoctors();
                                                                                });
        </script>
    </body>
</html>
