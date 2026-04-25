package com.bankmanage.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnectionManager {

    private static DBConnectionManager instance;
    
    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/indian_bank?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234"; // Update this with your actual MySQL password

    // Private constructor ensures the class cannot be instanciated externally
    private DBConnectionManager() {
        try {
            // Explicitly load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Critical Error: MySQL JDBC Driver not found.");
            e.printStackTrace();
        }
    }

    // Singleton pattern
    public static synchronized DBConnectionManager getInstance() {
        if (instance == null) {
            instance = new DBConnectionManager();
        }
        return instance;
    }

    // Provide a fresh connection per call to ensure thread safety during concurrent Servlets and specific DAO transaction blocks.
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}
