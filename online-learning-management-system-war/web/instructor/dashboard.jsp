<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% request.setAttribute("activePage", "dashboard"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instructor Dashboard - Online Learning Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .dashboard-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
        }
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            transition: transform 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .course-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease;
        }
        .course-card:hover {
            transform: translateY(-3px);
        }
        .quick-actions {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .recent-activity {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .activity-item {
            padding: 1rem 0;
            border-bottom: 1px solid #eee;
        }
        .activity-item:last-child {
            border-bottom: none;
        }
        .progress-ring {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: conic-gradient(#667eea 0deg 180deg, #e9ecef 180deg 360deg);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }
    </style>
    </head>
<body>
    <jsp:include page="/WEB-INF/fragments/header.jsp"/>

    <!-- Dashboard Header -->
    <section class="dashboard-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="display-4 mb-3">Hello, ${sessionScope.currentUser.fullName}!</h1>
                    <p class="lead mb-0">Welcome to Instructor Dashboard</p>
                </div>
                <div class="col-lg-4 text-center">
                    <i class="fas fa-chalkboard-teacher fa-5x"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Dashboard Content -->
    <div class="container py-5">
        <!-- Statistics Cards -->
        <div class="row mb-5">
            <div class="col-lg-3 col-md-6">
                <div class="stats-card">
                    <div class="progress-ring">
                        <i class="fas fa-book-open fa-2x text-primary"></i>
                    </div>
                    <h3 class="text-primary">${courseCount}</h3>
                    <p class="text-muted mb-0">Total Courses</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stats-card">
                    <div class="progress-ring">
                        <i class="fas fa-users fa-2x text-success"></i>
                    </div>
                    <h3 class="text-success">0</h3>
                    <p class="text-muted mb-0">Students</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stats-card">
                    <div class="progress-ring">
                        <i class="fas fa-star fa-2x text-warning"></i>
                    </div>
                    <h3 class="text-warning">0</h3>
                    <p class="text-muted mb-0">Reviews</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stats-card">
                    <div class="progress-ring">
                        <i class="fas fa-eye fa-2x text-info"></i>
                    </div>
                    <h3 class="text-info">0</h3>
                    <p class="text-muted mb-0">Views</p>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Main Content -->
            <div class="col-lg-8">
                <!-- Quick Actions -->
                <div class="quick-actions">
                    <h4 class="mb-4"><i class="fas fa-bolt me-2 text-warning"></i>Quick Actions</h4>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/course/create" class="btn btn-primary btn-lg w-100">
                                <i class="fas fa-plus me-2"></i>Create New Course
                            </a>
                        </div>
                        <div class="col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-primary btn-lg w-100">
                                <i class="fas fa-list me-2"></i>View All Courses
                            </a>
                        </div>
                        <div class="col-md-6 mb-3">
                            <button class="btn btn-outline-success btn-lg w-100" onclick="showAnalytics()">
                                <i class="fas fa-chart-bar me-2"></i>View Analytics
                            </button>
                        </div>
                        <div class="col-md-6 mb-3">
                            <button class="btn btn-outline-info btn-lg w-100" onclick="showSettings()">
                                <i class="fas fa-cog me-2"></i>Settings
                            </button>
                        </div>
                    </div>
                </div>

                <!-- My Courses -->
                <div class="course-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="mb-0"><i class="fas fa-book me-2 text-primary"></i>My Courses</h4>
                        <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-primary btn-sm">
                            View All
                        </a>
                    </div>

                    <c:if test="${empty courses}">
                        <div class="text-center py-4">
                            <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">You have no courses yet</h5>
                            <p class="text-muted">Start creating your first course!</p>
                            <a href="${pageContext.request.contextPath}/course/create" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Create First Course
                            </a>
                        </div>
                    </c:if>

                    <c:forEach var="course" items="${courses}">
                        <div class="border rounded p-3 mb-3">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h6 class="mb-1">${course.title}</h6>
                                    <p class="text-muted mb-2 small">
                                        <c:choose>
                                            <c:when test="${not empty course.description && course.description.length() > 100}">
                                                ${course.description.substring(0, 100)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${course.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <div class="d-flex align-items-center">
                                        <small class="text-muted me-3">
                                            <i class="fas fa-calendar me-1"></i>
                                            <fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy"/>
                                        </small>
                                        <small class="text-muted">
                                            <i class="fas fa-users me-1"></i>0 students
                                        </small>
                                    </div>
                                </div>
                                <div class="col-md-4 text-end">
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/course/view?id=${course.courseId}" 
                                           class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/course/edit?id=${course.courseId}" 
                                           class="btn btn-outline-warning btn-sm">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button class="btn btn-outline-danger btn-sm" 
                                                onclick="confirmDelete(${course.courseId}, &quot;${course.title}&quot;)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Recent Activity -->
                <div class="recent-activity">
                    <h5 class="mb-4"><i class="fas fa-clock me-2 text-info"></i>Recent Activity</h5>
                    
                    <div class="activity-item">
                        <div class="d-flex align-items-center">
                            <div class="bg-primary rounded-circle p-2 me-3">
                                <i class="fas fa-plus text-white"></i>
                            </div>
                            <div>
                                <p class="mb-1"><strong>Created New Course</strong></p>
                                <small class="text-muted">Today</small>
                            </div>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="d-flex align-items-center">
                            <div class="bg-success rounded-circle p-2 me-3">
                                <i class="fas fa-user text-white"></i>
                            </div>
                            <div>
                                <p class="mb-1"><strong>New Student Registered</strong></p>
                                <small class="text-muted">2 days ago</small>
                            </div>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="d-flex align-items-center">
                            <div class="bg-warning rounded-circle p-2 me-3">
                                <i class="fas fa-star text-white"></i>
                            </div>
                            <div>
                                <p class="mb-1"><strong>New Review</strong></p>
                                <small class="text-muted">3 days ago</small>
                            </div>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="d-flex align-items-center">
                            <div class="bg-info rounded-circle p-2 me-3">
                                <i class="fas fa-edit text-white"></i>
                            </div>
                            <div>
                                <p class="mb-1"><strong>Updated Course</strong></p>
                                <small class="text-muted">1 week ago</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tips & Resources -->
                <div class="course-card">
                    <h5 class="mb-4"><i class="fas fa-lightbulb me-2 text-warning"></i>Tips & Resources</h5>
                    <ul class="list-unstyled">
                        <li class="mb-3">
                            <i class="fas fa-check text-success me-2"></i>
                            <strong>Create quality content:</strong> Ensure clear and easy-to-understand content
                        </li>
                        <li class="mb-3">
                            <i class="fas fa-check text-success me-2"></i>
                            <strong>Engage with students:</strong> Quickly respond to questions and feedback
                        </li>
                        <li class="mb-3">
                            <i class="fas fa-check text-success me-2"></i>
                            <strong>Regular updates:</strong> Keep course content fresh and current
                        </li>
                        <li class="mb-3">
                            <i class="fas fa-check text-success me-2"></i>
                            <strong>Promote courses:</strong> Share on social media to attract students
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/fragments/footer.jsp"/>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the course "<span id="courseTitle"></span>"?</p>
                    <p class="text-danger"><small>This action cannot be undone!</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form action="${pageContext.request.contextPath}/course/delete" method="POST" style="display: inline;">
                        <input type="hidden" name="id" id="courseIdToDelete">
                        <button type="submit" class="btn btn-danger">Delete Course</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(courseId, courseTitle) {
            document.getElementById('courseIdToDelete').value = courseId;
            document.getElementById('courseTitle').textContent = courseTitle;
            var modal = new bootstrap.Modal(document.getElementById('deleteModal'));
            modal.show();
        }

        function showAnalytics() {
            alert('Detailed analytics functionality will be developed in a future version!');
        }

        function showSettings() {
            alert('Settings functionality will be developed in a future version!');
        }

        // Auto-refresh dashboard every 5 minutes
        setInterval(function() {
            // You can add AJAX call here to refresh dashboard data
            console.log('Dashboard auto-refresh...');
        }, 300000);
    </script>
</body>
</html>

