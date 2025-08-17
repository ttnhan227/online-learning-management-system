<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Online Learning Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/header.jsp"/>
    <div class="auth-container">
        <h2>Create an Account</h2>
        
        <%-- Display error message if registration failed --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <%-- Display success message if redirected from successful registration --%>
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/auth" method="POST" id="registerForm" novalidate>
            <input type="hidden" name="action" value="Register">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" required>
                <span class="error-text" id="fullNameError"></span>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
                <span class="error-text" id="emailError"></span>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
                <span class="error-text" id="passwordError"></span>
                <span class="password-strength" id="passwordStrength"></span>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
                <span class="error-text" id="confirmPasswordError"></span>
            </div>
            <div class="form-group">
                <label for="role">Register as</label>
                <select id="role" name="role" required>
                    <option value="student" selected>Student</option>
                    <option value="instructor">Instructor</option>
                </select>
                <span class="error-text" id="roleError"></span>
            </div>
            <button type="submit" class="btn btn-success">Create Account</button>
        </form>
        
        <div class="auth-link">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/auth?action=Login">Login here</a></p>
        </div>
    </div>
    
    <script>
        // Enhanced client-side validation for registration form
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const role = document.getElementById('role').value;
            
            // Clear previous errors
            clearErrors();
            
            let isValid = true;
            
            // Validate full name
            if (!fullName) {
                showError('fullName', 'Full name is required');
                isValid = false;
            } else if (fullName.length < 2) {
                showError('fullName', 'Full name must be at least 2 characters long');
                isValid = false;
            } else if (fullName.length > 50) {
                showError('fullName', 'Full name cannot exceed 50 characters');
                isValid = false;
            } else if (!/^[a-zA-Z\s\-']+$/.test(fullName)) {
                showError('fullName', 'Full name can only contain letters, spaces, hyphens, and apostrophes');
                isValid = false;
            }
            
            // Validate email
            if (!email) {
                showError('email', 'Email is required');
                isValid = false;
            } else if (!isValidEmail(email)) {
                showError('email', 'Please enter a valid email address');
                isValid = false;
            }
            
            // Validate password
            if (!password) {
                showError('password', 'Password is required');
                isValid = false;
            } else if (password.length < 6) {
                showError('password', 'Password must be at least 6 characters long');
                isValid = false;
            } else if (!isStrongPassword(password)) {
                showError('password', 'Password must contain at least one uppercase letter, one lowercase letter, and one number');
                isValid = false;
            }
            
            // Validate password confirmation
            if (!confirmPassword) {
                showError('confirmPassword', 'Please confirm your password');
                isValid = false;
            } else if (password !== confirmPassword) {
                showError('confirmPassword', 'Passwords do not match');
                isValid = false;
            }
            
            // Validate role
            if (!role) {
                showError('role', 'Please select a role');
                isValid = false;
            }
            
            if (!isValid) {
                e.preventDefault();
            }
        });
        
        // Real-time password strength indicator
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthSpan = document.getElementById('passwordStrength');
            
            if (!password) {
                strengthSpan.textContent = '';
                strengthSpan.className = 'password-strength';
                return;
            }
            
            const strength = getPasswordStrength(password);
            strengthSpan.textContent = `Password strength: ${strength.text}`;
            strengthSpan.className = `password-strength ${strength.class}`;
        });
        
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        function isStrongPassword(password) {
            // Must contain at least one uppercase, one lowercase, and one number
            const hasUpper = /[A-Z]/.test(password);
            const hasLower = /[a-z]/.test(password);
            const hasNumber = /\d/.test(password);
            return hasUpper && hasLower && hasNumber;
        }
        
        function getPasswordStrength(password) {
            let score = 0;
            
            if (password.length >= 6) score++;
            if (password.length >= 8) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[a-z]/.test(password)) score++;
            if (/\d/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;
            
            if (score < 3) return { text: 'Weak', class: 'weak' };
            if (score < 5) return { text: 'Medium', class: 'medium' };
            return { text: 'Strong', class: 'strong' };
        }
        
        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorSpan = document.getElementById(fieldId + 'Error');
            
            field.classList.add('error');
            errorSpan.textContent = message;
        }
        
        function clearErrors() {
            const inputs = document.querySelectorAll('input, select');
            const errorSpans = document.querySelectorAll('.error-text');
            
            inputs.forEach(input => input.classList.remove('error'));
            errorSpans.forEach(span => span.textContent = '');
        }
    </script>
    <jsp:include page="/WEB-INF/fragments/footer.jsp"/>
</body>
</html>
