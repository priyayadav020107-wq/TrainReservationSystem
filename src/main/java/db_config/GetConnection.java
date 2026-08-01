package db_config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GetConnection {
    
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/train_reservation_system", "root", "priya1234"
            );
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }
}