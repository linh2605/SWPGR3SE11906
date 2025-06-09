<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết tin nhắn - G3 Hospital Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="main">
        <div class="sidebar">
            <h3>ADMIN DASHBOARD</h3>
            <a href="${pageContext.request.contextPath}/admin-dashboard.jsp">Tổng quan</a>
            <a href="${pageContext.request.contextPath}/doctorManager.jsp">Quản lý bác sĩ</a>
            <a href="${pageContext.request.contextPath}/userManager.jsp">Quản lý bệnh nhân</a>
            <a href="${pageContext.request.contextPath}/contactManager" class="active">Quản lý liên hệ</a>
        </div>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Chi tiết tin nhắn</h2>
                <a href="${pageContext.request.contextPath}/contactManager" class="btn btn-secondary">Quay lại</a>
            </div>
            
            <c:if test="${not empty message}">
                <div class="card">
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h5 class="card-title">Thông tin người gửi</h5>
                                <p><strong>Họ tên:</strong> <c:out value="${message.name}"/></p>
                                <p><strong>Email:</strong> <c:out value="${message.email}"/></p>
                                <p><strong>Số điện thoại:</strong> <c:out value="${message.phone}"/></p>
                            </div>
                            <div class="col-md-6">
                                <h5 class="card-title">Thông tin tin nhắn</h5>
                                <p><strong>Chủ đề:</strong> 
                                    <c:choose>
                                        <c:when test="${message.subject eq 'service_feedback'}">Góp ý dịch vụ</c:when>
                                        <c:when test="${message.subject eq 'incident_report'}">Báo cáo sự cố</c:when>
                                        <c:when test="${message.subject eq 'improvement_suggestion'}">Đề xuất cải thiện</c:when>
                                        <c:when test="${message.subject eq 'cooperation'}">Liên hệ hợp tác</c:when>
                                        <c:otherwise>Khác</c:otherwise>
                                    </c:choose>
                                </p>
                                <p><strong>Trạng thái:</strong> 
                                    <c:choose>
                                        <c:when test="${message.status eq 'pending'}">Chờ xử lý</c:when>
                                        <c:when test="${message.status eq 'in_progress'}">Đang xử lý</c:when>
                                        <c:when test="${message.status eq 'resolved'}">Đã xử lý</c:when>
                                    </c:choose>
                                </p>
                                <p><strong>Mức độ ưu tiên:</strong> 
                                    <c:choose>
                                        <c:when test="${message.priority eq 'high'}">Cao</c:when>
                                        <c:when test="${message.priority eq 'medium'}">Trung bình</c:when>
                                        <c:when test="${message.priority eq 'low'}">Thấp</c:when>
                                    </c:choose>
                                </p>
                                <p><strong>Thời gian gửi:</strong> <c:out value="${message.created_at}"/></p>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-12">
                                <h5 class="card-title">Nội dung tin nhắn</h5>
                                <div class="p-3 bg-light rounded">
                                    <c:out value="${message.message}"/>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mt-4">
                            <div class="col-12">
                                <h5 class="card-title">Cập nhật trạng thái</h5>
                                <form method="post" action="${pageContext.request.contextPath}/contactManager" class="d-inline">
                                    <input type="hidden" name="action" value="updateStatus" />
                                    <input type="hidden" name="id" value="${message.message_id}" />
                                    <select name="status" class="form-select d-inline w-auto me-2">
                                        <option value="pending" ${message.status eq 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                                        <option value="in_progress" ${message.status eq 'in_progress' ? 'selected' : ''}>Đang xử lý</option>
                                        <option value="resolved" ${message.status eq 'resolved' ? 'selected' : ''}>Đã xử lý</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary">Cập nhật trạng thái</button>
                                </form>
                                
                                <form method="post" action="${pageContext.request.contextPath}/contactManager" class="d-inline ms-2">
                                    <input type="hidden" name="action" value="updatePriority" />
                                    <input type="hidden" name="id" value="${message.message_id}" />
                                    <select name="priority" class="form-select d-inline w-auto me-2">
                                        <option value="high" ${message.priority eq 'high' ? 'selected' : ''}>Cao</option>
                                        <option value="medium" ${message.priority eq 'medium' ? 'selected' : ''}>Trung bình</option>
                                        <option value="low" ${message.priority eq 'low' ? 'selected' : ''}>Thấp</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary">Cập nhật ưu tiên</button>
                                </form>
                                
                                <form method="post" action="${pageContext.request.contextPath}/contactManager" class="d-inline ms-2">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="id" value="${message.message_id}" />
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa tin nhắn này?')">Xóa tin nhắn</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${empty message}">
                <div class="alert alert-warning">
                    Không tìm thấy thông tin tin nhắn.
                </div>
            </c:if>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html> 