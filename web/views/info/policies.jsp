<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="vi">
<head>
    <title>Chính sách - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="../layouts/header.jsp" />

    <!-- Policies Content -->
    <main class="container my-5">
        <h2 class="section-title text-center mb-4">CHÍNH SÁCH</h2>
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <h3 class="mt-4">1. Chính sách bảo mật</h3>
                <p>Chúng tôi cam kết bảo vệ thông tin cá nhân của người dùng trong hệ thống G3 Hospital. Mọi dữ liệu được mô phỏng chỉ phục vụ mục đích học tập và không được sử dụng cho mục đích thương mại. Thông tin được lưu trữ an toàn và không chia sẻ với bên thứ ba.</p>

                <h3 class="mt-4">2. Chính sách sử dụng</h3>
                <p>Hệ thống G3 Hospital chỉ dành cho mục đích học tập và nghiên cứu. Người dùng không được phép sao chép, phân phối hoặc sử dụng mã nguồn hoặc nội dung của dự án cho mục đích thương mại mà không có sự đồng ý từ nhóm phát triển.</p>

                <h3 class="mt-4">3. Quy định giao dịch</h3>
                <p>Mọi giao dịch thanh toán trong hệ thống (nếu có) đều được mô phỏng thông qua VNPAY sandbox và không liên quan đến tiền thật. Người dùng cần tuân thủ các hướng dẫn khi tham gia trải nghiệm để tránh vi phạm quy định.</p>

                <h3 class="mt-4">4. Hỗ trợ và phản hồi</h3>
                <p>Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ qua trang <a href="../contact_us.jsp">Liên hệ</a>. Chúng tôi sẽ phản hồi trong vòng 24 giờ (mô phỏng) để hỗ trợ bạn tốt nhất.</p>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="../layouts/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>