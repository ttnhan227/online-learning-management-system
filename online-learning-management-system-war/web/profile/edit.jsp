<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Profile - Online Learning Management System</title>
    <style>
        .profile-container { max-width: 700px; margin: 40px auto; padding: 20px; }
        .profile-header { text-align: center; margin-bottom: 30px; }
        .profile-avatar { width: 120px; height: 120px; border-radius: 50%; margin: 0 auto 20px; background-color: #f0f0f0; display: flex; align-items: center; justify-content: center; font-size: 50px; color: #666; cursor: pointer; transition: all 0.3s; }
        .profile-avatar:hover { background-color: #e0e0e0; transform: scale(1.05); }
        .profile-form { background-color: #fff; border-radius: 8px; padding: 30px; box-shadow: 0 2px 15px rgba(0,0,0,0.1); }
        .form-label { font-weight: 600; color: #444; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<div class="container profile-container">
    <div class="profile-header">
        <h2>Edit Profile</h2>
        <p class="text-muted">Update your personal information</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:set var="deptPrefill" value="${profileUser.department}" />
    <c:set var="bioPrefill" value="${profileUser.bio}" />
    <c:if test="${empty deptPrefill and not empty bioPrefill}">
        <c:set var="deptFromBio" value="${fn:substringBefore(bioPrefill, ' - ')}" />
        <c:set var="restBio" value="${fn:substringAfter(bioPrefill, ' - ')}" />
        <c:if test="${not empty restBio}">
            <c:set var="deptPrefill" value="${deptFromBio}" />
            <c:set var="bioPrefill" value="${restBio}" />
        </c:if>
    </c:if>

    <form action="${pageContext.request.contextPath}/profile/edit" method="POST" class="profile-form" enctype="multipart/form-data">
        <div class="text-center mb-4">
            <label for="photoUpload" class="profile-avatar-label">
                <div id="avatarContainer" class="profile-avatar mx-auto" style="cursor: pointer;">
                    <c:choose>
                        <c:when test="${not empty profileUser.photoUrl}">
                            <img id="avatarPreview" src="${profileUser.photoUrl}" alt="Profile Photo" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover; display: block;">
                        </c:when>
                        <c:otherwise>
                            <span id="avatarInitial" style="font-size: 50px;">${profileUser.fullName.charAt(0)}</span>
                            <img id="avatarPreview" src="" alt="Profile Photo" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover; display: none;">
                        </c:otherwise>
                    </c:choose>
                </div>
            </label>
            <input type="file" id="photoUpload" name="photoUpload" style="display: none;" accept="image/*">
            <div class="mt-2">
                <label for="photoUpload" class="btn btn-sm btn-outline-secondary" style="cursor: pointer;">
                    <i class="bi bi-camera"></i> Change Photo
                </label>
            </div>
        </div>

        <div class="mb-3">
            <label for="fullName" class="form-label">Full Name</label>
            <input type="text" class="form-control" id="fullName" name="fullName" value="${profileUser.fullName}" required>
            <div class="form-text">Your full name as you'd like it to appear.</div>
        </div>

        <div class="mb-4">
            <label for="email" class="form-label">Email Address</label>
            <input type="email" class="form-control" id="email" name="email" value="${profileUser.email}" required>
            <div class="form-text">We'll never share your email with anyone else.</div>
        </div>

        <div class="mb-4">
            <label for="department" class="form-label">Department</label>
            <input type="text" class="form-control" id="department" name="department" value="${deptPrefill}" maxlength="100">
            <div class="form-text">Your department or faculty.</div>
        </div>

        <div class="mb-4">
            <label for="bio" class="form-label">Bio</label>
            <textarea class="form-control" id="bio" name="bio" rows="4">${bioPrefill}</textarea>
            <div class="form-text">Tell us about yourself (max 1000 characters).</div>
        </div>

        <c:if test="${empty profileUser.verificationDocument}">
            <div class="mb-4">
                <label for="verificationDocument" class="form-label">Verification Document</label>
                <input type="file" class="form-control" id="verificationDocument" name="verificationDocument" accept="application/pdf,image/*">
                <div class="form-text">Upload a document to verify your identity (e.g., student ID, staff card).</div>
            </div>
        </c:if>

        <div class="d-flex justify-content-between">
            <a href="${pageContext.request.contextPath}/profile?userId=${profileUser.userId}" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Back to Profile
            </a>
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-save"></i> Save Changes
            </button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/fragments/footer.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

<script>
document.addEventListener('DOMContentLoaded', function () {
    const photoUpload = document.getElementById('photoUpload');
    const avatarPreview = document.getElementById('avatarPreview');
    const avatarInitial = document.getElementById('avatarInitial');

    photoUpload.addEventListener('change', function (event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                avatarPreview.src = e.target.result;
                avatarPreview.style.display = 'block';
                if (avatarInitial) avatarInitial.style.display = 'none';
            };
            reader.readAsDataURL(file);
        }
    });

    document.querySelector('form').addEventListener('submit', function (e) {
        const fullName = document.getElementById('fullName').value.trim();
        const email = document.getElementById('email').value.trim();
        if (fullName.length < 2 || fullName.length > 100) { e.preventDefault(); alert('Full name must be between 2 and 100 characters'); return false; }
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { e.preventDefault(); alert('Please enter a valid email address'); return false; }
        const department = document.getElementById('department');
        if (department && department.value.length > 100) { e.preventDefault(); alert('Department must be 100 characters or less'); return false; }
        const bio = document.getElementById('bio');
        if (bio && bio.value.length > 1000) { e.preventDefault(); alert('Bio must be 1000 characters or less'); return false; }
        return true;
    });
});
</script>
</body>
</html>
