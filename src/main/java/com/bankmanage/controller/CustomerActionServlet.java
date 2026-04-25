package com.bankmanage.controller;

import com.bankmanage.dao.ServiceRequestDAO;
import com.bankmanage.model.AccountBean;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class CustomerActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        AccountBean user = (AccountBean) session.getAttribute("account");
        String requestType = request.getParameter("request_type");
        String amountStr = request.getParameter("amount");

        double amount = 0.0;
        if (amountStr != null && !amountStr.trim().isEmpty()) {
            try {
                amount = Double.parseDouble(amountStr);
                if (amount <= 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                response.sendRedirect("user_dashboard.jsp?status=error&message=Invalid+deposit+amount");
                return;
            }
        }

        try {
            ServiceRequestDAO dao = new ServiceRequestDAO();
            dao.submitRequest(user.getAccountId(), requestType, amount);
            response.sendRedirect("user_dashboard.jsp?status=success&message=Service+Request+Submitted+Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user_dashboard.jsp?status=error&message=System+Error+Processing+Request");
        }
    }
}
