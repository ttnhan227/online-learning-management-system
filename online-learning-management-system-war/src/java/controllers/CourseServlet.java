/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import beans.CourseManagementSBLocal;
import beans.AuthenticationSBLocal;
import entities.Course;
import entities.AppUser;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Servlet controller cho quản lý khóa học
 * @author ttnha
 */
@WebServlet(name = "CourseServlet", urlPatterns = {
    "/courses", 
    "/course/*", 
    "/instructor/*",
    "/test",
    "/test-dashboard",
    "/simple-test",
    "/instructor-dashboard-test"
})
public class CourseServlet extends HttpServlet {

    @EJB
    private CourseManagementSBLocal courseManagementSB;
    
    @EJB
    private AuthenticationSBLocal authBean;
    
    /**
     * Helper method to get current user from session
     */
    private AppUser getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        
        AppUser currentUser = (AppUser) session.getAttribute("currentUser");
        AppUser user = (AppUser) session.getAttribute("user");
        
        // If currentUser is null but user exists, use user as currentUser
        if (currentUser == null && user != null) {
            currentUser = user;
            session.setAttribute("currentUser", user);
        }
        
        return currentUser;
    }
    
    /**
     * Helper method to check if user has instructor role
     */
    private boolean isInstructor(AppUser user) {
        if (user == null) {
            return false;
        }
        return authBean.hasRole(user.getUserId(), "instructor");
    }
    
    /**
     * Helper method to check if user has admin role
     */
    private boolean isAdmin(AppUser user) {
        if (user == null) {
            return false;
        }
        return authBean.hasRole(user.getUserId(), "admin");
    }
    
    /**
     * Helper method to check if user has student role
     */
    private boolean isStudent(AppUser user) {
        if (user == null) {
            return false;
        }
        return authBean.hasRole(user.getUserId(), "student");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== DEBUG DOGET ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Request URL: " + request.getRequestURL());
        System.out.println("Context Path: " + request.getContextPath());
        
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        System.out.println("Servlet Path: " + servletPath);
        System.out.println("Path Info: " + pathInfo);
        System.out.println("=== END DEBUG DOGET ===");
        
        // Handle /courses
        if ("/courses".equals(servletPath)) {
            listCourses(request, response);
            return;
        }
        
        // Handle test endpoint
        if ("/test".equals(servletPath)) {
            testConnection(request, response);
            return;
        }
        
     
        
        // Handle /course/* patterns
        if ("/course".equals(servletPath) && pathInfo != null) {
            switch (pathInfo) {
                case "/view":
                    viewCourse(request, response);
                    break;
                case "/create":
                    showCreateForm(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/search":
                    searchCourses(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/courses");
                    break;
            }
            return;
        }
        
        // Handle /instructor/* patterns
        if ("/instructor".equals(servletPath) && pathInfo != null) {
            System.out.println("=== DEBUG INSTRUCTOR PATH ===");
            System.out.println("Servlet Path: " + servletPath);
            System.out.println("Path Info: " + pathInfo);
            System.out.println("Path Info length: " + (pathInfo != null ? pathInfo.length() : "null"));
            System.out.println("Path Info equals '/dashboard': " + "/dashboard".equals(pathInfo));
            System.out.println("Path Info starts with '/dashboard': " + (pathInfo != null && pathInfo.startsWith("/dashboard")));
            
            // Handle both /dashboard and /dashboard.jsp
            if (pathInfo.equals("/dashboard") || pathInfo.equals("/dashboard.jsp")) {
                System.out.println("Calling instructorDashboard for path: " + pathInfo);
                System.out.println("About to call instructorDashboard method...");
                instructorDashboard(request, response);
                System.out.println("instructorDashboard method completed");
                return;
            }
            
            // Handle other instructor paths
            System.out.println("Unknown instructor path, redirecting to courses");
            System.out.println("Path Info was: '" + pathInfo + "'");
            response.sendRedirect(request.getContextPath() + "/courses");
            return;
        }
        
        // Default redirect
        response.sendRedirect(request.getContextPath() + "/courses");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        // Handle /course/* patterns for POST
        if ("/course".equals(servletPath) && pathInfo != null) {
            switch (pathInfo) {
                case "/create":
                    createCourse(request, response);
                    break;
                case "/edit":
                    updateCourse(request, response);
                    break;
                case "/delete":
                    deleteCourse(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/courses");
                    break;
            }
            return;
        }
        
        // Default redirect
        response.sendRedirect(request.getContextPath() + "/courses");
    }

    /**
     * Hiển thị danh sách tất cả khóa học
     */
    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Debug: Check session
        HttpSession session = request.getSession(false);
        System.out.println("=== DEBUG SESSION ===");
        System.out.println("Session exists: " + (session != null));
        if (session != null) {
            System.out.println("Session ID: " + session.getId());
            AppUser user = (AppUser) session.getAttribute("user");
            AppUser currentUser = (AppUser) session.getAttribute("currentUser");
            System.out.println("Session user: " + (user != null ? user.getFullName() + " (ID: " + user.getUserId() + ")" : "null"));
            System.out.println("Session currentUser: " + (currentUser != null ? currentUser.getFullName() + " (ID: " + currentUser.getUserId() + ")" : "null"));
            
            // List all session attributes
            java.util.Enumeration<String> attributeNames = session.getAttributeNames();
            System.out.println("All session attributes:");
            while (attributeNames.hasMoreElements()) {
                String name = attributeNames.nextElement();
                Object value = session.getAttribute(name);
                System.out.println("  " + name + " = " + (value != null ? value.toString() : "null"));
            }
        } else {
            System.out.println("No session found");
        }
        System.out.println("=== END DEBUG SESSION ===");
        
        String pageStr = request.getParameter("page");
        int page = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
        int pageSize = 10;
        
        List<Course> courses = courseManagementSB.getCoursesWithPagination(page, pageSize);
        long totalCourses = courseManagementSB.getTotalCourseCount();
        int totalPages = (int) Math.ceil((double) totalCourses / pageSize);
        
        request.setAttribute("courses", courses);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCourses", totalCourses);
        
        // Add role information for JSP
        if (session != null) {
            AppUser currentUser = getCurrentUser(request);
            if (currentUser != null) {
                boolean hasInstructorRole = isInstructor(currentUser);
                boolean hasAdminRole = isAdmin(currentUser);
                boolean hasStudentRole = isStudent(currentUser);
                
                request.setAttribute("userHasInstructorRole", hasInstructorRole);
                request.setAttribute("userHasAdminRole", hasAdminRole);
                request.setAttribute("userHasStudentRole", hasStudentRole);
            }
        }
        
        request.getRequestDispatcher("/courses/course-list.jsp").forward(request, response);
    }

    /**
     * Hiển thị chi tiết khóa học
     */
    private void viewCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("id");
        System.out.println("ViewCourse called with ID: " + courseIdStr);
        
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            System.out.println("Course ID is null or empty, redirecting to courses");
            response.sendRedirect(request.getContextPath() + "/courses");
            return;
        }
        
        try {
            Integer courseId = Integer.parseInt(courseIdStr);
            System.out.println("Parsed course ID: " + courseId);
            
            Course course = courseManagementSB.getCourseById(courseId);
            System.out.println("Found course: " + (course != null ? course.getTitle() : "null"));
            
            if (course == null) {
                System.out.println("Course not found, showing error");
                request.setAttribute("error", "Invalid Course!!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("course", course);
            request.getRequestDispatcher("/courses/course-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException: " + e.getMessage());
            request.setAttribute("error", "ID Invalid!!");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * Hiển thị form tạo khóa học
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AppUser currentUser = getCurrentUser(request);
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=Login");
            return;
        }
        
        // Check if user has instructor or admin role
        boolean hasInstructorRole = isInstructor(currentUser);
        boolean hasAdminRole = isAdmin(currentUser);
        
        if (!hasInstructorRole && !hasAdminRole) {
            request.setAttribute("error", "Access Denied: You need instructor or admin privileges to create courses.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        request.getRequestDispatcher("/courses/course-create.jsp").forward(request, response);
    }

    /**
     * Hiển thị form chỉnh sửa khóa học
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AppUser currentUser = getCurrentUser(request);
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=Login");
            return;
        }
        
        // Check if user has instructor or admin role
        boolean hasInstructorRole = isInstructor(currentUser);
        boolean hasAdminRole = isAdmin(currentUser);
        
        if (!hasInstructorRole && !hasAdminRole) {
            request.setAttribute("error", "Access Denied: You need instructor or admin privileges to edit courses.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        String courseIdStr = request.getParameter("id");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/courses");
            return;
        }
        
        try {
            Integer courseId = Integer.parseInt(courseIdStr);
            Course course = courseManagementSB.getCourseById(courseId);
            
            if (course == null) {
                request.setAttribute("error", "Course Invalid!!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra quyền chỉnh sửa
            // Admin can edit any course, instructor can only edit their own courses
            if (!hasAdminRole && !courseManagementSB.isInstructorOfCourse(currentUser.getUserId(), courseId)) {
                request.setAttribute("error", "Access Denied: You can only edit your own courses.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("course", course);
            request.getRequestDispatcher("/courses/course-edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID Invalid!!");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * Tạo khóa học mới
     */
    private void createCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AppUser currentUser = getCurrentUser(request);
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=Login");
            return;
        }
        
        // Check if user has instructor or admin role
        boolean hasInstructorRole = isInstructor(currentUser);
        boolean hasAdminRole = isAdmin(currentUser);
        
        if (!hasInstructorRole && !hasAdminRole) {
            request.setAttribute("error", "Access Denied: You need instructor or admin privileges to create courses.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String prerequisites = request.getParameter("prerequisites");
        
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "title cant be blank!!");
            request.getRequestDispatcher("/courses/course-create.jsp").forward(request, response);
            return;
        }
        
        try {
            Course newCourse = courseManagementSB.createCourse(title.trim(), description, prerequisites, currentUser);
            
            // Debug logging
            System.out.println("Course created successfully:");
            System.out.println("Course ID: " + newCourse.getCourseId());
            System.out.println("Course Title: " + newCourse.getTitle());
            System.out.println("Instructor: " + newCourse.getInstructorId().getFullName());
            
            request.setAttribute("success", "Create Course Successfully!!");
            response.sendRedirect(request.getContextPath() + "/course/view?id=" + newCourse.getCourseId());
            
        } catch (Exception e) {
            System.out.println("Error creating course: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/courses/course-create.jsp").forward(request, response);
        }
    }

    /**
     * Cập nhật khóa học
     */
    private void updateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AppUser currentUser = getCurrentUser(request);
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=Login");
            return;
        }
        
        // Check if user has instructor or admin role
        boolean hasInstructorRole = isInstructor(currentUser);
        boolean hasAdminRole = isAdmin(currentUser);
        
        if (!hasInstructorRole && !hasAdminRole) {
            request.setAttribute("error", "Access Denied: You need instructor or admin privileges to update courses.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        String courseIdStr = request.getParameter("courseId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String prerequisites = request.getParameter("prerequisites");
        
        if (courseIdStr == null || title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Information Invalid!!");
            request.getRequestDispatcher("/courses/course-edit.jsp").forward(request, response);
            return;
        }
        
        try {
            Integer courseId = Integer.parseInt(courseIdStr);
            
            // Kiểm tra quyền chỉnh sửa
            // Admin can update any course, instructor can only update their own courses
            if (!hasAdminRole && !courseManagementSB.isInstructorOfCourse(currentUser.getUserId(), courseId)) {
                request.setAttribute("error", "Access Denied: You can only update your own courses.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            Course updatedCourse = courseManagementSB.updateCourse(courseId, title.trim(), description, prerequisites);
            
            if (updatedCourse != null) {
                request.setAttribute("success", "Update Successfully!!");
                response.sendRedirect(request.getContextPath() + "/course/view?id=" + courseId);
            } else {
                request.setAttribute("error", "Course Invalid!!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID khóa học không hợp lệ");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật khóa học: " + e.getMessage());
            request.getRequestDispatcher("/courses/course-edit.jsp").forward(request, response);
        }
    }

    /**
     * Xóa khóa học
     */
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AppUser currentUser = getCurrentUser(request);
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=Login");
            return;
        }
        
        // Check if user has instructor or admin role
        boolean hasInstructorRole = isInstructor(currentUser);
        boolean hasAdminRole = isAdmin(currentUser);
        
        if (!hasInstructorRole && !hasAdminRole) {
            request.setAttribute("error", "Access Denied: You need instructor or admin privileges to delete courses.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        String courseIdStr = request.getParameter("id");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/courses");
            return;
        }
        
        try {
            Integer courseId = Integer.parseInt(courseIdStr);
            
            // Kiểm tra quyền xóa
            // Admin can delete any course, instructor can only delete their own courses
            if (!hasAdminRole && !courseManagementSB.isInstructorOfCourse(currentUser.getUserId(), courseId)) {
                request.setAttribute("error", "Access Denied: You can only delete your own courses.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            boolean deleted = courseManagementSB.deleteCourse(courseId);
            
            if (deleted) {
                request.setAttribute("success", "Delete Course Succesfully!!");
            } else {
                request.setAttribute("error", "Course Invalid!");
            }
            
            response.sendRedirect(request.getContextPath() + "/courses");
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID khóa học không hợp lệ");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * Tìm kiếm khóa học
     */
    private void searchCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("q");

        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/courses");
            return;
        }

        // Read filters from query params
        String[] categoryParams = request.getParameterValues("category");
        String[] levelParams = request.getParameterValues("level");
        String sortOption = request.getParameter("sort");

        java.util.List<String> categories = categoryParams != null ? java.util.Arrays.asList(categoryParams) : java.util.Collections.emptyList();
        java.util.List<String> levels = levelParams != null ? java.util.Arrays.asList(levelParams) : java.util.Collections.emptyList();

        // Perform filtered search
        List<Course> searchResults = courseManagementSB.searchCourses(searchTerm.trim(), categories, levels, sortOption);

        // Attributes for JSP
        request.setAttribute("courses", searchResults);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("resultCount", searchResults.size());
        request.setAttribute("sortOption", sortOption != null ? sortOption : "latest");
        request.setAttribute("selectedCategories", String.join(",", categories));
        request.setAttribute("selectedLevels", String.join(",", levels));

        request.getRequestDispatcher("/courses/course-search.jsp").forward(request, response);
    }

    /**
     * Dashboard cho instructor
     */
    private void instructorDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== DEBUG INSTRUCTOR DASHBOARD ===");
        System.out.println("Method instructorDashboard called successfully!");
        
        AppUser currentUser = getCurrentUser(request);
        System.out.println("Current user: " + (currentUser != null ? currentUser.getFullName() + " (ID: " + currentUser.getUserId() + ")" : "null"));
        
        if (currentUser == null) {
            System.out.println("No user found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/auth?action=Login");
            return;
        }
        
        // Check if user has instructor or admin role
        boolean hasInstructorRole = isInstructor(currentUser);
        boolean hasAdminRole = isAdmin(currentUser);
        
        System.out.println("User has instructor role: " + hasInstructorRole);
        System.out.println("User has admin role: " + hasAdminRole);
        
        if (!hasInstructorRole && !hasAdminRole) {
            System.out.println("User does not have instructor or admin role, showing access denied");
            request.setAttribute("error", "Access Denied: You need instructor or admin privileges to access this page.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        System.out.println("User has proper role, proceeding to load dashboard data...");
        
        try {
            System.out.println("Calling getCoursesByInstructor for user ID: " + currentUser.getUserId());
            List<Course> instructorCourses = courseManagementSB.getCoursesByInstructor(currentUser.getUserId());
            System.out.println("Found " + (instructorCourses != null ? instructorCourses.size() : "null") + " courses");
            
            if (instructorCourses != null) {
                for (Course course : instructorCourses) {
                    System.out.println("Course: " + course.getTitle() + " (ID: " + course.getCourseId() + ")");
                }
            }
            
            request.setAttribute("courses", instructorCourses);
            request.setAttribute("courseCount", instructorCourses != null ? instructorCourses.size() : 0);
            request.setAttribute("isAdmin", hasAdminRole);
            request.setAttribute("isInstructor", hasInstructorRole);
            
            System.out.println("About to forward to /WEB-INF/instructor/dashboard.jsp");
            System.out.println("Request context path: " + request.getContextPath());
            System.out.println("Full request URI: " + request.getRequestURI());
            
            request.getRequestDispatcher("/WEB-INF/instructor/dashboard.jsp").forward(request, response);
            System.out.println("Forward completed successfully");
            
        } catch (Exception e) {
            System.out.println("Error in instructorDashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
        
        System.out.println("=== END DEBUG INSTRUCTOR DASHBOARD ===");
    }
    
    /**
     * Test connection to database and EJB
     */
    private void testConnection(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Test database connection
            List<Course> courses = courseManagementSB.getAllCourses();
            long totalCourses = courseManagementSB.getTotalCourseCount();
            
            response.setContentType("text/html");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h2>Database Connection Test</h2>");
            response.getWriter().println("<p>Total courses in database: " + totalCourses + "</p>");
            response.getWriter().println("<p>CourseManagementSB is working: " + (courses != null ? "YES" : "NO") + "</p>");
            
            if (courses != null && !courses.isEmpty()) {
                response.getWriter().println("<h3>Sample Courses:</h3>");
                response.getWriter().println("<ul>");
                for (Course course : courses) {
                    response.getWriter().println("<li>" + course.getTitle() + " (ID: " + course.getCourseId() + ")</li>");
                }
                response.getWriter().println("</ul>");
            }
            
            // Test creating a course
            response.getWriter().println("<h3>Testing Course Creation:</h3>");
            try {
                // Get first user as instructor (for testing)
                HttpSession session = request.getSession(false);
                AppUser testUser = null;
                if (session != null) {
                    testUser = (AppUser) session.getAttribute("currentUser");
                }
                
                if (testUser != null) {
                    Course testCourse = courseManagementSB.createCourse(
                        "Test Course " + System.currentTimeMillis(),
                        "Test Description",
                        "Test Prerequisites",
                        testUser
                    );
                    response.getWriter().println("<p>Test course created successfully with ID: " + testCourse.getCourseId() + "</p>");
                    
                    // Try to retrieve the course
                    Course retrievedCourse = courseManagementSB.getCourseById(testCourse.getCourseId());
                    if (retrievedCourse != null) {
                        response.getWriter().println("<p>Course retrieved successfully: " + retrievedCourse.getTitle() + "</p>");
                    } else {
                        response.getWriter().println("<p style='color: red;'>ERROR: Could not retrieve created course!</p>");
                    }
                } else {
                    response.getWriter().println("<p style='color: orange;'>No user in session, skipping course creation test</p>");
                }
            } catch (Exception e) {
                response.getWriter().println("<p style='color: red;'>Error creating test course: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
            
            response.getWriter().println("</body></html>");
            
        } catch (Exception e) {
            response.setContentType("text/html");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h2>Error Testing Connection</h2>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
            response.getWriter().println("<pre>" + e.toString() + "</pre>");
            response.getWriter().println("</body></html>");
            e.printStackTrace();
        }
    }

    /**
     * Test dashboard endpoint
     */
    private void testDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h2>Dashboard Test Endpoint</h2>");
        response.getWriter().println("<p>This endpoint is designed to test if the servlet is receiving the dashboard request.</p>");
        response.getWriter().println("<p>If you see this message, it means the servlet successfully received the request.</p>");
        response.getWriter().println("</body></html>");
    }

    /**
     * Simple test endpoint
     */
    private void simpleTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h2>Simple Test Endpoint</h2>");
        response.getWriter().println("<p>This endpoint is designed to test if the servlet is receiving the simple test request.</p>");
        response.getWriter().println("<p>If you see this message, it means the servlet successfully received the request.</p>");
        response.getWriter().println("</body></html>");
    }
    
    /**
     * Instructor dashboard test endpoint
     */
    private void instructorDashboardTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== INSTRUCTOR DASHBOARD TEST ===");
        instructorDashboard(request, response);
    }
}
