package implementor;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import db_config.GetConnection;
import model.ReportPojo;
import operations.ReportOperation;
import util.AppLogger; // ✅ NEW IMPORT

public class ReportOperationImpl implements ReportOperation {

    private static final Logger logger = AppLogger.getLogger(ReportOperationImpl.class); // ✅ NEW
    
    @Override
    public void getReportSummary(ReportPojo pojo) {
        String sql = "{CALL get_report_summary()}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            
            if (rs.next()) {
                pojo.setTotalRevenue(rs.getDouble("total_revenue"));
                pojo.setTotalBookings(rs.getInt("total_bookings"));
                pojo.setCancelledBookings(rs.getInt("cancelled_bookings"));
                pojo.setActiveTrains(rs.getInt("active_trains"));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getReportSummary failed", e);
        }
    }
    
    @Override
    public List<Map<String, Object>> getMonthlyBookings() {
        List<Map<String, Object>> monthlyData = new ArrayList<>();
        String sql = "{CALL get_monthly_bookings()}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> month = new HashMap<>();
                month.put("month_num", rs.getInt("month_num"));      
                month.put("month_name", rs.getString("month_name")); 
                month.put("booking_count", rs.getInt("booking_count"));
                monthlyData.add(month);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getMonthlyBookings failed", e);
        }
        return monthlyData;
    }
    
    @Override
    public List<Map<String, Object>> getBookingStatusDistribution() {
        List<Map<String, Object>> distribution = new ArrayList<>();
        String sql = "{CALL get_booking_status_distribution()}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> status = new HashMap<>();
                status.put("status", rs.getString("booking_status"));
                status.put("count", rs.getInt("count"));
                distribution.add(status);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getBookingStatusDistribution failed", e);
        }
        return distribution;
    }
}