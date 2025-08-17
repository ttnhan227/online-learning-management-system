package controllers;

import beans.AuthenticationSBLocal;
import entities.AppUser;
import jakarta.ejb.EJB;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import utils.ValidationUtils;
import utils.ValidationResult;

public class AuthServlet extends HttpServlet {
    
    @EJB
    private AuthenticationSBLocal authBean;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }
    
    protected void doProcess(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
            return;
        }
        
        try {
            switch (action) {
                case "test":
                    handleTestConnection(request, response);
                    break;
                case "Login":
                    if ("POST".equals(request.getMethod())) {
                        handleLogin(request, response);
                    } else {
                        request.getRequestDispatcher("auth/login.jsp").forward(request, response);
                    }
                    break;
                case "Register":
                    if ("POST".equals(request.getMethod())) {
                        handleRegister(request, response);
                    } else {
                        request.getRequestDispatcher("auth/register.jsp").forward(request, response);
                    }
                    break;
                case "Logout":
                    handleLogout(request, response);
                    break;
                default:
                    request.setAttribute("error", "Invalid action");
                    request.getRequestDispatcher("auth/login.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request");
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Client-side validation
        ValidationResult validationResult = ValidationUtils.validateLogin(email, password);
        if (!validationResult.isValid()) {
            request.setAttribute("error", validationResult.getMessage());
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
            return;
        }
        
        AppUser user = authBean.login(email, password);
        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("currentUser", user); // Add this line for compatibility
            
            // Add role information to session
            boolean hasInstructorRole = authBean.hasRole(user.getUserId(), "instructor");
            boolean hasAdminRole = authBean.hasRole(user.getUserId(), "admin");
            boolean hasStudentRole = authBean.hasRole(user.getUserId(), "student");
            
            session.setAttribute("userHasInstructorRole", hasInstructorRole);
            session.setAttribute("userHasAdminRole", hasAdminRole);
            session.setAttribute("userHasStudentRole", hasStudentRole);
            
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect(request.getContextPath() + "/HomeServlet");
        } else {
            request.setAttribute("error", "Invalid email or password. Please check your credentials and try again.");
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
        }
    }
    
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        
        // Comprehensive validation
        ValidationResult validationResult = ValidationUtils.validateRegistration(fullName, email, password, confirmPassword);
        if (!validationResult.isValid()) {
            request.setAttribute("error", validationResult.getMessage());
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        // Validate role selection
        if (role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "Please select a role");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        AppUser newUser = authBean.registerUser(fullName, email, password, role);
        if (newUser != null) {
            request.setAttribute("success", "Registration successful! You can now login with your new account.");
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. The email address may already be in use. Please try a different email.");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
        }
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/HomeServlet");
    }
    
    private void handleTestConnection(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            boolean connectionOk = authBean.testConnection();
            if (connectionOk) {
                response.getWriter().write("Database connection successful!");
            } else {
                response.getWriter().write("Database connection failed!");
            }
        } catch (Exception e) {
            response.getWriter().write("Error testing connection: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
