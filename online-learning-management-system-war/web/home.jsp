<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Online Learning Management System</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <header>
            <div class="container">
                <h1>E-Learning</h1>
            </div>
        </header>

        <nav>
            <div class="container">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/HomeServlet">Home</a></li>
                    <li><a href="#">Courses</a></li>
                    <li><a href="#">About</a></li>
                    <li><a href="#">Contact</a></li>
                        <%-- Check if user is logged in --%>
                        <% if (session != null && session.getAttribute("user") != null) { %>
                    <!-- Enrollment va DashBoard-->
                    <li><a href="${pageContext.request.contextPath}/EnrollmentServlet?action=list">My Enrollments</a></li>
                    <li><a href="${pageContext.request.contextPath}/EnrollmentServlet?action=dashboard">Dashboard</a></li>

                    <li>
                        <span>Welcome, ${sessionScope.user.fullName}</span>
                    </li>
                    <li>
                        <form action="${pageContext.request.contextPath}/auth" method="POST">
                            <input type="hidden" name="action" value="Logout">
                            <button type="submit">Logout</button>
                        </form>
                    </li>
                    <% } else { %>
                    <li>
                        <a href="${pageContext.request.contextPath}/auth?action=Login">Login</a>
                    </li>
                    <% }%>
                </ul>
            </div>
        </nav>

        <main class="container main">
            <section class="hero">
                <h2>Unlock Your Potential</h2>
                <p>Join our community and start your journey to mastering new skills today.</p>

                <!-- Truy cap nhanh Enrollment va Dashboard -->
                <div class="hero-actions" style="margin-top:12px; display:flex; gap:10px; flex-wrap:wrap;">
                    <% if (session != null && session.getAttribute("user") != null) { %>
                    <a class="btn" href="${pageContext.request.contextPath}/EnrollmentServlet?action=list">Go to My Enrollments</a>
                    <a class="btn" href="${pageContext.request.contextPath}/EnrollmentServlet?action=dashboard">Open Dashboard</a>
                    <% } else { %>
                    <a class="btn" href="${pageContext.request.contextPath}/auth?action=Login">Login to manage enrollments</a>
                    <% }%>
                </div>
            </section>

            <div class="feature-grid">
                <div class="feature-box">
                    <h3>Featured Courses</h3>
                    <p>Explore our wide range of courses designed to enhance your skills and knowledge.</p>
                    <a href="#">Browse Courses →</a>
                </div>
                <div class="feature-box">
                    <h3>Learn at Your Pace</h3>
                    <p>Access course materials anytime, anywhere, and learn at your own convenience.</p>
                    <a href="#">Get Started →</a>
                </div>
                <div class="feature-box">
                    <h3>Expert Instructors</h3>
                    <p>Learn from industry experts with years of experience in their respective fields.</p>
                    <a href="#">Meet Our Team →</a>
                </div>
            </div>
        </main>

        <footer>
            <div class="container">
                <p>&copy; 2025 Online Learning Management System. All rights reserved.</p>
            </div>
        </footer>
    </body>
</html>
