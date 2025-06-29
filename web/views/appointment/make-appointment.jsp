<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="vi">
    <head>
        <title>Đặt lịch khám - G3 Hospital</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- FullCalendar CSS -->
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    </head>
    <body id="appointments">
        <!-- Header -->
        <%@ include file="../layouts/header.jsp" %>
        <!-- Main Content -->
        <main class="container my-5 fade-in">
            <h2 class="section-title text-center mb-4">ĐẶT LỊCH KHÁM</h2>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger fs-5 mb-3" role="alert">${errorMsg}</div>
            </c:if>
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success fs-5 mb-3" role="alert">${successMsg}</div>
            </c:if>
            
            <c:if test="${empty patient}">
                <div class="alert alert-warning fs-5 mb-3" role="alert">Không tìm thấy thông tin bệnh nhân. Vui lòng đăng nhập lại.</div>
            </c:if>
            
            <c:if test="${not empty patient}">
                <form id="bookingForm" class="bg-light-blue p-4 rounded shadow-sm" action="${pageContext.request.contextPath}/appointment" method="POST" autocomplete="off">
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Họ và tên</label></div>
                        <div class="col-md-9"><input type="text" class="form-control" name="fullName" value="${patient.fullName}" readonly></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Số điện thoại</label></div>
                        <div class="col-md-9"><input type="tel" class="form-control" name="phone" value="${patient.user.phone}" readonly></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Email</label></div>
                        <div class="col-md-9"><input type="email" class="form-control" name="email" value="${patient.user.email}" readonly></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Dịch vụ khám</label></div>
                        <div class="col-md-9">
                            <select class="form-select" id="service" name="service" required>
                                <option value="" disabled selected>Chọn dịch vụ khám</option>
                                <c:forEach var="s" items="${services}">
                                    <option value="${s.serviceId}" data-price="${s.price}">${s.name} - ${s.detail}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3" id="priceDisplay" style="display:none;">
                        <div class="col-md-3"><label class="form-label">Giá dịch vụ</label></div>
                        <div class="col-md-9"><div class="alert alert-info"><strong id="servicePrice">0</strong> VNĐ</div></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Ngày hẹn</label></div>
                        <div class="col-md-9">
                            <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Ca làm việc</label></div>
                        <div class="col-md-9">
                            <select class="form-select" id="shift" name="shift" required>
                                <option value="" disabled selected>Chọn ca làm việc</option>
                                <c:forEach var="sh" items="${shifts}">
                                    <option value="${sh.shiftId}">${sh.name} (${sh.startTime} - ${sh.endTime})</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3" id="doctorRow" style="display:none;">
                        <div class="col-md-3"><label class="form-label">Bác sĩ</label></div>
                        <div class="col-md-9">
                            <select class="form-select" id="doctor" name="doctor" required>
                                <option value="" disabled selected>Chọn bác sĩ</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Ghi chú</label></div>
                        <div class="col-md-9"><textarea class="form-control" name="note" rows="3">${note}</textarea></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"></div>
                        <div class="col-md-9"><button type="submit" class="btn btn-primary w-100">Đặt lịch</button></div>
                    </div>
                    <input type="hidden" name="patientId" value="${patient.patient_id}"/>
                </form>
            </c:if>
        </main>

        <!-- Footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
        
       
    </body>
</html>