package model;
import implementor.TrainOperationImpl;
import java.sql.Time;
import java.util.List;
import java.util.Map;
public class TrainPojo {
    private int trainId;
    private String trainNo;
    private String trainName;
    private int sourceStationId;
    private int destinationStationId;
    private String sourceStationName;
    private String destinationStationName;
    private Time departureTime;
    private Time arrivalTime;
    private int totalSeats;
    private int availableSeats;
    private double fare;
    private String status;
    private String journeyDate;
    private String changedBy;
   
    
    // Getters and Setters
    public int getTrainId() { return trainId; }
    public void setTrainId(int trainId) { this.trainId = trainId; }
    public String getTrainNo() { return trainNo; }
    public void setTrainNo(String trainNo) { this.trainNo = trainNo; }
    public String getTrainName() { return trainName; }
    public void setTrainName(String trainName) { this.trainName = trainName; }
    public int getSourceStationId() { return sourceStationId; }
    public void setSourceStationId(int sourceStationId) { this.sourceStationId = sourceStationId; }
    public int getDestinationStationId() { return destinationStationId; }
    public void setDestinationStationId(int destinationStationId) { this.destinationStationId = destinationStationId; }
    public String getSourceStationName() { return sourceStationName; }
    public void setSourceStationName(String sourceStationName) { this.sourceStationName = sourceStationName; }
    public String getDestinationStationName() { return destinationStationName; }
    public void setDestinationStationName(String destinationStationName) { this.destinationStationName = destinationStationName; }
    public Time getDepartureTime() { return departureTime; }
    public void setDepartureTime(Time departureTime) { this.departureTime = departureTime; }
    public Time getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(Time arrivalTime) { this.arrivalTime = arrivalTime; }
    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }
    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getJourneyDate() { return journeyDate; }
    public void setJourneyDate(String journeyDate) { this.journeyDate = journeyDate; }
    public String getChangedBy() { return changedBy; }
    public void setChangedBy(String changedBy) { this.changedBy = changedBy; }
    
    // Business Methods
    public List<TrainPojo> searchTrains() { return new TrainOperationImpl().searchTrains(this); }
    public List<TrainPojo> getAllTrains() { return new TrainOperationImpl().getAllTrains(); }
    public void addTrain() { new TrainOperationImpl().addTrain(this); }
    public void updateTrain() { new TrainOperationImpl().updateTrain(this); }
    public void removeTrain() { new TrainOperationImpl().removeTrain(this); }
    
    public List<Map<String, Object>> getTrainSeatsStatus(int trainId, String journeyDate) {
        return new TrainOperationImpl().getTrainSeatsStatus(trainId, journeyDate);
    }
    
   
    
    public List<Map<String, Object>> getAllTrainAudit() {
        return new TrainOperationImpl().getAllTrainAudit();
    }
    
   
    
    public String getSeatNumberById(int seatId) {
        return new TrainOperationImpl().getSeatNumberById(seatId);
    }
    
    public List<Map<String, Object>> getAvailableSeatsForTrain(int trainId, String journeyDate) {
        return new TrainOperationImpl().getAvailableSeatsForTrain(trainId, journeyDate);
    }

    // ✅ NEW METHOD - Controller calls this to get the default date for
    // ViewSeats.jsp, same convention as every other business method here.
    public String getMostRecentBookingDate(int trainId) {
        return new TrainOperationImpl().getMostRecentBookingDate(trainId);
    }
}