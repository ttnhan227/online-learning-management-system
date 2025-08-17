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
        // Add input event listeners for real-time validation
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('registerForm');
            const fields = ['fullName', 'email', 'password', 'confirmPassword'];
            
            // Add input event listeners to all fields
            fields.forEach(field => {
                const input = document.getElementById(field);
                if (input) {
                    input.addEventListener('input', validateField);
                }
            });
            
            // Also validate on form submit
            form.addEventListener('submit', function(e) {
                const fullName = document.getElementById('fullName').value.trim();
                const email = document.getElementById('email').value.trim();
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                const role = document.getElementById('role').value;
                
                // Clear previous errors
                clearErrors();
                
                let isValid = true;
            
                // Validate all fields
                ['fullName', 'email', 'password', 'confirmPassword'].forEach(fieldId => {
                    const field = document.getElementById(fieldId);
                    if (field) {
                        const fakeEvent = { target: field };
                        validateField(fakeEvent);
                        if (document.getElementById(fieldId + 'Error').textContent) {
                            isValid = false;
                        }
                    }
                });
                
                // Validate role
                if (!role) {
                    showError('role', 'Please select a role');
                    isValid = false;
                }
                
                if (!isValid) {
                    e.preventDefault();
                }
            });
        });
        
        // Email validation helper
        function isValidEmail(email) {
            const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return re.test(email);
        }
        
        // Password strength validation
        function isStrongPassword(password) {
            return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/.test(password);
        }
        
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
        
        // Validate a single field
        function validateField(e) {
            const field = e ? e.target : null;
            if (!field) return;
            
            const fieldId = field.id;
            const value = field.value.trim();
            let error = '';
            
            switch(fieldId) {
                case 'fullName':
                    if (!value) {
                        error = 'Full name is required';
                    } else if (value.length < 2) {
                        error = 'Full name must be at least 2 characters long';
                    } else if (value.length > 50) {
                        error = 'Full name cannot exceed 50 characters';
                    } else if (!/^[a-zA-Z\s\-']+$/.test(value)) {
                        error = 'Full name can only contain letters, spaces, hyphens, and apostrophes';
                    }
                    break;
                    
                case 'email':
                    if (!value) {
                        error = 'Email is required';
                    } else if (!isValidEmail(value)) {
                        error = 'Please enter a valid email address';
                    }
                    break;
                    
                case 'password':
                    if (!value) {
                        error = 'Password is required';
                    } else if (value.length < 8) {
                        error = 'Password must be at least 8 characters long';
                    } else if (!isStrongPassword(value)) {
                        error = 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
                    }
                    break;
                    
                case 'confirmPassword':
                    const password = document.getElementById('password').value;
                    if (!value) {
                        error = 'Please confirm your password';
                    } else if (value !== password) {
                        error = 'Passwords do not match';
                    }
                    break;
            }
            
            // Show/hide error
            const errorSpan = document.getElementById(fieldId + 'Error');
            if (error) {
                field.classList.add('error');
                errorSpan.textContent = error;
            } else {
                field.classList.remove('error');
                errorSpan.textContent = '';
            }
            
            // Special case for confirm password to re-validate when password changes
            if (fieldId === 'password') {
                const confirmPwd = document.getElementById('confirmPassword');
                if (confirmPwd.value) {
                    validateField({ target: confirmPwd });
                }
            }
        }
        
        // Show error for a field
        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorSpan = document.getElementById(fieldId + 'Error');
            
            field.classList.add('error');
            errorSpan.textContent = message;
        }
        
        // Clear all errors
        function clearErrors() {
            const errorSpans = document.querySelectorAll('.error-text');
            const errorInputs = document.querySelectorAll('.error');
            
            errorSpans.forEach(span => span.textContent = '');
            errorInputs.forEach(input => input.classList.remove('error'));
        }
    </script>
    <jsp:include page="/WEB-INF/fragments/footer.jsp"/>
</body>
</html>
