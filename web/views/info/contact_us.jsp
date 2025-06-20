<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ - G3 Hospital</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <%@ include file="../layouts/header.jsp" %>
    <nav aria-label="breadcrumb" class="bg-light py-2">
        <div class="container">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li class="breadcrumb-item active">Liên hệ</li>
            </ol>
        </div>
    </nav>
    <main class="container my-5">
        <h1 class="text-center mb-5" style="color: #004d99;">Liên hệ với chúng tôi</h1>
        <div class="row mb-5">
            <div class="col-md-4">
                <div class="contact-info text-center">
                    <i class="bi bi-geo-alt"></i>
                    <h5>Địa chỉ</h5>
                    <p>Đại học FPT, Khu Công nghệ cao Hòa Lạc<br>Thạch Thất, Hà Nội</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="contact-info text-center">
                    <i class="bi bi-telephone"></i>
                    <h5>Điện thoại</h5>
                    <p>Hotline: 0976054728<br>Điện thoại: (028) 1234 5678</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="contact-info text-center">
                    <i class="bi bi-envelope"></i>
                    <h5>Email</h5>
                    <p>info@g3hospital.com<br>support@g3hospital.com</p>
                </div>
            </div>
        </div>
        <div class="row contact-row">
            <div class="col-lg-6 d-flex align-items-stretch">
                <div class="contact-form w-100">
                    <h3 class="mb-4">Gửi tin nhắn cho chúng tôi</h3>
                    <c:if test="${not empty param.status}">
                        <div class="alert alert-${param.status == 'success' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                            <c:choose>
                                <c:when test="${param.status == 'success'}">
                                    Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất có thể.
                                </c:when>
                                <c:when test="${param.status == 'error'}">
                                    <c:choose>
                                        <c:when test="${param.message == 'missing_fields'}">
                                            Vui lòng điền đầy đủ thông tin!
                                        </c:when>
                                        <c:when test="${param.message == 'database_error'}">
                                            Có lỗi xảy ra khi lưu tin nhắn. Vui lòng thử lại sau!
                                        </c:when>
                                        <c:otherwise>
                                            Có lỗi xảy ra! Vui lòng thử lại sau.
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                            </c:choose>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/contact" method="post" id="contactForm">
                        <div class="mb-3">
                            <label for="name" class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required>
                        </div>
                        <div class="mb-3">
                            <label for="subject" class="form-label">Mục đích liên hệ</label>
                            <select class="form-select" id="subject" name="subject" required>
                                <option value="">Chọn mục đích liên hệ</option>
                                <option value="service_feedback">Góp ý về dịch vụ</option>
                                <option value="incident_report">Báo cáo sự cố</option>
                                <option value="improvement_suggestion">Đề xuất cải thiện</option>
                                <option value="cooperation">Liên hệ hợp tác</option>
                                <option value="other">Khác</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="message" class="form-label">Nội dung</label>
                            <textarea class="form-control" id="message" name="message" rows="5" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Gửi tin nhắn</button>
                    </form>
                </div>
            </div>
            <div class="col-lg-6 d-flex align-items-stretch">
                <div class="map-container w-100">
                    <div id="map" style="height: 100%;"></div>
                </div>
            </div>
        </div>
        <div class="row mt-5">
            <div class="col-12 text-center">
                <h3 class="mb-4">Kết nối với chúng tôi</h3>
                <div class="social-links">
                    <a href="#" class="btn btn-outline-primary me-2"><i class="bi bi-facebook"></i> Facebook</a>
                    <a href="#" class="btn btn-outline-info me-2"><i class="bi bi-twitter"></i> Twitter</a>
                    <a href="#" class="btn btn-outline-danger me-2"><i class="bi bi-youtube"></i> YouTube</a>
                    <a href="#" class="btn btn-outline-success"><i class="bi bi-instagram"></i> Instagram</a>
                </div>
            </div>
        </div>
    </main>
    <%@ include file="../layouts/footer.jsp" %>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>