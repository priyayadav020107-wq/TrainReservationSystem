package implementor;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import db_config.GetConnection;
import model.UserPojo;
import operations.UserOperation;
import util.AppLogger; // ✅ NEW IMPORT

public class UserOperationImpl implements UserOperation {

    // ✅ NEW: logger for this class - replaces every e.printStackTrace() below
    private static final Logger logger = AppLogger.getLogger(UserOperationImpl.class);
    
    @Override
    public void registerUser(UserPojo pojo) {
        String sql = "{CALL register_user(?, ?, ?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setString(1, pojo.getName());
            cstmt.setString(2, pojo.getEmail());
            cstmt.setString(3, pojo.getPhone());
            cstmt.setString(4, pojo.getPassword());
            cstmt.execute();
            logger.info("User registered: " + pojo.getEmail());
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Registration failed for email=" + pojo.getEmail(), e);
            throw new RuntimeException(e.getMessage());
        }
    }
    
    @Override
    public boolean loginUser(UserPojo pojo) {
        String sql = "{? = CALL login_user_func(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, Types.BOOLEAN);
            cstmt.setString(2, pojo.getEmail());
            cstmt.setString(3, pojo.getPassword());
            cstmt.execute();
            boolean success = cstmt.getBoolean(1);
            if (success) {
                String getUserSql = "SELECT user_id, name FROM users WHERE email = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(getUserSql)) {
                    pstmt.setString(1, pojo.getEmail());
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        pojo.setUserId(rs.getInt("user_id"));
                        pojo.setName(rs.getString("name"));
                    }
                }
            }
            return success;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Login failed for email=" + pojo.getEmail(), e);
            return false;
        }
    }
    
    @Override
    public void logoutUser(UserPojo pojo) {
        String sql = "{? = CALL logout_user_func(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.registerOutParameter(1, Types.BOOLEAN);
            cstmt.setInt(2, pojo.getUserId());
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Logout failed for userId=" + pojo.getUserId(), e);
        }
    }
    
    @Override
    public void bookTicket(UserPojo pojo) {
        String sql = "{CALL book_ticket(?, ?, ?, ?, ?, ?, ?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getUserId());
            cstmt.setInt(2, pojo.getTrainId());
            cstmt.setString(3, pojo.getJourneyDate());
            cstmt.setString(4, pojo.getPassengerName());
            cstmt.setInt(5, pojo.getAge());
            cstmt.setString(6, pojo.getGender());
            cstmt.setInt(7, pojo.getSeatId());
            cstmt.setString(8, pojo.getPaymentMethod());
            
            boolean hasResults = cstmt.execute();
            
            if (hasResults) {
                ResultSet rs = cstmt.getResultSet();
                if (rs != null && rs.next()) {
                    pojo.setBookingId(rs.getInt("booking_id"));
                    pojo.setPnr(rs.getString("pnr"));
                }
                if (rs != null) rs.close();
            }
            
            // Update total_passengers and total_fare using stored procedure
            String updateSql = "{CALL update_booking_details(?, ?, ?)}";
            try (CallableStatement cstmt2 = conn.prepareCall(updateSql)) {
                cstmt2.setInt(1, pojo.getBookingId());
                cstmt2.setInt(2, pojo.getTotalPassengers());
                cstmt2.setDouble(3, pojo.getTotalFare());
                cstmt2.execute();
            } catch (SQLException e) {
                logger.log(Level.WARNING, "update_booking_details failed for bookingId=" + pojo.getBookingId(), e);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "bookTicket failed for userId=" + pojo.getUserId()
                    + ", trainId=" + pojo.getTrainId() + ", seatId=" + pojo.getSeatId(), e);
        }
    }
    
    @Override
    public void cancelTicket(UserPojo pojo) {
        String sql = "{CALL cancel_ticket(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getBookingId());

            // ✅ CHANGED: cancel_ticket now also returns which train/date/seat
            // was freed (all NULL if this booking wasn't CONFIRMED). We read
            // that back and stash it on the same UserPojo fields (trainId,
            // journeyDate, seatId already exist) so the Controller can decide
            // whether to trigger a waitlist promotion.
            boolean hasResults = cstmt.execute();
            if (hasResults) {
                ResultSet rs = cstmt.getResultSet();
                if (rs != null && rs.next()) {
                    int freedTrainId = rs.getInt("freed_train_id");
                    if (!rs.wasNull()) {
                        pojo.setTrainId(freedTrainId);
                    }
                    String freedJourneyDate = rs.getString("freed_journey_date");
                    if (freedJourneyDate != null) {
                        pojo.setJourneyDate(freedJourneyDate);
                    }
                    int freedSeatId = rs.getInt("freed_seat_id");
                    if (!rs.wasNull()) {
                        pojo.setSeatId(freedSeatId);
                    }
                }
                if (rs != null) rs.close();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "cancelTicket failed for bookingId=" + pojo.getBookingId(), e);
        }
    }
    
    @Override
    public List<UserPojo> getBookingHistory(UserPojo pojo) {
        List<UserPojo> bookings = new ArrayList<>();
        String sql = "{CALL get_booking_history(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getUserId());
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                UserPojo booking = new UserPojo();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setPnr(rs.getString("pnr"));
                booking.setTrainId(rs.getInt("train_id"));
                booking.setJourneyDate(rs.getString("journey_date"));
                booking.setTotalPassengers(rs.getInt("total_passengers"));
                booking.setTotalFare(rs.getDouble("total_fare"));
                booking.setBookingStatus(rs.getString("booking_status"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getBookingHistory failed for userId=" + pojo.getUserId(), e);
        }
        return bookings;
    }
    
    @Override
    public List<UserPojo> getPassengersByBooking(UserPojo pojo) {
        List<UserPojo> passengers = new ArrayList<>();
        String sql = "{CALL get_passengers_by_booking(?)}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getBookingId());
            ResultSet rs = cstmt.executeQuery();
            
            if (rs.next()) {
                UserPojo p = new UserPojo();
                p.setPassengerId(rs.getInt("passenger_id"));
                p.setPassengerName(rs.getString("passenger_name"));
                p.setAge(rs.getInt("age"));
                p.setGender(rs.getString("gender"));
                p.setSeatNumber(rs.getString("seat_number"));
                p.setCoachNo(rs.getString("coach_no"));
                passengers.add(p);
            }
            rs.close();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getPassengersByBooking failed for bookingId=" + pojo.getBookingId(), e);
        }
        return passengers;
    }
    
    @Override
    public List<UserPojo> downloadTicket(UserPojo pojo) {
        List<UserPojo> passengers = new ArrayList<>();
        String sql = "{CALL download_ticket(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setString(1, pojo.getPnr());
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                UserPojo p = new UserPojo();
                p.setPnr(rs.getString("pnr"));
                p.setTrainNo(rs.getString("train_no"));
                p.setTrainName(rs.getString("train_name"));
                p.setJourneyDate(rs.getString("journey_date"));
                p.setPassengerName(rs.getString("passenger_name"));
                p.setAge(rs.getInt("age"));
                p.setGender(rs.getString("gender"));
                p.setSeatNumber(rs.getString("seat_number"));
                p.setCoachNo(rs.getString("coach_no"));
                p.setTotalFare(rs.getDouble("total_fare"));
                passengers.add(p);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "downloadTicket failed for pnr=" + pojo.getPnr(), e);
        }
        return passengers;
    }
    
    @Override
    public List<UserPojo> getAllBookingsForAdmin() {
        List<UserPojo> bookings = new ArrayList<>();
        String sql = "{CALL get_all_bookings()}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            
            while (rs.next()) {
                UserPojo booking = new UserPojo();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setPnr(rs.getString("pnr"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setTrainId(rs.getInt("train_id"));
                booking.setJourneyDate(rs.getString("journey_date"));
                booking.setBookingDate(rs.getString("booking_date"));
                booking.setTotalPassengers(rs.getInt("total_passengers"));
                booking.setTotalFare(rs.getDouble("total_fare"));
                booking.setBookingStatus(rs.getString("booking_status"));
                
                try {
                    booking.setName(rs.getString("user_name"));
                } catch(Exception e) {}
                try {
                    booking.setTrainName(rs.getString("train_name"));
                } catch(Exception e) {}
                
                bookings.add(booking);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAllBookingsForAdmin failed", e);
        }
        return bookings;
    }
    
    @Override
    public List<UserPojo> getAllUsersForAdmin() {
        List<UserPojo> users = new ArrayList<>();
        String sql = "{CALL get_all_users()}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            
            while (rs.next()) {
                UserPojo user = new UserPojo();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setIsActive(rs.getString("is_active"));
                user.setCreatedAt(rs.getString("created_at"));
                users.add(user);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAllUsersForAdmin failed", e);
        }
        return users;
    }
    
    @Override
    public List<Map<String, Object>> getRecentActivities() {
        List<Map<String, Object>> activities = new ArrayList<>();
        String sql = "{CALL get_recent_activities()}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> activity = new HashMap<>();
                activity.put("description", rs.getString("description"));
                activity.put("time", rs.getString("activity_time"));
                activities.add(activity);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getRecentActivities failed", e);
        }
        return activities;
    }
    
    @Override
    public List<Map<String, Object>> getUserLoginHistory(int userId) {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "{CALL get_user_login_history(?)}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, userId);
            ResultSet rs = cstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("loginTime", rs.getString("login_time"));
                entry.put("logoutTime", rs.getString("logout_time"));
                history.add(entry);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getUserLoginHistory failed for userId=" + userId, e);
        }
        return history;
    }
    
    @Override
    public void deactivateUser(int userId) {
        String sql = "{CALL deactivate_user(?)}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, userId);
            cstmt.execute();
            logger.info("User deactivated: " + userId);
        } catch (SQLException e) {
            logger.log(Level.WARNING, "deactivateUser failed for userId=" + userId, e);
        }
    }
    
    @Override
    public void activateUser(int userId) {
        String sql = "{CALL activate_user(?)}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, userId);
            cstmt.execute();
            logger.info("User activated: " + userId);
        } catch (SQLException e) {
            logger.log(Level.WARNING, "activateUser failed for userId=" + userId, e);
        }
    }
    
    @Override
    public Map<String, Object> getUserDashboardStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = "{CALL get_user_dashboard(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, userId);
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                stats.put("totalBookings", rs.getInt("total_bookings"));
                stats.put("activeTickets", rs.getInt("active_tickets"));
                stats.put("cancelledTickets", rs.getInt("cancelled_tickets"));
                stats.put("upcomingJourney", rs.getString("upcoming_journey") != null ? rs.getString("upcoming_journey") : "No upcoming journey");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getUserDashboardStats failed for userId=" + userId, e);
        }
        return stats;
    }
    
    @Override
    public List<Map<String, Object>> getUserRecentBookings(int userId) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = "{CALL get_recent_bookings(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, userId);
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("pnr", rs.getString("pnr"));
                booking.put("trainName", rs.getString("train_name"));
                booking.put("journeyDate", rs.getString("journey_date"));
                booking.put("bookingStatus", rs.getString("booking_status"));
                booking.put("bookingId", rs.getInt("booking_id"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getUserRecentBookings failed for userId=" + userId, e);
        }
        return bookings;
    }
    
    @Override
    public void changeUserPassword(int userId, String oldPassword, String newPassword) {
        String sql = "{CALL change_password(?, ?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, userId);
            cstmt.setString(2, oldPassword);
            cstmt.setString(3, newPassword);
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.WARNING, "changeUserPassword failed for userId=" + userId, e);
        }
    }
    
    @Override
    public List<Map<String, Object>> getStations() {
        List<Map<String, Object>> stations = new ArrayList<>();
        String sql = "SELECT station_id, station_name FROM stations";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> station = new HashMap<>();
                station.put("id", rs.getInt("station_id"));
                station.put("name", rs.getString("station_name"));
                stations.add(station);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getStations failed", e);
        }
        return stations;
    }
    
    @Override
    public void getUserDetails(UserPojo pojo) {
        String sql = "{CALL get_user_details(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getUserId());
            ResultSet rs = cstmt.executeQuery();
            if(rs.next()) {
                pojo.setUserId(rs.getInt("user_id"));
                pojo.setName(rs.getString("name"));
                pojo.setEmail(rs.getString("email"));
                pojo.setPhone(rs.getString("phone"));
                pojo.setIsActive(rs.getString("is_active"));
                pojo.setCreatedAt(rs.getString("created_at"));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getUserDetails failed for userId=" + pojo.getUserId(), e);
        }
    }
    
    @Override
    public void updateUserName(UserPojo pojo) {
        String sql = "{CALL update_user_name(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getUserId());
            cstmt.setString(2, pojo.getName());
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.WARNING, "updateUserName failed for userId=" + pojo.getUserId(), e);
            throw new RuntimeException(e.getMessage());
        }
    }
    
    @Override
    public void updateUserEmail(UserPojo pojo) {
        String sql = "{CALL update_user_email(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getUserId());
            cstmt.setString(2, pojo.getEmail());
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.WARNING, "updateUserEmail failed for userId=" + pojo.getUserId(), e);
            throw new RuntimeException(e.getMessage());
        }
    }
    
    @Override
    public void updateUserPhone(UserPojo pojo) {
        String sql = "{CALL update_user_phone(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getUserId());
            cstmt.setString(2, pojo.getPhone());
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.WARNING, "updateUserPhone failed for userId=" + pojo.getUserId(), e);
            throw new RuntimeException(e.getMessage());
        }
    }
    
    @Override
    public Map<String, Object> getTicketDetails(String pnr) {
        return getCompleteBookingDetails(pnr);
    }
    
    @Override
    public Map<String, Object> getCompleteBookingDetails(String pnr) {
        Map<String, Object> result = new HashMap<>();
        String sql = "{CALL get_complete_booking_details(?)}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setString(1, pnr);
            ResultSet rs = cstmt.executeQuery();
            
            if (rs.next()) {
                result.put("pnr", rs.getString("pnr"));
                result.put("trainName", rs.getString("train_name"));
                result.put("journeyDate", rs.getString("journey_date"));
                result.put("status", rs.getString("booking_status"));
                result.put("passengerName", rs.getString("passenger_name"));
                result.put("age", rs.getInt("age"));
                result.put("gender", rs.getString("gender"));
                result.put("seatNumber", rs.getString("seat_number"));
                result.put("coachNo", rs.getString("coach_no"));
                result.put("fare", rs.getDouble("total_fare"));
            }
            rs.close();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getCompleteBookingDetails failed for pnr=" + pnr, e);
        }
        return result;
    }
    
    
    @Override
    public UserPojo searchByPNR(UserPojo pojo) {
        String sql = "{CALL search_booking_by_pnr(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setString(1, pojo.getPnr());
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                pojo.setBookingId(rs.getInt("booking_id"));
                pojo.setPnr(rs.getString("pnr"));
                pojo.setTrainId(rs.getInt("train_id"));
                pojo.setJourneyDate(rs.getString("journey_date"));
                pojo.setTotalFare(rs.getDouble("total_fare"));
                pojo.setBookingStatus(rs.getString("booking_status"));
                pojo.setTotalPassengers(rs.getInt("total_passengers"));
                
                pojo.setTrainNo(rs.getString("train_no"));
                pojo.setTrainName(rs.getString("train_name"));
                
                pojo.setUserId(rs.getInt("user_id"));
                pojo.setName(rs.getString("name"));
                
                return pojo;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "searchByPNR failed for pnr=" + pojo.getPnr(), e);
        }
        return null;
    }

    // ==================== WAITLIST (NEW) ====================

    // ✅ NEW METHOD
    @Override
    public void addToWaitlist(UserPojo pojo) {
        String sql = "{CALL add_to_waitlist(?, ?, ?, ?, ?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getUserId());
            cstmt.setInt(2, pojo.getTrainId());
            cstmt.setString(3, pojo.getJourneyDate());
            cstmt.setString(4, pojo.getPassengerName());
            cstmt.setInt(5, pojo.getAge());
            cstmt.setString(6, pojo.getGender());

            boolean hasResults = cstmt.execute();
            if (hasResults) {
                ResultSet rs = cstmt.getResultSet();
                if (rs != null && rs.next()) {
                    pojo.setBookingId(rs.getInt("booking_id"));
                    pojo.setPnr(rs.getString("pnr"));
                }
                if (rs != null) rs.close();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "addToWaitlist failed for userId=" + pojo.getUserId()
                    + ", trainId=" + pojo.getTrainId(), e);
        }
    }

    // ✅ NEW METHOD
    @Override
    public Map<String, Object> getNextWaitlistBooking(int trainId, String journeyDate) {
        String sql = "{CALL get_next_waitlist_booking(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, trainId);
            cstmt.setString(2, journeyDate);
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                Map<String, Object> result = new HashMap<>();
                result.put("bookingId", rs.getInt("booking_id"));
                result.put("pnr", rs.getString("pnr"));
                result.put("userId", rs.getInt("user_id"));
                result.put("totalFare", rs.getDouble("total_fare"));
                return result;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getNextWaitlistBooking failed for trainId=" + trainId
                    + ", journeyDate=" + journeyDate, e);
        }
        return null;
    }

    // ✅ NEW METHOD
    @Override
    public void promoteWaitlistBooking(int bookingId, int seatId) {
        String sql = "{CALL promote_waitlist_booking(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, bookingId);
            cstmt.setInt(2, seatId);
            cstmt.execute();
            logger.info("Waitlist booking promoted: bookingId=" + bookingId + ", seatId=" + seatId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "promoteWaitlistBooking failed for bookingId=" + bookingId
                    + ", seatId=" + seatId, e);
        }
    }

    // ==================== PAGINATION (NEW) ====================

    // ✅ NEW METHOD
    @Override
    public List<UserPojo> getBookingHistoryPaged(int userId, int limit, int offset) {
        List<UserPojo> bookings = new ArrayList<>();
        String sql = "{CALL get_booking_history_paged(?, ?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, userId);
            cstmt.setInt(2, limit);
            cstmt.setInt(3, offset);
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                UserPojo booking = new UserPojo();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setPnr(rs.getString("pnr"));
                booking.setTrainId(rs.getInt("train_id"));
                booking.setJourneyDate(rs.getString("journey_date"));
                booking.setTotalPassengers(rs.getInt("total_passengers"));
                booking.setTotalFare(rs.getDouble("total_fare"));
                booking.setBookingStatus(rs.getString("booking_status"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getBookingHistoryPaged failed for userId=" + userId, e);
        }
        return bookings;
    }

    // ✅ NEW METHOD
    @Override
    public int getBookingHistoryCount(int userId) {
        String sql = "{CALL get_booking_count_for_user(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, userId);
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getBookingHistoryCount failed for userId=" + userId, e);
        }
        return 0;
    }

    // ✅ NEW METHOD
    @Override
    public List<UserPojo> getAllBookingsForAdminPaged(int limit, int offset) {
        List<UserPojo> bookings = new ArrayList<>();
        String sql = "{CALL get_all_bookings_paged(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, limit);
            cstmt.setInt(2, offset);
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                UserPojo booking = new UserPojo();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setPnr(rs.getString("pnr"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setTrainId(rs.getInt("train_id"));
                booking.setJourneyDate(rs.getString("journey_date"));
                booking.setBookingDate(rs.getString("booking_date"));
                booking.setTotalPassengers(rs.getInt("total_passengers"));
                booking.setTotalFare(rs.getDouble("total_fare"));
                booking.setBookingStatus(rs.getString("booking_status"));
                try { booking.setName(rs.getString("user_name")); } catch(Exception e) {}
                try { booking.setTrainName(rs.getString("train_name")); } catch(Exception e) {}
                bookings.add(booking);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAllBookingsForAdminPaged failed", e);
        }
        return bookings;
    }

    // ✅ NEW METHOD
    @Override
    public int getAllBookingsCount() {
        String sql = "{CALL get_all_bookings_count()}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAllBookingsCount failed", e);
        }
        return 0;
    }

    // ✅ NEW METHOD
    @Override
    public List<UserPojo> getAllUsersForAdminPaged(int limit, int offset) {
        List<UserPojo> users = new ArrayList<>();
        String sql = "{CALL get_all_users_paged(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, limit);
            cstmt.setInt(2, offset);
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                UserPojo user = new UserPojo();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setIsActive(rs.getString("is_active"));
                user.setCreatedAt(rs.getString("created_at"));
                users.add(user);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAllUsersForAdminPaged failed", e);
        }
        return users;
    }

    // ✅ NEW METHOD
    @Override
    public int getAllUsersCount() {
        String sql = "{CALL get_all_users_count()}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAllUsersCount failed", e);
        }
        return 0;
    }
}