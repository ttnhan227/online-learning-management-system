<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
    .admin-sidebar {
        background-color: #343a40; /* Dark background for sidebar */
        color: white;
        padding-top: 1rem;
        height: 100vh; /* Full height sidebar */
        position: sticky;
        top: 0;
        left: 0;
        overflow-y: auto; /* Enable scrolling for long content */
    }
    .admin-sidebar .nav-link {
        color: #adb5bd; /* Light grey for inactive links */
        padding: 0.75rem 1rem;
        display: flex;
        align-items: center;
        transition: all 0.3s ease;
    }
    .admin-sidebar .nav-link:hover,
    .admin-sidebar .nav-link.active {
        color: white;
        background-color: #4e54c8; /* Primary color for active/hover */
        border-radius: 5px;
    }
    .admin-sidebar .nav-link i {
        margin-right: 0.75rem;
        font-size: 1.1rem;
    }
    .admin-sidebar .sidebar-heading {
        color: #ced4da;
        font-size: 0.85rem;
        padding: 0.5rem 1rem;
        margin-top: 1rem;
        margin-bottom: 0.5rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }
    .admin-sidebar .list-group-item {
        background-color: transparent;
        border: none;
        padding: 0;
    }
</style>

<nav class="admin-sidebar">
    <div class="p-3">
        <h4 class="text-white text-center mb-4">Admin Panel</h4>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link ${activePage eq 'admin-dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage eq 'admin-users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                    <i class="fas fa-users"></i> Users
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage eq 'admin-instructors' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/instructors">
                    <i class="fas fa-chalkboard-teacher"></i> Instructors
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage eq 'admin-students' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/students">
                    <i class="fas fa-user-graduate"></i> Students
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/courses">
                    <i class="fas fa-book"></i> Courses
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">
                    <i class="fas fa-tags"></i> Categories
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/settings">
                    <i class="fas fa-cog"></i> Settings
                </a>
            </li>
        </ul>
        <hr class="border-secondary">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </div>
</nav>
