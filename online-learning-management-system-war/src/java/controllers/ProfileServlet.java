package controllers;

import beans.ProfileSBLocal;
import beans.CourseManagementSBLocal;
import beans.EnrollmentSBLocal;
import entities.AppUser;
import entities.Course;
import entities.Enrollment;
import entities.UserRole;
import jakarta.ejb.EJB;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import jakarta.servlet.annotation.MultipartConfig;
import utils.ValidationResult;
import utils.ValidationUtils;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class ProfileServlet extends HttpServlet {

    @EJB
    private ProfileSBLocal profileBean;
    
    @EJB
    private CourseManagementSBLocal courseBean;
    
    @EJB
    private EnrollmentSBLocal enrollmentBean;
    
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Debug logging
        System.out.println("=== ProfileServlet doGet ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Path Info: " + request.getPathInfo());
        
        // Set request attribute to prevent infinite loops
        if (request.getAttribute("profileRequest") != null) {
            System.out.println("Recursive request detected, aborting...");
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Recursive profile request detected");
            return;
        }
        request.setAttribute("profileRequest", true);
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || (session.getAttribute("user") == null && session.getAttribute("currentUser") == null)) {
            System.out.println("User not logged in, redirecting to login...");
            String redirectUrl = request.getRequestURI();
            String queryString = request.getQueryString();
            if (queryString != null && !queryString.isEmpty()) {
                redirectUrl += "?" + queryString;
            }
            session = request.getSession();
            session.setAttribute("redirectAfterLogin", redirectUrl);
            
            response.sendRedirect(request.getContextPath() + "/auth?action=Login");
            return;
        }
        
        // Get current user from either attribute (for backward compatibility)
        AppUser currentUser = (AppUser) (session.getAttribute("user") != null
                ? session.getAttribute("user") : session.getAttribute("currentUser"));

        String servletPath = request.getServletPath();
        String action = null;
        String userIdStr = null;

        // Strategy:
        // 1. Parse servletPath for action. e.g., /profile/edit -> edit
        // 2. Fallback to request parameters if not found in path.
        if (servletPath != null && servletPath.startsWith("/profile")) {
            String[] parts = servletPath.split("/");
            if (parts.length > 2) {
                action = parts[2];
            }
        }

        if (action == null) {
            action = request.getParameter("action");
        }
        if (userIdStr == null) {
            userIdStr = request.getParameter("userId");
        }

        // Default action is to view profile
        if (action == null || action.isEmpty()) {
            action = "view";
        }

        try {
            request.setAttribute("profileRequest", "true");

            switch (action) {
                case "view":
                    // If no userId specified, view own profile
                    if (userIdStr == null || userIdStr.isEmpty()) {
                        userIdStr = String.valueOf(currentUser.getUserId());
                    }

                    // Permission check
                    if (!String.valueOf(currentUser.getUserId()).equals(userIdStr)
                            && (session.getAttribute("userHasAdminRole") == null || !(Boolean) session.getAttribute("userHasAdminRole"))) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to view this profile");
                        return;
                    }

                    request.setAttribute("userIdToView", userIdStr);
                    viewProfile(request, response);
                    break;

                case "edit":
                    // Permission check: can only edit own profile (or if admin)
                    if (userIdStr != null && !userIdStr.isEmpty() && !String.valueOf(currentUser.getUserId()).equals(userIdStr)
                            && (session.getAttribute("userHasAdminRole") == null || !(Boolean) session.getAttribute("userHasAdminRole"))) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only edit your own profile");
                        return;
                    }
                    showEditProfile(request, response);
                    break;

                case "change-password":
                    // Permission check: can only change own password
                    if (userIdStr != null && !userIdStr.isEmpty() && !String.valueOf(currentUser.getUserId()).equals(userIdStr)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only change your own password");
                        return;
                    }
                    showChangePassword(request, response);
                    break;

                default:
                    // If the action is a number, it's a profile view request
                    if (action.matches("\\d+")) {
                        userIdStr = action;
                        // Permission check
                        if (!String.valueOf(currentUser.getUserId()).equals(userIdStr)
                                && (session.getAttribute("userHasAdminRole") == null || !(Boolean) session.getAttribute("userHasAdminRole"))) {
                            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to view this profile");
                            return;
                        }
                        request.setAttribute("userIdToView", userIdStr);
                        viewProfile(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "The requested action '" + action + "' is not available");
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        
        if ("/profile/edit".equals(servletPath)) {
            // Update profile
            updateProfile(request, response);
        } else if ("/profile/change-password".equals(servletPath)) {
            // Handle password change
            changePassword(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private boolean isInstructor(AppUser user) {
        if (user == null) return false;
        
        // Get user roles from the database
        try {
            List<UserRole> userRoles = profileBean.getUserRoles(user.getUserId());
            if (userRoles != null) {
                return userRoles.stream()
                    .anyMatch(ur -> ur.getRoleId() != null && 
                                 "instructor".equalsIgnoreCase(ur.getRoleId().getRoleName()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private void viewProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=Login");
            return;
        }

        // Get current user from either attribute (for backward compatibility)
        AppUser currentUser = (AppUser) (session.getAttribute("user") != null ? 
            session.getAttribute("user") : session.getAttribute("currentUser"));
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=Login");
            return;
        }
        
        // Get the user ID from request attribute, parameter, or use current user's ID
        String userIdParam = (String) request.getAttribute("userIdToView");
        if (userIdParam == null) {
            userIdParam = request.getParameter("userId");
        }
        
        Integer userId;
        
        try {
            userId = (userIdParam != null && !userIdParam.isEmpty()) 
                ? Integer.parseInt(userIdParam) 
                : currentUser.getUserId();
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID format");
            return;
        }
        
        // Check if the current user has permission to view this profile
        if (!currentUser.getUserId().equals(userId) && 
            !(session.getAttribute("userHasAdminRole") != null && 
              (Boolean)session.getAttribute("userHasAdminRole"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, 
                "You don't have permission to view this profile");
            return;
        }
        
        try {
            // Get fresh user data from database
            AppUser profileUser = profileBean.getUserProfile(userId);
            if (profileUser == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            
            // Set request attributes for the view
            request.setAttribute("profileUser", profileUser);
            
            // If viewing instructor profile, fetch their courses
            if (isInstructor(profileUser)) {
                List<Course> instructorCourses = courseBean.getCoursesByInstructor(profileUser.getUserId());
                request.setAttribute("instructorCourses", instructorCourses);
            } else {
                // For students, fetch their enrollments
                List<Enrollment> studentEnrollments = enrollmentBean.getEnrollmentsByStudent(profileUser.getUserId());
                request.setAttribute("studentEnrollments", studentEnrollments);
            }
            
            // Clear any previous includes/forwards to prevent loops
            if (!response.isCommitted()) {
                // Use forward instead of include to prevent nested dispatches
                request.getRequestDispatcher("/profile/view.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Send error directly to response to prevent loops
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "An error occurred while loading the profile: " + e.getMessage());
        }
    }

    private void showEditProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            AppUser currentUser = (AppUser) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/auth?action=Login");
                return;
            }
            
            // Get fresh user data from database
            AppUser user = profileBean.getUserProfile(currentUser.getUserId());
            if (user == null) {
                request.setAttribute("error", "User not found");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("profileUser", user);
            request.getRequestDispatcher("/profile/edit.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the edit form");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            AppUser currentUser = (AppUser) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/auth?action=Login");
                return;
            }
            
            // Get fresh user data
            AppUser user = profileBean.getUserProfile(currentUser.getUserId());
            if (user == null) {
                request.setAttribute("error", "User not found");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Update user data from form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String photoUrl = request.getParameter("photoUrl");
            String department = request.getParameter("department");
            String bio = request.getParameter("bio");

            // Handle profile photo upload
            Part photoPart = request.getPart("photoUpload");
            String photoFileName = Paths.get(photoPart.getSubmittedFileName()).getFileName().toString();

            if (photoFileName != null && !photoFileName.isEmpty()) {
                // Define the upload path
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                File uploadDir = new File(uploadFilePath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Create a unique file name to avoid conflicts
                String uniqueFileName = "photo_" + System.currentTimeMillis() + "_" + photoFileName;
                String filePath = uploadFilePath + File.separator + uniqueFileName;

                // Save the file
                try (InputStream fileContent = photoPart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                }

                // Update photoUrl to the new path
                photoUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
            }
            
            // Handle verification document upload if it doesn't exist yet
            if (user.getVerificationDocument() == null || user.getVerificationDocument().isEmpty()) {
                Part docPart = request.getPart("verificationDocument");
                String docFileName = Paths.get(docPart.getSubmittedFileName()).getFileName().toString();
                
                if (docFileName != null && !docFileName.isEmpty()) {
                    // Define the upload path
                    String applicationPath = request.getServletContext().getRealPath("");
                    String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR + File.separator + "docs";
                    
                    File uploadDir = new File(uploadFilePath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Create a unique file name to avoid conflicts
                    String uniqueFileName = "doc_" + System.currentTimeMillis() + "_" + docFileName;
                    String filePath = uploadFilePath + File.separator + uniqueFileName;
                    
                    // Save the file
                    try (InputStream fileContent = docPart.getInputStream()) {
                        Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    }
                    
                    // Set the verification document path
                    user.setVerificationDocument("/" + UPLOAD_DIR + "/docs/" + uniqueFileName);
                    // Set is_approved to false when a new document is uploaded
                    user.setIsApproved(false);
                }
            }

            // Validate full name
            ValidationResult nameResult = ValidationUtils.validateFullName(fullName);
            if (!nameResult.isValid()) {
                request.setAttribute("error", "Invalid name: " + nameResult.getMessage());
                request.setAttribute("profileUser", user);
                request.getRequestDispatcher("/profile/edit.jsp").forward(request, response);
                return;
            }
            
            // Validate email
            ValidationResult emailResult = ValidationUtils.validateEmail(email);
            if (!emailResult.isValid()) {
                request.setAttribute("error", "Invalid email: " + emailResult.getMessage());
                request.setAttribute("profileUser", user);
                request.getRequestDispatcher("/profile/edit.jsp").forward(request, response);
                return;
            }
            
            // Update user object
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhotoUrl(photoUrl);
            user.setDepartment(department);
            user.setBio(bio);
            
            // Save changes
            boolean success = profileBean.updateProfile(user);
            
            if (success) {
                // Update session with new user data
                session.setAttribute("user", user);
                session.setAttribute("success", "Profile updated successfully");
                response.sendRedirect(request.getContextPath() + "/profile?userId=" + user.getUserId());
            } else {
                request.setAttribute("error", "Failed to update profile. The email may already be in use.");
                request.setAttribute("profileUser", user);
                request.getRequestDispatcher("/profile/edit.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while updating the profile");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void showChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            AppUser currentUser = (AppUser) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/auth?action=Login");
                return;
            }
            
            request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the password change form");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            AppUser currentUser = (AppUser) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/auth?action=Login");
                return;
            }
            
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Validate inputs
            if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
                
                request.setAttribute("error", "All fields are required");
                request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New password and confirm password do not match");
                request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
                return;
            }
            
            ValidationResult passwordResult = ValidationUtils.validatePassword(newPassword);
            if (!passwordResult.isValid()) {
                request.setAttribute("error", "New password does not meet the requirements");
                request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
                return;
            }
            
            // Attempt to change password
            boolean success = profileBean.changePassword(
                currentUser.getUserId(), 
                currentPassword, 
                newPassword
            );
            
            if (success) {
                // Refresh the user object in the session to reflect changes
                AppUser updatedUser = profileBean.getUserProfile(currentUser.getUserId());
                session.setAttribute("user", updatedUser);
                session.setAttribute("currentUser", updatedUser); // Update both for consistency
                
                session.setAttribute("success", "Password changed successfully");
                response.sendRedirect(request.getContextPath() + "/profile?userId=" + currentUser.getUserId());
            } else {
                request.setAttribute("error", "Failed to change password. Please check your current password.");
                request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while changing the password");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
