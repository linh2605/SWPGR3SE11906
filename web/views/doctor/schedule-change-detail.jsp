<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi Tiết Yêu Cầu Đổi Ca Dài Hạn - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        dl.row dt, dl.row dd {
            word-break: break-word;
            white-space: normal;
            vertical-align: middle;
        }
        dl.row dd {
            margin-bottom: 0.5rem;
        }
        .badge {
            font-size: 1em;
            padding: 0.5em 1em;
            border-radius: 0.5em;
        }
        .card-body {
            transition: box-shadow 0.2s;
        }
        .card-body:hover {
            box-shadow: 0 0 8px #007bff33;
            background: #f8f9fa;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="container">
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
            <div class="content">
                <h4 class="mb-0">Chi tiết yêu cầu đổi ca dài hạn</h4>
                <div class="card">
                    <div class="card-body">
                        <c:if test="${sessionScope.error != null}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${sessionScope.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <% session.removeAttribute("error"); %>
                        </c:if>
                        <dl class="row">
                            <dt class="col-sm-4">Loại yêu cầu:</dt>
                            <dd class="col-sm-8">
                                <span class="badge ${change.isCancelRequest() ? 'bg-danger' : 'bg-primary'}">
                                    ${change.typeDisplay}
                                </span>
                            </dd>
                            <dt class="col-sm-4">Ca hiện tại:</dt>
                            <dd class="col-sm-8">${change.oldShift.name} (${change.oldShift.startTime} - ${change.oldShift.endTime})</dd>
                            <dt class="col-sm-4">Ca muốn đổi sang:</dt>
                            <dd class="col-sm-8">
                                <c:choose>
                                    <c:when test="${change.isCancelRequest()}">
                                        <span class="text-danger">Hủy ca làm việc</span>
                                    </c:when>
                                    <c:otherwise>
                                        ${change.newShift.name} (${change.newShift.startTime} - ${change.newShift.endTime})
                                    </c:otherwise>
                                </c:choose>
                            </dd>
                            <dt class="col-sm-4">Ngày bắt đầu:</dt>
                            <dd class="col-sm-8">${change.effectiveDate}</dd>
                            <dt class="col-sm-4">Ngày kết thúc:</dt>
                            <dd class="col-sm-8"><c:out value="${change.endDate != null ? change.endDate : 'Không xác định'}"/></dd>
                            <dt class="col-sm-4">Lý do:</dt>
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
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/doctor/schedule-changes" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Quay lại danh sách
                            </a>
                            <c:if test="${change.status == 'pending'}">
                                <a href="${pageContext.request.contextPath}/doctor/schedule-changes?action=cancel&id=${change.changeId}" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn hủy yêu cầu này?');">
                                    <i class="bi bi-x-circle"></i> Hủy yêu cầu
                                </a>
                            </c:if>
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
</body>
</html> 