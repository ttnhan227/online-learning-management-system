<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% request.setAttribute("activePage", "dashboard"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Course - ${course.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .edit-header {
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
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            border: none;
            color: #212529;
        }
        .btn-warning:hover {
            background: linear-gradient(135deg, #e0a800 0%, #c69500 100%);
            color: #212529;
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
        .course-preview {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/header.jsp"/>

    <!-- Edit Course Header -->
    <section class="edit-header">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/courses" class="text-white">Courses</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/course/view?id=${course.courseId}" class="text-white">${course.title}</a></li>
                            <li class="breadcrumb-item active text-white" aria-current="page">Edit</li>
                        </ol>
                    </nav>
                    <h1 class="display-4 mb-3">Edit Course</h1>
                    <p class="lead">Update course information</p>
                </div>
                <div class="col-lg-4 text-center">
                    <i class="fas fa-edit fa-5x"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Edit Course Form -->
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

                <!-- Course Preview -->
                <div class="course-preview">
                    <h4><i class="fas fa-eye me-2 text-info"></i>Preview Course</h4>
                    <hr>
                    <div class="row">
                        <div class="col-md-8">
                            <h5 id="previewTitle">${course.title}</h5>
                            <p id="previewDescription" class="text-muted">${course.description}</p>
                            <small class="text-muted">
                                <i class="fas fa-user me-1"></i>Instructor: ${course.instructorId.fullName}
                            </small>
                        </div>
                        <div class="col-md-4 text-end">
                            <span class="badge bg-primary">ID: ${course.courseId}</span>
                        </div>
                    </div>
                </div>

                <div class="form-card">
                    <h3 class="mb-4"><i class="fas fa-edit me-2 text-warning"></i>Course Information</h3>
                    
                    <form action="${pageContext.request.contextPath}/course/edit" method="POST" id="editCourseForm">
                        <input type="hidden" name="courseId" value="${course.courseId}">
                        
                        <!-- Course Title -->
                        <div class="mb-4">
                            <label for="title" class="form-label">
                                <strong>Course Title <span class="text-danger">*</span></strong>
                            </label>
                            <input type="text" class="form-control form-control-lg" id="title" name="title" 
                                   placeholder="Enter course title..." required maxlength="200"
                                   value="${course.title}">
                            <div class="character-count mt-1">
                                <span id="titleCount">${course.title.length()}</span>/200 characters
                            </div>
                            <div class="form-text">
                                <i class="fas fa-lightbulb me-1"></i>
                                Title should be concise, clear, and attractive
                            </div>
                        </div>

                        <!-- Course Description -->
                        <div class="mb-4">
                            <label for="description" class="form-label">
                                <strong>Course Description <span class="text-danger">*</span></strong>
                            </label>
                            <textarea class="form-control" id="description" name="description" rows="6" 
                                      placeholder="Provide detailed course description, content to be learned, and goals to be achieved..." 
                                      required maxlength="1000">${course.description}</textarea>
                            <div class="character-count mt-1">
                                <span id="descriptionCount">${course.description.length()}</span>/1000 characters
                            </div>
                            <div class="form-text">
                                <i class="fas fa-info-circle me-1"></i>
                                Detailed description will help students better understand the course
                            </div>
                        </div>

                        <!-- Prerequisites -->
                        <div class="mb-4">
                            <label for="prerequisites" class="form-label">
                                <strong>Prerequisites</strong>
                            </label>
                            <textarea class="form-control" id="prerequisites" name="prerequisites" rows="4" 
                                      placeholder="Examples: Basic programming knowledge, Basic mathematics..." 
                                      maxlength="500">${course.prerequisites}</textarea>
                            <div class="character-count mt-1">
                                <span id="prerequisitesCount">${course.prerequisites.length()}</span>/500 characters
                            </div>
                            <div class="form-text">
                                <i class="fas fa-list-check me-1"></i>
                                List the knowledge or skills needed before participating in the course
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
                                <option value="language">Language</option>
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
                            <a href="${pageContext.request.contextPath}/course/view?id=${course.courseId}" 
                               class="btn btn-outline-secondary btn-lg">
                                <i class="fas fa-arrow-left me-2"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-warning btn-lg">
                                <i class="fas fa-save me-2"></i>Update Course
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Course Statistics -->
                <div class="form-card">
                    <h4><i class="fas fa-chart-bar me-2 text-success"></i>Course Statistics</h4>
                    <hr>
                    <div class="row text-center">
                        <div class="col-md-4">
                            <div class="border rounded p-3">
                                <i class="fas fa-calendar fa-2x text-primary mb-2"></i>
                                <h5>Created Date</h5>
                                <p class="text-muted">${course.createdAt}</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="border rounded p-3">
                                <i class="fas fa-user fa-2x text-success mb-2"></i>
                                <h5>Instructor</h5>
                                <p class="text-muted">${course.instructorId.fullName}</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="border rounded p-3">
                                <i class="fas fa-edit fa-2x text-warning mb-2"></i>
                                <h5>Last Edited</h5>
                                <p class="text-muted">First edit</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/fragments/footer.jsp"/>
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
        }

        // Real-time preview update
        function updatePreview() {
            const title = document.getElementById('title').value;
            const description = document.getElementById('description').value;
            
            document.getElementById('previewTitle').textContent = title || 'Course Title';
            document.getElementById('previewDescription').textContent = description || 'Course Description';
        }

        // Initialize character counters
        updateCharacterCount('title', 'titleCount', 200);
        updateCharacterCount('description', 'descriptionCount', 1000);
        updateCharacterCount('prerequisites', 'prerequisitesCount', 500);

        // Add preview update listeners
        document.getElementById('title').addEventListener('input', updatePreview);
        document.getElementById('description').addEventListener('input', updatePreview);

        // Form validation
        document.getElementById('editCourseForm').addEventListener('submit', function(e) {
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
