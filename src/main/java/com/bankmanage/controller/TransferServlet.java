package com.bankmanage.controller;

import com.bankmanage.dao.AccountDAO;
import com.bankmanage.dao.TransactionDAO;
import com.bankmanage.model.AccountBean;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Highly secure Controller strictly intercepting user dashboard POST requests.
 * Triggers the ACID compliant JDBC transaction logic for currency flows.
 */
@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Strict Session Security Verification avoiding NullPointerExceptions
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        AccountBean currentSessionAccount = (AccountBean) session.getAttribute("account");
        
        try {
            int toAccountId = Integer.parseInt(request.getParameter("to_account"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String transactionType = request.getParameter("transaction_type"); // IMPS or NEFT
            
            // 2. Invoke the Highly Secure ACID Transaction Block built into the DAO
            TransactionDAO txnDao = new TransactionDAO();
            txnDao.transferFunds(currentSessionAccount.getAccountId(), toAccountId, amount, transactionType);
            
            // 3. Immediately refresh session state to reflect the deducted balance on the UI memory side
            AccountDAO acctDao = new AccountDAO();
            session.setAttribute("account", acctDao.getAccountById(currentSessionAccount.getAccountId()));
            
            // Re-route browser to the dashboard with a success trigger parameter
            response.sendRedirect("user_dashboard.jsp?status=success");
            
        } catch (NumberFormatException e) {
            response.sendRedirect("user_dashboard.jsp?status=invalid_input");
        } catch (SQLException e) {
            // Intercept Indian Banking domain rules thrown from DAO (Insufficient funds, Account missing)
            // Encode the string specifically for safe URL transportation
            String encodedMsg = java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
            response.sendRedirect("user_dashboard.jsp?status=error&message=" + encodedMsg);
        }
    }
}
