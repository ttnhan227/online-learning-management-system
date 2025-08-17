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
        <title>Student Dashboard</title>
        <style>
            body {
                font-family: system-ui, Arial, sans-serif;
                margin: 24px;
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
            input[type=number]{
                width: 80px;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h2 style="margin:0;">Student Dashboard</h2>
            <a class="btn" href="${pageContext.request.contextPath}/EnrollmentServlet?action=list">Back to Enrollments</a>
        </div>

        <div class="grid">
            <c:forEach items="${enrollments}" var="e">
                <div class="card">
                    <div class="title">${e.courseId.title}</div>
                    <div class="meta">
                        Enrolled: ${e.enrolledAt} &middot;
                        Status:
                        <strong>
                            <c:choose>
                                <c:when test="${e.progress == null || e.progress <= 0}">Not started</c:when>
                                <c:when test="${e.progress >= 100}">Completed</c:when>
                                <c:otherwise>In progress</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                    <div class="progress"><div style="width:${e.progress}%"></div></div>
                    <div class="small">Progress: ${e.progress}%</div>

                    <form method="post" action="${pageContext.request.contextPath}/EnrollmentServlet" class="row">
                        <input type="hidden" name="action" value="updateProgress"/>
                        <input type="hidden" name="courseId" value="${e.courseId.courseId}"/>
                        <input type="number" name="progress" min="0" max="100" step="1" value="${e.progress}" />
                        <button class="btn" type="submit">Save Progress</button>
                    </form>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty enrollments}">
            <p><em>No enrollments yet. Browse the <a href="${pageContext.request.contextPath}/course/list.jsp">course catalog</a>.</em></p>
        </c:if>
    </body>
</html>