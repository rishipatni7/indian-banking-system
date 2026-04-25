package com.bankmanage.dao;

import com.bankmanage.model.ApplicationBean;
import com.bankmanage.util.DBConnectionManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public boolean submitApplication(ApplicationBean app) {
        String sql = "INSERT INTO account_applications (full_name, dob, phone, email, address, account_type, currency, initial_deposit, id_type, id_number, occupation, employer_name, username, password_hash) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, app.getFullName());
            ps.setDate(2, app.getDob());
            ps.setString(3, app.getPhone());
            ps.setString(4, app.getEmail());
            ps.setString(5, app.getAddress());
            ps.setString(6, app.getAccountType());
            ps.setString(7, app.getCurrency());
            ps.setDouble(8, app.getInitialDeposit());
            ps.setString(9, app.getIdType());
            ps.setString(10, app.getIdNumber());
            ps.setString(11, app.getOccupation());
            ps.setString(12, app.getEmployerName());
            ps.setString(13, app.getUsername());
            ps.setString(14, app.getPasswordHash());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ApplicationBean> getPendingApplications() {
        List<ApplicationBean> list = new ArrayList<>();
        String sql = "SELECT * FROM account_applications WHERE status = 'PENDING' ORDER BY submitted_at ASC";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while(rs.next()) {
                ApplicationBean app = new ApplicationBean();
                app.setApplicationId(rs.getInt("application_id"));
                app.setFullName(rs.getString("full_name"));
                app.setDob(rs.getDate("dob"));
                app.setPhone(rs.getString("phone"));
                app.setEmail(rs.getString("email"));
                app.setAddress(rs.getString("address"));
                app.setAccountType(rs.getString("account_type"));
                app.setCurrency(rs.getString("currency"));
                app.setInitialDeposit(rs.getDouble("initial_deposit"));
                app.setIdType(rs.getString("id_type"));
                app.setIdNumber(rs.getString("id_number"));
                app.setOccupation(rs.getString("occupation"));
                app.setEmployerName(rs.getString("employer_name"));
                app.setUsername(rs.getString("username"));
                app.setPasswordHash(rs.getString("password_hash"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Approves an application by moving it directly into the `accounts` table within a Transaction.
     */
    public boolean approveApplication(int applicationId) throws SQLException {
        Connection con = null;
        PreparedStatement fetchPs = null;
        PreparedStatement insertAccPs = null;
        PreparedStatement updateAppPs = null;
        ResultSet rs = null;

        try {
            con = DBConnectionManager.getInstance().getConnection();
            con.setAutoCommit(false); // Begin Strict Transaction

            // 1. Fetch Application Data (locking row)
            String fetchSql = "SELECT * FROM account_applications WHERE application_id = ? AND status = 'PENDING' FOR UPDATE";
            fetchPs = con.prepareStatement(fetchSql);
            fetchPs.setInt(1, applicationId);
            rs = fetchPs.executeQuery();

            if (!rs.next()) {
                throw new SQLException("Pending Application not found.");
            }

            // 2. Insert into main accounts table (KYC APPROVED automatically)
            String insertSql = "INSERT INTO accounts (username, password_hash, full_name, role, balance, kyc_status) VALUES (?, ?, ?, 'USER', ?, 'APPROVED')";
            insertAccPs = con.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
            insertAccPs.setString(1, rs.getString("username"));
            insertAccPs.setString(2, rs.getString("password_hash"));
            insertAccPs.setString(3, rs.getString("full_name"));
            insertAccPs.setDouble(4, rs.getDouble("initial_deposit"));
            insertAccPs.executeUpdate();
            
            // Get the newly generated account_id
            ResultSet generatedKeys = insertAccPs.getGeneratedKeys();
            if(!generatedKeys.next()) throw new SQLException("Failed to auto-generate main account_id.");
            
            // Note: If you want to automatically create a transaction log for their initial_deposit, you can do it here

            // 3. Mark application as APPROVED
            String updateSql = "UPDATE account_applications SET status = 'APPROVED' WHERE application_id = ?";
            updateAppPs = con.prepareStatement(updateSql);
            updateAppPs.setInt(1, applicationId);
            updateAppPs.executeUpdate();

            con.commit();
            return true;

        } catch (SQLException e) {
            if (con != null) { try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
            return false;
        } finally {
            if (rs != null) try { rs.close(); } catch(SQLException e){}
            if (fetchPs != null) try { fetchPs.close(); } catch(SQLException e){}
            if (insertAccPs != null) try { insertAccPs.close(); } catch(SQLException e){}
            if (updateAppPs != null) try { updateAppPs.close(); } catch(SQLException e){}
            if (con != null) { try { con.setAutoCommit(true); } catch(SQLException e){} try { con.close(); } catch(SQLException e){} }
        }
    }

    public boolean rejectApplication(int applicationId) {
        String sql = "UPDATE account_applications SET status = 'REJECTED' WHERE application_id = ? AND status = 'PENDING'";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             ps.setInt(1, applicationId);
             return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
