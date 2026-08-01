package model;

import implementor.UserOperationImpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class UserPojo {
    private int userId;
    private String name;
    private String email;
    private String phone;
    private String password;
    private String isActive;
    private String createdAt;
    
    private int bookingId;
    private String pnr;
    private int trainId;
    private String journeyDate;
    private String bookingDate;
    private int totalPassengers;
    private double totalFare;
    private String bookingStatus;
    private String paymentMethod;
    
    private int passengerId;
    private String passengerName;
    private int age;
    private String gender;
    private String passengerStatus;
    private int seatId;
    private String seatNumber;
    private String coachNo;
    
    private String trainName;
    private String trainNo;
    
    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getIsActive() { return isActive; }
    public void setIsActive(String isActive) { this.isActive = isActive; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    
    public String getPnr() { return pnr; }
    public void setPnr(String pnr) { this.pnr = pnr; }
    
    public int getTrainId() { return trainId; }
    public void setTrainId(int trainId) { this.trainId = trainId; }
    
    public String getJourneyDate() { return journeyDate; }
    public void setJourneyDate(String journeyDate) { this.journeyDate = journeyDate; }
    
    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
    
    public int getTotalPassengers() { return totalPassengers; }
    public void setTotalPassengers(int totalPassengers) { this.totalPassengers = totalPassengers; }
    
    public double getTotalFare() { return totalFare; }
    public void setTotalFare(double totalFare) { this.totalFare = totalFare; }
    
    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public int getPassengerId() { return passengerId; }
    public void setPassengerId(int passengerId) { this.passengerId = passengerId; }
    
    public String getPassengerName() { return passengerName; }
    public void setPassengerName(String passengerName) { this.passengerName = passengerName; }
    
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public String getPassengerStatus() { return passengerStatus; }
    public void setPassengerStatus(String passengerStatus) { this.passengerStatus = passengerStatus; }
    
    public int getSeatId() { return seatId; }
    public void setSeatId(int seatId) { this.seatId = seatId; }
    
    public String getSeatNumber() { return seatNumber; }
    public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }
    
    public String getCoachNo() { return coachNo; }
    public void setCoachNo(String coachNo) { this.coachNo = coachNo; }
    
    public String getTrainName() { return trainName; }
    public void setTrainName(String trainName) { this.trainName = trainName; }
    
    public String getTrainNo() { return trainNo; }
    public void setTrainNo(String trainNo) { this.trainNo = trainNo; }
    
    // Business Methods
    public void register() throws SQLException {
        new UserOperationImpl().registerUser(this);
    }
    public boolean login() { return new UserOperationImpl().loginUser(this); }
    public void logout() { new UserOperationImpl().logoutUser(this); }
    public void bookTicket() { new UserOperationImpl().bookTicket(this); }
    public void cancelTicket() { new UserOperationImpl().cancelTicket(this); }
    public List<UserPojo> getBookingHistory() { return new UserOperationImpl().getBookingHistory(this); }
    public List<UserPojo> getPassengers() { return new UserOperationImpl().getPassengersByBooking(this); }
    public List<UserPojo> downloadTicket() { return new UserOperationImpl().downloadTicket(this); }
    public List<UserPojo> getAllBookingsForAdmin() {
        return new UserOperationImpl().getAllBookingsForAdmin();
    }
    
    public List<Map<String, Object>> getRecentActivities() {
        return new UserOperationImpl().getRecentActivities();
    }
    
    public List<Map<String, Object>> getUserLoginHistory(int userId) {
        return new UserOperationImpl().getUserLoginHistory(userId);
    }
    
    public void deactivateUser(int userId) {
        new UserOperationImpl().deactivateUser(userId);
    }
    
    public List<UserPojo> getAllUsersForAdmin() {
        return new UserOperationImpl().getAllUsersForAdmin();
    }
    
    public void activateUser(int userId) {
        new UserOperationImpl().activateUser(userId);
    }
    
    // ==================== USER DASHBOARD & PROFILE ====================
    public Map<String, Object> getUserDashboardStats() {
        return new UserOperationImpl().getUserDashboardStats(this.userId);
    }
    
    public List<Map<String, Object>> getUserRecentBookings() {
        return new UserOperationImpl().getUserRecentBookings(this.userId);
    }
    
    public Map<String, Object> getTicketDetails(String pnr) {
        return new UserOperationImpl().getTicketDetails(pnr);
    }
    
    public void changeUserPassword(int userId, String oldPassword, String newPassword) {
        new UserOperationImpl().changeUserPassword(userId, oldPassword, newPassword);
    }
    
    public List<Map<String, Object>> getStations() {
        return new UserOperationImpl().getStations();
    }
    
    public void getUserDetails() {
        new UserOperationImpl().getUserDetails(this);
    }
    
    public void updateUserName() {
        new UserOperationImpl().updateUserName(this);
    }
    
    public void updateUserEmail() {
        new UserOperationImpl().updateUserEmail(this);
    }
    
    public void updateUserPhone() {
        new UserOperationImpl().updateUserPhone(this);
    }
    
    public Map<String, Object> getCompleteBookingDetails(String pnr) {
        return new UserOperationImpl().getCompleteBookingDetails(pnr);
    }
    
    public UserPojo searchByPNR() { 
        return new UserOperationImpl().searchByPNR(this); 
    }

    // ==================== WAITLIST (NEW) ====================

    // ✅ NEW METHOD - Controller calls this the same way it calls bookTicket()
    public void addToWaitlist() {
        new UserOperationImpl().addToWaitlist(this);
    }

    // ==================== PAGINATION (NEW) ====================

    // ✅ NEW METHOD
    public List<UserPojo> getBookingHistoryPaged(int limit, int offset) {
        return new UserOperationImpl().getBookingHistoryPaged(this.userId, limit, offset);
    }

    // ✅ NEW METHOD
    public int getBookingHistoryCount() {
        return new UserOperationImpl().getBookingHistoryCount(this.userId);
    }

    // ✅ NEW METHOD
    public List<UserPojo> getAllBookingsForAdminPaged(int limit, int offset) {
        return new UserOperationImpl().getAllBookingsForAdminPaged(limit, offset);
    }

    // ✅ NEW METHOD
    public int getAllBookingsCount() {
        return new UserOperationImpl().getAllBookingsCount();
    }

    // ✅ NEW METHOD
    public List<UserPojo> getAllUsersForAdminPaged(int limit, int offset) {
        return new UserOperationImpl().getAllUsersForAdminPaged(limit, offset);
    }

    // ✅ NEW METHOD
    public int getAllUsersCount() {
        return new UserOperationImpl().getAllUsersCount();
    }
}