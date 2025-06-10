<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<html lang="vi">
    <head>
        <title>Lịch hẹn đã đặt - G3 Hospital</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- FullCalendar CSS -->
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
        
        <!--TODO: fix theo role sau-->
        <%
//            Integer roleId = null;
//            if (session == null || (roleId = (Integer) session.getAttribute("roleId")) == null || roleId != 1) {
//                response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
//                return;
//            }
        %>
    </head>
    <body id="appointments">
        <!-- Header -->
        <%@ include file="../layouts/header.jsp" %>
        <!-- Main Content -->
        <main class="container my-5">
            <h2 class="section-title text-center mb-4">ĐẶT LỊCH KHÁM</h2>

            <div class="">
                <form id="bookingForm">
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="fullName" class="form-label">Họ và tên</label>
                        </div>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="fullName" name="fullName" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                        </div>
                        <div class="col-md-9">
                            <input type="tel" class="form-control" id="phone" name="phone" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="email" class="form-label">Email</label>
                        </div>
                        <div class="col-md-9">
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="specialty" class="form-label">Chuyên khoa</label>
                        </div>
                        <div class="col-md-9">
                            <select class="form-select" id="specialty" name="specialty" required>
                                <option value="">Chọn chuyên khoa</option>
                                <option value="co-xuong-khop">Cơ Xương Khớp</option>
                                <option value="ngoai-tong-hop">Ngoại Tổng Hợp</option>
                                <option value="nhi-khoa">Nhi Khoa</option>
                                <option value="san-khoa">Sản Khoa</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="doctor" class="form-label">Bác sĩ</label>
                        </div>
                        <div class="col-md-9">
                            <select class="form-select" id="doctor" name="doctor" required>
                                <option value="">Chọn bác sĩ</option>
                                <option value="dr1">ThS.BSCKI Trịnh Minh Thanh</option>
                                <option value="dr2">ThS.BS Nguyễn Văn Hải</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="appointmentDate" class="form-label">Ngày giờ hẹn</label>
                        </div>
                        <div class="col-md-9">
                            <input type="datetime-local" class="form-control" id="appointmentDate" name="appointmentDate" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="note" class="form-label">Ghi chú</label>
                        </div>
                        <div class="col-md-9">
                            <textarea class="form-control" id="note" name="note" rows="3"></textarea>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Đặt lịch</button>
                </form>
            </div>
        </main>

        <!-- Footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
    </body>
</html>