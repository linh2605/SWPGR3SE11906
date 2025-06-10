<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="admin-auth.jsp" %>
<%@ page import="java.lang.String" %>
<%
    String editId = request.getParameter("edit");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý liên hệ - G3 Hospital Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="main">
<%@include file="../layouts/admin-side-bar.jsp"%>
        <div class="content">
            <h2 class="mb-4">Quản lý liên hệ (Contact Us)</h2>
            <c:if test="${not empty messages}">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>SĐT</th>
                            <th>Chủ đề</th>
                            <th>Nội dung</th>
                            <th>Trạng thái</th>
                            <th>Ưu tiên</th>
                            <th>Ngày gửi</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="msg" items="${messages}" varStatus="loop">
                            <tr>
                                <td><c:out value="${loop.index + 1}"/></td>
                                <td><c:out value="${msg.name}"/></td>
                                <td><c:out value="${msg.email}"/></td>
                                <td><c:out value="${msg.phone}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${msg.subject eq 'service_feedback'}">Góp ý dịch vụ</c:when>
                                        <c:when test="${msg.subject eq 'incident_report'}">Báo cáo sự cố</c:when>
                                        <c:when test="${msg.subject eq 'improvement_suggestion'}">Đề xuất cải thiện</c:when>
                                        <c:when test="${msg.subject eq 'cooperation'}">Liên hệ hợp tác</c:when>
                                        <c:otherwise>Khác</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${fn:length(msg.message) > 40 ? fn:substring(msg.message, 0, 40) : msg.message}"/><c:if test="${fn:length(msg.message) > 40}">...</c:if></td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/contactManager" style="display:inline;">
                                        <input type="hidden" name="action" value="updateStatus" />
                                        <input type="hidden" name="id" value="${msg.message_id}" />
                                        <select name="status" class="form-select form-select-sm d-inline w-auto" onchange="this.form.submit()">
                                            <option value="pending" ${msg.status eq 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                                            <option value="in_progress" ${msg.status eq 'in_progress' ? 'selected' : ''}>Đang xử lý</option>
                                            <option value="resolved" ${msg.status eq 'resolved' ? 'selected' : ''}>Đã xử lý</option>
                                        </select>
                                    </form>
                                </td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/contactManager" style="display:inline;">
                                        <input type="hidden" name="action" value="updatePriority" />
                                        <input type="hidden" name="id" value="${msg.message_id}" />
                                        <select name="priority" class="form-select form-select-sm d-inline w-auto" onchange="this.form.submit()">
                                            <option value="high" ${msg.priority eq 'high' ? 'selected' : ''}>Cao</option>
                                            <option value="medium" ${msg.priority eq 'medium' ? 'selected' : ''}>Trung bình</option>
                                            <option value="low" ${msg.priority eq 'low' ? 'selected' : ''}>Thấp</option>
                                        </select>
                                    </form>
                                </td>
                                <td><c:out value="${msg.created_at}"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/contactManager?view=${msg.message_id}" class="btn btn-sm btn-info mb-1">Xem</a>
                                    <form method="post" action="${pageContext.request.contextPath}/contactDetail" style="display:inline;">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="id" value="${msg.message_id}" />
                                        <button type="submit" class="btn btn-sm btn-danger mb-1" onclick="return confirm('Xóa tin nhắn này?')">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
            <c:if test="${empty messages}">
                <div class="alert alert-info">Chưa có tin nhắn liên hệ nào.</div>
            </c:if>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>