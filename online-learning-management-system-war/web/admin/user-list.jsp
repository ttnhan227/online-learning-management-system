<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% request.setAttribute("activePage", "admin-users"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Dashboard</title>
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
        .badge-role {
            padding: 0.4em 0.8em;
            font-weight: 500;
        }
        .badge-instructor {
            background-color: #4e54c8;
            color: white;
        }
        .badge-student {
            background-color: #38a169;
            color: white;
        }
        .badge-admin {
            background-color: #9f7aea;
            color: white;
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
                            <h1><i class="fas fa-users me-2"></i>User Management</h1>
                            <p class="lead mb-0">Manage all system users</p>
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
                                    <input type="text" class="form-control search-input" placeholder="Search users...">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <select class="form-select">
                                    <option value="">All Roles</option>
                                    <option value="student">Students</option>
                                    <option value="instructor">Instructors</option>
                                    <option value="admin">Admins</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">All Users</h5>
                        <div>
                            <a href="#" class="btn btn-admin">
                                <i class="fas fa-plus me-1"></i> Add New User
                            </a>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>User</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Joined Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${users}" var="user">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <c:choose>
                                                        <c:when test="${not empty user.photoUrl}">
                                                            <img src="${user.photoUrl}" alt="User Avatar" class="user-avatar me-2">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="user-avatar bg-secondary text-white d-flex align-items-center justify-content-center me-2">
                                                                ${user.fullName.charAt(0)}
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <div class="fw-medium">${user.fullName}</div>
                                                        <small class="text-muted">ID: ${user.userId}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${user.email}</td>
                                            <td>
                                                <c:forEach items="${user.userRoleList}" var="userRole">
                                                    <c:choose>
                                                        <c:when test="${userRole.roleId.roleName eq 'INSTRUCTOR'}">
                                                            <span class="badge badge-role badge-instructor">Instructor</span>
                                                        </c:when>
                                                        <c:when test="${userRole.roleId.roleName eq 'STUDENT'}">
                                                            <span class="badge badge-role badge-student">Student</span>
                                                        </c:when>
                                                        <c:when test="${userRole.roleId.roleName eq 'ADMIN'}">
                                                            <span class="badge badge-role badge-admin">Admin</span>
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.isApproved}">
                                                        <span class="badge bg-success">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${user.createdAt}" pattern="MMM d, yyyy"/>
                                            </td>
                                            <td>
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="userActions${user.userId}" data-bs-toggle="dropdown" aria-expanded="false">
                                                        <i class="fas fa-ellipsis-v"></i>
                                                    </button>
                                                    <ul class="dropdown-menu" aria-labelledby="userActions${user.userId}">
                                                        <li>
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile/view?id=${user.userId}">
                                                                <i class="far fa-eye me-2"></i>View Profile
                                                            </a>
                                                        </li>
                                                        <li>
                                                            <a class="dropdown-item" href="#">
                                                                <i class="far fa-edit me-2"></i>Edit
                                                            </a>
                                                        </li>
                                                        <c:if test="${user.userRoleList.stream().anyMatch(r -> r.roleId.roleName eq 'INSTRUCTOR') && !user.isApproved}">
                                                            <li>
                                                                <a class="dropdown-item text-success" href="${pageContext.request.contextPath}/admin/users/approve?id=${user.userId}" onclick="return confirm('Approve this instructor?')">
                                                                    <i class="fas fa-check me-2"></i>Approve Instructor
                                                                </a>
                                                    </li>
                                                </c:if>
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <a class="dropdown-item text-danger" href="#" onclick="return confirm('Are you sure you want to delete this user?')">
                                                        <i class="far fa-trash-alt me-2"></i>Delete
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
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
