package controllers;

import beans.AdminSBLocal;
import entities.AppUser;
import entities.Role;
import entities.UserRole;
import jakarta.servlet.ServletException;
import jakarta.ejb.EJB;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import utils.ValidationResult;

/**
 *
 * @author ttnha
 */
public class AdminServlet extends HttpServlet {

    @EJB
    private AdminSBLocal adminSB;
    
    private boolean isAdminUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        // Check if user is already marked as admin in session
        Boolean isAdmin = (Boolean) session.getAttribute("userHasAdminRole");
        if (isAdmin != null && isAdmin) {
            return true;
        }
        
        // Fallback check using user roles
        AppUser currentUser = (AppUser) session.getAttribute("currentUser");
        if (currentUser == null) {
            currentUser = (AppUser) session.getAttribute("user");
        }
        
        if (currentUser == null) return false;
        
        // Check if user has admin role
        try {
            // Create a final copy of currentUser for use in lambda
            final AppUser user = currentUser;
            
            // Get user's roles from the database
            List<AppUser> adminUsers = adminSB.getUsersByRole("administrator");
            return adminUsers.stream()
                    .anyMatch(u -> u.getUserId().equals(user.getUserId()));
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("error", "You are not authorized to access this page.");
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        if (!isAdminUser(request)) {
            handleUnauthorized(request, response);
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            if (path.endsWith("/admin") || path.endsWith("/admin/") || path.endsWith("/admin/dashboard")) {
                showDashboard(request, response);
                return;
            }
            if (path.endsWith("/admin/users")) {
                listUsers(request, response);
            } else if (path.endsWith("/admin/users/approve")) {
                approveInstructor(request, response);
            } else if (path.endsWith("/admin/users/delete")) {
                deleteUser(request, response);
            } else if (path.endsWith("/admin/instructors")) {
                listInstructors(request, response);
            } else if (path.endsWith("/admin/students")) {
                listStudents(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get counts for dashboard
        List<AppUser> users = adminSB.getAllUsers();
        List<AppUser> instructors = adminSB.getUsersByRole("INSTRUCTOR");
        List<AppUser> students = adminSB.getUsersByRole("STUDENT");
        
        // Get recent users (last 5)
        List<AppUser> recentUsers = users.stream()
                .sorted((u1, u2) -> u2.getCreatedAt().compareTo(u1.getCreatedAt()))
                .limit(5)
                .collect(Collectors.toList());
        
        long pendingInstructors = instructors.stream()
                .filter(i -> !i.getIsApproved())
                .count();
        
        request.setAttribute("userCount", users.size());
        request.setAttribute("instructorCount", instructors.size());
        request.setAttribute("studentCount", students.size());
        request.setAttribute("pendingInstructorCount", pendingInstructors);
        request.setAttribute("recentUsers", recentUsers);
        request.setAttribute("instructors", instructors);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<AppUser> users = adminSB.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/user-list.jsp").forward(request, response);
    }
    
    private void listInstructors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<AppUser> instructors = adminSB.getUsersByRole("INSTRUCTOR");
        request.setAttribute("instructors", instructors);
        request.getRequestDispatcher("/admin/instructor-list.jsp").forward(request, response);
    }
    
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<AppUser> students = adminSB.getUsersByRole("STUDENT");
        request.setAttribute("students", students);
        request.getRequestDispatcher("/admin/student-list.jsp").forward(request, response);
    }
    
    private void approveInstructor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            ValidationResult result = adminSB.approveInstructor(userId);
            
            if (result.isValid()) {
                request.getSession().setAttribute("successMessage", result.getMessage());
            } else {
                request.getSession().setAttribute("errorMessage", result.getMessage());
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid user ID");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/instructors");
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            ValidationResult result = adminSB.deleteUser(userId);
            
            if (result.isValid()) {
                request.getSession().setAttribute("successMessage", result.getMessage());
            } else {
                request.getSession().setAttribute("errorMessage", result.getMessage());
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid user ID");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
