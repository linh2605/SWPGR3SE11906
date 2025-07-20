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

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    </head>
    <body id="appointments">
        <!-- Header -->
        <%@ include file="../layouts/header.jsp" %>
        <!-- Main Content -->
        <main class="container my-5 fade-in">
            <h2 class="section-title text-center mb-4">ĐẶT LỊCH KHÁM THEO BÁC SĨ</h2>
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
                <form id="bookingForm1" class="bg-light-blue p-4 rounded shadow-sm" action="${pageContext.request.contextPath}/appointment-doctor" method="POST" autocomplete="off">
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
                    <div class="row mb-3" id="doctorRow">
                        <div class="col-md-3"><label class="form-label">Bác sĩ</label></div>
                        <div class="col-md-9">
                            <select class="form-select" id="doctor" name="doctor" required>
                                <option value="${doctor.doctor_id}" selected>${doctor.specialty.name} - ${doctor.degree} ${doctor.user.fullName}</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Dịch vụ khám</label></div>
                        <div class="col-md-9">
                            <select class="form-select" id="service" name="service" required>
                                <option value="" disabled selected>Chọn dịch vụ khám</option>
                                <c:forEach var="s" items="${services}">
                                    <option value="${s.serviceId}" 
                                            data-price="${s.price}"
                                            ${s.serviceId eq service_id ? 'selected' : ''}
                                            >${s.name} - ${s.detail}</option>
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
                            <input type="text" class="form-control" id="appointmentDate" name="appointmentDate" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Ca làm việc</label></div>
                        <div class="col-md-9">
                            <select class="form-select" id="shift" name="shift" required>
                                <option value="" disabled selected>Chọn ca làm việc</option>

                            </select>
                        </div>
                    </div>
<!--                    <div class="row mb-3" id="errMessage" style="display:flex;">
                        <div class="col-md-3"></div>
                        <div class="col-md-9"><div class="alert alert-danger">
                                <strong id="errMessageDetail">Bác sĩ không có ca làm việc trong ngày đã chọn.</strong>
                            </div>
                        </div>
                    </div>-->
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
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script></script>
        <script>
            const service_id = '<%=request.getParameter("service_id")%>';
            if (service_id !== 'null') {
                document.getElementById("service").value = service_id
            }

            const serviceSelect = document.getElementById('service');
            const priceDisplay = document.getElementById('priceDisplay');
            const servicePrice = document.getElementById('servicePrice');
            serviceSelect.addEventListener('change', function () {
                const price = this.options[this.selectedIndex].getAttribute('data-price');
                if (price && price !== 'null') {
                    servicePrice.textContent = new Intl.NumberFormat('vi-VN').format(price);
                    priceDisplay.style.display = 'flex';
                } else {
                    priceDisplay.style.display = 'none';
                }
            });
            const allowedWeekDays = [
            <c:forEach var="s" items="${schedules}" varStatus="loop">
            "${s.weekDay}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
            const weekdayMap = {
                "Chủ nhật": 0,
                "Thứ 2": 1,
                "Thứ 3": 2,
                "Thứ 4": 3,
                "Thứ 5": 4,
                "Thứ 6": 5,
                "Thứ 7": 6
            };
            const allowedDayIndexes = [];
            allowedWeekDays.forEach(day => {
                const index = weekdayMap[day];
                if (!allowedDayIndexes.includes(index)) {
                    allowedDayIndexes.push(index);
                }
            });
            const schedules = [
            <c:forEach var="s" items="${schedules}" varStatus="loop">
            {
            weekDay: "${s.weekDay}", // ví dụ "Thứ 2"
                    shiftId: "${s.shiftId}"
            }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
            const shifts = [
            <c:forEach var="sh" items="${shifts}" varStatus="loop">
            {id: "${sh.shiftId}", name: "${sh.name} (${sh.startTime} - ${sh.endTime})"}
                <c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
            console.log(`shifts:`, shifts);

            function updateShiftOptions() {
                const input = document.getElementById("appointmentDate").value;
                if (!input)
                    return;
                const dateParts = input.split("/");
                if (dateParts.length !== 3)
                    return;
                const day = parseInt(dateParts[0]);
                const month = parseInt(dateParts[1]) - 1; // JS: 0-based month
                const year = parseInt(dateParts[2]);
                const selectedDate = new Date(year, month, day);
                const weekdayNames = ["Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"];
                const weekdayString = weekdayNames[selectedDate.getDay()];
                // Lọc shift theo thứ
                const matchingShifts = schedules.filter(s => s.weekDay === weekdayString);
                console.log(`matchingShifts:`, matchingShifts);
                // Gán vào thẻ select
                const select = document.getElementById("shift");
                select.innerHTML = '<option value="" disabled selected>Chọn ca làm việc</option>'; // clear cũ

                matchingShifts.forEach(sh => {
                    const matchedShift = shifts.find(shift => shift.id === sh.shiftId);
                    if (matchedShift) {
                        const opt = document.createElement("option");
                        opt.value = sh.shiftId;
                        opt.textContent = matchedShift.name;
                        select.appendChild(opt);
                    }
                });
            }

            flatpickr("#appointmentDate", {
                dateFormat: "d/m/Y",
                minDate: "today",
                disable: [
                    function (date) {
                        const day = date.getDay(); // 0–6
                        return !allowedDayIndexes.includes(day); // chỉ cho phép ngày có thứ nằm trong danh sách
                    }
                ],
                onChange: function () {
                    updateShiftOptions();
                }
            });
        </script>

    </body>
</html>