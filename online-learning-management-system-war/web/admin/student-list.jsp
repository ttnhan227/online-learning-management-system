<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% request.setAttribute("activePage", "admin-students"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Students - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .page-header {
            background: linear-gradient(135deg, #4e54c8 0%, #8f94fb 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #eee;
            font-weight: 600;
            padding: 1rem 1.25rem;
        }
        .btn-admin {
            background-color: #4e54c8;
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        .btn-admin:hover {
            background-color: #434190;
            color: white;
            transform: translateY(-2px);
        }
        .table th {
            font-weight: 600;
            border-top: none;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        .search-box {
            position: relative;
        }
        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        .search-input {
            padding-left: 40px;
        }
        .enrollment-count {
            display: inline-block;
            min-width: 25px;
            height: 25px;
            line-height: 25px;
            text-align: center;
            background-color: #4e54c8;
            color: white;
            border-radius: 50%;
            font-size: 0.8rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

        <!-- Page Content -->
        <div id="page-content-wrapper" class="flex-grow-1">
            <!-- Page Header -->
            <section class="page-header">
                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1><i class="fas fa-user-graduate me-2"></i>Student Management</h1>
                            <p class="lead mb-0">Manage all students in the system</p>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/admin" class="btn btn-light">
                                <i class="fas fa-arrow-left me-1"></i> Back to Dashboard
                            </a>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Main Content -->
            <div class="container-fluid mb-5">
                <!-- Search and Filter -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <div class="search-box">
                                    <i class="fas fa-search"></i>
                                    <input type="text" class="form-control search-input" placeholder="Search students...">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <select class="form-select">
                                    <option value="">All Students</option>
                                    <option value="active">Active</option>
                                    <option value="inactive">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Students Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">All Students</h5>
                        <div>
                            <a href="#" class="btn btn-admin">
                                <i class="fas fa-plus me-1"></i> Add New Student
                            </a>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Student</th>
                                        <th>Email</th>
                                        <th>Enrollments</th>
                                        <th>Status</th>
                                        <th>Join Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${students}" var="student">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <c:choose>
                                                        <c:when test="${not empty student.photoUrl}">
                                                            <img src="${student.photoUrl}" alt="Student Avatar" class="user-avatar me-2">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="user-avatar bg-secondary text-white d-flex align-items-center justify-content-center me-2">
                                                                ${student.fullName.charAt(0)}
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <div class="fw-medium">${student.fullName}</div>
                                                        <small class="text-muted">ID: ${student.userId}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${student.email}</td>
                                            <td>
                                                <span class="enrollment-count">${not empty student.enrollmentList ? student.enrollmentList.size() : 0}</span>
                                            </td>
                                            <td>
                                                <span class="badge bg-success">Active</span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${student.createdAt}" pattern="MMM d, yyyy"/>
                                            </td>
                                            <td>
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="studentActions${student.userId}" data-bs-toggle="dropdown" aria-expanded="false">
                                                        <i class="fas fa-ellipsis-v"></i>
                                                    </button>
                                                    <ul class="dropdown-menu" aria-labelledby="studentActions${student.userId}">
                                                        <li>
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile/view?id=${student.userId}">
                                                                <i class="far fa-eye me-2"></i>View Profile
                                                            </a>
                                                        </li>
                                                        <li>
                                                            <a class="dropdown-item" href="#">
                                                                <i class="far fa-edit me-2"></i>Edit
                                                            </a>
                                                        </li>
                                                        <li>
                                                            <a class="dropdown-item" href="#">
                                                                <i class="fas fa-book me-2"></i>View Enrollments
                                                            </a>
                                                        </li>
                                                        <li><hr class="dropdown-divider"></li>
                                                        <li>
                                                            <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/admin/users/delete?id=${student.userId}" onclick="return confirm('Are you sure you want to delete this student?')">
                                                                <i class="far fa-trash-alt me-2"></i>Delete
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty students}">
                                        <tr>
                                            <td colspan="6" class="text-center py-4">
                                                <div class="text-muted">
                                                    <i class="fas fa-user-graduate fa-3x mb-3"></i>
                                                    <p class="mb-0">No students found</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer bg-white">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center mb-0">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Previous</a>
                                </li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Show success/error messages
        document.addEventListener('DOMContentLoaded', function() {
            const successMessage = '${successMessage}';
            const errorMessage = '${errorMessage}';
            
            if (successMessage) {
                alert(successMessage);
            }
            
            if (errorMessage) {
                alert(errorMessage);
            }
        });
    </script>
</body>
</html>
