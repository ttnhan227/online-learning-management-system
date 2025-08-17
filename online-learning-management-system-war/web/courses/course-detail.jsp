<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% request.setAttribute("activePage", "courses"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${course.title} - Course Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .course-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
        }
        .course-image {
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 4rem;
            border-radius: 15px;
        }
        .info-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .action-buttons {
            position: sticky;
            top: 20px;
        }
        .prerequisites-box {
            background: #f8f9fa;
            border-left: 4px solid #007bff;
            padding: 1rem;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/header.jsp"/>

    <!-- Course Header -->
    <section class="course-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/courses" class="text-white">Courses</a></li>
                            <li class="breadcrumb-item active text-white" aria-current="page">${course.title}</li>
                        </ol>
                    </nav>
                    <h1 class="display-4 mb-3">${course.title}</h1>
                    <p class="lead mb-3">${course.description}</p>
                    <div class="d-flex align-items-center">
                        <i class="fas fa-user me-2"></i>
                        <span>Instructor: ${course.instructorId.fullName}</span>
                    </div>
                </div>
                <div class="col-lg-4 text-center">
                    <div class="course-image">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Course Content -->
    <div class="container py-5">
        <div class="row">
            <!-- Main Content -->
            <div class="col-lg-8">
                <!-- Course Description -->
                <div class="info-card">
                    <h3><i class="fas fa-info-circle me-2 text-primary"></i>Course Description</h3>
                    <hr>
                    <p class="lead">${course.description}</p>
                </div>

                <!-- Prerequisites -->
                <c:if test="${not empty course.prerequisites}">
                    <div class="info-card">
                        <h3><i class="fas fa-list-check me-2 text-warning"></i>Prerequisites</h3>
                        <hr>
                        <div class="prerequisites-box">
                            <p class="mb-0">${course.prerequisites}</p>
                        </div>
                    </div>
                </c:if>

                <!-- Course Content (Placeholder for future features) -->
                <div class="info-card">
                    <h3><i class="fas fa-book me-2 text-success"></i>Course Content</h3>
                    <hr>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        This feature will be developed in the next version.
                    </div>
                </div>

                <!-- Assignments (Placeholder) -->
                <div class="info-card">
                    <h3><i class="fas fa-tasks me-2 text-danger"></i>Assignments</h3>
                    <hr>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        Assignment management feature will be developed in the next version.
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <div class="action-buttons">
                    <!-- Course Info Card -->
                    <div class="info-card">
                        <h4><i class="fas fa-calendar me-2 text-primary"></i>Course Information</h4>
                        <hr>
                        <div class="mb-3">
                            <strong>Created Date:</strong><br>
                            <fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                        <div class="mb-3">
                            <strong>Instructor:</strong><br>
                            ${course.instructorId.fullName}
                        </div>
                        <div class="mb-3">
                            <strong>Instructor Email:</strong><br>
                            ${course.instructorId.email}
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="info-card">
                        <h4><i class="fas fa-cogs me-2 text-success"></i>Actions</h4>
                        <hr>
                        
                        <!-- Enroll Button (for students) -->
                        <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.userId != course.instructorId.userId}">
                            <button class="btn btn-primary btn-lg w-100 mb-3">
                                <i class="fas fa-user-plus me-2"></i>Enroll in Course
                            </button>
                        </c:if>

                        <!-- Instructor Actions -->
                        <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.userId == course.instructorId.userId}">
                            <a href="${pageContext.request.contextPath}/course/edit?id=${course.courseId}" 
                               class="btn btn-warning btn-lg w-100 mb-3">
                                <i class="fas fa-edit me-2"></i>Edit Course
                            </a>
                            
                            <button class="btn btn-danger btn-lg w-100 mb-3" 
                                    onclick="confirmDelete(${course.courseId})">
                                <i class="fas fa-trash me-2"></i>Delete Course
                            </button>
                        </c:if>

                        <!-- Back to Courses -->
                        <a href="${pageContext.request.contextPath}/courses" 
                           class="btn btn-outline-secondary w-100">
                            <i class="fas fa-arrow-left me-2"></i>Back to List
                        </a>
                    </div>

                    <!-- Share Course -->
                    <div class="info-card">
                        <h4><i class="fas fa-share me-2 text-info"></i>Share</h4>
                        <hr>
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-primary" onclick="shareCourse()">
                                <i class="fab fa-facebook me-2"></i>Facebook
                            </button>
                            <button class="btn btn-outline-info" onclick="shareCourse()">
                                <i class="fab fa-twitter me-2"></i>Twitter
                            </button>
                            <button class="btn btn-outline-success" onclick="copyLink()">
                                <i class="fas fa-link me-2"></i>Copy Link
                            </button>
                        </div>
                    </div>
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
                    <p>Are you sure you want to delete the course "${course.title}"?</p>
                    <p class="text-danger"><small>This action cannot be undone!</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form action="${pageContext.request.contextPath}/course/delete" method="POST" style="display: inline;">
                        <input type="hidden" name="id" value="${course.courseId}">
                        <button type="submit" class="btn btn-danger">Delete Course</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(courseId) {
            var modal = new bootstrap.Modal(document.getElementById('deleteModal'));
            modal.show();
        }

        function shareCourse() {
            // Placeholder for social media sharing
            alert('Share functionality will be developed in the next version!');
        }

        function copyLink() {
            navigator.clipboard.writeText(window.location.href).then(function() {
                alert('Course link copied!');
            }, function(err) {
                alert('Could not copy link: ' + err);
            });
        }
    </script>
</body>
</html>
