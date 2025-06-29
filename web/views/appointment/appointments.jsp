<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <%
        Integer roleId = null;
        if (session == null || (roleId = (Integer) session.getAttribute("roleId")) == null || roleId != 1) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
    %>
    <script>
        window.roleId = <%= roleId %>;
        window.contextPath = '<%= request.getContextPath() %>';
    </script>
</head>
<body id="appointments">
    <!-- Header -->
    <%@ include file="../layouts/header.jsp" %>

    <!-- Main Content -->
    <main class="container my-5">
        <h2 class="section-title text-center mb-4">LỊCH HẸN ĐÃ ĐẶT</h2>

        <!-- Hiển thị thông báo lỗi -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Hai nút xuất file .ics và đồng bộ Google Calendar tự động cùng một cột -->
        <div class="d-flex flex-column align-items-end gap-2 mb-3">
            <button id="exportIcsBtn" class="btn btn-primary">
                <i class="bi bi-calendar-plus"></i> Đồng bộ với lịch ngoài
            </button>
            <button id="googleSyncBtn" class="btn btn-success">
                <i class="bi bi-google"></i> Đồng bộ Google Calendar (tự động)
            </button>
        </div>

        <!-- Bộ lọc -->
        <div class="filter-bar row g-3">
            <div class="col-md-3">
                <label for="filterDate" class="form-label">Lọc theo ngày</label>
                <select id="filterDate" class="form-select">
                    <option value="">Tất cả</option>
                </select>
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
                    <option value="pending">Đang chờ</option>
                    <option value="completed">Hoàn thành</option>
                    <option value="canceled">Đã hủy</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="search" class="form-label">Tìm kiếm</label>
                <input type="text" id="search" class="form-control" placeholder="Tìm theo bác sĩ...">
            </div>
            <div class="col-md-12 text-end">
                <button class="btn btn-primary mt-3" id="filterButton">
                    <i class="bi bi-funnel"></i> Lọc lịch hẹn
                </button>
            </div>
        </div>

        <!-- Lịch FullCalendar -->
        <div id="calendar"></div>

        <!-- Danh sách chi tiết -->
        <div class="appointment-table">
            <h3 class="section-title mb-3">Danh sách lịch hẹn</h3>
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>ID Hẹn</th>
                        <th>Ngày giờ</th>
                        <th>Bác sĩ</th>
                        <th>Dịch vụ</th>
                        <th>Trạng thái</th>
                        <th>Thanh toán</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody id="appointmentList">
                    <c:forEach var="appointment" items="${appointments}">
                        <tr>
                            <td>${appointment.id}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty appointment.appointmentDateTime}">
                                        ${appointment.appointmentDateTime.toLocalDate()} ${appointment.appointmentDateTime.toLocalTime()}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Không có thông tin</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${appointment.doctor.user.fullName}</td>
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
                            <td>
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
                            <td>
                                <span class="badge 
                                    <c:choose>
                                        <c:when test="${appointment.paymentStatus == 'PENDING'}">bg-warning</c:when>
                                        <c:when test="${appointment.paymentStatus == 'PAID'}">bg-success</c:when>
                                        <c:when test="${appointment.paymentStatus == 'RESERVED'}">bg-info</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>">
                                    ${appointment.paymentStatus}
                                </span>
                            </td>
                            <td>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <c:if test="${appointment.status.code == 'pending'}">
                                        <button type="button" class="btn btn-sm btn-outline-danger" title="Hủy lịch hẹn">
                                            <i class="bi bi-x-circle"></i>
                                        </button>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty appointments}">
                        <tr>
                            <td colspan="7" class="text-center py-4">
                                <div class="text-muted">
                                    <i class="bi bi-calendar-x fs-1"></i>
                                    <p class="mt-2">Chưa có lịch hẹn nào</p>
                                    <a href="${pageContext.request.contextPath}/appointment/make-appointment" class="btn btn-primary">
                                        <i class="bi bi-plus-circle"></i> Đặt lịch hẹn ngay
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../layouts/footer.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        if (!calendarEl) return;

        window.calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'vi',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            events: function(fetchInfo, successCallback, failureCallback) {
                fetch(window.contextPath + '/api/patient/appointments')
                    .then(response => response.json())
                    .then(events => successCallback(events))
                    .catch(error => failureCallback(error));
            }
        });
        window.calendar.render();
    });
    </script>

    <!-- Google API scripts: Đặt cuối cùng trước </body> -->
    <script src="https://apis.google.com/js/api.js?onload=onGapiLoad"></script>
    <script>
    console.log('[GAPI] Script loaded, window.gapi:', window.gapi);
    // Hàm callback phải nằm ngoài mọi block
    function onGapiLoad() {
        console.log('[GAPI] onGapiLoad called');
        gapi.load('client:auth2', () => {
            console.log('[GAPI] gapi.load completed');
            gapi.client.init({
                clientId: GOOGLE_CLIENT_ID,
                scope: GOOGLE_API_SCOPES
            }).then(() => {
                googleAuthInstance = gapi.auth2.getAuthInstance();
                gapiReady = true;
                console.log('[GAPI] gapiReady = true, googleAuthInstance:', googleAuthInstance);
            }).catch(err => {
                console.error('[GAPI] gapi.client.init error:', err);
            });
        });
    }
    </script>
    <script>
    const GOOGLE_CLIENT_ID = '1071870713266-nngs20p3sig7k27ervsndpjnl44v2pj9.apps.googleusercontent.com';
    const GOOGLE_API_SCOPES = 'https://www.googleapis.com/auth/calendar.events';
    let googleAuthInstance = null;
    let gapiReady = false;

    document.addEventListener('DOMContentLoaded', function() {
        // Nút xuất file .ics
        const exportIcsBtn = document.getElementById('exportIcsBtn');
        if (exportIcsBtn) {
            exportIcsBtn.addEventListener('click', function() {
                if (!window.calendar) return alert('Lịch chưa được tải.');
                const events = window.calendar.getEvents();
                if (!events.length) return alert('Không có lịch hẹn nào để xuất.');
                let icsContent = [
                    'BEGIN:VCALENDAR',
                    'VERSION:2.0',
                    'PRODID:-//G3 Hospital//EN'
                ];
                events.forEach(event => {
                    icsContent.push('BEGIN:VEVENT');
                    icsContent.push('UID:' + event.id + '@g3hospital.vn');
                    icsContent.push('DTSTAMP:' + new Date().toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z');
                    icsContent.push('DTSTART:' + event.start.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z');
                    if (event.end) {
                        icsContent.push('DTEND:' + event.end.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z');
                    }
                    icsContent.push('SUMMARY:' + event.title);
                    icsContent.push('END:VEVENT');
                });
                icsContent.push('END:VCALENDAR');
                const blob = new Blob([icsContent.join('\r\n')], { type: 'text/calendar' });
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'lich-hen-g3hospital.ics';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
                alert('Đã xuất file lịch hẹn. Bạn chỉ cần import file này vào Google Calendar!');
            });
        }

        // Nút đồng bộ Google Calendar tự động
        const googleSyncBtn = document.getElementById('googleSyncBtn');
        if (googleSyncBtn) {
            googleSyncBtn.addEventListener('click', async function() {
                console.log('[GAPI] Button clicked. gapiReady:', gapiReady, 'googleAuthInstance:', googleAuthInstance);
                if (!window.calendar) {
                    console.warn('[GAPI] Calendar not loaded');
                    return alert('Lịch chưa được tải.');
                }
                if (!gapiReady || !googleAuthInstance) {
                    console.warn('[GAPI] Google API chưa sẵn sàng. gapiReady:', gapiReady, 'googleAuthInstance:', googleAuthInstance);
                    return alert('Google API chưa sẵn sàng, thử lại sau.');
                }
                if (!googleAuthInstance.isSignedIn.get()) {
                    console.log('[GAPI] Not signed in, calling signIn...');
                    await googleAuthInstance.signIn();
                }
                const user = googleAuthInstance.currentUser.get();
                const isAuthorized = user.hasGrantedScopes(GOOGLE_API_SCOPES);
                console.log('[GAPI] User:', user, 'isAuthorized:', isAuthorized);
                if (!isAuthorized) {
                    alert('Bạn chưa cấp quyền truy cập Google Calendar!');
                    return;
                }
                const events = window.calendar.getEvents();
                if (!events.length) return alert('Không có lịch hẹn nào để đồng bộ.');
                let ok = 0, fail = 0;
                for (const event of events) {
                    const gEvent = {
                        summary: event.title,
                        start: { dateTime: event.start.toISOString() },
                        end: { dateTime: (event.end ? event.end.toISOString() : event.start.toISOString()) }
                    };
                    try {
                        await gapi.client.calendar.events.insert({
                            calendarId: 'primary',
                            resource: gEvent
                        });
                        ok++;
                    } catch (e) {
                        fail++;
                        console.error('Lỗi khi đồng bộ sự kiện:', e);
                    }
                }
                alert('Đồng bộ Google Calendar thành công! ('+ok+' thành công, '+fail+' lỗi)');
            });
        }
    });
    </script>
</body>
</html>