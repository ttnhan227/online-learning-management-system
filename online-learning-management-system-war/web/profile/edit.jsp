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
        .profile-avatar { width: 140px; height: 140px; border-radius: 50%; margin: 0 auto 15px; background-color: #f8f9fa; display: flex; align-items: center; justify-content: center; font-size: 50px; color: #6c757d; cursor: pointer; transition: all 0.3s; border: 3px solid #e9ecef; }
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
        <div class="row">
            <div class="col-12 text-center mb-4">
                <div class="profile-avatar-container">
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
                    
                    <div class="mt-3">
                        <div class="btn-group btn-group-sm" role="group">
                            <input type="radio" class="btn-check" name="imageSource" id="uploadImage" value="upload" autocomplete="off" checked>
                            <label class="btn btn-outline-secondary" for="uploadImage" style="cursor: pointer;">
                                <i class="bi bi-upload"></i> Upload
                            </label>
                            
                            <input type="radio" class="btn-check" name="imageSource" id="generateImage" value="generate" autocomplete="off">
                            <label class="btn btn-outline-secondary" for="generateImage" style="cursor: pointer;">
                                <i class="bi bi-magic"></i> AI Generate
                            </label>
                        </div>
                    </div>
                    
                    <!-- AI Image Generation Section -->
                    <div id="imageGenerateSection" class="mt-3" style="display: none;">
                        <div class="input-group input-group-sm mb-2" style="max-width: 400px; margin: 0 auto;">
                            <input type="text" id="imagePrompt" class="form-control form-control-sm" placeholder="Describe the image...">
                            <button class="btn btn-primary" type="button" id="generateImageBtn">
                                <span class="spinner-border spinner-border-sm d-none" id="generateSpinner" role="status" aria-hidden="true"></span>
                                <span id="generateText">Generate</span>
                            </button>
                        </div>
                        <div id="generatedImagePreview" class="text-center" style="display: none;">
                            <img id="generatedImage" src="" alt="Generated Image Preview" class="img-fluid rounded border" style="max-height: 200px; max-width: 100%;">
                            <div class="mt-2">
                                <button type="button" class="btn btn-sm btn-success me-2" id="useGeneratedImage">
                                    <i class="bi bi-check-lg"></i> Use This Image
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" id="regenerateImage">
                                    <i class="bi bi-arrow-repeat"></i> Regenerate
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
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

        <c:if test="${not empty sessionScope.userHasInstructorRole and sessionScope.userHasInstructorRole == true}">
            <div class="mb-4">
                <label for="department" class="form-label">Department</label>
                <input type="text" class="form-control" id="department" name="department" value="${deptPrefill}" maxlength="100">
                <div class="form-text">Your department or faculty.</div>
            </div>
        </c:if>

        <div class="mb-4">
            <label for="bio" class="form-label">Bio</label>
            <textarea class="form-control" id="bio" name="bio" rows="4">${bioPrefill}</textarea>
            <div class="form-text">Tell us about yourself (max 1000 characters).</div>
        </div>

        <c:if test="${sessionScope.userHasInstructorRole == true}">
            <c:if test="${empty profileUser.verificationDocument}">
                <div class="mb-4">
                    <label for="verificationDocument" class="form-label">Verification Document</label>
                    <input type="file" class="form-control" id="verificationDocument" name="verificationDocument" accept="application/pdf,image/*">
                    <div class="form-text">Upload a document to verify your identity (e.g., staff card, professional certification).</div>
                </div>
            </c:if>
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
    // Image Generation Variables
    const imageSourceRadios = document.querySelectorAll('input[name="imageSource"]');
    const imageUpload = document.getElementById('photoUpload');
    const imageGenerateSection = document.getElementById('imageGenerateSection');
    const imagePrompt = document.getElementById('imagePrompt');
    const generateImageBtn = document.getElementById('generateImageBtn');
    const generateSpinner = document.getElementById('generateSpinner');
    const generateText = document.getElementById('generateText');
    const generatedImagePreview = document.getElementById('generatedImagePreview');
    const generatedImage = document.getElementById('generatedImage');
    const useGeneratedImageBtn = document.getElementById('useGeneratedImage');
    const regenerateImageBtn = document.getElementById('regenerateImage');
    let generatedImageUrl = '';

    // Toggle between upload and generate sections
    imageSourceRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            if (this.value === 'generate') {
                imageGenerateSection.style.display = 'block';
                imageUpload.disabled = true;
            } else {
                imageGenerateSection.style.display = 'none';
                imageUpload.disabled = false;
                generatedImagePreview.style.display = 'none';
            }
        });
    });

    // Handle image generation
    async function generateImage() {
        const prompt = imagePrompt.value.trim();
        if (!prompt) {
            alert('Please enter a description for the image');
            return;
        }

        console.log('Starting image generation with prompt:', prompt);
        generateSpinner.classList.remove('d-none');
        generateText.textContent = 'Generating...';
        generateImageBtn.disabled = true;
        generatedImagePreview.style.display = 'none';

        try {
            console.log('Sending request to server...');
            const startTime = Date.now();
            const response = await fetch('${pageContext.request.contextPath}/profile/generate-image', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'prompt=' + encodeURIComponent(prompt)
            });
            
            const responseTime = Date.now() - startTime;
            console.log(`Server responded in ${responseTime}ms with status:`, response.status);

            if (!response.ok) {
                const errorText = await response.text();
                console.error('Server error response:', errorText);
                throw new Error(`Server error: ${response.status} - ${errorText}`);
            }

            const data = await response.json();
            console.log('Response data:', data);
            
            if (data.imageUrl) {
                console.log('Image generated successfully at:', data.imageUrl);
                generatedImageUrl = data.imageUrl;
                
                // Preload the image before showing it
                const img = new Image();
                img.onload = function() {
                    generatedImage.src = data.imageUrl;
                    generatedImage.alt = 'Generated profile picture: ' + prompt;
                    generatedImagePreview.style.display = 'block';
                    console.log('Image loaded successfully');
                };
                img.onerror = function() {
                    console.error('Failed to load generated image:', data.imageUrl);
                    throw new Error('Failed to load the generated image');
                };
                img.src = data.imageUrl;
                
            } else if (data.error) {
                console.error('Error from server:', data.error);
                throw new Error(data.error);
            } else {
                console.error('Unexpected response format:', data);
                throw new Error('Unexpected response from server');
            }
        } catch (error) {
            console.error('Error in generateImage:', error);
            let errorMessage = 'Error generating image';
            
            // Provide more user-friendly error messages
            if (error.message.includes('Failed to fetch')) {
                errorMessage = 'Failed to connect to the server. Please check your internet connection.';
            } else if (error.message.includes('timeout') || error.message.includes('timed out')) {
                errorMessage = 'The request timed out. Please try again.';
            } else if (error.message) {
                errorMessage = error.message;
            }
            
            alert(errorMessage);
            console.error('Full error details:', error);
        } finally {
            generateSpinner.classList.add('d-none');
            generateText.textContent = 'Generate';
            generateImageBtn.disabled = false;
        }
    }

    // Event listeners for image generation
    generateImageBtn.addEventListener('click', generateImage);
    imagePrompt.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            generateImage();
        }
    });

    // Use the generated image
    useGeneratedImageBtn.addEventListener('click', function() {
        if (generatedImageUrl) {
            // Create a file input change event
            fetch(generatedImageUrl)
                .then(res => res.blob())
                .then(blob => {
                    const file = new File([blob], 'generated-avatar.png', { type: 'image/png' });
                    const dataTransfer = new DataTransfer();
                    dataTransfer.items.add(file);
                    
                    // Update the file input
                    imageUpload.files = dataTransfer.files;
                    
                    // Update the preview
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        avatarPreview.src = e.target.result;
                        avatarPreview.style.display = 'block';
                        if (avatarInitial) avatarInitial.style.display = 'none';
                    };
                    reader.readAsDataURL(file);
                    
                    // Switch back to upload mode
                    document.getElementById('uploadImage').click();
                    
                    // Hide the generated image preview
                    generatedImagePreview.style.display = 'none';
                    imagePrompt.value = '';
                })
                .catch(error => {
                    console.error('Error using generated image:', error);
                    alert('Error applying the generated image');
                });
        }
    });

    // Regenerate image
    regenerateImageBtn.addEventListener('click', generateImage);

    // Existing code
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
