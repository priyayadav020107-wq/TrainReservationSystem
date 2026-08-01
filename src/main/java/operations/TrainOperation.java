package operations;

import model.TrainPojo;
import java.util.List;
import java.util.Map;

public interface TrainOperation {
    List<TrainPojo> searchTrains(TrainPojo pojo);
   
    List<TrainPojo> getAllTrains();
    void addTrain(TrainPojo pojo);
    void updateTrain(TrainPojo pojo);
    void removeTrain(TrainPojo pojo);
    List<Map<String, Object>> getTrainSeatsStatus(int trainId, String journeyDate);
    // NEW METHODS FOR AUDIT HISTORY

    List<Map<String, Object>> getAllTrainAudit();
    
    List<Map<String, Object>> getAvailableSeatsForTrain(int trainId, String journeyDate);
    String getMostRecentBookingDate(int trainId);
}