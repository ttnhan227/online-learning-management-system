<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% request.setAttribute("activePage", "admin-dashboard"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Online Learning Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .dashboard-header {
            background: linear-gradient(135deg, #4e54c8 0%, #8f94fb 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
        }
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .stats-card i {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: #4e54c8;
        }
        .stats-card h3 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .stats-card p {
            color: #6c757d;
            margin-bottom: 0;
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
        .badge-pending {
            background-color: #f6ad55;
            color: white;
        }
    </style>
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

        <!-- Page Content -->
        <div id="page-content-wrapper" class="flex-grow-1">
            <!-- Dashboard Header -->
            <section class="dashboard-header">
                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1><i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard</h1>
                            <p class="lead mb-0">Manage your learning platform</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Main Content -->
            <div class="container-fluid py-4">
                <!-- Stats Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="stats-card">
                            <i class="fas fa-users"></i>
                            <h3>${userCount}</h3>
                            <p>Total Users</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <i class="fas fa-chalkboard-teacher"></i>
                            <h3>${instructorCount}</h3>
                            <p>Instructors</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <i class="fas fa-user-graduate"></i>
                            <h3>${studentCount}</h3>
                            <p>Students</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <i class="fas fa-clock"></i>
                            <h3>${pendingInstructorCount}</h3>
                            <p>Pending Approvals</p>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Pending Approvals -->
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-clock me-2"></i>Pending Instructor Approvals</span>
                                <a href="${pageContext.request.contextPath}/admin/instructors" class="btn btn-sm btn-admin">View All</a>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${instructors}" var="instructor" end="4">
                                                <c:if test="${!instructor.isApproved}">
                                                    <tr>
                                                        <td>${instructor.fullName}</td>
                                                        <td>${instructor.email}</td>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/admin/users/approve?id=${instructor.userId}" 
                                                               class="btn btn-sm btn-success" 
                                                               onclick="return confirm('Approve this instructor?')">
                                                                <i class="fas fa-check"></i> Approve
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${empty instructors || instructors.stream().noneMatch(i -> !i.isApproved)}">
                                                <tr>
                                                    <td colspan="3" class="text-center text-muted py-3">No pending approvals</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header">
                                <i class="fas fa-bolt me-2"></i>Quick Actions
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-admin w-100 mb-2">
                                            <i class="fas fa-users me-2"></i>Manage Users
                                        </a>
                                    </div>
                                    <div class="col-md-6">
                                        <a href="${pageContext.request.contextPath}/admin/instructors" class="btn btn-admin w-100 mb-2">
                                            <i class="fas fa-chalkboard-teacher me-2"></i>Manage Instructors
                                        </a>
                                    </div>
                                    <div class="col-md-6">
                                        <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-admin w-100 mb-2">
                                            <i class="fas fa-user-graduate me-2"></i>Manage Students
                                        </a>
                                    </div>
                                    <div class="col-md-6">
                                        <a href="#" class="btn btn-admin w-100 mb-2">
                                            <i class="fas fa-cog me-2"></i>System Settings
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- System Status -->
                        <div class="card mt-4">
                            <div class="card-header">
                                <i class="fas fa-server me-2"></i>System Status
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <span>Database Status</span>
                                    <span class="badge bg-success">Connected</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <span>Server Load</span>
                                    <span class="badge bg-info">Normal</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span>Last Backup</span>
                                    <span class="text-muted small">Today, 02:30 AM</span>
                                </div>
                            </div>
                        </div>
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
