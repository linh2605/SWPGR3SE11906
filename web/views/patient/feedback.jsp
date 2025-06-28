<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../layouts/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đánh giá dịch vụ - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
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
<div class="wrapper">
    <div class="container my-5">
        <div class="form-section">
            <h3 class="text-primary mb-4">Đánh giá dịch vụ</h3>

            <form method="post" action="${pageContext.request.contextPath}/patient/feedback">
                <div class="mb-4">
                    <label class="form-label">Mức độ hài lòng tổng thể</label>
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rate" value="5"><label for="star5">★</label>
                        <input type="radio" id="star4" name="rate" value="4"><label for="star4">★</label>
                        <input type="radio" id="star3" name="rate" value="3"><label for="star3">★</label>
                        <input type="radio" id="star2" name="rate" value="2"><label for="star2">★</label>
                        <input type="radio" id="star1" name="rate" value="1"><label for="star1">★</label>
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
                    <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
<%@include file="../layouts/toastr.jsp"%>
</body>
</html>
