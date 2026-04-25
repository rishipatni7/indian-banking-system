package com.bankmanage.controller;

import com.bankmanage.dao.ServiceRequestDAO;
import com.bankmanage.model.AccountBean;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AdminActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        AccountBean admin = (AccountBean) session.getAttribute("account");
        if (!"ADMIN".equals(admin.getRole())) {
            response.sendRedirect("error.jsp");
            return;
        }

        String requestIdStr = request.getParameter("request_id");
        String action = request.getParameter("action"); // APPROVE or REJECT

        if (requestIdStr != null && action != null) {
            try {
                int requestId = Integer.parseInt(requestIdStr);
                ServiceRequestDAO dao = new ServiceRequestDAO();
                dao.processRequest(requestId, action);
                response.sendRedirect("admin_dashboard.jsp?status=service_success");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_dashboard.jsp?status=service_error&message=" + e.getMessage());
            }
        } else {
            response.sendRedirect("admin_dashboard.jsp?status=service_error");
        }
    }
}
