<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi Tiết Yêu Cầu Đổi Ca Dài Hạn - Admin</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <%@ include file="../layouts/admin-side-bar.jsp" %>
        <main class="container my-5">
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="mb-0">Chi tiết yêu cầu đổi ca dài hạn</h4>
                        </div>
                        <div class="card-body">
                            <c:if test="${sessionScope.error != null}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${sessionScope.error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% session.removeAttribute("error"); %>
                            </c:if>
                            <dl class="row">
                                <dt class="col-sm-4">Bác sĩ:</dt>
                                <dd class="col-sm-8">${change.doctor.user.fullName}</dd>
                                <dt class="col-sm-4">Ca hiện tại:</dt>
                                <dd class="col-sm-8">${change.oldShift.name} (${change.oldShift.startTime} - ${change.oldShift.endTime})</dd>
                                <dt class="col-sm-4">Ca muốn đổi sang:</dt>
                                <dd class="col-sm-8">${change.newShift.name} (${change.newShift.startTime} - ${change.newShift.endTime})</dd>
                                <dt class="col-sm-4">Ngày bắt đầu:</dt>
                                <dd class="col-sm-8">${change.effectiveDate}</dd>
                                <dt class="col-sm-4">Ngày kết thúc:</dt>
                                <dd class="col-sm-8"><c:out value="${change.endDate != null ? change.endDate : 'Không xác định'}"/></dd>
                                <dt class="col-sm-4">Lý do đổi ca:</dt>
                                <dd class="col-sm-8">${change.changeReason}</dd>
                                <dt class="col-sm-4">Trạng thái:</dt>
                                <dd class="col-sm-8"><span class="badge ${change.statusBadgeClass}">${change.statusDisplay}</span></dd>
                                <dt class="col-sm-4">Ngày gửi yêu cầu:</dt>
                                <dd class="col-sm-8">${change.createdAt}</dd>
                                <c:if test="${change.status == 'approved' || change.status == 'rejected' || change.status == 'active' || change.status == 'completed'}">
                                    <dt class="col-sm-4">Người duyệt:</dt>
                                    <dd class="col-sm-8">${change.approvedByUser != null ? change.approvedByUser.fullName : '---'}</dd>
                                    <dt class="col-sm-4">Ngày duyệt:</dt>
                                    <dd class="col-sm-8">${change.approvedAt != null ? change.approvedAt : '---'}</dd>
                                </c:if>
                            </dl>
                            <hr>
                            <h5>Lịch hẹn bị ảnh hưởng</h5>
                            <div class="table-responsive mb-3">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Bệnh nhân</th>
                                            <th>Ngày hẹn</th>
                                            <th>Giờ</th>
                                            <th>Trạng thái hiện tại</th>
                                            <th>Bác sĩ thay thế (nếu có)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="appt" items="${affectedAppointments}">
                                            <tr>
                                                <td>${appt.patientName}</td>
                                                <td>${appt.appointmentDate}</td>
                                                <td>${appt.timeSlot}</td>
                                                <td>${appt.status}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${appt.suggestedDoctor != null}">
                                                            ${appt.suggestedDoctor.fullName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-danger">Không có bác sĩ thay thế</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty affectedAppointments}">
                                            <tr>
                                                <td colspan="5" class="text-center">Không có lịch hẹn nào bị ảnh hưởng</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${change.status == 'pending'}">
                                <form method="post" action="${pageContext.request.contextPath}/admin/schedule-changes">
                                    <input type="hidden" name="action" value="process">
                                    <input type="hidden" name="changeId" value="${change.changeId}">
                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="checkbox" id="autoReassign" name="autoReassign" checked>
                                        <label class="form-check-label" for="autoReassign">
                                            Tự động chuyển lịch hẹn sang bác sĩ thay thế nếu có (nếu không sẽ huỷ lịch hẹn)
                                        </label>
                                    </div>
                                    <div class="d-flex justify-content-end gap-2">
                                        <button type="submit" name="decision" value="approve" class="btn btn-success">
                                            <i class="bi bi-check-circle"></i> Duyệt yêu cầu
                                        </button>
                                        <button type="submit" name="decision" value="reject" class="btn btn-danger">
                                            <i class="bi bi-x-circle"></i> Từ chối
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/schedule-changes" class="btn btn-secondary">
                                            <i class="bi bi-arrow-left"></i> Quay lại danh sách
                                        </a>
                                    </div>
                                </form>
                            </c:if>
                            <c:if test="${change.status != 'pending'}">
                                <a href="${pageContext.request.contextPath}/admin/schedule-changes" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <%@ include file="../layouts/footer.jsp" %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html> 