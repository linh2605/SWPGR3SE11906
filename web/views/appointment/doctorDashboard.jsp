<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="vi">
    <head>
        <title>Lịch hẹn của bác sĩ - G3 Hospital</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Font -->
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- FullCalendar CSS -->
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <%
            Integer roleId = null;
            if (session == null || (roleId = (Integer) session.getAttribute("roleId")) == null || roleId != 2) {
                response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
                return;
            }
        %>
        <script>
            window.roleId = <%= roleId %>;
            window.contextPath = '<%= request.getContextPath() %>';
        </script>
    </head>
    <body id="doctor-appointments">
        <!-- Header -->
        <%@ include file="../layouts/header.jsp" %>

        <!-- Main Content -->
        <div class="d-flex">
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
            
            <main class="container my-5 fade-in flex-grow-1">
                <h2 class="section-title text-center mb-4">LỊCH HẸN CỦA TÔI</h2>

                <!-- Hiển thị thông báo lỗi -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Nút xuất file .ics -->
                <div class="text-end mb-3">
                    <button id="exportIcsBtn" class="btn sync-btn">
                        <i class="bi bi-calendar-plus"></i> Đồng bộ với lịch ngoài
                    </button>
                </div>

                <!-- Bộ lọc -->
                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label for="filterDate" class="form-label">Lọc theo ngày</label>
                        <input type="date" id="filterDate" class="form-control">
                    </div>
                    <div class="col-md-4">
                        <label for="filterStatus" class="form-label">Lọc theo trạng thái</label>
                        <select id="filterStatus" class="form-select">
                            <option value="">Tất cả</option>
                            <option value="pending">Chờ xác nhận</option>
                            <option value="confirmed">Đã xác nhận</option>
                            <option value="completed">Hoàn thành</option>
                            <option value="canceled">Đã hủy</option>
                        </select>
                    </div>
                </div>

                <!-- Lịch FullCalendar -->
                <div id="calendar"></div>

                <!-- Danh sách chi tiết -->
                <div class="appointment-table">
                    <h3 class="section-title mb-3">Danh sách lịch hẹn</h3>
                    <table class="table table-bordered table-hover" id="appointmentTable">
                        <thead>
                            <tr>
                                <th class="text-center">STT</th>
                                <th>Ngày</th>
                                <th class="text-center">Ca làm</th>
                                <th>Bệnh nhân</th>
                                <th>Dịch vụ</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center">Thanh toán</th>
                                <th class="text-center">Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="appointmentList">
                            <!-- Giữ nguyên phần render dữ liệu -->
                            <c:forEach var="appointment" items="${appointments}" varStatus="loop">
                                <tr>
                                    <td class="text-center">${loop.index + 1}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty appointment.appointmentDateTime}">
                                                ${appointment.appointmentDateTime.toLocalDate().getDayOfMonth()}/${appointment.appointmentDateTime.toLocalDate().getMonthValue()}/${appointment.appointmentDateTime.toLocalDate().getYear()}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Không có thông tin</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${appointment.shiftId == 1}">
                                                <span class="badge bg-primary">Sáng</span>
                                            </c:when>
                                            <c:when test="${appointment.shiftId == 2}">
                                                <span class="badge bg-warning">Chiều</span>
                                            </c:when>
                                            <c:when test="${appointment.shiftId == 3}">
                                                <span class="badge bg-dark">Tối</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Không xác định</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${appointment.patient.user.fullName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty appointment.service}">
                                                ${appointment.service.name}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Không có thông tin</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge
                                              <c:choose>
                                                  <c:when test="${appointment.status.code == 'pending'}">bg-warning</c:when>
                                                  <c:when test="${appointment.status.code == 'completed'}">bg-success</c:when>
                                                  <c:when test="${appointment.status.code == 'canceled'}">bg-danger</c:when>
                                                  <c:otherwise>bg-secondary</c:otherwise>
                                              </c:choose>">
                                            ${appointment.status.displayName}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${appointment.paymentStatus == 'PENDING'}">
                                                <span class="badge bg-danger">Chờ thanh toán</span>
                                            </c:when>
                                            <c:when test="${appointment.paymentStatus == 'PAID'}">
                                                <span class="badge bg-success">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${appointment.paymentStatus == 'RESERVED'}">
                                                <span class="badge bg-warning">Đã đặt cọc</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group" role="group">
                                            <button type="button" class="btn btn-sm btn-outline-info" title="Xem chi tiết" data-bs-toggle="modal" data-bs-target="#appointmentDetailModal"
                                                    onclick="showAppointmentDetail('${fn:escapeXml(appointment.id)}', '${fn:escapeXml(loop.index + 1)}', '${appointment.appointmentDateTime != null ? appointment.appointmentDateTime.toLocalDate() : ''}', '${fn:escapeXml(appointment.shiftId)}', '${fn:escapeXml(appointment.patient.user.fullName)}', '${appointment.service != null ? fn:escapeXml(appointment.service.name) : ''}', '${fn:escapeXml(appointment.status.displayName)}', '${appointment.note != null ? fn:escapeXml(appointment.note) : ''}')">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty appointments}">
                                <tr>
                                    <td colspan="8" class="text-center py-4">
                                        <div class="text-muted">
                                            <i class="bi bi-calendar-x fs-1"></i>
                                            <p class="mt-2">Chưa có lịch hẹn nào</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <!-- Giữ nguyên phần modal và scripts -->
        <!-- Modal xem chi tiết lịch hẹn -->
        <div class="modal fade" id="appointmentDetailModal" tabindex="-1" aria-labelledby="appointmentDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="appointmentDetailModalLabel">Chi tiết lịch hẹn</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <ul class="list-group">
                            <li class="list-group-item"><b>STT:</b> <span id="modalQueueNumber"></span></li>
                            <li class="list-group-item"><b>Ngày:</b> <span id="modalDate"></span></li>
                            <li class="list-group-item"><b>Ca làm:</b> <span id="modalShift"></span></li>
                            <li class="list-group-item"><b>Bệnh nhân:</b> <span id="modalPatient"></span></li>
                            <li class="list-group-item"><b>Dịch vụ:</b> <span id="modalService"></span></li>
                            <li class="list-group-item"><b>Trạng thái:</b> <span id="modalStatus"></span></li>
                            <li class="list-group-item"><b>Ghi chú:</b> <span id="modalNote"></span></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
        <script>
            // Giữ nguyên toàn bộ JavaScript
            document.addEventListener('DOMContentLoaded', function() {
                // Khởi tạo FullCalendar
                var calendarEl = document.getElementById('calendar');
                if (calendarEl) {
                    var calendar = new FullCalendar.Calendar(calendarEl, {
                        initialView: 'dayGridMonth',
                        locale: 'vi',
                        headerToolbar: {
                            left: 'prev,next today',
                            center: 'title',
                            right: 'dayGridMonth,timeGridWeek,timeGridDay'
                        },
                        buttonText: {
                            today: 'Hôm nay',
                            month: 'Tháng',
                            week: 'Tuần',
                            day: 'Ngày'
                        },
                        events: function(info, successCallback, failureCallback) {
                            // Get events from table
                            var events = [];
                            $('#appointmentTable tbody tr').each(function() {
                                var cells = $(this).find('td');
                                if (cells.length >= 6) {
                                    var date = cells.eq(1).text().trim();
                                    var patient = cells.eq(3).text().trim();
                                    var service = cells.eq(4).text().trim();
                                    var status = cells.eq(5).text().trim();
                                    
                                    if (date && date !== 'Không có thông tin') {
                                        var dateParts = date.split('/');
                                        var eventDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                                        
                                        events.push({
                                            title: service + ' - ' + patient,
                                            start: eventDate,
                                            allDay: true,
                                            backgroundColor: getStatusColor(status),
                                            borderColor: getStatusColor(status)
                                        });
                                    }
                                }
                            });
                            successCallback(events);
                        }
                    });
                    calendar.render();
                }

                // Handle filters
                $('#filterDate, #filterStatus').on('change', function() {
                    filterAppointments();
                });

                // Handle export button
                $('#exportIcsBtn').on('click', function() {
                    exportToICS();
                });
            });

            // Helper functions
            function getStatusColor(status) {
                status = status.toLowerCase();
                if (status.includes('chờ')) return '#ffc107';
                if (status.includes('hoàn thành')) return '#28a745';
                if (status.includes('hủy')) return '#dc3545';
                return '#6c757d';
            }

            function filterAppointments() {
                var dateFilter = $('#filterDate').val();
                var statusFilter = $('#filterStatus').val().toLowerCase();
                
                $('#appointmentTable tbody tr').each(function() {
                    var row = $(this);
                    var date = row.find('td:eq(1)').text().trim();
                    var status = row.find('td:eq(5)').text().trim().toLowerCase();
                    
                    var dateMatch = true;
                    if (dateFilter) {
                        var filterDate = new Date(dateFilter);
                        var dateParts = date.split('/');
                        var rowDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                        dateMatch = filterDate.toDateString() === rowDate.toDateString();
                    }
                    
                    var statusMatch = true;
                    if (statusFilter) {
                        statusMatch = status.includes(statusFilter);
                    }
                    
                    row.toggle(dateMatch && statusMatch);
                });
            }

            function exportToICS() {
                var icsContent = 'BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//G3Hospital//Appointments//VN\n';
                
                $('#appointmentTable tbody tr').each(function() {
                    var cells = $(this).find('td');
                    if (cells.length >= 6) {
                        var date = cells.eq(1).text().trim();
                        var patient = cells.eq(3).text().trim();
                        var service = cells.eq(4).text().trim();
                        var status = cells.eq(5).text().trim();
                        
                        if (date && date !== 'Không có thông tin') {
                            var dateParts = date.split('/');
                            var eventDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                            var dateStr = eventDate.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z';
                            
                            icsContent += 'BEGIN:VEVENT\n';
                            icsContent += 'UID:' + Math.random().toString(36).substring(2) + '\n';
                            icsContent += 'DTSTAMP:' + dateStr + '\n';
                            icsContent += 'DTSTART;VALUE=DATE:' + dateParts[2] + dateParts[1] + dateParts[0] + '\n';
                            icsContent += 'SUMMARY:' + service + ' - ' + patient + '\n';
                            icsContent += 'DESCRIPTION:Trạng thái: ' + status + '\n';
                            icsContent += 'END:VEVENT\n';
                        }
                    }
                });
                
                icsContent += 'END:VCALENDAR';
                
                var blob = new Blob([icsContent], { type: 'text/calendar;charset=utf-8' });
                var link = document.createElement('a');
                link.href = window.URL.createObjectURL(blob);
                link.download = 'appointments.ics';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }

            function showAppointmentDetail(id, queueNumber, date, shiftId, patient, service, status, note) {
                document.getElementById('modalQueueNumber').textContent = queueNumber || 'N/A';
                document.getElementById('modalDate').textContent = date || 'N/A';
                document.getElementById('modalShift').textContent = getShiftName(shiftId);
                document.getElementById('modalPatient').textContent = patient || 'N/A';
                document.getElementById('modalService').textContent = service || 'N/A';
                document.getElementById('modalStatus').textContent = status || 'N/A';
                document.getElementById('modalNote').textContent = note || 'Không có ghi chú';
            }

            function getShiftName(shiftId) {
                switch (shiftId) {
                    case '1': return 'Sáng';
                    case '2': return 'Chiều';
                    case '3': return 'Tối';
                    default: return 'Không xác định';
                }
            }
        </script>
    </body>
</html>