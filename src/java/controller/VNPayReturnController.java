/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import config.VNPayConfig;
import controller.auth.util.EmailServices;
import dal.AppointmentDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import models.Appointment;
import models.PaymentStatus;
import models.User;

/**
 *
 * @author New_user
 */
@WebServlet(name = "VNPayReturnController", urlPatterns = {"/checkout-result"})
public class VNPayReturnController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            Map fields = new HashMap();
            for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }
            String signValue = VNPayConfig.hashAllFields(fields);
            if (signValue.equals(vnp_SecureHash)) {
                String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
                String vnp_Amount = request.getParameter("vnp_Amount");
                String vnp_TxnRef = request.getParameter("vnp_TxnRef");

                String apptID = vnp_TxnRef.substring(10); // cat bo doan "G3CMSxxxxx"

                boolean isSuccess = false;
                boolean isReserved = vnp_Amount.equalsIgnoreCase("5000000"); // check dat coc hay thanh toan full
                String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
                request.setAttribute("vnp_ResponseCode", vnp_ResponseCode);
                switch (vnp_ResponseCode) {
                    case "00":
                        isSuccess = true;
                        if (isReserved) { // chuyen tu PENDING -> RESERVED
                            AppointmentDao.updateAppointmentPaymentStatus(Integer.parseInt(apptID), PaymentStatus.RESERVED);
                        } else { // chuyen tu RESERVED -> PAID
                            AppointmentDao.updateAppointmentPaymentStatus(Integer.parseInt(apptID), PaymentStatus.PAID);
                        }
                        System.out.println("Payment success.");
                        System.out.println("apptID:" + apptID);
                        System.out.println("vnp_TransactionNo:" + vnp_TransactionNo);
                        System.out.println("vnp_Amount" + vnp_Amount);

                        request.setAttribute("msg", "Giao dịch thành công.");
                        break;
                    case "07":
                        request.setAttribute("msg", "Trừ tiền thành công. "
                                + "Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).");
                        break;
                    case "09":
                        request.setAttribute("msg", "Giao dịch không thành công do: "
                                + "Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.");
                        break;
                    case "10":
                        request.setAttribute("msg", "Giao dịch không thành công do: "
                                + "Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần");
                        break;
                    case "11":
                        request.setAttribute("msg", "Giao dịch không thành công do: "
                                + "Đã hết hạn chờ thanh toán (15 phút). Xin quý khách vui lòng thực hiện lại giao dịch.");
                        break;
                    case "12":
                        request.setAttribute("msg", "Giao dịch không thành công do: "
                                + "Thẻ/Tài khoản của khách hàng bị khóa.");
                        break;
                    case "13":
                        request.setAttribute("msg", "Giao dịch không thành công do: "
                                + "Quý khách nhập sai mật khẩu xác thực giao dịch (OTP). "
                                + "Xin quý khách vui lòng thực hiện lại giao dịch.");
                        break;
                    case "24":
                        request.setAttribute("msg", "Giao dịch không thành công do: "
                                + "Khách hàng hủy giao dịch");
                        break;
                    case "51":
                        request.setAttribute("msg", "Giao dịch không thành công do: "
                                + "Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.");
                        break;
                    case "65":
                        request.setAttribute("msg", "Giao dịch không thành công do: "
                                + "Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.");
                        break;
                    case "75":
                        request.setAttribute("msg", "Ngân hàng thanh toán đang bảo trì.");
                        break;
                    case "79":
                        request.setAttribute("msg", "Giao dịch không thành công do: "
                                + "KH nhập sai mật khẩu thanh toán quá số lần quy định. "
                                + "Xin quý khách vui lòng thực hiện lại giao dịch");
                        break;
                    case "99":
                        request.setAttribute("msg", "Các lỗi khác "
                                + "(lỗi còn lại, không có trong danh sách mã lỗi đã liệt kê)");
                        break;
                }
                Appointment appt = AppointmentDao.getAppointmentById(Integer.parseInt(apptID));
                request.setAttribute("appt", appt);
                User user = (User) request.getSession().getAttribute("user");
                String email = user.getEmail();
                String title = "";
                String content = "";
                if (isSuccess) {
                    if (isReserved) { // dat coc
                        title = "G3 Clinic - Đặt lịch khám thành công";
                        content = "Chúc mừng bạn đã đặt lịch khám thành công\n"
                                + "Họ và tên bệnh nhân: " + user.getFullName() + "\n"
                                + "Số điện thoại: " + user.getPhone() + "\n"
                                + "Dịch vụ khám: " + appt.getService().getName() + "\n"
                                + "Bác sĩ khám:" + appt.getDoctor().getUser().getFullName() + "\n"
                                + "Thời gian khám:" + appt.getAppointmentDate().format(DateTimeFormatter.ISO_DATE) + "\n"
                                + "Giá tiền: " + appt.getService().getPrice() + "đ\n"
                                + "Trạng thái thanh toán: Đã đặt cọc - 50000đ\n";
                    } else {
                        title = "G3 Clinic - Thanh toán khám bệnh thành công";
                        content = "Chúc mừng bạn đã thanh toán khám bệnh thành công\n"
                                + "Họ và tên bệnh nhân: " + user.getFullName() + "\n"
                                + "Số điện thoại: " + user.getPhone() + "\n"
                                + "Dịch vụ khám: " + appt.getService().getName() + "\n"
                                + "Bác sĩ khám:" + appt.getDoctor().getUser().getFullName() + "\n"
                                + "Thời gian khám:" + appt.getAppointmentDate().format(DateTimeFormatter.ISO_DATE) + "\n"
                                + "Giá tiền: " + appt.getService().getPrice() + "đ\n"
                                + "Trạng thái thanh toán: Đã thanh toán.\n";
                    }
                    EmailServices.sendEmail(email, title, content);
                }

                request.setAttribute("isSuccess", isSuccess);
                request.getRequestDispatcher("/views/appointment/payment-result.jsp").forward(request, response);
//                response.sendRedirect(request.getContextPath() + "/views/appointment/appointments.jsp");
            } else {
                System.out.println("invalid signature");
                request.setAttribute("errorMsg", "Giao dịch không hợp lệ (Invalid Signature).");
                request.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(request, response);
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
