<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results - "${searchTerm}" - Online Learning Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .search-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
        }
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
        .search-highlight {
            background-color: #fff3cd;
            padding: 2px 4px;
            border-radius: 3px;
        }
        .filter-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .no-results {
            text-align: center;
            padding: 4rem 0;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <i class="fas fa-graduation-cap me-2"></i>EduLMS
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/HomeServlet">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/courses">Courses</a>
                    </li>
                    <c:if test="${not empty sessionScope.currentUser}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/instructor/dashboard">Dashboard</a>
                        </li>
                    </c:if>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user me-1"></i>${sessionScope.currentUser.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout">Logout</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/auth/register">Register</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Search Header -->
    <section class="search-header">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb justify-content-center">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/courses" class="text-white">Courses</a></li>
                            <li class="breadcrumb-item active text-white" aria-current="page">Search</li>
                        </ol>
                    </nav>
                    <h1 class="display-4 mb-4">Search Results</h1>
                    <p class="lead mb-4">Found <strong>${resultCount}</strong> courses for keyword "<strong>${searchTerm}</strong>"</p>
                    
                    <!-- Search Form -->
                    <form action="${pageContext.request.contextPath}/course/search" method="GET" class="d-flex">
                        <input type="text" name="q" class="form-control form-control-lg me-2" 
                               placeholder="Search courses..." required value="${searchTerm}">
                        <button type="submit" class="btn btn-light btn-lg">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Search Results -->
    <div class="container py-5">
        <div class="row">
            <!-- Filters Sidebar -->
            <div class="col-lg-3">
                <div class="filter-card">
                    <h5><i class="fas fa-filter me-2 text-primary"></i>Filters</h5>
                    <hr>
                    
                    <!-- Category Filter -->
                    <div class="mb-3">
                        <label class="form-label"><strong>Category</strong></label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterProgramming">
                            <label class="form-check-label" for="filterProgramming">
                                Programming
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterDesign">
                            <label class="form-check-label" for="filterDesign">
                                Design
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterBusiness">
                            <label class="form-check-label" for="filterBusiness">
                                Business
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterLanguage">
                            <label class="form-check-label" for="filterLanguage">
                                Language
                            </label>
                        </div>
                    </div>

                    <!-- Level Filter -->
                    <div class="mb-3">
                        <label class="form-label"><strong>Level</strong></label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterBeginner">
                            <label class="form-check-label" for="filterBeginner">
                                Beginner
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterIntermediate">
                            <label class="form-check-label" for="filterIntermediate">
                                Intermediate
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterAdvanced">
                            <label class="form-check-label" for="filterAdvanced">
                                Advanced
                            </label>
                        </div>
                    </div>

                    <!-- Clear Filters -->
                    <button class="btn btn-outline-secondary btn-sm w-100" onclick="clearFilters()">
                        <i class="fas fa-times me-1"></i>Clear Filters
                    </button>
                </div>

                <!-- Search Tips -->
                <div class="filter-card">
                    <h6><i class="fas fa-lightbulb me-2 text-warning"></i>Search Tips</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><i class="fas fa-check text-success me-1"></i>Use specific keywords</li>
                        <li class="mb-2"><i class="fas fa-check text-success me-1"></i>Try synonyms</li>
                        <li class="mb-2"><i class="fas fa-check text-success me-1"></i>Check spelling</li>
                    </ul>
                </div>
            </div>

            <!-- Results Column -->
            <div class="col-lg-9">
                <!-- Results Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3>Search Results</h3>
                        <p class="text-muted mb-0">
                            Showing <strong>${resultCount}</strong> courses for "<strong>${searchTerm}</strong>"
                        </p>
                    </div>
                    <div class="d-flex align-items-center">
                        <label class="form-label me-2 mb-0">Sort by:</label>
                        <select class="form-select form-select-sm" style="width: auto;">
                            <option>Latest</option>
                            <option>Oldest</option>
                            <option>A-Z</option>
                            <option>Z-A</option>
                        </select>
                    </div>
                </div>

                <!-- No Results -->
                <c:if test="${empty courses}">
                    <div class="no-results">
                        <i class="fas fa-search fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">No courses found</h4>
                        <p class="text-muted">Try searching with different keywords or check spelling</p>
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary">
                                <i class="fas fa-arrow-left me-2"></i>View All Courses
                            </a>
                        </div>
                    </div>
                </c:if>

                <!-- Course Results -->
                <div class="row">
                    <c:forEach var="course" items="${courses}">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="card course-card h-100">
                                <div class="course-image">
                                    <i class="fas fa-graduation-cap"></i>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title">
                                        ${course.title}
                                    </h5>
                                    <p class="card-text text-muted">
                                        <c:choose>
                                            <c:when test="${course.description.length() > 100}">
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
                                        <a href="${pageContext.request.contextPath}/course/view?id=${course.courseId}" 
                                           class="btn btn-outline-primary btn-sm">
                                            View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Related Searches -->
                <c:if test="${not empty courses}">
                    <div class="mt-5">
                        <h5><i class="fas fa-lightbulb me-2 text-info"></i>Related Searches</h5>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="${pageContext.request.contextPath}/course/search?q=programming" class="btn btn-outline-secondary btn-sm">
                                Programming
                            </a>
                            <a href="${pageContext.request.contextPath}/course/search?q=design" class="btn btn-outline-secondary btn-sm">
                                Design
                            </a>
                            <a href="${pageContext.request.contextPath}/course/search?q=business" class="btn btn-outline-secondary btn-sm">
                                Business
                            </a>
                            <a href="${pageContext.request.contextPath}/course/search?q=language" class="btn btn-outline-secondary btn-sm">
                                Language
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>EduLMS</h5>
                    <p>Modern Online Learning Management System</p>
                </div>
                <div class="col-md-6 text-end">
                    <p>&copy; 2024 EduLMS. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function clearFilters() {
            // Clear all checkboxes
            document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
                checkbox.checked = false;
            });
            
            // You can add AJAX call here to refresh results without filters
            alert('Filters cleared!');
        }

        // Add filter functionality (placeholder for future implementation)
        document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                // Add AJAX call here to filter results
                console.log('Filter changed:', this.id, this.checked);
            });
        });
    </script>
</body>
</html>
