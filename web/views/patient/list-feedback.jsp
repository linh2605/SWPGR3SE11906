<%@ page import="models.Feedback" %>
<%@ page import="java.util.List" %>
<%@ include file="../layouts/header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        .star-rating {
            direction: ltr;
            font-size: 2rem;
            unicode-bidi: bidi-override;
            display: inline-flex;
            justify-content: flex-start;
        }

        .star-rating input {
            display: none;
        }

        .star-rating label {
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
        }

        .star-rating input:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: #ffc107;
        }

        /* fix hover bị ngược: dùng flex-row-reverse */
        .star-rating {
            flex-direction: row-reverse;
        }

        .star-rating label:hover ~ label {
            color: #ffc107;
        }

        .star-rating input:checked ~ label {
            color: #ffc107;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Phản hồi của bạn</h2>
    <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addFeedbackModal">Thêm phản hồi</button>

    <% List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks"); %>
    <table class="table table-bordered" id="feedbackTable">
        <thead class="table-light">
        <tr>
            <th>ID</th>
            <th>Đánh giá bác sĩ</th>
            <th>Đánh giá dịch vụ</th>
            <th>Đánh giá giá cả</th>
            <th>Đánh giá ưu đãi</th>
            <th>Rate</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <% for (Feedback fb : feedbacks) { %>
        <tr>
            <td><%= fb.getId() %></td>
            <td><%= fb.getDoctorFeedback() %></td>
            <td><%= fb.getServiceFeedback() %></td>
            <td><%= fb.getPriceFeedback() %></td>
            <td><%= fb.getOfferFeedback() %></td>
            <td><%= fb.getRate() %></td>
            <td>
                <button class="btn btn-warning btn-sm" onclick="populateUpdateForm(<%= fb.getId() %>, <%= fb.getRate() %>, '<%= fb.getDoctorFeedback().replace("'", "\\'") %>', '<%= fb.getServiceFeedback().replace("'", "\\'") %>', '<%= fb.getPriceFeedback().replace("'", "\\'") %>', '<%= fb.getOfferFeedback().replace("'", "\\'") %>')" data-bs-toggle="modal" data-bs-target="#updateFeedbackModal" title="Chỉnh sửa">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-danger btn-sm" onclick="confirmDelete(<%= fb.getId() %>)" data-bs-toggle="modal" data-bs-target="#deleteFeedbackModal" title="Xóa">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<!-- Add Feedback Modal -->
<div class="modal fade" id="addFeedbackModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="post" action="${pageContext.request.contextPath}/patient/feedback" class="modal-content p-4">
            <input type="hidden" name="action" value="add">

            <h5 class="modal-title mb-3">Thêm phản hồi</h5>

            <div class="mb-4">
                <label class="form-label">Mức độ hài lòng tổng thể</label>
                <div class="star-rating">
                    <input type="radio" id="add_star5" name="rate" value="5"><label for="add_star5">★</label>
                    <input type="radio" id="add_star4" name="rate" value="4"><label for="add_star4">★</label>
                    <input type="radio" id="add_star3" name="rate" value="3"><label for="add_star3">★</label>
                    <input type="radio" id="add_star2" name="rate" value="2"><label for="add_star2">★</label>
                    <input type="radio" id="add_star1" name="rate" value="1"><label for="add_star1">★</label>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Đánh giá về bác sĩ</label>
                <textarea name="doctorFeedback" class="form-control" rows="3" required></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Đánh giá về dịch vụ</label>
                <textarea name="serviceFeedback" class="form-control" rows="3" required></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Đánh giá về giá cả</label>
                <textarea name="priceFeedback" class="form-control" rows="3" required></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Đánh giá về ưu đãi</label>
                <textarea name="offerFeedback" class="form-control" rows="3" required></textarea>
            </div>

            <div class="d-flex justify-content-end">
                <button type="submit" class="btn btn-success">Gửi đánh giá</button>
            </div>
        </form>
    </div>
</div>

<!-- Update Feedback Modal -->
<div class="modal fade" id="updateFeedbackModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="post" action="${pageContext.request.contextPath}/patient/feedback" class="modal-content p-4">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="update_id" name="id">

            <h5 class="modal-title mb-3">Cập nhật phản hồi</h5>

            <div class="mb-4">
                <label class="form-label">Mức độ hài lòng tổng thể</label>
                <div class="star-rating">
                    <input type="radio" id="update_star5" name="rate" value="5"><label for="update_star5">★</label>
                    <input type="radio" id="update_star4" name="rate" value="4"><label for="update_star4">★</label>
                    <input type="radio" id="update_star3" name="rate" value="3"><label for="update_star3">★</label>
                    <input type="radio" id="update_star2" name="rate" value="2"><label for="update_star2">★</label>
                    <input type="radio" id="update_star1" name="rate" value="1"><label for="update_star1">★</label>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Đánh giá về bác sĩ</label>
                <textarea name="doctorFeedback" class="form-control" rows="3" required></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Đánh giá về dịch vụ</label>
                <textarea name="serviceFeedback" class="form-control" rows="3" required></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Đánh giá về giá cả</label>
                <textarea name="priceFeedback" class="form-control" rows="3" required></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Đánh giá về ưu đãi</label>
                <textarea name="offerFeedback" class="form-control" rows="3" required></textarea>
            </div>

            <div class="d-flex justify-content-end">
                <button type="submit" class="btn btn-primary">Cập nhật</button>
            </div>
        </form>

    </div>
</div>

<!-- Delete Modal -->
<div class="modal fade" id="deleteFeedbackModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="post" action="${pageContext.request.contextPath}/patient/feedback" class="modal-content">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" id="delete_id" name="id">
            <div class="modal-header">
                <h5 class="modal-title">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                Bạn có chắc chắn muốn xóa phản hồi này?
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-danger">Xóa</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            </div>
        </form>
    </div>
</div>
<%@ include file="../layouts/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function populateUpdateForm(id, rate, doctor, service, price, offer) {
        document.getElementById('update_id').value = id;
        document.querySelectorAll('#updateFeedbackModal input[name="rate"]').forEach(r => {
            r.checked = r.value == rate;
        });
        document.querySelector('#updateFeedbackModal textarea[name="doctorFeedback"]').value = doctor;
        document.querySelector('#updateFeedbackModal textarea[name="serviceFeedback"]').value = service;
        document.querySelector('#updateFeedbackModal textarea[name="priceFeedback"]').value = price;
        document.querySelector('#updateFeedbackModal textarea[name="offerFeedback"]').value = offer;
    }

    function confirmDelete(id) {
        document.getElementById('delete_id').value = id;
    }
</script>
<%@include file="../layouts/toastr.jsp"%>
</body>
</html>