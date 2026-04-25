package com.bankmanage.dao;

import com.bankmanage.util.DBConnectionManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class KycDAO {
    
    /**
     * Updates an account's KYC status atomically across two tables.
     */
    public boolean updateKycStatus(int accountId, String status) {
        String sqlAccount = "UPDATE accounts SET kyc_status = ? WHERE account_id = ?";
        String sqlReq = "UPDATE kyc_requests SET status = ?, resolved_at = CURRENT_TIMESTAMP WHERE account_id = ? AND status = 'PENDING'";
        
        try (Connection con = DBConnectionManager.getInstance().getConnection()) {
            // Atomic update to ensure both Account flags and Request logs match
            con.setAutoCommit(false);
            
            try (PreparedStatement psAcc = con.prepareStatement(sqlAccount);
                 PreparedStatement psReq = con.prepareStatement(sqlReq)) {
                 
                 psAcc.setString(1, status);
                 psAcc.setInt(2, accountId);
                 psAcc.executeUpdate();
                 
                 psReq.setString(1, status);
                 psReq.setInt(2, accountId);
                 psReq.executeUpdate();
                 
                 con.commit();
                 return true;
            } catch (SQLException e) {
                 con.rollback();
                 e.printStackTrace();
            } finally {
                 con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
