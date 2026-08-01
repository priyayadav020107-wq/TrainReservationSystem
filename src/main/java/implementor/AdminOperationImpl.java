package implementor;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import db_config.GetConnection;
import model.AdminPojo;
import operations.AdminOperation;
import util.AppLogger; // ✅ NEW IMPORT

public class AdminOperationImpl implements AdminOperation {

    private static final Logger logger = AppLogger.getLogger(AdminOperationImpl.class); // ✅ NEW
    
    @Override
    public boolean adminLogin(AdminPojo pojo) {
        String sql = "SELECT * FROM admins WHERE email = ? AND admin_password = SHA2(?, 256)";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, pojo.getEmail());
            pstmt.setString(2, pojo.getPassword());
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                pojo.setAdminId(rs.getInt("admin_id"));
                pojo.setName(rs.getString("name"));
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "adminLogin failed for email=" + pojo.getEmail(), e);
        }
        return false;
    }
    
    @Override
    public void getDashboardStats(AdminPojo pojo) {
        String sql = "{CALL get_dashboard_stats()}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            if (rs.next()) {
                pojo.setTotalUsers(rs.getInt("total_users"));
                pojo.setTotalTrains(rs.getInt("total_trains"));
                pojo.setTotalBookings(rs.getInt("total_bookings"));
                pojo.setTotalRevenue(rs.getDouble("total_revenue"));
                pojo.setTodaysBookings(rs.getInt("todays_bookings"));
                pojo.setTodaysRevenue(rs.getDouble("todays_revenue"));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getDashboardStats failed", e);
        }
    }
    
    

    // ========== ADMIN PROFILE METHODS ==========
    
    @Override
    public void getAdminProfile(AdminPojo pojo) {
        String sql = "{CALL get_admin_profile(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getAdminId());
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                pojo.setAdminId(rs.getInt("admin_id"));
                pojo.setName(rs.getString("name"));
                pojo.setEmail(rs.getString("email"));
            }
            rs.close();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAdminProfile failed for adminId=" + pojo.getAdminId(), e);
        }
    }
    

    @Override
    public void updateAdminName(AdminPojo pojo, String name) {
        String sql = "{CALL update_admin_name(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getAdminId());
            cstmt.setString(2, name);
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.WARNING, "updateAdminName failed for adminId=" + pojo.getAdminId(), e);
            throw new RuntimeException(e.getMessage());
        }
    }
    
    @Override
    public void updateAdminEmail(AdminPojo pojo, String email) {
        String sql = "{CALL update_admin_email(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getAdminId());
            cstmt.setString(2, email);
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.WARNING, "updateAdminEmail failed for adminId=" + pojo.getAdminId(), e);
            throw new RuntimeException(e.getMessage());
        }
    }
    
    
    @Override
    public void changeAdminPassword(AdminPojo pojo, String currentPassword, String newPassword) {
        String sql = "{CALL change_admin_password(?, ?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getAdminId());
            cstmt.setString(2, currentPassword);
            cstmt.setString(3, newPassword);
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.WARNING, "changeAdminPassword failed for adminId=" + pojo.getAdminId(), e);
            throw new RuntimeException(e.getMessage());
        }
    }
}