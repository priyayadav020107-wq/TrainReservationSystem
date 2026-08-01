package operations;

import model.AdminPojo;

public interface AdminOperation {
    boolean adminLogin(AdminPojo pojo);
    void getDashboardStats(AdminPojo pojo);
    void getAdminProfile(AdminPojo pojo);
   
    void changeAdminPassword(AdminPojo pojo, String currentPassword, String newPassword);
    void updateAdminName(AdminPojo pojo, String name);
    void updateAdminEmail(AdminPojo pojo, String email);
    
}