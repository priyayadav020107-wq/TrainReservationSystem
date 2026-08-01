package model;

import implementor.ReportOperationImpl;
import java.util.List;
import java.util.Map;

public class ReportPojo {
    
    // Summary Stats
    private double totalRevenue;
    private int totalBookings;
    private int cancelledBookings;
    private int activeTrains;
    
    // Getters and Setters
    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
    
    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }
    
    public int getCancelledBookings() { return cancelledBookings; }
    public void setCancelledBookings(int cancelledBookings) { this.cancelledBookings = cancelledBookings; }
    
    public int getActiveTrains() { return activeTrains; }
    public void setActiveTrains(int activeTrains) { this.activeTrains = activeTrains; }
    
    // Business Methods
    public void getReportSummary() {
        new ReportOperationImpl().getReportSummary(this);
    }
    
    public List<Map<String, Object>> getMonthlyBookings() {
        return new ReportOperationImpl().getMonthlyBookings();
    }
    
    public List<Map<String, Object>> getBookingStatusDistribution() {
        return new ReportOperationImpl().getBookingStatusDistribution();
    }
    
    
}