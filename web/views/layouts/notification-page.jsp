<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="vi">
    <head>
        <title>G3 Hospital</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- FullCalendar CSS -->
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    </head>
    <body id="appointments">
        <!-- Header -->
        <%@ include file="../layouts/header.jsp" %>
        <!-- Main Content -->
        <main class="container my-5 text-center">
            <c:if test="${successMsg != null}">
                <div class="alert alert-success fs-5" role="alert">
                    ${successMsg}
                </div>
                <c:choose>
                    <c:when test="${note == 'appointmentSuccess'}">
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-primary mt-3">
                            <i class="bi bi-house-door-fill me-1"></i> Lịch hẹn của tôi
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary mt-3">
                            <i class="bi bi-house-door-fill me-1"></i> Trở về trang chủ
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:if>
            <c:if test="${errorMsg != null}">
                <div class="alert alert-danger fs-5" role="alert">
                    ${errorMsg}
                </div>
                <a href="javascript:history.back()" class="btn btn-primary mt-3">
                    <i class="bi bi-house-door-fill me-1"></i> Quay lại
                </a>
            </c:if>

        </main>

        <!-- Footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    </body>
</html>