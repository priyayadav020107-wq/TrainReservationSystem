package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.locks.ReentrantLock;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.UserPojo;
import model.TrainPojo;
import service.ConcurrencyService;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    
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
            resp.sendRedirect("Login.jsp");
            return;
        }
        
        switch(action) {
            case "register": register(req, resp); break;
            case "login": login(req, resp); break;
            case "logout": logout(req, resp); break;
            case "searchTrain": searchTrain(req, resp); break;
            case "confirmBooking": confirmBooking(req, resp); break;
            case "cancelBookingJSON": cancelBookingJSON(req, resp); break;
            case "changePassword": changePassword(req, resp); break;
            case "updateName": updateName(req, resp); break;
            case "updateEmail": updateEmail(req, resp); break;
            case "updatePhone": updatePhone(req, resp); break;
            case "joinWaitlist": joinWaitlist(req, resp); break; // ✅ NEW
            default: resp.sendRedirect("UserDashboard.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        
        if(action == null) {
            resp.sendRedirect("UserDashboard.jsp");
        } else if("getTicketDetails".equals(action)) {
            getTicketDetails(req, resp);
        } else if("downloadTicketPDF".equals(action)) {
            downloadTicketPDF(req, resp);
        } else if("getAvailableSeats".equals(action)) {
            getAvailableSeats(req, resp);
        } else {
            doPost(req, resp);
        }
    }
    
    // ==================== AUTHENTICATION ====================
    
    private void register(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        
        if(name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Name is required");
            req.getRequestDispatcher("Register.jsp").forward(req, resp);
            return;
        }
        if(email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Email is required");
            req.getRequestDispatcher("Register.jsp").forward(req, resp);
            return;
        }
        if(phone == null || phone.trim().isEmpty()) {
            req.setAttribute("error", "Phone number is required");
            req.getRequestDispatcher("Register.jsp").forward(req, resp);
            return;
        }
        if(password == null || password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters");
            req.getRequestDispatcher("Register.jsp").forward(req, resp);
            return;
        }
        
        try {
            UserPojo pojo = new UserPojo();
            pojo.setName(name);
            pojo.setEmail(email);
            pojo.setPhone(phone);
            pojo.setPassword(password);
            pojo.register();
            req.setAttribute("message", "Registration Successful! Please Login.");
            req.getRequestDispatcher("Login.jsp").forward(req, resp);
        } catch (SQLException e) {
            String errorMsg = e.getMessage();
            if(errorMsg.contains("Email already exists")) {
                req.setAttribute("error", "Email already registered! Please use a different email.");
            } else if(errorMsg.contains("Phone number already exists")) {
                req.setAttribute("error", "Phone number already registered! Please use a different phone number.");
            } else if(errorMsg.contains("Password must be minimum")) {
                req.setAttribute("error", "Password must be at least 6 characters.");
            } else {
                req.setAttribute("error", "Registration failed: " + errorMsg);
            }
            req.getRequestDispatcher("Register.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Registration failed: " + e.getMessage());
            req.getRequestDispatcher("Register.jsp").forward(req, resp);
        }
    }
    
    private void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserPojo pojo = new UserPojo();
        pojo.setEmail(req.getParameter("email"));
        pojo.setPassword(req.getParameter("password"));
        
        if (pojo.login()) {
            HttpSession session = req.getSession();
            session.setAttribute("userId", pojo.getUserId());
            session.setAttribute("userName", pojo.getName());
            resp.sendRedirect("UserDashboard.jsp");
        } else {
            req.setAttribute("error", "Invalid credentials");
            req.getRequestDispatcher("Login.jsp").forward(req, resp);
        }
    }
    
    private void logout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId != null) {
            UserPojo pojo = new UserPojo();
            pojo.setUserId(userId);
            pojo.logout();
        }
        session.invalidate();
        resp.sendRedirect("Login.jsp");
    }
    
    // ==================== TRAIN SEARCH ====================
    
    private void searchTrain(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String sourceStation = request.getParameter("sourceStation");
        String destinationStation = request.getParameter("destinationStation");
        
        if(sourceStation == null || sourceStation.trim().isEmpty() ||
           destinationStation == null || destinationStation.trim().isEmpty()) {
            request.setAttribute("searchMessage", "⚠️ Please select both source and destination stations!");
            request.getRequestDispatcher("SearchTrain.jsp").forward(request, response);
            return;
        }
        
        if(sourceStation.equals(destinationStation)) {
            request.setAttribute("searchMessage", "⚠️ Source and destination stations cannot be the same!");
            request.getRequestDispatcher("SearchTrain.jsp").forward(request, response);
            return;
        }
        
        try {
            int sourceId = Integer.parseInt(sourceStation);
            int destId = Integer.parseInt(destinationStation);
            
            TrainPojo pojo = new TrainPojo();
            pojo.setSourceStationId(sourceId);
            pojo.setDestinationStationId(destId);
            
            ConcurrencyService concurrencyService = new ConcurrencyService();
            List<TrainPojo> searchResults = concurrencyService.searchTrainsWithLock(pojo);
            
            if(searchResults == null || searchResults.isEmpty()) {
                request.setAttribute("searchMessage", "❌ No trains found for selected route!");
            } else {
                request.setAttribute("trains", searchResults);
                request.setAttribute("searchMessage", "✅ Found " + searchResults.size() + " train(s)");
            }
            
            request.getRequestDispatcher("SearchTrain.jsp").forward(request, response);
            
        } catch(NumberFormatException e) {
            request.setAttribute("searchMessage", "⚠️ Invalid station selection!");
            request.getRequestDispatcher("SearchTrain.jsp").forward(request, response);
        }
    }
    
    private void getAvailableSeats(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int trainId = Integer.parseInt(req.getParameter("trainId"));
        String journeyDate = req.getParameter("journeyDate");
        
        TrainPojo trainPojo = new TrainPojo();
        List<Map<String, Object>> seats = trainPojo.getAvailableSeatsForTrain(trainId, journeyDate);
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder();
        json.append("[");
        for(int i = 0; i < seats.size(); i++) {
            Map<String, Object> seat = seats.get(i);
            json.append("{");
            json.append("\"seatId\":").append(seat.get("seatId")).append(",");
            json.append("\"seatNumber\":\"").append(seat.get("seatNumber")).append("\",");
            json.append("\"coachNo\":\"").append(seat.get("coachNo")).append("\",");
            json.append("\"seatType\":\"").append(seat.get("seatType")).append("\"");
            json.append("}");
            if(i < seats.size() - 1) json.append(",");
        }
        json.append("]");
        
        resp.getWriter().write(json.toString());
    }
    
    // ==================== BOOKING ====================
    
    private void confirmBooking(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if(userId == null) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Please login again\"}");
            return;
        }
        
        int trainId = Integer.parseInt(req.getParameter("trainId"));
        String journeyDate = req.getParameter("journeyDate");
        String passengerName = req.getParameter("passengerName");
        int age = Integer.parseInt(req.getParameter("age"));
        String gender = req.getParameter("gender");
        int seatId = Integer.parseInt(req.getParameter("seatId"));
        double fare = Double.parseDouble(req.getParameter("fare"));
        int passengerCount = Integer.parseInt(req.getParameter("passengerCount"));
        String paymentMethod = req.getParameter("paymentMethod");
        
        UserPojo bookingPojo = new UserPojo();
        bookingPojo.setUserId(userId);
        bookingPojo.setTrainId(trainId);
        bookingPojo.setJourneyDate(journeyDate);
        bookingPojo.setPassengerName(passengerName);
        bookingPojo.setAge(age);
        bookingPojo.setGender(gender);
        bookingPojo.setSeatId(seatId);
        bookingPojo.setTotalPassengers(passengerCount);
        bookingPojo.setTotalFare(fare);
        bookingPojo.setPaymentMethod(paymentMethod);
        
        // ✅ CHANGED (per-seat lock granularity): key is now seatId+journeyDate
        // instead of trainId+journeyDate, so bookings for different seats on
        // the same train+date no longer block one another unnecessarily.
        String seatKey = seatId + "_" + journeyDate;
        ReentrantLock seatLock = ConcurrencyService.getSeatLock(seatKey);
        seatLock.lock();
        try {
            bookingPojo.bookTicket();
        } finally {
            seatLock.unlock();
        }
        
        int bookingId = bookingPojo.getBookingId();
        String pnr = bookingPojo.getPnr();
        
        resp.setContentType("application/json");
        
        if(bookingId > 0 && pnr != null && !pnr.isEmpty()) {
            resp.getWriter().write("{\"success\":true,\"pnr\":\"" + pnr + "\",\"bookingId\":" + bookingId + "}");
        } else {
            resp.getWriter().write("{\"success\":false,\"message\":\"Booking failed\"}");
        }
    }

    // ==================== WAITLIST (NEW) ====================

    // ✅ NEW METHOD - used when a train is full for the selected date.
    private void joinWaitlist(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if(userId == null) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Please login again\"}");
            return;
        }

        int trainId = Integer.parseInt(req.getParameter("trainId"));
        String journeyDate = req.getParameter("journeyDate");
        String passengerName = req.getParameter("passengerName");
        int age = Integer.parseInt(req.getParameter("age"));
        String gender = req.getParameter("gender");

        UserPojo waitlistPojo = new UserPojo();
        waitlistPojo.setUserId(userId);
        waitlistPojo.setTrainId(trainId);
        waitlistPojo.setJourneyDate(journeyDate);
        waitlistPojo.setPassengerName(passengerName);
        waitlistPojo.setAge(age);
        waitlistPojo.setGender(gender);

        waitlistPojo.addToWaitlist();

        int bookingId = waitlistPojo.getBookingId();
        String pnr = waitlistPojo.getPnr();

        resp.setContentType("application/json");

        if(bookingId > 0 && pnr != null && !pnr.isEmpty()) {
            resp.getWriter().write("{\"success\":true,\"pnr\":\"" + pnr + "\",\"bookingId\":" + bookingId + ",\"waiting\":true}");
        } else {
            resp.getWriter().write("{\"success\":false,\"message\":\"Failed to join waitlist\"}");
        }
    }
    
    private void cancelBookingJSON(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        
        UserPojo pojo = new UserPojo();
        pojo.setBookingId(bookingId);
        pojo.cancelTicket();

        // ✅ NEW: if a CONFIRMED seat was actually freed by this cancellation,
        // check the waitlist for this train+date and, if someone is waiting,
        // queue an automatic promotion job through ConcurrencyService's
        // real virtual-thread queue.
        if (pojo.getSeatId() > 0) {
            concurrencyService.processWaitlistPromotion(pojo.getTrainId(), pojo.getJourneyDate(), pojo.getSeatId());
        }
        
        resp.setContentType("application/json");
        resp.getWriter().write("{\"success\":true}");
    }
    
    // ==================== TICKET DETAILS ====================
    
    private void getTicketDetails(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pnr = req.getParameter("pnr");
        
        UserPojo userPojo = new UserPojo();
        Map<String, Object> details = userPojo.getCompleteBookingDetails(pnr);
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        if(details != null && !details.isEmpty()) {
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"pnr\":\"").append(details.get("pnr")).append("\",");
            json.append("\"trainName\":\"").append(details.get("trainName")).append("\",");
            json.append("\"journeyDate\":\"").append(details.get("journeyDate")).append("\",");
            json.append("\"status\":\"").append(details.get("status")).append("\",");
            json.append("\"passengerName\":\"").append(details.get("passengerName")).append("\",");
            json.append("\"age\":").append(details.get("age")).append(",");
            json.append("\"gender\":\"").append(details.get("gender")).append("\",");
            json.append("\"seatNumber\":\"").append(details.get("seatNumber")).append("\",");
            json.append("\"coachNo\":\"").append(details.get("coachNo")).append("\",");
            json.append("\"fare\":").append(details.get("fare"));
            json.append("}");
            
            resp.getWriter().write(json.toString());
        } else {
            resp.getWriter().write("{\"error\":\"Booking not found\"}");
        }
    }
    
    private void downloadTicketPDF(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pnr = req.getParameter("pnr");
        
        UserPojo userPojo = new UserPojo();
        List<UserPojo> ticketDetails = userPojo.downloadTicket();
        
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        
        out.println("<html><head><title>Ticket - " + pnr + "</title>");
        out.println("<style>body{font-family:Arial;padding:20px;} .ticket{border:1px solid #ccc;padding:20px;border-radius:10px;}</style>");
        out.println("</head><body>");
        out.println("<div class='ticket'>");
        out.println("<h2>Train Reservation Ticket</h2>");
        out.println("<p><strong>PNR:</strong> " + pnr + "</p>");
        
        if(ticketDetails != null && !ticketDetails.isEmpty()) {
            UserPojo first = ticketDetails.get(0);
            out.println("<p><strong>Train:</strong> " + first.getTrainName() + "</p>");
            out.println("<p><strong>Journey Date:</strong> " + first.getJourneyDate() + "</p>");
            out.println("<p><strong>Passenger:</strong> " + first.getPassengerName() + "</p>");
            out.println("<p><strong>Age:</strong> " + first.getAge() + "</p>");
            out.println("<p><strong>Gender:</strong> " + first.getGender() + "</p>");
            out.println("<p><strong>Seat:</strong> " + first.getSeatNumber() + "</p>");
            out.println("<p><strong>Coach:</strong> " + first.getCoachNo() + "</p>");
            out.println("<p><strong>Fare:</strong> Rs. " + first.getTotalFare() + "</p>");
        }
        
        out.println("<button onclick='window.print()'>Print Ticket</button>");
        out.println("<button onclick='window.close()'>Close</button>");
        out.println("</div></body></html>");
    }
    
    // ==================== PROFILE MANAGEMENT ====================
    
    private void changePassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        
        UserPojo userPojo = new UserPojo();
        
        resp.setContentType("application/json");
        
        try {
            userPojo.changeUserPassword(userId, oldPassword, newPassword);
            resp.getWriter().write("{\"success\":true}");
        } catch(Exception e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
    
    private void updateName(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if(userId == null) {
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
        
        UserPojo pojo = new UserPojo();
        pojo.setUserId(userId);
        pojo.setName(name);
        
        resp.setContentType("application/json");
        
        try {
            pojo.updateUserName();
            session.setAttribute("userName", name);
            resp.getWriter().write("{\"success\":true}");
        } catch(Exception e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
    
    private void updateEmail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if(userId == null) {
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
        
        UserPojo pojo = new UserPojo();
        pojo.setUserId(userId);
        pojo.setEmail(email);
        
        resp.setContentType("application/json");
        
        try {
            pojo.updateUserEmail();
            resp.getWriter().write("{\"success\":true}");
        } catch(Exception e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
    
    private void updatePhone(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if(userId == null) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Session expired\"}");
            return;
        }
        
        String phone = req.getParameter("phone");
        
        if(phone == null || phone.trim().isEmpty()) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Phone number cannot be empty\"}");
            return;
        }
        
        if(!phone.matches("\\d{10}")) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":false,\"message\":\"Enter valid 10-digit phone number\"}");
            return;
        }
        
        UserPojo pojo = new UserPojo();
        pojo.setUserId(userId);
        pojo.setPhone(phone);
        
        resp.setContentType("application/json");
        
        try {
            pojo.updateUserPhone();
            resp.getWriter().write("{\"success\":true}");
        } catch(Exception e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}