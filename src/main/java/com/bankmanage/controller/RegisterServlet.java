package com.bankmanage.controller;

import com.bankmanage.dao.ApplicationDAO;
import com.bankmanage.model.ApplicationBean;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

// This maps the exact URL /RegisterServlet which Tomcat could not find earlier
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Extract all form data sent by user
        ApplicationBean app = new ApplicationBean();
        app.setUsername(request.getParameter("username"));
        app.setPasswordHash(request.getParameter("password")); // Real systems would hash here
        app.setFullName(request.getParameter("full_name"));
        
        // Safely parse Date
        try {
            app.setDob(Date.valueOf(request.getParameter("dob")));
        } catch (Exception e) {}
        
        app.setPhone(request.getParameter("phone"));
        app.setEmail(request.getParameter("email"));
        app.setAddress(request.getParameter("address"));
        app.setAccountType(request.getParameter("account_type"));
        app.setCurrency(request.getParameter("currency"));
        
        try {
            app.setInitialDeposit(Double.parseDouble(request.getParameter("initial_deposit")));
        } catch (NumberFormatException e) {
            app.setInitialDeposit(0.0);
        }
        
        app.setIdType(request.getParameter("id_type"));
        app.setIdNumber(request.getParameter("id_number"));
        app.setOccupation(request.getParameter("occupation"));
        app.setEmployerName(request.getParameter("employer_name"));

        // 2. Transmit to Data Access Layer
        ApplicationDAO dao = new ApplicationDAO();
        boolean success = dao.submitApplication(app);

        // 3. Route accordingly
        if (success) {
            // Solves your issue! Now seamlessly routes to your new status page
            response.sendRedirect("approval_status.jsp");
        } else {
            // Fallback (e.g., username already taken error)
            response.sendRedirect("register.jsp?error=failed");
        }
    }
}
