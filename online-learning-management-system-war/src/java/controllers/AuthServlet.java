package controllers;

import beans.AuthenticationSBLocal;
import entities.AppUser;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
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
import java.util.List;
import utils.ValidationUtils;
import utils.ValidationResult;

import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 1024 * 1024 * 5,    // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
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
            // Set user object with consistent attribute name
            session.setAttribute("user", user);
            
            // Set user ID as a separate attribute for easy access in JSP
            session.setAttribute("userId", user.getUserId());
            
            // Add role information to session
            boolean hasInstructorRole = authBean.hasRole(user.getUserId(), "instructor");
            boolean hasAdminRole = authBean.hasRole(user.getUserId(), "admin");
            boolean hasStudentRole = authBean.hasRole(user.getUserId(), "student");
            
            session.setAttribute("userHasInstructorRole", hasInstructorRole);
            session.setAttribute("userHasAdminRole", hasAdminRole);
            session.setAttribute("userHasStudentRole", hasStudentRole);
        
            session.setMaxInactiveInterval(30 * 60);
        
            // Check if there's a redirect URL in session
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                // Remove the redirect URL from session to avoid future redirects
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectUrl);
            } else {
                // Default redirect to home if no specific redirect URL is set
                response.sendRedirect(request.getContextPath() + "/HomeServlet");
            }
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
        String bio = request.getParameter("bio");
        String department = request.getParameter("department");
        
        // Client-side validation
        ValidationResult validationResult = ValidationUtils.validateRegistration(
                fullName, email, password, confirmPassword);
        
        // Validate role separately
        if (role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "Please select a role");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!validationResult.isValid()) {
            request.setAttribute("error", validationResult.getMessage());
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        // Handle file upload for verification document
        Part filePart = request.getPart("verificationDocument");
        
        // Process file upload
        String fileName = filePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("");
        File uploadDir = new File(uploadPath + File.separator + "uploads" + File.separator + "verification");
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Generate unique filename
        String fileExtension = "";
        int i = fileName.lastIndexOf('.');
        if (i > 0) {
            fileExtension = fileName.substring(i);
        }
        String uniqueFileName = "verif_" + System.currentTimeMillis() + "_" + email.hashCode() + fileExtension;
        String filePath = uploadDir + File.separator + uniqueFileName;
        
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
        } catch (Exception e) {
            request.setAttribute("error", "Error uploading verification document: " + e.getMessage());
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        // Store the relative path in the database
        String relativeFilePath = "uploads/verification/" + uniqueFileName;
        
        // Check if email already exists
        if (authBean.getUserByEmail(email) != null) {
            request.setAttribute("error", "Email already registered. Please use a different email or login.");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        // Register the user
        AppUser newUser;
        if ("instructor".equalsIgnoreCase(role)) {
            // Validate instructor-specific fields
            if (bio == null || bio.trim().isEmpty()) {
                request.setAttribute("error", "Bio is required for instructor registration");
                request.getRequestDispatcher("auth/register.jsp").forward(request, response);
                return;
            }
            if (department == null || department.trim().isEmpty()) {
                request.setAttribute("error", "Department is required for instructor registration");
                request.getRequestDispatcher("auth/register.jsp").forward(request, response);
                return;
            }
            
            // Register the instructor with additional fields
            newUser = authBean.registerInstructor(fullName, email, password, role, 
                    bio, department, relativeFilePath);
        } else {
            // Register the student
            newUser = authBean.registerUser(fullName, email, password, role);
        }
        
        if (newUser != null) {
            String successMessage;
            if ("instructor".equalsIgnoreCase(role)) {
                successMessage = "Thank you for registering as an instructor! Your application is currently under review by our admin team. "
                    + "We will verify your credentials and documents. You will receive an email notification once your account is approved. "
                    + "This process typically takes 1-2 business days. We appreciate your patience.";
            } else {
                successMessage = "Registration successful! Please login with your credentials to access your student dashboard.";
            }
            // Forward to login page with success message
            request.setAttribute("success", successMessage);
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }
        
        // If we get here, something went wrong
        request.setAttribute("error", "Registration failed. Please try again.");
        request.getRequestDispatcher("auth/register.jsp").forward(request, response);
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("user");
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
