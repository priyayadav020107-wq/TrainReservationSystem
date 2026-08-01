package controller;

import java.io.IOException;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.AdminPojo;
import model.ReportPojo;
import model.TrainPojo;
import model.UserPojo;
import service.ConcurrencyService;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    
    private ConcurrencyService concurrencyService;
    
    @Override
    public void init() {
        concurrencyService = new ConcurrencyService();
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        
        if (action == null) {
            resp.sendRedirect("AdminLogin.jsp");
            return;
        }
        
        switch(action) {
            case "login": 
                login(req, resp); 
                break;
            case "logout": 
                logout(req, resp); 
                break;
            case "addTrain": 
                addTrain(req, resp); 
                break;
            case "updateTrain": 
                updateTrain(req, resp); 
                break;
            case "removeTrain": 
                removeTrain(req, resp); 
                break;
            case "deactivateUser":
                deactivateUser(req, resp);
                break;
            case "activateUser":
                activateUser(req, resp);
                break;
            case "updateAdminName":
                updateAdminName(req, resp);
                break;
            case "updateAdminEmail":
                updateAdminEmail(req, resp);
                break;
            case "changeAdminPassword":
                changeAdminPassword(req, resp);
                break;
            default: 
                resp.sendRedirect("AdminServlet?action=dashboard");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        
        if (action == null || "dashboard".equals(action)) {
            dashboard(req, resp);
        } else if ("manageTrains".equals(action)) {
            manageTrains(req, resp);
        } else if ("bookings".equals(action)) {
            bookings(req, resp);
        } else if ("users".equals(action)) {
            users(req, resp);
        } else if ("reports".equals(action)) {
            reports(req, resp);
        } else if ("viewSeats".equals(action)) {
            viewSeats(req, resp);
        } else if ("getLoginHistory".equals(action)) {
            getLoginHistory(req, resp);
        } else if ("getBookingDetails".equals(action)) {
            getBookingDetails(req, resp);
        } else if ("trainHistoryAll".equals(action)) {
            trainHistoryAll(req, resp);
        } else if ("cancelBooking".equals(action)) {
            cancelBooking(req, resp);
        } else if ("adminProfile".equals(action)) {
            adminProfile(req, resp);
        } else {
            dashboard(req, resp);
        }
    }
    
    
    private void login(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        AdminPojo pojo = new AdminPojo();
        pojo.setEmail(req.getParameter("email"));
        pojo.setPassword(req.getParameter("password"));
        
        if (pojo.login()) {
            HttpSession session = req.getSession();
            session.setAttribute("adminId", pojo.getAdminId());
            session.setAttribute("adminName", pojo.getName());
            resp.sendRedirect("AdminServlet?action=dashboard");
        } else {
            req.setAttribute("error", "Invalid credentials");
            req.getRequestDispatcher("AdminLogin.jsp").forward(req, resp);
        }
    }
    
    private void logout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.getSession().invalidate();
        resp.sendRedirect("AdminLogin.jsp");
    }
    
    
    private void dashboard(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        AdminPojo pojo = new AdminPojo();
        pojo.getDashboardStats();
        
        UserPojo userPojo = new UserPojo();
        List<Map<String, Object>> recentActivities = userPojo.getRecentActivities();
        
        req.setAttribute("stats", pojo);
        req.setAttribute("recentActivities", recentActivities);
        req.setAttribute("activeBookings", ConcurrencyService.getActiveBookingCount());
        req.setAttribute("queueSize", ConcurrencyService.getQueueSize());
        req.setAttribute("activeThreads", ConcurrencyService.getActiveThreadCount());
        req.setAttribute("seatLockCount", ConcurrencyService.getSeatLockCount());
        req.setAttribute("completedTasks", ConcurrencyService.getCompletedTaskCount());
        req.getRequestDispatcher("AdminDashboard.jsp").forward(req, resp);
    }
    
    
    private void manageTrains(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        TrainPojo pojo = new TrainPojo();
        List<TrainPojo> trains = pojo.getAllTrains();
        req.setAttribute("trains", trains);
        req.getRequestDispatcher("ManageTrains.jsp").forward(req, resp);
    }
    
    private void addTrain(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            TrainPojo pojo = new TrainPojo();
            pojo.setTrainNo(req.getParameter("trainNo"));
            pojo.setTrainName(req.getParameter("trainName"));
            pojo.setSourceStationId(Integer.parseInt(req.getParameter("sourceStation")));
            pojo.setDestinationStationId(Integer.parseInt(req.getParameter("destinationStation")));
            pojo.setDepartureTime(Time.valueOf(req.getParameter("departureTime") + ":00"));
            pojo.setArrivalTime(Time.valueOf(req.getParameter("arrivalTime") + ":00"));
            pojo.setTotalSeats(Integer.parseInt(req.getParameter("totalSeats")));
            pojo.setFare(Double.parseDouble(req.getParameter("fare")));
            
            concurrencyService.addTrainWithLock(pojo);
            req.setAttribute("message", "Train Added Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to add train: " + e.getMessage());
        }
        
        TrainPojo pojo = new TrainPojo();
        List<TrainPojo> trains = pojo.getAllTrains();
        req.setAttribute("trains", trains);
        req.getRequestDispatcher("ManageTrains.jsp").forward(req, resp);
    }
    
    private void updateTrain(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            int trainId = Integer.parseInt(req.getParameter("trainId"));
            double fare = Double.parseDouble(req.getParameter("fare"));
            String status = req.getParameter("status");
            
            HttpSession session = req.getSession();
            String adminName = (String) session.getAttribute("adminName");
            
            TrainPojo pojo = new TrainPojo();
            pojo.setTrainId(trainId);
            pojo.setFare(fare);
            pojo.setStatus(status);
            pojo.setChangedBy(adminName);
            
            concurrencyService.updateTrainWithLock(pojo);
            req.setAttribute("message", "Train Updated Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to update train: " + e.getMessage());
        }
        
        TrainPojo pojo = new TrainPojo();
        List<TrainPojo> trains = pojo.getAllTrains();
        req.setAttribute("trains", trains);
        req.getRequestDispatcher("ManageTrains.jsp").forward(req, resp);
    }
    
    private void removeTrain(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            int trainId = Integer.parseInt(req.getParameter("trainId"));
            TrainPojo pojo = new TrainPojo();
            pojo.setTrainId(trainId);
            concurrencyService.removeTrainWithLock(pojo);
            req.setAttribute("message", "Train Deactivated Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to deactivate train: " + e.getMessage());
        }
        
        TrainPojo pojo = new TrainPojo();
        List<TrainPojo> trains = pojo.getAllTrains();
        req.setAttribute("trains", trains);
        req.getRequestDispatcher("ManageTrains.jsp").forward(req, resp);
    }
    
    private void viewSeats(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        int trainId = Integer.parseInt(req.getParameter("trainId"));
        String journeyDate = req.getParameter("journeyDate");
        
        TrainPojo trainPojo = new TrainPojo();
        
        if (journeyDate == null || journeyDate.trim().isEmpty()) {
            journeyDate = trainPojo.getMostRecentBookingDate(trainId);
            if (journeyDate == null || journeyDate.trim().isEmpty()) {
                journeyDate = LocalDate.now().plusDays(1).toString();
            }
        }
        
        List<Map<String, Object>> seats = trainPojo.getTrainSeatsStatus(trainId, journeyDate);
        
        req.setAttribute("seats", seats);
        req.setAttribute("trainId", trainId);
        req.setAttribute("journeyDate", journeyDate);
        req.getRequestDispatcher("ViewSeats.jsp").forward(req, resp);
    }
    
    private void trainHistoryAll(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        TrainPojo trainPojo = new TrainPojo();
        List<Map<String, Object>> allAudit = trainPojo.getAllTrainAudit();
        
        req.setAttribute("allAudit", allAudit);
        req.getRequestDispatcher("TrainHistory.jsp").forward(req, resp);
    }
    
    
    private void bookings(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String pnr = req.getParameter("pnr");
        
        if(pnr != null && !pnr.isEmpty()) {
            UserPojo userPojo = new UserPojo();
            userPojo.setPnr(pnr);
            UserPojo booking = userPojo.searchByPNR();
            
            if(booking != null && booking.getPnr() != null) {
                req.setAttribute("singleBooking", booking);
                req.setAttribute("searchPnr", pnr);
            } else {
                req.setAttribute("searchError", "not_found");
                req.setAttribute("searchPnr", pnr);
            }
        }
        
        // ✅ NEW: pagination for the "All Bookings" table
        int pageSize = 10;
        int page = 1;
        String pageParam = req.getParameter("page");
        if(pageParam != null) {
            try { page = Integer.parseInt(pageParam); if(page < 1) page = 1; } catch(NumberFormatException e) { page = 1; }
        }
        
        UserPojo userPojo = new UserPojo();
        int totalBookings = userPojo.getAllBookingsCount();
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
        if(totalPages < 1) totalPages = 1;
        if(page > totalPages) page = totalPages;
        int offset = (page - 1) * pageSize;
        
        List<UserPojo> bookings = userPojo.getAllBookingsForAdminPaged(pageSize, offset);
        req.setAttribute("bookings", bookings);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("Bookings.jsp").forward(req, resp);
    }
    
    
    private void getBookingDetails(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String pnr = req.getParameter("pnr");
        
        UserPojo userPojo = new UserPojo();
        userPojo.setPnr(pnr);
        UserPojo booking = userPojo.searchByPNR();
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        if(booking != null) {
            if("CANCELLED".equals(booking.getBookingStatus())) {
                String json = "[{\"status\":\"CANCELLED\",\"message\":\"This booking has been CANCELLED. No passenger details available.\"}]";
                resp.getWriter().write(json);
                return;
            }
            
            UserPojo passengerPojo = new UserPojo();
            passengerPojo.setBookingId(booking.getBookingId());
            List<UserPojo> passengers = passengerPojo.getPassengers();
            
            List<Map<String, Object>> passengerList = new ArrayList<>();
            if(passengers != null && !passengers.isEmpty()) {
                for(UserPojo p : passengers) {
                    Map<String, Object> passenger = new HashMap<>();
                    passenger.put("name", p.getPassengerName());
                    passenger.put("age", p.getAge());
                    passenger.put("gender", p.getGender());
                    passenger.put("seatNumber", p.getSeatNumber() != null ? p.getSeatNumber() : "Not assigned");
                    passenger.put("coachNo", p.getCoachNo() != null ? p.getCoachNo() : "-");
                    passengerList.add(passenger);
                }
            }
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for(int i = 0; i < passengerList.size(); i++) {
                Map<String, Object> p = passengerList.get(i);
                json.append("{");
                json.append("\"name\":\"").append(p.get("name")).append("\",");
                json.append("\"age\":").append(p.get("age")).append(",");
                json.append("\"gender\":\"").append(p.get("gender")).append("\",");
                json.append("\"seatNumber\":\"").append(p.get("seatNumber")).append("\",");
                json.append("\"coachNo\":\"").append(p.get("coachNo")).append("\"");
                json.append("}");
                if(i < passengerList.size() - 1) json.append(",");
            }
            json.append("]");
            
            resp.getWriter().write(json.toString());
        } else {
            resp.getWriter().write("[]");
        }
    }
    
    private void cancelBooking(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        
        UserPojo userPojo = new UserPojo();
        userPojo.setBookingId(bookingId);
        userPojo.cancelTicket();

        // ✅ NEW: same waitlist promotion trigger as UserServlet.cancelBookingJSON()
        if (userPojo.getSeatId() > 0) {
            concurrencyService.processWaitlistPromotion(userPojo.getTrainId(), userPojo.getJourneyDate(), userPojo.getSeatId());
        }
        
        req.setAttribute("message", "Booking Cancelled Successfully");
        bookings(req, resp);
    }
   
    private void users(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // ✅ NEW: pagination for the Users table
        int pageSize = 10;
        int page = 1;
        String pageParam = req.getParameter("page");
        if(pageParam != null) {
            try { page = Integer.parseInt(pageParam); if(page < 1) page = 1; } catch(NumberFormatException e) { page = 1; }
        }
        
        UserPojo userPojo = new UserPojo();
        int totalUsers = userPojo.getAllUsersCount();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if(totalPages < 1) totalPages = 1;
        if(page > totalPages) page = totalPages;
        int offset = (page - 1) * pageSize;
        
        List<UserPojo> users = userPojo.getAllUsersForAdminPaged(pageSize, offset);
        req.setAttribute("users", users);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("Users.jsp").forward(req, resp);
    }
    
    private void deactivateUser(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(req.getParameter("userId"));
        UserPojo userPojo = new UserPojo();
        userPojo.deactivateUser(userId);
        
        req.setAttribute("message", "User Deactivated Successfully");
        users(req, resp);
    }
    
    private void activateUser(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(req.getParameter("userId"));
        UserPojo userPojo = new UserPojo();
        userPojo.activateUser(userId);
        
        req.setAttribute("message", "User Activated Successfully");
        users(req, resp);
    }
    
    private void getLoginHistory(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        UserPojo userPojo = new UserPojo();
        List<Map<String, Object>> history = userPojo.getUserLoginHistory(userId);
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder();
        json.append("[");
        for(int i = 0; i < history.size(); i++) {
            Map<String, Object> entry = history.get(i);
            json.append("{");
            json.append("\"loginTime\":\"").append(entry.get("loginTime")).append("\",");
            json.append("\"logoutTime\":");
            if(entry.get("logoutTime") == null) {
                json.append("null");
            } else {
                json.append("\"").append(entry.get("logoutTime")).append("\"");
            }
            json.append("}");
            if(i < history.size() - 1) json.append(",");
        }
        json.append("]");
        
        resp.getWriter().write(json.toString());
    }
  
    private void reports(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String generate = req.getParameter("generate");
        
        if("true".equals(generate)) {
            long startTime = System.currentTimeMillis();
            concurrencyService.generateAllReportsParallel();
            long endTime = System.currentTimeMillis();
            
            req.setAttribute("reportMessage", "Report Generated Successfully");
            req.setAttribute("reportTime", (endTime - startTime));
        }
        
        ReportPojo reportPojo = new ReportPojo();
        reportPojo.getReportSummary();
        
        List<Map<String, Object>> monthlyBookings = reportPojo.getMonthlyBookings();
        List<Map<String, Object>> statusDistribution = reportPojo.getBookingStatusDistribution();
        
        req.setAttribute("summary", reportPojo);
        req.setAttribute("monthlyBookings", monthlyBookings);
        req.setAttribute("statusDistribution", statusDistribution);
      
        req.getRequestDispatcher("Reports.jsp").forward(req, resp);
    }
 
    
    private void adminProfile(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");
        
        if(adminId == null) {
            resp.sendRedirect("AdminLogin.jsp");
            return;
        }
        
        AdminPojo pojo = new AdminPojo();
        pojo.setAdminId(adminId);
        pojo.getAdminProfile();
        
        req.setAttribute("adminProfile", pojo);
        req.getRequestDispatcher("AdminProfile.jsp").forward(req, resp);
    }
    
    private void updateAdminName(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        HttpSession session = req.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");
        
        if(adminId == null) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Session expired\"}");
            return;
        }
        
        String name = req.getParameter("name");
        
        if(name == null || name.trim().isEmpty()) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Name cannot be empty\"}");
            return;
        }
        
        try {
            AdminPojo pojo = new AdminPojo();
            pojo.setAdminId(adminId);
            pojo.updateAdminName(name);
            session.setAttribute("adminName", name);
            
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":true}");
        } catch(Exception e) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
    
    private void updateAdminEmail(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        HttpSession session = req.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");
        
        if(adminId == null) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Session expired\"}");
            return;
        }
        
        String email = req.getParameter("email");
        
        if(email == null || email.trim().isEmpty()) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Email cannot be empty\"}");
            return;
        }
        
        if(!email.contains("@")) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Invalid email format\"}");
            return;
        }
        
        try {
            AdminPojo pojo = new AdminPojo();
            pojo.setAdminId(adminId);
            pojo.updateAdminEmail(email);
            
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":true}");
        } catch(Exception e) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
    
    private void changeAdminPassword(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        HttpSession session = req.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");
        
        if(adminId == null) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Session expired\"}");
            return;
        }
        
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        
        try {
            AdminPojo pojo = new AdminPojo();
            pojo.setAdminId(adminId);
            pojo.changeAdminPassword(currentPassword, newPassword);
            
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":true}");
        } catch(Exception e) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}