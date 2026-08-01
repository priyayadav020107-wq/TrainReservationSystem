package operations;

import model.ReportPojo;
import java.util.List;
import java.util.Map;

public interface ReportOperation {
    void getReportSummary(ReportPojo pojo);
    List<Map<String, Object>> getMonthlyBookings();
    List<Map<String, Object>> getBookingStatusDistribution();
    
}