<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% request.setAttribute("activePage", ""); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Online Learning Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }
        .error-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        .error-card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
        }
        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-title {
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-message {
            margin-bottom: 30px;
            font-size: 1.1rem;
        }
        .btn-action {
            margin: 5px;
            min-width: 150px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-card">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            
            <h1 class="error-title">
                <c:choose>
                    <c:when test="${not empty requestScope['jakarta.servlet.error.message']}">
                        ${requestScope['jakarta.servlet.error.message']}
                    </c:when>
                    <c:when test="${not empty error}">
                        ${error}
                    </c:when>
                    <c:otherwise>
                        An Unexpected Error Occurred
                    </c:otherwise>
                </c:choose>
            </h1>
            
            <p class="error-message">
                We're sorry, but something went wrong while processing your request.
                Our team has been notified and we're working to fix the issue.
            </p>
                    
                    <p class="lead text-muted mb-4">
                        Please try again or contact the administrator if the problem persists.
                    </p>
                    
                    <div class="d-flex flex-wrap justify-content-center gap-3 mt-4">
                        <a href="${pageContext.request.contextPath}/HomeServlet" class="btn btn-primary btn-action">
                            <i class="fas fa-home me-2"></i>Back to Home
                        </a>
                        <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-primary btn-action">
                            <i class="fas fa-book me-2"></i>Browse Courses
                        </a>
                        <a href="#" onclick="window.history.back()" class="btn btn-outline-secondary btn-action">
                            <i class="fas fa-arrow-left me-2"></i>Go Back
                        </a>
                    </div>
                    
                    <div class="mt-5 text-start bg-light p-3 rounded">
                        <h5><i class="fas fa-bug me-2 text-warning"></i>Technical Details</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <ul class="list-unstyled">
                                    <li class="mb-2"><strong>URL:</strong> <span id="errorUrl" class="text-muted"></span></li>
                                    <li class="mb-2"><strong>User:</strong> <span id="errorUser" class="text-muted">${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName : 'Guest'}</span></li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <ul class="list-unstyled">
                                    <c:if test="${not empty requestScope['jakarta.servlet.error.status_code']}">
                                        <li class="mb-2"><strong>Status Code:</strong> ${requestScope['jakarta.servlet.error.status_code']}</li>
                                    </c:if>
                                    <c:if test="${not empty requestScope['jakarta.servlet.error.exception_type']}">
                                        <li class="mb-2"><strong>Exception Type:</strong> ${requestScope['jakarta.servlet.error.exception_type']}</li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Display error information
        document.getElementById('errorUrl').textContent = window.location.href;
    </script>
</body>
</html>
