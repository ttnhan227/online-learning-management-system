<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Change Password - Online Learning Management System</title>
    <style>
        .password-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 20px;
        }
        .password-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .password-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .password-header i {
            font-size: 2.5rem;
            color: #0d6efd;
            margin-bottom: 15px;
        }
        .form-label {
            font-weight: 600;
            color: #444;
        }
        .password-strength {
            height: 5px;
            background-color: #e9ecef;
            border-radius: 5px;
            margin-top: 5px;
            overflow: hidden;
        }
        .strength-bar {
            height: 100%;
            width: 0;
            transition: width 0.3s, background-color 0.3s;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/header.jsp" />
    
    <div class="container password-container">
        <div class="password-card">
            <div class="password-header">
                <i class="bi bi-shield-lock"></i>
                <h2>Change Password</h2>
                <p class="text-muted">Create a strong password to secure your account</p>
            </div>
            
            <!-- Error Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/profile/change-password" method="POST" id="passwordForm">
                <div class="mb-4">
                    <label for="currentPassword" class="form-label">Current Password</label>
                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                </div>
                
                <div class="mb-3">
                    <label for="newPassword" class="form-label">New Password</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                    <div class="password-strength mt-2">
                        <div class="strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="form-text">
                        Password must be at least 8 characters long and include:
                        <ul class="mb-0">
                            <li id="lengthReq">At least 8 characters</li>
                            <li id="uppercaseReq">At least one uppercase letter</li>
                            <li id="numberReq">At least one number</li>
                            <li id="specialReq">At least one special character</li>
                        </ul>
                    </div>
                </div>
                
                <div class="mb-4">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    <div class="form-text">
                        <span id="passwordMatch">Passwords must match</span>
                    </div>
                </div>
                
                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/profile?userId=${profileUser.userId}" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary" id="submitBtn" disabled>
                        <i class="bi bi-check-lg"></i> Update Password
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const newPassword = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');
            const submitBtn = document.getElementById('submitBtn');
            const strengthBar = document.getElementById('strengthBar');
            
            // Password requirements elements
            const lengthReq = document.getElementById('lengthReq');
            const uppercaseReq = document.getElementById('uppercaseReq');
            const numberReq = document.getElementById('numberReq');
            const specialReq = document.getElementById('specialReq');
            const passwordMatch = document.getElementById('passwordMatch');
            
            // Check password strength and update UI
            function checkPasswordStrength(password) {
                let strength = 0;
                let messages = [];
                
                // Check length
                const hasMinLength = password.length >= 8;
                if (hasMinLength) {
                    strength += 25;
                    lengthReq.style.color = '#198754';
                    lengthReq.innerHTML = '<i class="bi bi-check-circle-fill"></i> At least 8 characters';
                } else {
                    lengthReq.style.color = '';
                    lengthReq.innerHTML = 'At least 8 characters';
                }
                
                // Check uppercase
                const hasUppercase = /[A-Z]/.test(password);
                if (hasUppercase) {
                    strength += 25;
                    uppercaseReq.style.color = '#198754';
                    uppercaseReq.innerHTML = '<i class="bi bi-check-circle-fill"></i> At least one uppercase letter';
                } else {
                    uppercaseReq.style.color = '';
                    uppercaseReq.innerHTML = 'At least one uppercase letter';
                }
                
                // Check number
                const hasNumber = /[0-9]/.test(password);
                if (hasNumber) {
                    strength += 25;
                    numberReq.style.color = '#198754';
                    numberReq.innerHTML = '<i class="bi bi-check-circle-fill"></i> At least one number';
                } else {
                    numberReq.style.color = '';
                    numberReq.innerHTML = 'At least one number';
                }
                
                // Check special character
                const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
                if (hasSpecial) {
                    strength += 25;
                    specialReq.style.color = '#198754';
                    specialReq.innerHTML = '<i class="bi bi-check-circle-fill"></i> At least one special character';
                } else {
                    specialReq.style.color = '';
                    specialReq.innerHTML = 'At least one special character';
                }
                
                // Update strength bar
                strengthBar.style.width = strength + '%';
                
                // Update strength bar color
                if (strength < 50) {
                    strengthBar.style.backgroundColor = '#dc3545'; // Red
                } else if (strength < 75) {
                    strengthBar.style.backgroundColor = '#fd7e14'; // Orange
                } else {
                    strengthBar.style.backgroundColor = '#198754'; // Green
                }
                
                return hasMinLength && hasUppercase && hasNumber && hasSpecial;
            }
            
            // Check if passwords match
            function checkPasswordsMatch() {
                const newPwd = newPassword.value;
                const confirmPwd = confirmPassword.value;
                
                if (newPwd === '' || confirmPwd === '') {
                    passwordMatch.style.color = '';
                    passwordMatch.textContent = 'Passwords must match';
                    return false;
                }
                
                if (newPwd === confirmPwd) {
                    passwordMatch.style.color = '#198754';
                    passwordMatch.innerHTML = '<i class="bi bi-check-circle-fill"></i> Passwords match';
                    return true;
                } else {
                    passwordMatch.style.color = '#dc3545';
                    passwordMatch.innerHTML = '<i class="bi bi-x-circle-fill"></i> Passwords do not match';
                    return false;
                }
            }
            
            // Update submit button state
            function updateSubmitButton() {
                const isStrongPassword = checkPasswordStrength(newPassword.value);
                const passwordsMatch = checkPasswordsMatch();
                
                submitBtn.disabled = !(isStrongPassword && passwordsMatch);
            }
            
            // Event listeners
            newPassword.addEventListener('input', updateSubmitButton);
            confirmPassword.addEventListener('input', updateSubmitButton);
            
            // Form submission
            document.getElementById('passwordForm').addEventListener('submit', function(e) {
                if (!submitBtn.disabled) {
                    // Additional check before submission
                    if (!checkPasswordStrength(newPassword.value) || !checkPasswordsMatch()) {
                        e.preventDefault();
                        return false;
                    }
                    return true;
                }
                e.preventDefault();
                return false;
            });
            
            // Initial check
            updateSubmitButton();
        });
    </script>
</body>
</html>
