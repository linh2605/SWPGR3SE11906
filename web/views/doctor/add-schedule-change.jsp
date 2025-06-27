<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Gửi Yêu Cầu Đổi Ca Dài Hạn - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="container">
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
            <div class="content">
                <h4 class="mb-0">Gửi yêu cầu đổi ca dài hạn</h4>
                <%@ include file="doctor-auth.jsp" %>
                <main class="container my-5">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h4 class="mb-0">Gửi yêu cầu đổi ca dài hạn</h4>
                                </div>
                                <div class="card-body">
                                    <c:if test="${sessionScope.error != null}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            ${sessionScope.error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                        <% session.removeAttribute("error"); %>
                                    </c:if>
                                    <form action="${pageContext.request.contextPath}/doctor/schedule-changes" method="post">
                                        <input type="hidden" name="action" value="add">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="oldShiftId" class="form-label">Ca hiện tại *</label>
                                                    <select class="form-select" id="oldShiftId" name="oldShiftId" required>
                                                        <option value="">Chọn ca hiện tại</option>
                                                        <c:forEach var="schedule" items="${currentSchedules}">
                                                            <option value="${schedule.shift.shiftId}">
                                                                ${schedule.shift.name} (${schedule.shift.startTime} - ${schedule.shift.endTime})
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="newShiftId" class="form-label">Ca muốn đổi sang *</label>
                                                    <select class="form-select" id="newShiftId" name="newShiftId" required>
                                                        <option value="">Chọn ca mới</option>
                                                        <c:forEach var="shift" items="${shifts}">
                                                            <option value="${shift.shiftId}">
                                                                ${shift.name} (${shift.startTime} - ${shift.endTime})
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="effectiveDate" class="form-label">Ngày bắt đầu *</label>
                                                    <input type="date" class="form-control" id="effectiveDate" name="effectiveDate" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="endDate" class="form-label">Ngày kết thúc</label>
                                                    <input type="date" class="form-control" id="endDate" name="endDate">
                                                    <div class="form-text">Có thể để trống nếu đổi ca đến hết hợp đồng</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="changeReason" class="form-label">Lý do đổi ca *</label>
                                            <textarea class="form-control" id="changeReason" name="changeReason" rows="3" required placeholder="Nhập lý do..."></textarea>
                                        </div>
                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/doctor/schedule-changes" class="btn btn-secondary">
                                                <i class="bi bi-arrow-left"></i> Quay lại
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="bi bi-send"></i> Gửi yêu cầu
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <%@ include file="../layouts/footer.jsp" %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html> 