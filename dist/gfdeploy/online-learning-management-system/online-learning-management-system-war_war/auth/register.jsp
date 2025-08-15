<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Register - Online Learning Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .register-container {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }
        h2 {
            text-align: center;
            color: #35424a;
            margin-bottom: 1.5rem;
        }
        .form-group {
            margin-bottom: 1rem;
        }
        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #555;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn-register {
            width: 100%;
            padding: 0.75rem;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            margin-top: 1rem;
        }
        .btn-register:hover {
            background-color: #45a049;
        }
        .login-link {
            text-align: center;
            margin-top: 1rem;
        }
        .login-link a {
            color: #4CAF50;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .error-message {
            color: #e8491d;
            text-align: center;
            margin-bottom: 1rem;
        }
        .success-message {
            color: #4CAF50;
            text-align: center;
            margin-bottom: 1rem;
        }
        .error-text {
            color: #e8491d;
            font-size: 0.8rem;
            margin-top: 0.25rem;
            display: block;
        }
        .form-group input.error,
        .form-group select.error {
            border-color: #e8491d;
        }
        .password-strength {
            font-size: 0.8rem;
            margin-top: 0.25rem;
        }
        .password-strength.weak {
            color: #e8491d;
        }
        .password-strength.medium {
            color: #ff9800;
        }
        .password-strength.strong {
            color: #4CAF50;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Create an Account</h2>
        
        <%-- Display error message if registration failed --%>
        <% if (request.getParameter("error") != null) { %>
            <div class="error-message">
                <% if ("email_exists".equals(request.getParameter("error"))) { %>
                    Email already exists. Please use a different email.
                <% } else if ("password_mismatch".equals(request.getParameter("error"))) { %>
                    Passwords do not match. Please try again.
                <% } else if ("missing_fields".equals(request.getParameter("error"))) { %>
                    Please fill in all required fields.
                <% } else if ("registration_failed".equals(request.getParameter("error"))) { %>
                    An error occurred during registration. Please try again.
                <% } else { %>
                    An error occurred during registration. Please try again.
                <% } %>
            </div>
        <% } %>
        
        <%-- Display success message if redirected from successful registration --%>
        <% if (request.getParameter("success") != null) { %>
            <div class="success-message">
                Registration successful! You can now login.
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/auth" method="POST" id="registerForm">
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
                <select id="role" name="role">
                    <option value="student" selected>Student</option>
                    <option value="instructor">Instructor</option>
                </select>
                <span class="error-text" id="roleError"></span>
            </div>
            <button type="submit" class="btn-register">Create Account</button>
        </form>
        
        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/auth?action=Login">Login here</a>
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
</body>
</html>
