<%@ page contentType="text/html; charset=UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- Bootstrap CSS & Font Awesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

  <title>EduLMS</title>

  <style>
    :root{
      --primary-color:#4e73df;
      --secondary-color:#2e59d9;
      --text-color:#5a5c69;
      --light-gray:#f8f9fc;
      --dark-gray:#d1d3e2;
    }

    header{
      background:var(--primary-color);
      color:#fff;
      padding:1rem 0;
      box-shadow:0 0.15rem 1.75rem 0 rgba(58,59,69,.15);
    }
    header h1{ margin:0; font-size:1.8rem; font-weight:600; letter-spacing:.05em; }

    header .nav-button{
      background:#fff;
      color:var(--primary-color) !important;
      font-weight:600;
    }
    header .nav-button:hover{
      background:var(--light-gray);
    }
    header .welcome-message{
      color:#fff !important;
      font-weight:500;
    }

    nav{
      background:#fff;
      box-shadow:0 0.15rem 1.75rem 0 rgba(58,59,69,.1);
      border-bottom:1px solid var(--dark-gray);
      position: relative;
      z-index: 1; /* keep above page content */
    }

    /* ---- GRID LAYOUT ---- */
    nav .container{
      display:grid;
      grid-template-columns: 1fr auto auto; /* spacer | center | right */
      align-items:center;
      gap:.75rem 1rem;
      padding:.75rem 1rem;
    }

    /* Center the navigation */
    .nav-center{ justify-self:center; }

    nav ul{
      display:flex;
      list-style:none;
      margin:0;
      padding:0;
      align-items:center;
      gap:.5rem;
      flex-wrap:nowrap;
    }
    nav li{ display:flex; align-items:center; }

    nav a, nav .welcome-message{
      color:var(--text-color);
      text-decoration:none;
      padding:.75rem .75rem;
      display:inline-flex;
      align-items:center;
      white-space:nowrap;
      font-weight:500;
      font-size:.95rem;
      transition:all .2s;
      border-radius:.35rem;
    }
    nav a:hover, nav a:focus{ color:var(--primary-color); background-color:var(--light-gray); }
    nav a.active{ color:var(--primary-color); font-weight:600; }

    .welcome-message{
      color:#4e73df !important;
      margin-right:.25rem;
    }

    .nav-button{
      background:var(--primary-color);
      color:#fff !important;
      border:none;
      padding:.5rem 1rem !important;
      border-radius:.35rem;
      cursor:pointer;
      font-weight:500 !important;
      transition:all .2s;
    }
    .nav-button:hover{ background:var(--secondary-color); transform:translateY(-1px); }

    /* Ensure dropdowns appear above custom elements */
    .dropdown-menu { z-index: 2000; }

    /* ---- RESPONSIVE ---- */
    @media (max-width: 992px){
      nav .container{
        grid-template-columns: 1fr;     /* single column */
        justify-items:center;
        gap:.5rem;
      }
      .nav-center{ justify-self:center; }
      nav ul{ flex-wrap:wrap; justify-content:center; }
    }
  </style>
</head>
<body>

<header>
  <div class="container d-flex justify-content-between align-items-center">
    <h1 class="m-0">
      <i class="fas fa-graduation-cap me-2"></i>EduLMS
    </h1>

    <div class="d-flex align-items-center gap-3">
      <c:choose>
        <c:when test="${not empty sessionScope.currentUser or not empty sessionScope.user}">
          <div class="dropdown">
            <c:set var="currentUser" value="${not empty sessionScope.currentUser ? sessionScope.currentUser : sessionScope.user}" />
            <button
              class="btn dropdown-toggle d-flex align-items-center text-white"
              type="button"
              id="userDropdown"
              data-bs-toggle="dropdown"
              aria-expanded="false"
              style="background: none; border: none; font-weight: 500;"
            >
              <div class="profile-avatar-container me-2" style="width: 32px; height: 32px; border-radius: 50%; overflow: hidden; background-color: #f0f0f0; display: flex; align-items: center; justify-content: center;">
                <c:choose>
                  <c:when test="${not empty currentUser.photoUrl}">
                    <img src="${currentUser.photoUrl}" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                  </c:when>
                  <c:otherwise>
                    <span style="font-size: 16px; color: #666; font-weight: 600;">${currentUser.fullName.charAt(0)}</span>
                  </c:otherwise>
                </c:choose>
              </div>
              ${currentUser.fullName}
            </button>

            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
              <li>
                <c:set var="profileUserId" value="${not empty sessionScope.user ? sessionScope.user.userId : sessionScope.currentUser.userId}" />
                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile?userId=${profileUserId}">
                  <i class="fas fa-user me-2"></i> My Profile
                </a>
              </li>
              <li><hr class="dropdown-divider"></li>
              <li>
                <!-- Use a button styled like a menu item for proper semantics -->
                <form action="${pageContext.request.contextPath}/auth" method="POST" class="px-3 py-1">
                  <input type="hidden" name="action" value="Logout">
                  <button type="submit" class="btn btn-link p-0 text-decoration-none text-dark">
                    <i class="fas fa-sign-out-alt me-2"></i> Logout
                  </button>
                </form>
              </li>
            </ul>
          </div>
        </c:when>

        <c:otherwise>
          <a href="${pageContext.request.contextPath}/auth?action=Login" class="nav-button">
            <i class="fas fa-sign-in-alt me-1"></i> Login
          </a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</header>

<nav>
  <div class="container">
    <!-- Center group -->
    <ul class="nav-center">
      <li>
        <a href="${pageContext.request.contextPath}/HomeServlet" ${requestScope.activePage == 'home' ? 'class="active"' : ''}>
          <i class="fas fa-home me-1"></i> Home
        </a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/courses" ${requestScope.activePage == 'courses' ? 'class="active"' : ''}>
          <i class="fas fa-book me-1"></i> Courses
        </a>
      </li>
      <li>
        <a href="#" ${requestScope.activePage == 'about' ? 'class="active"' : ''}>
          <i class="fas fa-info-circle me-1"></i> About
        </a>
      </li>
      <li>
        <a href="#" ${requestScope.activePage == 'contact' ? 'class="active"' : ''}>
          <i class="fas fa-envelope me-1"></i> Contact
        </a>
      </li>
    </ul>

    <!-- Right-side items -->
    <ul class="nav-center">
      <c:set var="currentUser" value="${not empty sessionScope.currentUser ? sessionScope.currentUser : sessionScope.user}" />
      <c:set var="isAdmin" value="${false}" />
      <c:forEach items="${currentUser.userRoleList}" var="role">
          <c:if test="${role.roleId.roleName eq 'administrator'}">
              <c:set var="isAdmin" value="${true}" />
          </c:if>
      </c:forEach>
      
      <c:if test="${isAdmin}">
        <li>
          <a href="${pageContext.request.contextPath}/admin" ${requestScope.activePage == 'admin-dashboard' ? 'class="active"' : ''}>
            <i class="fas fa-user-shield me-1"></i> Admin Dashboard
          </a>
        </li>
      </c:if>
      
      <c:if test="${sessionScope.userHasInstructorRole == true}">
        <li>
          <a href="${pageContext.request.contextPath}/instructor/dashboard" ${requestScope.activePage == 'dashboard' ? 'class="active"' : ''}>
            <i class="fas fa-chalkboard-teacher me-1"></i> Instructor Dashboard
          </a>
        </li>
      </c:if>
      <c:if test="${not empty sessionScope.currentUser or not empty sessionScope.user}">
        <li>
          <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=list" ${requestScope.activePage == 'enrollments' ? 'class="active"' : ''}>
            <i class="fas fa-list-alt me-1"></i> My Enrollments
          </a>
        </li>
      </c:if>
    </ul>
  </div>
</nav>



  <!-- jQuery first, then Bootstrap Bundle with Popper -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    // Initialize dropdowns explicitly
    document.addEventListener('DOMContentLoaded', function() {
      var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
      var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
        return new bootstrap.Dropdown(dropdownToggleEl);
      });
    });
  </script>
</body>
</html>
