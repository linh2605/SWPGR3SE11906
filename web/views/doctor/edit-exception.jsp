<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Sửa Yêu Cầu Ngoại Lệ - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="container">
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
            <div class="content">
                <h4 class="mb-0">Sửa yêu cầu ngoại lệ</h4>
                <%@ include file="doctor-auth.jsp" %>

                <main class="container my-5">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h4 class="mb-0">Sửa yêu cầu ngoại lệ</h4>
                                </div>
                                <div class="card-body">
                                    <c:if test="${error != null}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            ${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>
                                    
                                    <form action="${pageContext.request.contextPath}/doctor-schedule" method="post">
                                        <input type="hidden" name="action" value="update-exception">
                                        <input type="hidden" name="exceptionId" value="${exception.exceptionId}">
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="exceptionDate" class="form-label">Ngày ngoại lệ *</label>
                                                    <input type="date" class="form-control" id="exceptionDate" name="exceptionDate" 
                                                           value="${exception.exceptionDate}" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="exceptionType" class="form-label">Loại yêu cầu *</label>
                                                    <select class="form-select" id="exceptionType" name="exceptionType" required>
                                                        <option value="">Chọn loại</option>
                                                        <option value="Nghỉ phép" ${exception.exceptionType == 'Nghỉ phép' ? 'selected' : ''}>Nghỉ phép</option>
                                                        <option value="Thay đổi giờ làm" ${exception.exceptionType == 'Thay đổi giờ làm' ? 'selected' : ''}>Thay đổi giờ làm</option>
                                                        <option value="Khẩn cấp" ${exception.exceptionType == 'Khẩn cấp' ? 'selected' : ''}>Khẩn cấp</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3" id="newShiftSection" style="display: none;">
                                            <label for="newShiftId" class="form-label">Ca làm việc mới *</label>
                                            <select class="form-select" id="newShiftId" name="newShiftId">
                                                <option value="">Chọn ca làm việc mới</option>
                                                <c:forEach var="shift" items="${shifts}">
                                                    <option value="${shift.shiftId}" ${exception.newShiftId == shift.shiftId ? 'selected' : ''}>
                                                        ${shift.name} (${shift.startTime} - ${shift.endTime})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="reason" class="form-label">Lý do *</label>
                                            <textarea class="form-control" id="reason" name="reason" rows="3" required 
                                                      placeholder="Nhập lý do cho yêu cầu...">${exception.reason}</textarea>
                                        </div>
                                        
                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/doctor-schedule?action=exceptions" class="btn btn-secondary">
                                                <i class="bi bi-arrow-left"></i> Quay lại
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="bi bi-check-circle"></i> Cập nhật yêu cầu
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
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script></script>
</body>
</html> 