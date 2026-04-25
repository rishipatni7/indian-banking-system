package com.bankmanage.controller;

import com.bankmanage.dao.ApplicationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/AdminApplicationServlet")
public class AdminApplicationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int appId = Integer.parseInt(request.getParameter("application_id"));
        
        ApplicationDAO dao = new ApplicationDAO();
        
        try {
            if ("APPROVE".equals(action)) {
                // Instantly clones staging application into secure DB and authorizes KYC
                dao.approveApplication(appId);
            } else if ("REJECT".equals(action)) {
                dao.rejectApplication(appId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Reload Admin Queue
        response.sendRedirect("admin_dashboard.jsp");
    }
}
