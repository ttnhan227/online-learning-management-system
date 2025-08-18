<%-- 
    Document   : dashboard
    Created on : Aug 17, 2025, 3:54:54 PM
    Author     : Admin
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Student Dashboard - Online Learning Management System</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f8f9fa;
            }
            .grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 16px;
            }
            .card {
                border: 1px solid #ddd;
                border-radius: 10px;
                padding: 16px;
                background: #fff;
            }
            .title {
                font-weight: 600;
                margin-bottom: 6px;
            }
            .meta {
                color: #666;
                font-size: 12px;
                margin-bottom: 12px;
            }
            .progress {
                background: #eee;
                border-radius: 8px;
                height: 10px;
                width: 100%;
                overflow: hidden;
                margin: 6px 0;
            }
            .progress > div {
                height: 100%;
                background: #4caf50;
            }
            .row {
                display:flex;
                align-items:center;
                gap:12px;
                margin-top: 12px;
            }
            .btn {
                padding:6px 10px;
                border:1px solid #999;
                background:#f8f8f8;
                border-radius:6px;
                cursor:pointer;
            }
            .small {
                font-size: 12px;
                color:#555;
            }
            .header {
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom: 16px;
            }
            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid #e9ecef;
            }
            
            .grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 1.5rem;
                margin-top: 1.5rem;
            }
            
            .card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                padding: 1.5rem;
                transition: transform 0.2s, box-shadow 0.2s;
                border: 1px solid #e9ecef;
            }
            
            .card:hover {
                transform: translateY(-4px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
            }
            
            .card .title {
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 0.75rem;
                color: #2d3436;
            }
            
            .card .meta {
                font-size: 0.875rem;
                color: #6c757d;
                margin-bottom: 1rem;
            }
            
            .progress-container {
                margin: 1.25rem 0;
            }
            
            .progress {
                height: 8px;
                background-color: #e9ecef;
                border-radius: 4px;
                margin-bottom: 0.5rem;
                overflow: hidden;
            }
            
            .progress > div {
                height: 100%;
                background: linear-gradient(90deg, #4e54c8, #8f94fb);
                border-radius: 4px;
                transition: width 0.3s ease;
            }
            
            .progress-text {
                display: flex;
                justify-content: space-between;
                font-size: 0.875rem;
                color: #6c757d;
                margin-bottom: 1.25rem;
            }
            
            .progress-form {
                display: flex;
                gap: 0.75rem;
                margin-top: 1rem;
            }
            
            .progress-form input[type="number"] {
                width: 80px;
                padding: 0.5rem;
                border: 1px solid #ced4da;
                border-radius: 4px;
                text-align: center;
            }
            
            .btn {
                padding: 0.5rem 1rem;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
            }
            
            .btn-primary {
                background-color: #4e54c8;
                color: white;
            }
            
            .btn-primary:hover {
                background-color: #434190;
                transform: translateY(-1px);
            }
            
            .status-badge {
                display: inline-block;
                padding: 0.25rem 0.5rem;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .status-not-started { background-color: #e9ecef; color: #495057; }
            .status-in-progress { background-color: #fff3cd; color: #856404; }
            .status-completed { background-color: #d4edda; color: #155724; }
            
            .empty-state {
                text-align: center;
                padding: 3rem 1rem;
                color: #6c757d;
                background: #f8f9fa;
                border-radius: 8px;
                margin: 2rem 0;
            }
            
            @media (max-width: 768px) {
                .grid {
                    grid-template-columns: 1fr;
                }
                
                .progress-form {
                    flex-direction: column;
                }
                
                .progress-form input[type="number"] {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/fragments/header.jsp"/>
        <main class="container main">
        <div class="dashboard-header">
            <h1 style="margin:0; font-size: 1.75rem; color: #2d3436;">My Learning Dashboard</h1>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/EnrollmentServlet?action=list">
                <i class="fas fa-list"></i> View All Enrollments
            </a>
        </div>

        <div class="grid">
            <c:forEach items="${enrollments}" var="e">
                <div class="card">
                    <div class="title">${e.courseId.title}</div>
                    <div class="meta">
                        <i class="far fa-calendar-alt"></i> Enrolled on ${e.enrolledAt}
                    </div>
                    
                    <c:choose>
                        <c:when test="${e.progress == null || e.progress <= 0}">
                            <span class="status-badge status-not-started">Not Started</span>
                        </c:when>
                        <c:when test="${e.progress >= 100}">
                            <span class="status-badge status-completed">Completed</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge status-in-progress">In Progress</span>
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="progress-container">
                        <div class="progress">
                            <div style="width: ${e.progress}%"></div>
                        </div>
                        <div class="progress-text">
                            <span>Course Progress</span>
                            <span><strong>${e.progress}%</strong> complete</span>
                        </div>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/EnrollmentServlet" class="progress-form">
                        <input type="hidden" name="action" value="updateProgress"/>
                        <input type="hidden" name="courseId" value="${e.courseId.courseId}"/>
                        <input type="number" 
                               name="progress" 
                               min="0" 
                               max="100" 
                               step="1" 
                               value="${e.progress}" 
                               class="form-control"
                               aria-label="Progress percentage" />
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-save"></i> Update
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty enrollments}">
            <div class="empty-state">
                <i class="fas fa-book-open fa-3x mb-3" style="color: #6c757d;"></i>
                <h3 style="color: #2d3436;">No Enrollments Yet</h3>
                <p>You haven't enrolled in any courses yet. Start your learning journey today!</p>
                <a href="${pageContext.request.contextPath}/course/list.jsp" class="btn btn-primary">
                    <i class="fas fa-search"></i> Browse Course Catalog
                </a>
            </div>
        </c:if>
        </main>
        <jsp:include page="/WEB-INF/fragments/footer.jsp"/>
    </body>
</html>