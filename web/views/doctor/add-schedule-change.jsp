<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gửi Yêu Cầu Đổi Ca Dài Hạn - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        
        <div class="d-flex">
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
            
            <div class="content flex-grow-1">
                <div class="container-fluid mt-4">
                    <div class="row justify-content-center">
                        <div class="col-xxl-8 col-xl-9 col-lg-10">
                            <div class="card shadow-sm">
                                <div class="card-header bg-primary text-white py-3">
                                    <h5 class="card-title mb-0">
                                        <i class="bi bi-calendar-week me-2"></i>
                                        Gửi yêu cầu đổi ca dài hạn
                                    </h5>
                                </div>
                                <div class="card-body p-4">
                                    <c:if test="${sessionScope.error != null}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                            ${sessionScope.error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                        <% session.removeAttribute("error"); %>
                                    </c:if>

                                    <!-- Thông tin ca hiện tại -->
                                    <div class="row mb-3">
                                        <div class="col-12">
                                            <div class="alert alert-info">
                                                <strong>Các ca bạn đang làm:</strong>
                                                <div class="mt-2">
                                                    <c:forEach var="sd" items="${shiftDisplays}">
                                                        <div class="badge bg-primary p-2 mb-2 d-block text-start">
                                                            ${sd.shift.name} (${sd.shift.startTime} - ${sd.shift.endTime}): 
                                                            <c:forEach var="wd" items="${sd.weekDays}">${wd}<c:if test="${!fn:endsWith(sd.weekDays[sd.weekDays.size()-1], wd)}">, </c:if></c:forEach>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Form đổi ca -->
                                    <form action="${pageContext.request.contextPath}/doctor/schedule-changes" method="post">
                                        <input type="hidden" name="action" value="add">
                                        
                                        <div class="row g-4">
                                            <!-- Ca hiện tại -->
                                            <div class="col-md-6">
                                                <label for="oldShiftId" class="form-label">
                                                    <i class="bi bi-clock-history me-1"></i>
                                                    Chọn ca hiện tại muốn đổi <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="oldShiftId" name="oldShiftId" required>
                                                    <option value="">Chọn ca hiện tại</option>
                                                    <c:forEach var="sd" items="${shiftDisplays}">
                                                        <option value="${sd.shift.shiftId}">
                                                            ${sd.shift.name} (${sd.shift.startTime} - ${sd.shift.endTime}):
                                                            <c:forEach var="wd" items="${sd.weekDays}">${wd}<c:if test="${!fn:endsWith(sd.weekDays[sd.weekDays.size()-1], wd)}">, </c:if></c:forEach>
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <!-- Ca mới -->
                                            <div class="col-md-6">
                                                <label for="newShiftId" class="form-label">
                                                    <i class="bi bi-clock me-1"></i>
                                                    Chọn ca muốn đổi sang <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="newShiftId" name="newShiftId" required>
                                                    <option value="">Chọn ca mới</option>
                                                    <c:forEach var="shift" items="${shifts}">
                                                        <option value="${shift.shiftId}">
                                                            ${shift.name} (${shift.startTime} - ${shift.endTime})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <!-- Ngày bắt đầu -->
                                            <div class="col-md-6">
                                                <label for="effectiveDate" class="form-label">
                                                    <i class="bi bi-calendar-check me-1"></i>
                                                    Ngày bắt đầu <span class="text-danger">*</span>
                                                </label>
                                                <input type="date" class="form-control" id="effectiveDate" name="effectiveDate" required>
                                            </div>

                                            <!-- Ngày kết thúc -->
                                            <div class="col-md-6">
                                                <label for="endDate" class="form-label">
                                                    <i class="bi bi-calendar-x me-1"></i>
                                                    Ngày kết thúc
                                                </label>
                                                <input type="date" class="form-control" id="endDate" name="endDate">
                                                <div class="form-text mt-1">
                                                    <i class="bi bi-info-circle me-1"></i>
                                                    Có thể để trống nếu đổi ca đến hết hợp đồng
                                                </div>
                                            </div>

                                            <!-- Lý do -->
                                            <div class="col-12">
                                                <label for="changeReason" class="form-label">
                                                    <i class="bi bi-chat-left-text me-1"></i>
                                                    Lý do đổi ca <span class="text-danger">*</span>
                                                </label>
                                                <textarea class="form-control" id="changeReason" name="changeReason" rows="3" required 
                                                    placeholder="Vui lòng nhập lý do chi tiết để giúp quản lý xem xét yêu cầu của bạn..."></textarea>
                                            </div>
                                        </div>

                                        <!-- Buttons -->
                                        <div class="d-flex justify-content-between align-items-center mt-4 pt-2 border-top">
                                            <a href="${pageContext.request.contextPath}/doctor/schedule-changes" class="btn btn-secondary">
                                                <i class="bi bi-arrow-left me-1"></i> Quay lại
                                            </a>
                                            <button type="submit" class="btn btn-primary px-4">
                                                <i class="bi bi-send me-1"></i> Gửi yêu cầu
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../layouts/footer.jsp" %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>
    
    <script>
        $(document).ready(function() {
            // Set min date for date inputs to today
            const today = new Date().toISOString().split('T')[0];
            $('#effectiveDate').attr('min', today);
            $('#endDate').attr('min', today);

            // Update end date min when start date changes
            $('#effectiveDate').on('change', function() {
                $('#endDate').attr('min', $(this).val());
                if ($('#endDate').val() && $('#endDate').val() < $(this).val()) {
                    $('#endDate').val($(this).val());
                }
            });
        });
    </script>
</body>
</html> 