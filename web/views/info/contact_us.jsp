<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="vi">
<head>
    <title>Liên hệ - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../layouts/header.jsp" />

    <main class="container my-5">
        <h2 class="section-title text-center mb-4">LIÊN HỆ VỚI G3 HOSPITAL</h2>

        <section class="contact-form mb-5 bg-light-blue">
            <form action="contact" method="post">
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
                    <label for="message" class="form-label">Tin nhắn</label>
                    <textarea class="form-control" id="message" name="message" rows="4" required></textarea>
                </div>
                <button type="submit" class="btn btn-custom w-100">Gửi tin nhắn</button>
            </form>
        </section>

        <section class="mb-5">
            <h3 class="section-title text-center mb-4">THÔNG TIN LIÊN HỆ</h3>
            <div class="row text-center">
                <div class="col-md-4">
                    <i class="bi bi-geo-alt-fill" style="font-size: 24px; color: #004d99;"></i>
                    <p>Trường Đại Học FPT, Thạch Hòa, Thạch Thất, TP. Hà Nội</p>
                </div>
                <div class="col-md-4">
                    <i class="bi bi-telephone-fill" style="font-size: 24px; color: #004d99;"></i>
                    <p>Hotline: 0976054728</p>
                </div>
                <div class="col-md-4">
                    <i class="bi bi-envelope-fill" style="font-size: 24px; color: #004d99;"></i>
                    <p>Email: support@g3hospital.vn</p>
                </div>
            </div>
        </section>
    </main>

    <div>
        <section class="map-section mb-4">
            <div id="map" style="height: 300px; width: 100%;"></div>
        </section>
    </div>

    <jsp:include page="../layouts/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>