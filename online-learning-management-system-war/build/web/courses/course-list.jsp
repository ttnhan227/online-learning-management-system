<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% request.setAttribute("activePage", "courses"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course List - Online Learning Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .course-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
            border-radius: 15px;
            overflow: hidden;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        .course-image {
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }
        .search-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .pagination .page-link {
            border-radius: 10px;
            margin: 0 2px;
            border: none;
            color: #667eea;
        }
        .pagination .page-item.active .page-link {
            background-color: #667eea;
            border-color: #667eea;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/header.jsp"/>

    <!-- Search Section -->
    <section class="search-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <h1 class="display-4 mb-4">Explore Courses</h1>
                    <p class="lead mb-4">Search and enroll in courses that suit you</p>
                    <form action="${pageContext.request.contextPath}/course/search" method="GET" class="d-flex">
                        <input type="text" name="q" class="form-control form-control-lg me-2" 
                               placeholder="Search courses..." required>
                        <button type="submit" class="btn btn-light btn-lg">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <div class="container mb-4">
        <div class="row">
            <div class="col-md-4 mb-3">
                <div class="stats-card">
                    <i class="fas fa-book-open fa-2x text-primary mb-2"></i>
                    <h4>${totalCourses}</h4>
                    <p class="text-muted mb-0">Total Courses</p>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="stats-card">
                    <i class="fas fa-users fa-2x text-success mb-2"></i>
                    <h4>${courses.size()}</h4>
                    <p class="text-muted mb-0">Current Courses</p>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="stats-card">
                    <i class="fas fa-chalkboard-teacher fa-2x text-warning mb-2"></i>
                    <h4>${totalPages}</h4>
                    <p class="text-muted mb-0">Pages</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Course List -->
    <div class="container">
        <div class="row mb-4">
            <div class="col-md-6">
                <h2>Course List</h2>
            </div>
            <div class="col-md-6 text-end">
                <c:if test="${not empty sessionScope.currentUser}">
                    <!-- Only show Create button for instructors and admins -->
                    <c:if test="${sessionScope.userHasInstructorRole or sessionScope.userHasAdminRole}">
                        <a href="${pageContext.request.contextPath}/course/create" class="btn btn-primary">
                            <i class="fas fa-plus me-1"></i>Create New Course
                        </a>
                    </c:if>
                </c:if>
            </div>
        </div>

        <c:if test="${empty courses}">
            <div class="text-center py-5">
                <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                <h4 class="text-muted">No courses available</h4>
                <p class="text-muted">Be the first to create a course!</p>
            </div>
        </c:if>

        <div class="row">
            <c:forEach var="course" items="${courses}">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="card course-card h-100">
                        <div class="course-image">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">${course.title}</h5>
                            <p class="card-text text-muted">
                                <c:choose>
                                    <c:when test="${not empty course.description && course.description.length() > 100}">
                                        ${course.description.substring(0, 100)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${course.description}
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <div class="mb-3">
                                <small class="text-muted">
                                    <i class="fas fa-user me-1"></i>${course.instructorId.fullName}
                                </small>
                            </div>
                            <c:if test="${not empty course.prerequisites}">
                                <div class="mb-3">
                                    <small class="text-info">
                                        <i class="fas fa-info-circle me-1"></i>Prerequisites: ${course.prerequisites}
                                    </small>
                                </div>
                            </c:if>
                        </div>
                        <div class="card-footer bg-transparent border-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted">
                                    <i class="fas fa-calendar me-1"></i>
                                    <fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy"/>
                                </small>
                                <div class="btn-group" role="group">
                                    <a href="${pageContext.request.contextPath}/course/view?id=${course.courseId}" 
                                       class="btn btn-outline-primary btn-sm">
                                        View Details
                                    </a>
                                    
                                    <!-- Show Edit/Delete buttons for instructors and admins -->
                                    <c:if test="${sessionScope.userHasInstructorRole or sessionScope.userHasAdminRole}">
                                        <a href="${pageContext.request.contextPath}/course/edit?id=${course.courseId}" 
                                           class="btn btn-outline-warning btn-sm">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger btn-sm" 
                                                onclick="confirmDelete('${course.courseId}', '${course.title}')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Course pagination">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${pageNum}">${pageNum}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
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
    
    <script>
        function confirmDelete(courseId, courseTitle) {
            document.getElementById('courseIdToDelete').value = courseId;
            document.getElementById('courseTitle').textContent = courseTitle;
            var modal = new bootstrap.Modal(document.getElementById('deleteModal'));
            modal.show();
        }
    </script>
</body>
</html>
