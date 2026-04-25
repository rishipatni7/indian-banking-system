package com.bankmanage.dao;

import com.bankmanage.model.AccountBean;
import com.bankmanage.util.DBConnectionManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO {
    
    // Method for user authentication
    public AccountBean authenticate(String identifier, String passwordHash) {
        // Allows login via either Username or Account ID
        String sql = "SELECT * FROM accounts WHERE (username = ? OR account_id = ?) AND password_hash = ?";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, identifier);
            
            // Handle parsing if the identifier happens to be their numerical account ID
            try {
                ps.setInt(2, Integer.parseInt(identifier));
            } catch (NumberFormatException e) {
                ps.setInt(2, -1);
            }
            
            ps.setString(3, passwordHash);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AccountBean account = new AccountBean();
                    account.setAccountId(rs.getInt("account_id"));
                    account.setUsername(rs.getString("username"));
                    account.setFullName(rs.getString("full_name"));
                    account.setRole(rs.getString("role"));
                    account.setBalance(rs.getDouble("balance"));
                    account.setKycStatus(rs.getString("kyc_status"));
                    account.setCreatedAt(rs.getTimestamp("created_at"));
                    return account;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In production, use Logger
        }
        return null;
    }

    // Retrieve an account for refreshing session balance
    public AccountBean getAccountById(int accountId) {
        String sql = "SELECT * FROM accounts WHERE account_id = ?";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, accountId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AccountBean account = new AccountBean();
                    account.setAccountId(rs.getInt("account_id"));
                    account.setUsername(rs.getString("username"));
                    account.setFullName(rs.getString("full_name"));
                    account.setRole(rs.getString("role"));
                    account.setBalance(rs.getDouble("balance"));
                    account.setKycStatus(rs.getString("kyc_status"));
                    return account;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
