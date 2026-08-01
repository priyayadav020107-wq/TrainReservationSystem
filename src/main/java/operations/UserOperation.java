package operations;
import model.UserPojo;
import java.util.List;
import java.util.Map;
public interface UserOperation {
    
    // ==================== AUTHENTICATION ====================
    void registerUser(UserPojo pojo);
    boolean loginUser(UserPojo pojo);
    void logoutUser(UserPojo pojo);
    
    // ==================== BOOKING ====================
    void bookTicket(UserPojo pojo);
    void cancelTicket(UserPojo pojo);
    List<UserPojo> getBookingHistory(UserPojo pojo);
    UserPojo searchByPNR(UserPojo pojo);  // ✅ KEEP - Used in AdminServlet
    List<UserPojo> getPassengersByBooking(UserPojo pojo);
    List<UserPojo> downloadTicket(UserPojo pojo);
    
    // ==================== ADMIN OPERATIONS ====================
    List<UserPojo> getAllBookingsForAdmin();
    List<UserPojo> getAllUsersForAdmin();
    List<Map<String, Object>> getRecentActivities();
    List<Map<String, Object>> getUserLoginHistory(int userId);
    void deactivateUser(int userId);
    void activateUser(int userId);
    
    // ==================== USER DASHBOARD & PROFILE ====================
    Map<String, Object> getUserDashboardStats(int userId);
    List<Map<String, Object>> getUserRecentBookings(int userId);
    Map<String, Object> getTicketDetails(String pnr);
    
    void changeUserPassword(int userId, String oldPassword, String newPassword);
    List<Map<String, Object>> getStations();
    
    void getUserDetails(UserPojo pojo);
    void updateUserName(UserPojo pojo);
    void updateUserEmail(UserPojo pojo);
    void updateUserPhone(UserPojo pojo);
    
    // ==================== TICKET DETAILS ====================
    Map<String, Object> getCompleteBookingDetails(String pnr);

    // ==================== WAITLIST (NEW) ====================
    // ✅ NEW: creates a WAITING booking (no seat assigned)
    void addToWaitlist(UserPojo pojo);
    // ✅ NEW: returns the oldest WAITING booking for a train+date, or null if none
    Map<String, Object> getNextWaitlistBooking(int trainId, String journeyDate);
    // ✅ NEW: promotes a WAITING booking to CONFIRMED with the given freed seat
    void promoteWaitlistBooking(int bookingId, int seatId);

    // ==================== PAGINATION (NEW) ====================
    List<UserPojo> getBookingHistoryPaged(int userId, int limit, int offset);
    int getBookingHistoryCount(int userId);
    List<UserPojo> getAllBookingsForAdminPaged(int limit, int offset);
    int getAllBookingsCount();
    List<UserPojo> getAllUsersForAdminPaged(int limit, int offset);
    int getAllUsersCount();
}