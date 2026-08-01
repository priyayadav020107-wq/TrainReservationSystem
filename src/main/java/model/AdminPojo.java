package model;

import implementor.AdminOperationImpl;

public class AdminPojo {
    private int adminId;
    private String name;
    private String email;
    private String password;
    private int totalUsers;
    private int totalTrains;
    private int totalBookings;
    private double totalRevenue;
    private int todaysBookings;
    private double todaysRevenue;
    
    // Getters and Setters
    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
    public int getTotalTrains() { return totalTrains; }
    public void setTotalTrains(int totalTrains) { this.totalTrains = totalTrains; }
    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }
    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
    public int getTodaysBookings() { return todaysBookings; }
    public void setTodaysBookings(int todaysBookings) { this.todaysBookings = todaysBookings; }
    public double getTodaysRevenue() { return todaysRevenue; }
    public void setTodaysRevenue(double todaysRevenue) { this.todaysRevenue = todaysRevenue; }
    
    // Business Methods
    public boolean login() { return new AdminOperationImpl().adminLogin(this); }
    public void getDashboardStats() { new AdminOperationImpl().getDashboardStats(this); }
    
    public void getAdminProfile() {
        new AdminOperationImpl().getAdminProfile(this);
    }
    
    public void updateAdminName(String name) {
        new AdminOperationImpl().updateAdminName(this, name);
    }
    
    public void updateAdminEmail(String email) {
        new AdminOperationImpl().updateAdminEmail(this, email);
    }
    
    public void changeAdminPassword(String currentPassword, String newPassword) {
        new AdminOperationImpl().changeAdminPassword(this, currentPassword, newPassword);
    }
}