package controller;

import dal.ShiftDAO;
import models.Shift;
import java.io.IOException;
import java.sql.Time;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import java.io.PrintWriter;

@WebServlet(name="AdminShiftServlet", urlPatterns={"/admin/shifts"})
public class AdminShiftServlet extends HttpServlet {
    
    private ShiftDAO shiftDAO;
    private Gson gson;
    
    @Override
    public void init() {
        shiftDAO = new ShiftDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "get":
                getShiftData(request, response);
                break;
            case "delete":
                deleteShift(request, response);
                break;
            case "detail":
                showShiftDetail(request, response);
                break;
            case "list":
            default:
                listShifts(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "add":
                addShift(request, response);
                break;
            case "update":
                updateShift(request, response);
                break;
            case "list":
            default:
                listShifts(request, response);
                break;
        }
    }
    
    private void listShifts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Shift> shifts = shiftDAO.getAllShifts();
        request.setAttribute("shifts", shifts);
        
        request.getRequestDispatcher("/views/admin/shifts.jsp").forward(request, response);
    }
    
    private void getShiftData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int shiftId = Integer.parseInt(request.getParameter("id"));
            Shift shift = shiftDAO.getShiftById(shiftId);
            
            if (shift != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                // Ép về 24h
                String startTime24 = shift.getStartTime() != null ? shift.getStartTime().toString() : ""; // "13:00:00"
                String endTime24 = shift.getEndTime() != null ? shift.getEndTime().toString() : "";     // "17:00:00"

                String json = String.format(
                    "{\"shiftId\":%d,\"name\":\"%s\",\"startTime\":\"%s\",\"endTime\":\"%s\",\"description\":\"%s\"}",
                    shift.getShiftId(),
                    shift.getName() == null ? "" : shift.getName().replace("\"", "\\\""),
                    startTime24,
                    endTime24,
                    shift.getDescription() == null ? "" : shift.getDescription().replace("\"", "\\\"")
                );
                response.getWriter().write(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Shift not found\"}");
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid shift ID\"}");
        }
    }
    
    private void addShift(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String name = request.getParameter("name");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String description = request.getParameter("description");
            
            // Validation
            if (name == null || name.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Name is required");
                return;
            }
            
            if (startTimeStr == null || endTimeStr == null) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Start time and end time are required");
                return;
            }
            
            // Fix time format - ensure it's in HH:mm:ss format
            if (!startTimeStr.contains(":")) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Invalid start time format");
                return;
            }
            if (!endTimeStr.contains(":")) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Invalid end time format");
                return;
            }
            
            // Add seconds if not present
            if (startTimeStr.split(":").length == 2) {
                startTimeStr += ":00";
            }
            if (endTimeStr.split(":").length == 2) {
                endTimeStr += ":00";
            }
            
            Time startTime = Time.valueOf(startTimeStr);
            Time endTime = Time.valueOf(endTimeStr);
            
            if (startTime.after(endTime)) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Start time must be before end time");
                return;
            }
            
            // Check if name already exists
            if (shiftDAO.isShiftNameExists(name)) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Shift name already exists");
                return;
            }
            
            Shift shift = new Shift();
            shift.setName(name);
            shift.setStartTime(startTime);
            shift.setEndTime(endTime);
            shift.setDescription(description);
            
            boolean success = shiftDAO.addShift(shift);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?success=Shift added successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Failed to add shift");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Invalid data format: " + e.getMessage());
        }
    }
    
    private void updateShift(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int shiftId = Integer.parseInt(request.getParameter("shiftId"));
            String name = request.getParameter("name");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String description = request.getParameter("description");
            
            // Validation
            if (name == null || name.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Name is required");
                return;
            }
            
            if (startTimeStr == null || endTimeStr == null) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Start time and end time are required");
                return;
            }
            
            // Fix time format - ensure it's in HH:mm:ss format
            if (!startTimeStr.contains(":")) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Invalid start time format");
                return;
            }
            if (!endTimeStr.contains(":")) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Invalid end time format");
                return;
            }
            
            // Add seconds if not present
            if (startTimeStr.split(":").length == 2) {
                startTimeStr += ":00";
            }
            if (endTimeStr.split(":").length == 2) {
                endTimeStr += ":00";
            }
            
            Time startTime = Time.valueOf(startTimeStr);
            Time endTime = Time.valueOf(endTimeStr);
            
            if (startTime.after(endTime)) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Start time must be before end time");
                return;
            }
            
            // Check if name already exists (excluding current shift)
            if (shiftDAO.isShiftNameExists(name, shiftId)) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Shift name already exists");
                return;
            }
            
            Shift shift = new Shift();
            shift.setShiftId(shiftId);
            shift.setName(name);
            shift.setStartTime(startTime);
            shift.setEndTime(endTime);
            shift.setDescription(description);
            
            boolean success = shiftDAO.updateShift(shift);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?success=Shift updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Failed to update shift");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Invalid data format: " + e.getMessage());
        }
    }
    
    private void deleteShift(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int shiftId = Integer.parseInt(request.getParameter("id"));
            
            boolean success = shiftDAO.deleteShift(shiftId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?success=Shift deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Cannot delete shift. It may be used in working schedules.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/shifts?error=Invalid shift ID");
        }
    }
    
    private void showShiftDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int shiftId = Integer.parseInt(request.getParameter("id"));
        Shift shift = shiftDAO.getShiftById(shiftId);
        request.setAttribute("shift", shift);
        request.getRequestDispatcher("/views/admin/shift-detail.jsp").forward(request, response);
    }
} 