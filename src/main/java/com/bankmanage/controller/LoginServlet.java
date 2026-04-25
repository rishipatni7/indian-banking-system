package com.bankmanage.controller;

import com.bankmanage.dao.AccountDAO;
import com.bankmanage.model.AccountBean;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String identifier = request.getParameter("username"); // can be user or acct#
        String pass = request.getParameter("password");
        
        AccountDAO dao = new AccountDAO();
        AccountBean account = dao.authenticate(identifier, pass);
        
        if (account != null) {
            // ESTABLISH HYBRID SESSION MANAGEMENT Standard
            HttpSession session = request.getSession(true);
            session.setAttribute("account", account);
            session.setAttribute("role", account.getRole());
            
            // Route based on Authorization clearance
            if ("ADMIN".equals(account.getRole())) {
                response.sendRedirect("admin_dashboard.jsp"); 
            } else {
                response.sendRedirect("user_dashboard.jsp"); 
            }
        } else {
            // Authentication Failed
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}
