<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="newLineChar" value="\n" />
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>User Profile - Online Learning Management System</title>
    <style>
        .profile-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .profile-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            margin: 0 auto 20px;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            color: #666;
            object-fit: cover;
        }
        .profile-details {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .detail-row {
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .detail-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        .detail-label {
            font-weight: 600;
            color: #555;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/header.jsp" />
    
    <div class="container profile-container">
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <div class="profile-header">
            <div class="profile-avatar">
                <c:choose>
                    <c:when test="${not empty profileUser.photoUrl}">
                        <img src="${profileUser.photoUrl}" alt="Profile Photo" class="profile-avatar">
                    </c:when>
                    <c:otherwise>
                        ${profileUser.fullName.charAt(0)}
                    </c:otherwise>
                </c:choose>
            </div>
            <h2>${profileUser.fullName}</h2>
            <p class="text-muted">Member since ${profileUser.createdAt}</p>
        </div>
        
        <div class="profile-details">
            <div class="detail-row">
                <div class="row">
                    <div class="col-md-3 detail-label">Full Name:</div>
                    <div class="col-md-9">${profileUser.fullName}</div>
                </div>
            </div>
            <div class="detail-row">
                <div class="row">
                    <div class="col-md-3 detail-label">Email:</div>
                    <div class="col-md-9">${profileUser.email}</div>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty profileUser.department}">
                    <div class="detail-row">
                        <div class="row">
                            <div class="col-md-3 detail-label">Department:</div>
                            <div class="col-md-9">${profileUser.department}</div>
                        </div>
                    </div>
                    <c:if test="${not empty profileUser.bio}">
                        <div class="detail-row">
                            <div class="row">
                                <div class="col-md-3 detail-label">About Me:</div>
                                <div class="col-md-9">
                                    <c:out value="${fn:replace(profileUser.bio, newLineChar, '<br/>')}" escapeXml="false"/>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty profileUser.bio}">
                        <c:set var="bioText" value="${profileUser.bio}" />
                        <c:set var="deptFromBio" value="${fn:substringBefore(bioText, ' - ')}" />
                        <c:set var="restBio" value="${fn:substringAfter(bioText, ' - ')}" />
                        <c:choose>
                            <c:when test="${not empty restBio}">
                                <div class="detail-row">
                                    <div class="row">
                                        <div class="col-md-3 detail-label">Department:</div>
                                        <div class="col-md-9">${deptFromBio}</div>
                                    </div>
                                </div>
                                <div class="detail-row">
                                    <div class="row">
                                        <div class="col-md-3 detail-label">About Me:</div>
                                        <div class="col-md-9">
                                            <c:out value="${fn:replace(restBio, newLineChar, '<br/>')}" escapeXml="false"/>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="detail-row">
                                    <div class="row">
                                        <div class="col-md-3 detail-label">About Me:</div>
                                        <div class="col-md-9">
                                            <c:out value="${fn:replace(bioText, newLineChar, '<br/>')}" escapeXml="false"/>
                                        </div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <c:if test="${not empty profileUser.verificationDocument}">
                <div class="detail-row">
                    <div class="row">
                        <div class="col-md-3 detail-label">Verification Status:</div>
                        <div class="col-md-9">
                            <span class="badge ${profileUser.isApproved ? 'bg-success' : 'bg-warning'}">
                                ${profileUser.isApproved ? 'Verified' : 'Pending Verification'}
                            </span>
                            <div class="mt-2">
                                <a href="${profileUser.verificationDocument}" target="_blank" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-file-earmark-text"></i> View Verification Document
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="detail-row">
                <div class="row">
                    <div class="col-md-3 detail-label">Member Since:</div>
                    <div class="col-md-9">${profileUser.createdAt}</div>
                </div>
            </div>
            <div class="detail-row">
                <div class="row">
                    <div class="col-md-3 detail-label">Account Type:</div>
                    <div class="col-md-9">
                        <c:choose>
                            <c:when test="${sessionScope.userHasAdminRole}">Administrator</c:when>
                            <c:when test="${sessionScope.userHasInstructorRole}">Instructor</c:when>
                            <c:otherwise>Student</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <c:if test="${not empty instructorCourses}">
                <div class="mt-4">
                    <h5 class="mb-3">My Courses</h5>
                    <div class="row">
                        <c:forEach items="${instructorCourses}" var="course">
                            <div class="col-md-6 mb-3">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <h6 class="card-title">${course.title}</h6>
                                        <p class="card-text text-muted small">
                                            <c:if test="${not empty course.description}">
                                                ${fn:substring(course.description, 0, 100)}${fn:length(course.description) > 100 ? '...' : ''}
                                            </c:if>
                                        </p>
                                        <a href="${pageContext.request.contextPath}/course/view?id=${course.courseId}" 
                                           class="btn btn-sm btn-outline-primary">
                                            View Course
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty studentEnrollments}">
                <div class="mt-4">
                    <h5 class="mb-3">My Enrolled Courses</h5>
                    <div class="row">
                        <c:forEach items="${studentEnrollments}" var="enrollment">
                            <div class="col-md-6 mb-3">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <h6 class="card-title">${enrollment.courseId.title}</h6>
                                        <p class="card-text text-muted small">
                                            Enrolled on: ${enrollment.enrolledAt}
                                            <c:if test="${not empty enrollment.progress}">
                                                <br>Progress: ${enrollment.progress}%
                                            </c:if>
                                        </p>
                                        <a href="${pageContext.request.contextPath}/course/view?id=${enrollment.courseId.courseId}" 
                                           class="btn btn-sm btn-outline-primary">
                                            View Course
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>
        
        <div class="mt-4 text-center">
            <a href="${pageContext.request.contextPath}/profile/edit?userId=${profileUser.userId}" class="btn btn-primary me-2">
                <i class="bi bi-pencil-square"></i> Edit Profile
            </a>
            <a href="${pageContext.request.contextPath}/profile/change-password?userId=${profileUser.userId}" class="btn btn-outline-secondary">
                <i class="bi bi-key"></i> Change Password
            </a>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</body>
</html>
