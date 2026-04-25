package com.bankmanage.dao;

import com.bankmanage.model.TransactionBean;
import com.bankmanage.util.DBConnectionManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    /**
     * Executes a strict, ACID-compliant money transfer using a database transaction.
     */
    public void transferFunds(int fromAccountId, int toAccountId, double amount, String transactionType) throws SQLException {
        Connection con = null;
        PreparedStatement checkBalancePs = null;
        PreparedStatement deductPs = null;
        PreparedStatement addPs = null;
        PreparedStatement recordTxnPs = null;
        ResultSet rs = null;

        try {
            con = DBConnectionManager.getInstance().getConnection();
            
            // [CRITICAL EXAM] Start strict transaction block
            con.setAutoCommit(false);

            // 1. Lock the sender account row and check balance/KYC
            String balanceSql = "SELECT balance, kyc_status FROM accounts WHERE account_id = ? FOR UPDATE";
            checkBalancePs = con.prepareStatement(balanceSql);
            checkBalancePs.setInt(1, fromAccountId);
            rs = checkBalancePs.executeQuery();

            if (!rs.next()) {
                throw new SQLException("Sender account not found.");
            }
            
            double currentBalance = rs.getDouble("balance");
            String kycStatus = rs.getString("kyc_status");

            // Banking Domain Rule Enforcement
            if (!"APPROVED".equals(kycStatus)) {
                throw new SQLException("Outbound transfers restricted: KYC is " + kycStatus + ".");
            }
            if (currentBalance < amount) {
                throw new SQLException("Insufficient funds for this transfer.");
            }

            // 2. Lock the receiver row to guarantee they exist before deduction
            String checkReceiverSql = "SELECT account_id FROM accounts WHERE account_id = ? FOR UPDATE";
            try (PreparedStatement recvPs = con.prepareStatement(checkReceiverSql)) {
                recvPs.setInt(1, toAccountId);
                try (ResultSet recvRs = recvPs.executeQuery()) {
                    if (!recvRs.next()) {
                         throw new SQLException("Recipient account does not exist.");
                    }
                }
            }

            // 3. Deduct from Sender
            String deductSql = "UPDATE accounts SET balance = balance - ? WHERE account_id = ?";
            deductPs = con.prepareStatement(deductSql);
            deductPs.setDouble(1, amount);
            deductPs.setInt(2, fromAccountId);
            int rowsDeducted = deductPs.executeUpdate();
            if (rowsDeducted == 0) throw new SQLException("Failed to debit sender.");

            // 4. Credit to Receiver
            String addSql = "UPDATE accounts SET balance = balance + ? WHERE account_id = ?";
            addPs = con.prepareStatement(addSql);
            addPs.setDouble(1, amount);
            addPs.setInt(2, toAccountId);
            addPs.executeUpdate();

            // 5. Record the Audit Log in 'transactions' table
            // In accordance with Indian Banking simulation, NEFT is batched/delayed (Pending), IMPS is quick (Completed)
            String status = "NEFT".equals(transactionType) ? "PENDING" : "COMPLETED"; 
            
            String recordSql = "INSERT INTO transactions (from_account, to_account, amount, transaction_type, status) VALUES (?, ?, ?, ?, ?)";
            recordTxnPs = con.prepareStatement(recordSql);
            recordTxnPs.setInt(1, fromAccountId);
            recordTxnPs.setInt(2, toAccountId);
            recordTxnPs.setDouble(3, amount);
            recordTxnPs.setString(4, transactionType);
            recordTxnPs.setString(5, status);
            recordTxnPs.executeUpdate();

            // 6. Commit the entire transaction atomically
            con.commit();

        } catch (SQLException e) {
            // [CRITICAL ERROR HANDLING] Rollback transaction instantly on any violation or crash
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e; // Rethrow back to the controller
        } finally {
            // Memory cleanup and connection reset
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (checkBalancePs != null) try { checkBalancePs.close(); } catch (SQLException e) {}
            if (deductPs != null) try { deductPs.close(); } catch (SQLException e) {}
            if (addPs != null) try { addPs.close(); } catch (SQLException e) {}
            if (recordTxnPs != null) try { recordTxnPs.close(); } catch (SQLException e) {}
            
            if (con != null) {
                 try { con.setAutoCommit(true); } catch(SQLException ex) {} // ALWAYS RESTORE
                 try { con.close(); } catch(SQLException ex) {}
            }
        }
    }

    public List<TransactionBean> getRecentTransactions(int accountId) {
        List<TransactionBean> list = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE from_account = ? OR to_account = ? ORDER BY created_at DESC LIMIT 10";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            ps.setInt(2, accountId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TransactionBean txn = new TransactionBean();
                    txn.setTransactionId(rs.getInt("transaction_id"));
                    txn.setFromAccount(rs.getInt("from_account"));
                    txn.setToAccount(rs.getInt("to_account"));
                    txn.setAmount(rs.getDouble("amount"));
                    txn.setTransactionType(rs.getString("transaction_type"));
                    txn.setStatus(rs.getString("status"));
                    txn.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(txn);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
