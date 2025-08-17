<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Course - Online Learning Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .create-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
        }
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }
        .character-count {
            font-size: 0.875rem;
            color: #6c757d;
        }
        .character-count.warning {
            color: #ffc107;
        }
        .character-count.danger {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/HomeServlet">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/courses">Courses</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/instructor/dashboard">Dashboard</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
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
                </ul>
            </div>
        </div>
    </nav>

    <!-- Create Course Header -->
    <section class="create-header">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/courses" class="text-white">Courses</a></li>
                            <li class="breadcrumb-item active text-white" aria-current="page">Create New Course</li>
                        </ol>
                    </nav>
                    <h1 class="display-4 mb-3">Create New Course</h1>
                    <p class="lead">Share your knowledge with the learning community</p>
                </div>
                <div class="col-lg-4 text-center">
                    <i class="fas fa-plus-circle fa-5x"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Create Course Form -->
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Error Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="form-card">
                    <h3 class="mb-4"><i class="fas fa-edit me-2 text-primary"></i>Course Information</h3>
                    
                    <form action="${pageContext.request.contextPath}/course/create" method="POST" id="createCourseForm">
                        <!-- Course Title -->
                        <div class="mb-4">
                            <label for="title" class="form-label">
                                <strong>Course Title <span class="text-danger">*</span></strong>
                            </label>
                            <input type="text" class="form-control form-control-lg" id="title" name="title" 
                                   placeholder="Enter course title..." required maxlength="200"
                                   value="${param.title}">
                            <div class="character-count mt-1">
                                <span id="titleCount">0</span>/200 characters
                            </div>
                            <div class="form-text">
                                <i class="fas fa-lightbulb me-1"></i>
                                Title should be concise and compelling
                            </div>
                        </div>

                        <!-- Course Description -->
                        <div class="mb-4">
                            <label for="description" class="form-label">
                                <strong>Course Description <span class="text-danger">*</span></strong>
                            </label>
                            <textarea class="form-control" id="description" name="description" rows="6" 
                                      placeholder="Provide a detailed description of the course, content to be learned, and goals to be achieved..." 
                                      required maxlength="1000">${param.description}</textarea>
                            <div class="character-count mt-1">
                                <span id="descriptionCount">0</span>/1000 characters
                            </div>
                            <div class="form-text">
                                <i class="fas fa-info-circle me-1"></i>
                                A detailed description will help students better understand the course
                            </div>
                        </div>

                        <!-- Prerequisites -->
                        <div class="mb-4">
                            <label for="prerequisites" class="form-label">
                                <strong>Prerequisites</strong>
                            </label>
                            <textarea class="form-control" id="prerequisites" name="prerequisites" rows="4" 
                                      placeholder="Examples: Basic programming knowledge, Basic mathematics..." 
                                      maxlength="500">${param.prerequisites}</textarea>
                            <div class="character-count mt-1">
                                <span id="prerequisitesCount">0</span>/500 characters
                            </div>
                            <div class="form-text">
                                <i class="fas fa-list-check me-1"></i>
                                List the knowledge or skills required before participating in the course
                            </div>
                        </div>

                        <!-- Course Category (Placeholder for future) -->
                        <div class="mb-4">
                            <label for="category" class="form-label">
                                <strong>Course Category</strong>
                            </label>
                            <select class="form-select" id="category" name="category">
                                <option value="">Select a category...</option>
                                <option value="programming">Programming</option>
                                <option value="design">Design</option>
                                <option value="business">Business</option>
                                <option value="language">Foreign Language</option>
                                <option value="other">Other</option>
                            </select>
                            <div class="form-text">
                                <i class="fas fa-tags me-1"></i>
                                Select a category to make it easier for students to find
                            </div>
                        </div>

                        <!-- Course Level (Placeholder for future) -->
                        <div class="mb-4">
                            <label for="level" class="form-label">
                                <strong>Course Level</strong>
                            </label>
                            <select class="form-select" id="level" name="level">
                                <option value="">Select a level...</option>
                                <option value="beginner">Beginner</option>
                                <option value="intermediate">Intermediate</option>
                                <option value="advanced">Advanced</option>
                            </select>
                            <div class="form-text">
                                <i class="fas fa-chart-line me-1"></i>
                                Determine the difficulty level of the course
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-between align-items-center pt-4">
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-secondary btn-lg">
                                <i class="fas fa-arrow-left me-2"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>Create Course
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Tips Card -->
                <div class="form-card">
                    <h4><i class="fas fa-lightbulb me-2 text-warning"></i>Tips for Creating a Course</h4>
                    <hr>
                    <div class="row">
                        <div class="col-md-6">
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Short and compelling title</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Detailed and clear description</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Complete prerequisite list</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Select an appropriate category</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Determine the correct level</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Thoroughly check information before creating</li>
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
        // Character count functionality
        function updateCharacterCount(inputId, countId, maxLength) {
            const input = document.getElementById(inputId);
            const count = document.getElementById(countId);
            const countElement = count.parentElement;
            
            input.addEventListener('input', function() {
                const currentLength = this.value.length;
                count.textContent = currentLength;
                
                // Update color based on usage
                countElement.className = 'character-count mt-1';
                if (currentLength > maxLength * 0.8) {
                    countElement.classList.add('warning');
                }
                if (currentLength > maxLength * 0.95) {
                    countElement.classList.remove('warning');
                    countElement.classList.add('danger');
                }
            });
            
            // Initialize count
            count.textContent = input.value.length;
        }

        // Initialize character counters
        updateCharacterCount('title', 'titleCount', 200);
        updateCharacterCount('description', 'descriptionCount', 1000);
        updateCharacterCount('prerequisites', 'prerequisitesCount', 500);

        // Form validation
        document.getElementById('createCourseForm').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const description = document.getElementById('description').value.trim();
            
            if (!title) {
                e.preventDefault();
                alert('Please enter a course title!');
                document.getElementById('title').focus();
                return false;
            }
            
            if (!description) {
                e.preventDefault();
                alert('Please enter a course description!');
                document.getElementById('description').focus();
                return false;
            }
            
            if (title.length < 10) {
                e.preventDefault();
                alert('Course title must be at least 10 characters!');
                document.getElementById('title').focus();
                return false;
            }
            
            if (description.length < 50) {
                e.preventDefault();
                alert('Course description must be at least 50 characters!');
                document.getElementById('description').focus();
                return false;
            }
        });
    </script>
</body>
</html>
