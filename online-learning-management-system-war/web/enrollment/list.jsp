<%-- 
    Document   : list
    Created on : Aug 17, 2025, 3:53:22 PM
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Enrollments - Online Learning Management System</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <style>
            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f8fafc;
                color: #1e293b;
                line-height: 1.5;
            }
            
            /* Layout */
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 1.5rem;
            }
            
            /* Header */
            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin: 2rem 0;
                padding-bottom: 1.5rem;
                border-bottom: 1px solid #e2e8f0;
            }
            
            .page-title {
                margin: 0;
                font-size: 1.75rem;
                font-weight: 700;
                color: #1e293b;
            }
            
            /* Buttons */
            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
                padding: 0.625rem 1.25rem;
                border: none;
                border-radius: 8px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
                text-decoration: none;
                font-size: 0.9375rem;
            }
            
            .btn-primary {
                background-color: #4e54c8;
                color: white;
            }
            
            .btn-primary:hover {
                background-color: #434190;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(78, 84, 200, 0.2);
            }
            
            .btn-outline {
                background: transparent;
                border: 1px solid #cbd5e1;
                color: #475569;
            }
            
            .btn-outline:hover {
                background-color: #f1f5f9;
                border-color: #94a3b8;
            }
            
            .btn-danger {
                background-color: #fee2e2;
                color: #dc2626;
                padding: 0.5rem 1rem;
                font-size: 0.875rem;
            }
            
            .btn-danger:hover {
                background-color: #fecaca;
            }
            
            /* Table */
            .enrollments-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            }
            
            .enrollments-table thead {
                background-color: #f8fafc;
                border-bottom: 1px solid #e2e8f0;
            }
            
            .enrollments-table th {
                padding: 1rem 1.5rem;
                text-align: left;
                font-weight: 600;
                color: #475569;
                font-size: 0.875rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }
            
            .enrollments-table td {
                padding: 1.25rem 1.5rem;
                border-bottom: 1px solid #f1f5f9;
                vertical-align: middle;
            }
            
            .enrollments-table tbody tr:last-child td {
                border-bottom: none;
            }
            
            .enrollments-table tbody tr:hover {
                background-color: #f8fafc;
            }
            
            /* Status Badges */
            .status-badge {
                display: inline-flex;
                align-items: center;
                padding: 0.375rem 0.75rem;
                border-radius: 9999px;
                font-size: 0.8125rem;
                font-weight: 600;
                line-height: 1;
            }
            
            .status-pending {
                background-color: #fef3c7;
                color: #92400e;
            }
            
            .status-active {
                background-color: #dcfce7;
                color: #166534;
            }
            
            .status-completed {
                background-color: #e0f2fe;
                color: #075985;
            }
            
            /* Progress */
            .progress-container {
                display: flex;
                align-items: center;
                gap: 1rem;
                min-width: 200px;
            }
            
            .progress {
                flex: 1;
                height: 8px;
                background-color: #e2e8f0;
                border-radius: 4px;
                overflow: hidden;
            }
            
            .progress-bar {
                height: 100%;
                background: linear-gradient(90deg, #4e54c8, #8f94fb);
                border-radius: 4px;
                transition: width 0.3s ease;
            }
            
            .progress-text {
                font-size: 0.875rem;
                color: #64748b;
                min-width: 3rem;
                text-align: right;
            }
            
            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 4rem 2rem;
                background: white;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            }
            
            .empty-state i {
                font-size: 3rem;
                color: #cbd5e1;
                margin-bottom: 1.5rem;
            }
            
            .empty-state h3 {
                margin: 0 0 0.5rem;
                color: #1e293b;
            }
            
            .empty-state p {
                color: #64748b;
                margin: 0 0 1.5rem;
                max-width: 400px;
                margin-left: auto;
                margin-right: auto;
            }
            
            /* Error Message */
            .alert-error {
                padding: 1rem;
                background-color: #fef2f2;
                color: #991b1b;
                border-radius: 8px;
                margin-bottom: 1.5rem;
                border-left: 4px solid #dc2626;
            }
            
            /* Responsive */
            @media (max-width: 768px) {
                .page-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 1rem;
                }
                
                .progress-container {
                    min-width: 0;
                }
                
                .enrollments-table {
                    display: block;
                    overflow-x: auto;
                    -webkit-overflow-scrolling: touch;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/fragments/header.jsp"/>
        <main class="container main">
        <div class="page-header">
            <h1 class="page-title">My Enrolled Courses</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=dashboard" class="btn btn-outline">
                    <i class="fas fa-tachometer-alt"></i> Go to your Dashboard
                </a>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty enrollments}">
                <div class="table-responsive">
                    <table class="enrollments-table">
                        <thead>
                            <tr>
                                <th>Course</th>
                                <th>Enrolled On</th>
                                <th>Status</th>
                                <th>Progress</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${enrollments}" var="e">
                                <tr>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/course/view.jsp?courseId=${e.courseId.courseId}" 
                                           class="font-medium text-slate-800 hover:text-indigo-600">
                                            ${e.courseId.title}
                                        </a>
                                    </td>
                                    <td>
                                        <span class="text-slate-600">
                                            <i class="far fa-calendar-alt mr-1"></i> ${e.enrolledAt}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${e.progress == null || e.progress <= 0}">
                                                <span class="status-badge status-pending">
                                                    <i class="far fa-clock mr-1"></i> Not Started
                                                </span>
                                            </c:when>
                                            <c:when test="${e.progress >= 100}">
                                                <span class="status-badge status-completed">
                                                    <i class="fas fa-check-circle mr-1"></i> Completed
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-active">
                                                    <i class="fas fa-spinner mr-1"></i> In Progress
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="progress-container">
                                            <div class="progress">
                                                <div class="progress-bar" style="width: ${e.progress}%"></div>
                                            </div>
                                            <span class="progress-text">${e.progress}%</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="flex items-center gap-2">
                                            <a href="${pageContext.request.contextPath}/course/view.jsp?courseId=${e.courseId.courseId}" 
                                               class="btn btn-outline btn-sm" 
                                               title="View Course">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <form method="post" action="${pageContext.request.contextPath}/EnrollmentServlet" class="inline">
                                                <input type="hidden" name="action" value="unenroll"/>
                                                <input type="hidden" name="courseId" value="${e.courseId.courseId}"/>
                                                <button type="submit" 
                                                        class="btn btn-danger btn-sm" 
                                                        title="Unenroll"
                                                        onclick="return confirm('Are you sure you want to unenroll from this course?')">
                                                    <i class="fas fa-sign-out-alt"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h3>You are not enrolled in any courses yet.</h3>
                    <p>Start exploring our courses and enroll in the ones that interest you.</p>
                </div>
            </c:otherwise>
        </c:choose>
        </main>
        <jsp:include page="/WEB-INF/fragments/footer.jsp"/>
    </body>
</html>