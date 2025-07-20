<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="roleId" value="${sessionScope.roleId}" />
<c:if test="${empty roleId or roleId != 5}">
    <c:redirect url="/views/home/login.jsp?error=access_denied" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Technician Dashboard - G3 Hospital</title>
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
            <%@ include file="../layouts/technician-side-bar.jsp" %>
            
            <div class="content">
                <div class="container-fluid my-5">
                    <h2 class="text-primary mb-4">Technician Dashboard</h2>
                    
                    <!-- Thống kê tổng quan -->
                    <div class="row mb-4 g-3">
                        <div class="col-lg-3 col-md-6">
                            <div class="dashboard-card text-center">
                                <i class="bi bi-flask text-primary" style="font-size: 3rem;"></i>
                                <div class="stat-number">${waitingTests}</div>
                                <div class="stat-label">Xét nghiệm chờ</div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="dashboard-card text-center">
                                <i class="bi bi-gear text-success" style="font-size: 3rem;"></i>
                                <div class="stat-number">${processingTests}</div>
                                <div class="stat-label">Đang xử lý</div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="dashboard-card text-center">
                                <i class="bi bi-clock text-warning" style="font-size: 3rem;"></i>
                                <div class="stat-number">${waitingResults}</div>
                                <div class="stat-label">Chờ kết quả</div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="dashboard-card text-center">
                                <i class="bi bi-check-circle text-info" style="font-size: 3rem;"></i>
                                <div class="stat-number">${completedTests}</div>
                                <div class="stat-label">Đã hoàn thành</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Hành động nhanh -->
                    <div class="dashboard-card">
                        <h4 class="mb-4">Hành động nhanh</h4>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/technicianupdate" class="btn quick-action-btn w-100">
                                    <i class="bi bi-flask me-2"></i>
                                    Danh sách xét nghiệm
                                </a>
                            </div>
                            <div class="col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/ProfileServlet" class="btn quick-action-btn w-100">
                                    <i class="bi bi-person-circle me-2"></i>
                                    Hồ sơ cá nhân
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Danh sách xét nghiệm gần đây -->
                    <div class="dashboard-card">
                        <h4 class="mb-4">Xét nghiệm gần đây</h4>
                        <div class="table-responsive">
                            <c:choose>
                                <c:when test="${not empty testPatients or not empty processingTestPatients or not empty waitingResultPatients}">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Thời gian</th>
                                                <th>Bệnh nhân</th>
                                                <th>Loại xét nghiệm</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="patient" items="${testPatients}">
                                                <tr>
                                                    <td>${patient.changedAt}</td>
                                                    <td>${patient.fullName}</td>
                                                    <td>Xét nghiệm máu</td>
                                                    <td><span class="badge bg-warning">Chờ xử lý</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary">Bắt đầu</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:forEach var="patient" items="${processingTestPatients}">
                                                <tr>
                                                    <td>${patient.changedAt}</td>
                                                    <td>${patient.fullName}</td>
                                                    <td>Xét nghiệm máu</td>
                                                    <td><span class="badge bg-info">Đang xử lý</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-success">Hoàn thành</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:forEach var="patient" items="${waitingResultPatients}">
                                                <tr>
                                                    <td>${patient.changedAt}</td>
                                                    <td>${patient.fullName}</td>
                                                    <td>Xét nghiệm máu</td>
                                                    <td><span class="badge bg-secondary">Chờ kết quả</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-info">Xem kết quả</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <i class="bi bi-flask text-muted" style="font-size: 3rem;"></i>
                                        <p class="text-muted mt-2">Chưa có xét nghiệm nào</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Thống kê theo loại xét nghiệm -->
                    <div class="dashboard-card">
                        <h4 class="mb-4">Thống kê theo loại xét nghiệm</h4>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="text-center p-3">
                                    <i class="bi bi-droplet text-danger" style="font-size: 2rem;"></i>
                                    <h5 class="mt-2">Xét nghiệm máu</h5>
                                    <p class="text-muted">${bloodTests} ca hôm nay</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-center p-3">
                                    <i class="bi bi-camera text-primary" style="font-size: 2rem;"></i>
                                    <h5 class="mt-2">Chụp X-quang</h5>
                                    <p class="text-muted">${xrayTests} ca hôm nay</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-center p-3">
                                    <i class="bi bi-activity text-success" style="font-size: 2rem;"></i>
                                    <h5 class="mt-2">Siêu âm</h5>
                                    <p class="text-muted">${ultrasoundTests} ca hôm nay</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <%@ include file="../layouts/footer.jsp" %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>
</body>
</html> 