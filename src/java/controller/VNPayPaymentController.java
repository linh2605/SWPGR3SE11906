package controller;

import config.VNPayConfig;
import dal.AppointmentDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import models.Appointment;
import models.PaymentStatus;

@WebServlet(name = "VNPayPaymentController", urlPatterns = {"/checkout"})
public class VNPayPaymentController extends HttpServlet {

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

        // Use AuthHelper for unified authentication (for patients making payment)
        if (!utils.AuthHelper.hasRole(request, 1)) { // 1 = patient
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }

//        String amount = request.getParameter("amount");
        int apptID = Integer.parseInt(request.getParameter("id"));
        System.out.println("id:" + apptID);
        request.getSession().setAttribute("apptID", apptID);
        Appointment appt = AppointmentDao.getAppointmentById(apptID);
        System.out.println("appt:" + appt.getId() + " service:" + appt.getService().getName());

        long amount = 0L;
        String vnp_OrderInfo = "";
        PaymentStatus paymentStatus = appt.getPaymentStatus();
        switch (paymentStatus) {
            case RESERVED: // thanh toán cuối: trừ 50k đặt cọc
                amount = appt.getService().getPrice() - 50000;
                vnp_OrderInfo = "G3 Clinic thanh toan don kham ";
                break;
            case PENDING: // đặt cọc trước
                amount = 50000L;
                vnp_OrderInfo = "G3 Clinic dat coc don kham ";
                break;
            case PAID:
                request.setAttribute("errorMsg", "Giao dịch đã hoàn tất, không thể thanh toán.");
                request.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(request, response);
                return;
        }

//        String vnp_TxnRef = VNPayConfig.getRandomNumber(8);
        String vnp_TxnRef = "G3CMS"  + VNPayConfig.getRandomNumber(5)+ apptID;
        String vnp_IpAddr = VNPayConfig.getIpAddress(request);
        String vnp_CreateDate = VNPayConfig.getCurrentDate();
        String vnp_ExpireDate = VNPayConfig.getExpireDate(15); // thoi gian het han giao dich
        String bankCode = request.getParameter("bankCode");

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount * 100)); // *100
        if (bankCode != null && !bankCode.isEmpty()) {
            vnp_Params.put("vnp_BankCode", bankCode);
        }
//        vnp_Params.put("vnp_BankCode", "INTCARD"); // thanh toan the VISA
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);

        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.secretKey, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + queryUrl;
        System.out.println(paymentUrl);
        response.sendRedirect(paymentUrl);
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
