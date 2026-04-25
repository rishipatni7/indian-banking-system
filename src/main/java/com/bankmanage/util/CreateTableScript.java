package com.bankmanage.util;

import java.sql.Connection;
import java.sql.Statement;

public class CreateTableScript {
    public static void main(String[] args) {
        try {
            Connection con = DBConnectionManager.getInstance().getConnection();
            Statement stmt = con.createStatement();
            
            String sql = "CREATE TABLE IF NOT EXISTS service_requests (" +
                         "request_id INT AUTO_INCREMENT PRIMARY KEY, " +
                         "account_id INT NOT NULL, " +
                         "request_type ENUM('DEPOSIT', 'DEBIT_CARD', 'CREDIT_CARD') NOT NULL, " +
                         "amount DECIMAL(15, 2), " +
                         "status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING', " +
                         "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                         "resolved_at TIMESTAMP NULL, " +
                         "FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE" +
                         ") ENGINE=InnoDB;";
                         
            stmt.executeUpdate(sql);
            System.out.println("service_requests table verified/created successfully.");
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
