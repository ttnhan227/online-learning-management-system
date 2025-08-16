<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Online Learning Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .error-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
        }
        .error-card {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-align: center;
            margin: 2rem 0;
        }
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 2rem;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/courses">Courses</a>
                    </li>
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

    <!-- Error Header -->
    <section class="error-header">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <h1 class="display-4 mb-3">An Error Occurred</h1>
                    <p class="lead">Sorry, something went wrong</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Error Content -->
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="error-card">
                    <div class="error-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    
                    <c:if test="${not empty error}">
                        <h3 class="text-danger mb-3">${error}</h3>
                    </c:if>
                    
                    <c:if test="${empty error}">
                        <h3 class="text-danger mb-3">An unexpected error occurred</h3>
                    </c:if>
                    
                    <p class="lead text-muted mb-4">
                        Please try again or contact the administrator if the problem persists.
                    </p>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/HomeServlet" class="btn btn-primary btn-lg w-100">
                                <i class="fas fa-home me-2"></i>Back to Home
                            </a>
                        </div>
                        <div class="col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-primary btn-lg w-100">
                                <i class="fas fa-book me-2"></i>View Courses
                            </a>
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="row text-start">
                        <div class="col-md-6">
                            <h5><i class="fas fa-lightbulb me-2 text-warning"></i>You can try:</h5>
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Refresh the page</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Check your internet connection</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Clear browser cache</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="fas fa-info-circle me-2 text-info"></i>Error Information:</h5>
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="fas fa-clock me-2 text-muted"></i>Time: <span id="errorTime"></span></li>
                                <li class="mb-2"><i class="fas fa-link me-2 text-muted"></i>URL: <span id="errorUrl"></span></li>
                                <li class="mb-2"><i class="fas fa-user me-2 text-muted"></i>User: <span id="errorUser"></span></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>EduLMS</h5>
                    <p>Modern online learning management system</p>
                </div>
                <div class="col-md-6 text-end">
                    <p>&copy; 2024 EduLMS. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Display error information
        document.getElementById('errorTime').textContent = new Date().toLocaleString('en-US');
        document.getElementById('errorUrl').textContent = window.location.href;
        document.getElementById('errorUser').textContent = '${sessionScope.currentUser.fullName}' || 'Guest';
        
        // Auto redirect after 10 seconds
        setTimeout(function() {
            window.location.href = '${pageContext.request.contextPath}/home';
        }, 10000);
    </script>
</body>
</html>
