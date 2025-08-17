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
        <title>My Enrollments</title>
        <style>
            body {
                font-family: system-ui, Arial, sans-serif;
                margin: 24px;
            }
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th, td {
                padding: 10px 12px;
                border-bottom: 1px solid #ddd;
                text-align: left;
            }
            .btn {
                padding: 6px 10px;
                border: 1px solid #999;
                background: #f8f8f8;
                border-radius: 6px;
                cursor: pointer;
            }
            .btn-danger {
                border-color: #cc0000;
                color: #cc0000;
                background: #fff5f5;
            }
            .progress {
                background: #eee;
                border-radius: 8px;
                height: 10px;
                width: 160px;
                overflow: hidden;
            }
            .progress > div {
                height: 100%;
                background: #4caf50;
            }
            .topbar {
                margin-bottom: 16px;
                display: flex;
                gap: 12px;
                align-items: center;
            }
            .error {
                color: #b00020;
                margin: 12px 0;
            }
        </style>
    </head>
    <body>
        <div class="topbar">
            <h2 style="margin:0;">My Enrolled Courses</h2>
            <a class="btn" href="${pageContext.request.contextPath}/EnrollmentServlet?action=dashboard">Dashboard</a>
        </div>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>Course</th>
                    <th>Enrolled At</th>
                    <th>Status</th>
                    <th>Progress</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${enrollments}" var="e">
                    <tr>
                        <td>
                            <!-- e.courseId là Course -->
                            <a href="${pageContext.request.contextPath}/course/view.jsp?courseId=${e.courseId.courseId}">
                                ${e.courseId.title}
                            </a>
                        </td>
                        <td>${e.enrolledAt}</td>
                        <td>
                            <c:choose>
                                <c:when test="${e.progress == null || e.progress <= 0}">Not started</c:when>
                                <c:when test="${e.progress >= 100}">Completed</c:when>
                                <c:otherwise>In progress</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="progress">
                                <div style="width:${e.progress}%"></div>
                            </div>
                            <small>${e.progress}%</small>
                        </td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/EnrollmentServlet" style="display:inline;">
                                <input type="hidden" name="action" value="unenroll"/>
                                <input type="hidden" name="courseId" value="${e.courseId.courseId}"/>
                                <button class="btn btn-danger" type="submit">Unenroll</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty enrollments}">
                    <tr><td colspan="5"><em>You are not enrolled in any courses yet.</em></td></tr>
                </c:if>
            </tbody>
        </table>
    </body>
</html>