package com.bankmanage.dao;

import com.bankmanage.model.ServiceRequestBean;
import com.bankmanage.util.DBConnectionManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceRequestDAO {

    public void submitRequest(int accountId, String requestType, double amount) throws SQLException {
        String sql = "INSERT INTO service_requests (account_id, request_type, amount, status) VALUES (?, ?, ?, 'PENDING')";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setString(2, requestType);
            if (amount > 0) {
                ps.setDouble(3, amount);
            } else {
                ps.setNull(3, java.sql.Types.DECIMAL);
            }
            ps.executeUpdate();
        }
    }

    public List<ServiceRequestBean> getUserRequests(int accountId) throws SQLException {
        List<ServiceRequestBean> requests = new ArrayList<>();
        String sql = "SELECT * FROM service_requests WHERE account_id = ? ORDER BY created_at DESC";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiceRequestBean bean = new ServiceRequestBean();
                    bean.setRequestId(rs.getInt("request_id"));
                    bean.setAccountId(rs.getInt("account_id"));
                    bean.setRequestType(rs.getString("request_type"));
                    bean.setAmount(rs.getDouble("amount"));
                    bean.setStatus(rs.getString("status"));
                    bean.setCreatedAt(rs.getTimestamp("created_at"));
                    bean.setResolvedAt(rs.getTimestamp("resolved_at"));
                    requests.add(bean);
                }
            }
        }
        return requests;
    }

    public List<ServiceRequestBean> getPendingRequests() throws SQLException {
        List<ServiceRequestBean> requests = new ArrayList<>();
        String sql = "SELECT * FROM service_requests WHERE status = 'PENDING' ORDER BY created_at ASC";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ServiceRequestBean bean = new ServiceRequestBean();
                bean.setRequestId(rs.getInt("request_id"));
                bean.setAccountId(rs.getInt("account_id"));
                bean.setRequestType(rs.getString("request_type"));
                bean.setAmount(rs.getDouble("amount"));
                bean.setStatus(rs.getString("status"));
                bean.setCreatedAt(rs.getTimestamp("created_at"));
                requests.add(bean);
            }
        }
        return requests;
    }

    /**
     * ACID Compliant processing of service requests.
     * If the request is a DEPOSIT and is APPROVED, it atomically updates the account balance.
     */
    public void processRequest(int requestId, String actionStr) throws SQLException {
        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement updateRequestPs = null;
        PreparedStatement addBalancePs = null;
        ResultSet rs = null;

        try {
            con = DBConnectionManager.getInstance().getConnection();
            con.setAutoCommit(false); // START TRANSACTION

            // 1. Lock the request row
            String checkSql = "SELECT account_id, request_type, amount, status FROM service_requests WHERE request_id = ? FOR UPDATE";
            checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, requestId);
            rs = checkPs.executeQuery();

            if (!rs.next()) {
                throw new SQLException("Request ID not found.");
            }

            String currentStatus = rs.getString("status");
            if (!"PENDING".equals(currentStatus)) {
                throw new SQLException("Request has already been processed.");
            }

            int accountId = rs.getInt("account_id");
            String requestType = rs.getString("request_type");
            double amount = rs.getDouble("amount");
            String finalStatus = "APPROVE".equalsIgnoreCase(actionStr) ? "APPROVED" : "REJECTED";

            // 2. If it's a deposit and it's approved, instantly credit the account
            if ("APPROVED".equals(finalStatus) && "DEPOSIT".equals(requestType)) {
                // Lock the account row
                String addSql = "UPDATE accounts SET balance = balance + ? WHERE account_id = ?";
                addBalancePs = con.prepareStatement(addSql);
                addBalancePs.setDouble(1, amount);
                addBalancePs.setInt(2, accountId);
                int updated = addBalancePs.executeUpdate();
                if (updated == 0) {
                     throw new SQLException("Failed to credit account. Account may not exist.");
                }
            }

            // 3. Update the request status and set resolution time
            String completeSql = "UPDATE service_requests SET status = ?, resolved_at = CURRENT_TIMESTAMP WHERE request_id = ?";
            updateRequestPs = con.prepareStatement(completeSql);
            updateRequestPs.setString(1, finalStatus);
            updateRequestPs.setInt(2, requestId);
            updateRequestPs.executeUpdate();

            // COMMIT
            con.commit();
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (checkPs != null) try { checkPs.close(); } catch (SQLException e) {}
            if (addBalancePs != null) try { addBalancePs.close(); } catch (SQLException e) {}
            if (updateRequestPs != null) try { updateRequestPs.close(); } catch (SQLException e) {}
            if (con != null) {
                 try { con.setAutoCommit(true); } catch(SQLException ex) {}
                 try { con.close(); } catch(SQLException ex) {}
            }
        }
    }
}
