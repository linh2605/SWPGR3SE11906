<%-- 
    Document   : footer
    Created on : May 23, 2025, 3:20:35 PM
    Author     : HoangAnh
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="bg-dark text-white py-4">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h5>G3 Hospital</h5>
                <p>Địa chỉ: Trường Đại Học FPT, Thạch Hòa, Thạch Thất, Hà Nội</p>
                <p>Email: [email protected]</p>
                <p>Hotline: 0976054728</p>
            </div>
            <div class="col-md-4">
                <h5>Liên kết nhanh</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/views/info/about_us.jsp" class="text-white">Giới thiệu</a></li>
                    <li><a href="${pageContext.request.contextPath}/views/info/policies.jsp" class="text-white">Chính Sách</a></li>
                    <li><a href="#" class="text-white">Chuyên khoa</a></li>
                    <li><a href="#" class="text-white">Bác sĩ</a></li>
                    <li><a href="${pageContext.request.contextPath}/views/info/contact_us.jsp" class="text-white">Liên hệ</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5>Kết nối với chúng tôi</h5>
                <a href="#" class="text-white me-2"><i class="bi bi-facebook"></i></a>
                <a href="#" class="text-white me-2"><i class="bi bi-youtube"></i></a>
                <a href="#" class="text-white"><i class="bi bi-twitter"></i></a>
            </div>
        </div>
    </div>
</footer>