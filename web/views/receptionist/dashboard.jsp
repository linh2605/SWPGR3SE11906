<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="roleId" value="${sessionScope.roleId}" />
<c:if test="${empty roleId or roleId != 3}">
    <c:redirect url="/views/home/login.jsp?error=access_denied" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receptionist Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        .dashboard-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-bottom: 20px;
            transition: transform 0.3s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #0d6efd;
        }
        .stat-label {
            font-size: 1.1rem;
            color: #6c757d;
            margin-top: 10px;
        }
        .quick-action-btn {
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            border: none;
            border-radius: 12px;
            padding: 15px 25px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .quick-action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(13, 110, 253, 0.3);
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        
        <div class="d-flex">
            <%@ include file="../layouts/receptionist-side-bar.jsp" %>
            
            <div class="content">
                <div class="container-fluid my-5">
                    <h2 class="text-primary mb-4">Receptionist Dashboard</h2>
                    
                    <!-- Thống kê tổng quan -->
                    <div class="row mb-4 g-3">
                        <div class="col-lg-3 col-md-6">
                            <div class="dashboard-card text-center">
                                <i class="bi bi-calendar-check text-primary" style="font-size: 3rem;"></i>
                                <div class="stat-number">${todayAppointments}</div>
                                <div class="stat-label">Lịch hẹn hôm nay</div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="dashboard-card text-center">
                                <i class="bi bi-people text-success" style="font-size: 3rem;"></i>
                                <div class="stat-number">${waitingPatients}</div>
                                <div class="stat-label">Bệnh nhân chờ khám</div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="dashboard-card text-center">
                                <i class="bi bi-clock text-warning" style="font-size: 3rem;"></i>
                                <div class="stat-number">${processingPatients}</div>
                                <div class="stat-label">Đang xử lý</div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="dashboard-card text-center">
                                <i class="bi bi-check-circle text-info" style="font-size: 3rem;"></i>
                                <div class="stat-number">${completedPatients}</div>
                                <div class="stat-label">Đã hoàn thành</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Hành động nhanh -->
                    <div class="dashboard-card">
                        <h4 class="mb-4">Hành động nhanh</h4>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn quick-action-btn w-100">
                                    <i class="bi bi-calendar-plus me-2"></i>
                                    Quản lý lịch hẹn
                                </a>
                            </div>
                            <div class="col-md-4 mb-3">
                                <a href="${pageContext.request.contextPath}/receptionistuplate" class="btn quick-action-btn w-100">
                                    <i class="bi bi-people me-2"></i>
                                    Danh sách bệnh nhân
                                </a>
                            </div>
                            <div class="col-md-4 mb-3">
                                <a href="${pageContext.request.contextPath}/ProfileServlet" class="btn quick-action-btn w-100">
                                    <i class="bi bi-person-circle me-2"></i>
                                    Hồ sơ cá nhân
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Lịch hẹn gần đây -->
                    <div class="dashboard-card">
                        <h4 class="mb-4">Lịch hẹn gần đây</h4>
                        <div class="table-responsive">
                            <c:choose>
                                <c:when test="${not empty recentAppointments}">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Thời gian</th>
                                                <th>Bệnh nhân</th>
                                                <th>Dịch vụ</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="appointment" items="${recentAppointments}">
                                                <tr>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${appointment.shiftId == 1}">Sáng</c:when>
                                                            <c:when test="${appointment.shiftId == 2}">Chiều</c:when>
                                                            <c:when test="${appointment.shiftId == 3}">Tối</c:when>
                                                            <c:otherwise>Không xác định</c:otherwise>
                                                        </c:choose>
                                                        - ${appointment.queueNumber}
                                                    </td>
                                                    <td>${appointment.patient.user.fullName}</td>
                                                    <td>${appointment.service.name}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${appointment.status.code == 'PENDING'}">
                                                                <span class="badge bg-warning">Chờ xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${appointment.status.code == 'CONFIRMED'}">
                                                                <span class="badge bg-success">Đã xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${appointment.status.code == 'COMPLETED'}">
                                                                <span class="badge bg-info">Hoàn thành</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${appointment.status.displayName}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-primary btn-view-appointment"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#appointmentDetailModal"
                                                            data-patient="${appointment.patient.user.fullName}"
                                                            data-service="${appointment.service.name}"
                                                            data-date="${appointment.appointmentDateTime}"
                                                            data-status="${appointment.status.displayName}"
                                                            data-note="${appointment.note}">
                                                            Xem
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <i class="bi bi-calendar-x text-muted" style="font-size: 3rem;"></i>
                                        <p class="text-muted mt-2">Chưa có lịch hẹn nào</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <%@ include file="../layouts/footer.jsp" %>
    </div>

    <!-- Modal chi tiết lịch hẹn -->
    <div class="modal fade" id="appointmentDetailModal" tabindex="-1" aria-labelledby="appointmentDetailModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="appointmentDetailModalLabel">Chi tiết lịch hẹn</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="mb-2"><strong>Bệnh nhân:</strong> <span id="modalPatient"></span></div>
            <div class="mb-2"><strong>Dịch vụ:</strong> <span id="modalService"></span></div>
            <div class="mb-2"><strong>Thời gian:</strong> <span id="modalDate"></span></div>
            <div class="mb-2"><strong>Trạng thái:</strong> <span id="modalStatus"></span></div>
            <div class="mb-2"><strong>Ghi chú:</strong> <span id="modalNote"></span></div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
      document.querySelectorAll('.btn-view-appointment').forEach(function(btn) {
        btn.addEventListener('click', function() {
          document.getElementById('modalPatient').textContent = btn.getAttribute('data-patient');
          document.getElementById('modalService').textContent = btn.getAttribute('data-service');
          document.getElementById('modalDate').textContent = btn.getAttribute('data-date');
          document.getElementById('modalStatus').textContent = btn.getAttribute('data-status');
          document.getElementById('modalNote').textContent = btn.getAttribute('data-note');
        });
      });
    });
    </script>
</body>
</html> 