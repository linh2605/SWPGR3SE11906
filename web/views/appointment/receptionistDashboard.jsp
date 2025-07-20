<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="roleId" value="${sessionScope.roleId}" />
<c:if test="${empty roleId or roleId != 3}">
    <c:redirect url="/views/home/login.jsp?error=access_denied" />
</c:if>
<html lang="vi">
<head>
    <title>Quản lý lịch hẹn - Lễ tân</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Font -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body id="receptionistDashboard">
    <!-- Header -->
    <%@ include file="../layouts/header.jsp" %>

    <!-- Main Content -->
    <div class="d-flex">
        <%@ include file="../layouts/receptionist-side-bar.jsp" %>
        
        <main class="container my-5 fade-in flex-grow-1">
        <h2 class="section-title text-center mb-4">QUẢN LÝ LỊCH HẸN</h2>

        <!-- Nút đồng bộ -->
        <div class="text-end mb-3">
            <button class="btn sync-btn" id="syncCalendarBtn">
                <i class="bi bi-calendar-plus"></i> Đồng bộ với lịch ngoài
            </button>
        </div>

        <!-- Bộ lọc -->
        <div class="row g-3 mb-3">
            <div class="col-md-3">
                <label for="filterDate" class="form-label">Lọc theo ngày</label>
                <input type="date" id="filterDate" class="form-control">
            </div>
            <div class="col-md-3">
                <label for="filterDoctor" class="form-label">Lọc theo bác sĩ</label>
                <select id="filterDoctor" class="form-select">
                    <option value="">Tất cả</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="filterStatus" class="form-label">Lọc theo trạng thái</label>
                <select id="filterStatus" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="pending">Chờ xác nhận</option>
                    <option value="confirmed">Đã xác nhận</option>
                    <option value="completed">Hoàn thành</option>
                    <option value="canceled">Đã hủy</option>
                </select>
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button class="btn btn-primary w-100" id="filterButton"><i class="bi bi-funnel"></i> Lọc lịch hẹn</button>
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
                        <th class="text-center">Hành động</th>
                    </tr>
                </thead>
                <tbody id="appointmentList">
                    <!-- JS render here -->
                </tbody>
            </table>
        </div>
        </main>
    </div>

    <!-- Footer -->
    <%@ include file="../layouts/footer.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>
    <script>
        window.roleId = '${sessionScope.roleId}';
        window.contextPath = '${pageContext.request.contextPath}';
        
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize calendar
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'vi',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                events: function(fetchInfo, successCallback, failureCallback) {
                    fetch(window.contextPath + '/api/receptionist/appointments')
                        .then(response => response.json())
                        .then(events => successCallback(events))
                        .catch(error => failureCallback(error));
                }
            });
            calendar.render();
            
            // Load appointments for table
            loadAppointments();
        });
        
        function loadAppointments() {
            fetch(window.contextPath + '/api/receptionist/appointments')
                .then(response => response.json())
                .then(data => {
                    renderAppointmentTable(data);
                })
                .catch(error => {
                    console.error('Error loading appointments:', error);
                    document.getElementById('appointmentList').innerHTML = 
                        '<tr><td colspan="7" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
                });
        }
        
        function renderAppointmentTable(appointments) {
            console.log('Appointments data:', appointments);
            const tbody = document.getElementById('appointmentList');
            if (!appointments || appointments.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center py-4"><div class="text-muted"><i class="bi bi-calendar-x fs-1"></i><p class="mt-2">Chưa có lịch hẹn nào</p></div></td></tr>';
                return;
            }
            
            tbody.innerHTML = appointments.map(appointment => {
                const date = appointment.date ? new Date(appointment.date) : null;
                const dateStr = date ? date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear() : 'Không có thông tin';
                
                const shiftBadge = appointment.shiftId === 1 ? 'bg-primary' : 
                                  appointment.shiftId === 2 ? 'bg-warning' : 
                                  appointment.shiftId === 3 ? 'bg-dark' : 'bg-secondary';
                const shiftText = appointment.shiftId === 1 ? 'Sáng' : 
                                 appointment.shiftId === 2 ? 'Chiều' : 
                                 appointment.shiftId === 3 ? 'Tối' : 'Không xác định';
                
                const statusBadge = appointment.statusCode === 'PENDING' ? 'bg-warning' :
                                   appointment.statusCode === 'COMPLETED' ? 'bg-success' :
                                   appointment.statusCode === 'CANCELED' ? 'bg-danger' : 'bg-secondary';
                
                const patientName = appointment.patientName || 'Không có thông tin';
                const serviceName = appointment.serviceName || 'Không có thông tin';
                const statusText = appointment.status || 'Không xác định';
                
                let actionButtons = '<button type="button" class="btn btn-sm btn-outline-info" title="Xem chi tiết" data-bs-toggle="modal" data-bs-target="#appointmentDetailModal" onclick="showAppointmentDetail(\'' + appointment.id + '\',\'' + appointment.queueNumber + '\',\'' + appointment.date + '\',\'' + appointment.shiftId + '\',\'' + patientName + '\',\'' + serviceName + '\',\'' + statusText + '\',\'' + (appointment.note || '') + '\')"><i class="bi bi-eye"></i> Xem</button>';
                
                // Nút xác nhận (chỉ hiện khi trạng thái là 'pending')
                if (appointment.statusCode && appointment.statusCode.toLowerCase() === 'pending') {
                    actionButtons += '<button type="button" class="btn btn-sm btn-outline-primary ms-1" title="Xác nhận" onclick="updateAppointmentStatus(' + appointment.id + ',\'new\')"><i class="bi bi-check2-circle"></i> Xác nhận</button>';
                }
                
                // Nút hoàn thành (chỉ hiện khi trạng thái là 'completed' và đã thanh toán)
                if (appointment.statusCode && appointment.statusCode.toLowerCase() === 'completed') {
                    const isPaid = appointment.paymentStatus === 'PAID';
                    const disabledAttr = isPaid ? '' : 'disabled';
                    const title = isPaid ? 'Hoàn thành' : 'Hoàn thành (chưa thanh toán)';
                    actionButtons += '<button type="button" class="btn btn-sm btn-outline-success ms-1" title="' + title + '" ' + disabledAttr + ' onclick="updateAppointmentStatus(' + appointment.id + ',\'completed\')"><i class="bi bi-check-circle"></i> Hoàn thành</button>';
                }
                
                // Nút hủy (luôn hiện trừ khi đã hoàn thành)
                if (!appointment.statusCode || appointment.statusCode.toLowerCase() !== 'completed') {
                    actionButtons += '<button type="button" class="btn btn-sm btn-outline-danger ms-1" title="Hủy lịch hẹn" onclick="updateAppointmentStatus(' + appointment.id + ',\'canceled\')"><i class="bi bi-x-circle"></i> Hủy</button>';
                }
                
                return '<tr>' +
                    '<td class="text-center">' + (appointment.queueNumber || '') + '</td>' +
                    '<td>' + dateStr + '</td>' +
                    '<td class="text-center"><span class="badge ' + shiftBadge + '">' + shiftText + '</span></td>' +
                    '<td>' + patientName + '</td>' +
                    '<td>' + serviceName + '</td>' +
                    '<td class="text-center"><span class="badge ' + statusBadge + '">' + statusText + '</span></td>' +
                    '<td class="text-center"><div class="btn-group" role="group">' + actionButtons + '</div></td>' +
                    '</tr>';
            }).join('');
        }
        
        function showAppointmentDetail(id, queueNumber, date, shiftId, patientName, serviceName, status, note) {
            document.getElementById('modalQueueNumber').textContent = queueNumber || '';
            document.getElementById('modalDate').textContent = date ? new Date(date).toLocaleDateString('vi-VN') : '';
            document.getElementById('modalShift').textContent = shiftId === 1 ? 'Sáng' : shiftId === 2 ? 'Chiều' : shiftId === 3 ? 'Tối' : '';
            document.getElementById('modalPatient').textContent = patientName || '';
            document.getElementById('modalService').textContent = serviceName || '';
            document.getElementById('modalStatus').textContent = status || '';
            document.getElementById('modalNote').textContent = note || '';
        }

        function updateAppointmentStatus(appointmentId, newStatus) {
            if (!appointmentId || !newStatus) return;
            if (newStatus === 'canceled' && !confirm('Bạn có chắc chắn muốn hủy lịch hẹn này?')) return;
            fetch(window.contextPath + '/api/receptionist/appointments/status', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id: appointmentId, status: newStatus })
            })
            .then(res => res.json())
            .then(data => {
                if (data && data.success) {
                    alert('Cập nhật trạng thái thành công!');
                    loadAppointments();
                } else {
                    alert('Cập nhật trạng thái thất bại!');
                }
            })
            .catch(err => {
                alert('Có lỗi xảy ra khi cập nhật trạng thái!');
                console.error(err);
            });
        }
    </script>
    
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
</body>
</html>