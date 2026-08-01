package implementor;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import db_config.GetConnection;
import model.TrainPojo;
import operations.TrainOperation;
import util.AppLogger; // ✅ NEW IMPORT

public class TrainOperationImpl implements TrainOperation {

    private static final Logger logger = AppLogger.getLogger(TrainOperationImpl.class); // ✅ NEW
    
    @Override
    public List<TrainPojo> searchTrains(TrainPojo pojo) {
        List<TrainPojo> trains = new ArrayList<>();
        String sql = "{CALL search_train(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getSourceStationId());
            cstmt.setInt(2, pojo.getDestinationStationId());
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                TrainPojo train = new TrainPojo();
                train.setTrainId(rs.getInt("train_id"));
                train.setTrainNo(rs.getString("train_no"));
                train.setTrainName(rs.getString("train_name"));
                train.setDepartureTime(rs.getTime("departure_time"));
                train.setArrivalTime(rs.getTime("arrival_time"));
                train.setTotalSeats(rs.getInt("total_seats"));
                train.setAvailableSeats(rs.getInt("available_seats"));
                train.setFare(rs.getDouble("fare"));
                trains.add(train);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "searchTrains failed for sourceStationId=" + pojo.getSourceStationId()
                    + ", destinationStationId=" + pojo.getDestinationStationId(), e);
        }
        return trains;
    }
    
    @Override
    public List<TrainPojo> getAllTrains() {
        List<TrainPojo> trains = new ArrayList<>();
        String sql = "SELECT * FROM trains";
        
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                TrainPojo train = new TrainPojo();
                train.setTrainId(rs.getInt("train_id"));
                train.setTrainNo(rs.getString("train_no"));
                train.setTrainName(rs.getString("train_name"));
                train.setSourceStationId(rs.getInt("source_station_id"));
                train.setDestinationStationId(rs.getInt("destination_station_id"));
                train.setDepartureTime(rs.getTime("departure_time"));
                train.setArrivalTime(rs.getTime("arrival_time"));
                train.setTotalSeats(rs.getInt("total_seats"));
                train.setAvailableSeats(rs.getInt("available_seats"));
                train.setFare(rs.getDouble("fare"));
                train.setStatus(rs.getString("status"));
                trains.add(train);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAllTrains failed", e);
        }
        return trains;
    }
    
    @Override
    public void addTrain(TrainPojo pojo) {
        String sql = "{CALL add_train(?, ?, ?, ?, ?, ?, ?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setString(1, pojo.getTrainNo());
            cstmt.setString(2, pojo.getTrainName());
            cstmt.setInt(3, pojo.getSourceStationId());
            cstmt.setInt(4, pojo.getDestinationStationId());
            cstmt.setTime(5, pojo.getDepartureTime());
            cstmt.setTime(6, pojo.getArrivalTime());
            cstmt.setInt(7, pojo.getTotalSeats());
            cstmt.setDouble(8, pojo.getFare());
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "addTrain failed for trainNo=" + pojo.getTrainNo(), e);
        }
    }
    
    @Override
    public void updateTrain(TrainPojo pojo) {
        try (Connection conn = GetConnection.getConnection()) {
            try (PreparedStatement pstmt = conn.prepareStatement("SET @current_admin = ?")) {
                pstmt.setString(1, pojo.getChangedBy());
                pstmt.execute();
            }
            try (CallableStatement cstmt = conn.prepareCall("{CALL update_train(?, ?, ?)}")) {
                cstmt.setInt(1, pojo.getTrainId());
                cstmt.setDouble(2, pojo.getFare());
                cstmt.setString(3, pojo.getStatus());
                cstmt.execute();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "updateTrain failed for trainId=" + pojo.getTrainId(), e);
        }
    }
    
    @Override
    public void removeTrain(TrainPojo pojo) {
        String sql = "{CALL remove_train(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, pojo.getTrainId());
            cstmt.execute();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "removeTrain failed for trainId=" + pojo.getTrainId(), e);
        }
    }
    
    @Override
    public List<Map<String, Object>> getTrainSeatsStatus(int trainId, String journeyDate) {
        List<Map<String, Object>> seats = new ArrayList<>();
        String sql = "{CALL get_train_seats_status(?, ?)}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, trainId);
            cstmt.setString(2, journeyDate);
            ResultSet rs = cstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> seat = new HashMap<>();
                seat.put("seatId", rs.getInt("seat_id"));
                seat.put("seatNumber", rs.getString("seat_number"));
                seat.put("coachNo", rs.getString("coach_no"));
                seat.put("seatType", rs.getString("seat_type"));
                seat.put("status", rs.getString("seat_status"));
                seats.add(seat);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getTrainSeatsStatus failed for trainId=" + trainId
                    + ", journeyDate=" + journeyDate, e);
        }
        return seats;
    }
    
    @Override
    public List<Map<String, Object>> getAllTrainAudit() {
        List<Map<String, Object>> allAudit = new ArrayList<>();
        String sql = "{CALL get_all_train_audit()}";
        
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql);
             ResultSet rs = cstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("auditId", rs.getInt("audit_id"));
                entry.put("trainId", rs.getInt("train_id"));
                entry.put("trainNo", rs.getString("train_no"));
                entry.put("trainName", rs.getString("train_name"));
                entry.put("oldFare", rs.getDouble("old_fare"));
                entry.put("newFare", rs.getDouble("new_fare"));
                entry.put("oldStatus", rs.getString("old_status"));
                entry.put("newStatus", rs.getString("new_status"));
                entry.put("actionType", rs.getString("action_type"));
                entry.put("changedBy", rs.getString("changed_by"));
                entry.put("changedAt", rs.getString("changed_at"));
                allAudit.add(entry);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAllTrainAudit failed", e);
        }
        return allAudit;
    }
    
    public String getSeatNumberById(int seatId) {
        String seatNumber = "";
        String sql = "SELECT seat_number FROM seats WHERE seat_id = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, seatId);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()) {
                seatNumber = rs.getString("seat_number");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getSeatNumberById failed for seatId=" + seatId, e);
        }
        return seatNumber;
    }
    
    @Override
    public List<Map<String, Object>> getAvailableSeatsForTrain(int trainId, String journeyDate) {
        List<Map<String, Object>> availableSeats = new ArrayList<>();
        String sql = "{CALL get_train_seats_status(?, ?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, trainId);
            cstmt.setString(2, journeyDate);
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                String status = rs.getString("seat_status");
                if("AVAILABLE".equals(status)) {
                    Map<String, Object> seat = new HashMap<>();
                    seat.put("seatId", rs.getInt("seat_id"));
                    seat.put("seatNumber", rs.getString("seat_number"));
                    seat.put("coachNo", rs.getString("coach_no"));
                    seat.put("seatType", rs.getString("seat_type"));
                    availableSeats.add(seat);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getAvailableSeatsForTrain failed for trainId=" + trainId
                    + ", journeyDate=" + journeyDate, e);
        }
        return availableSeats;
    }

    @Override
    public String getMostRecentBookingDate(int trainId) {
        String recentDate = null;
        String sql = "{CALL get_recent_booking_date_for_train(?)}";
        try (Connection conn = GetConnection.getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {
            cstmt.setInt(1, trainId);
            ResultSet rs = cstmt.executeQuery();
            if(rs.next()) {
                recentDate = rs.getString("journey_date");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "getMostRecentBookingDate failed for trainId=" + trainId, e);
        }
        return recentDate;
    }

}