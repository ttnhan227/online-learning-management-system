<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login - Online Learning Management System</title>
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
        .login-container {
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
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn-login {
            width: 100%;
            padding: 0.75rem;
            background-color: #e8491d;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            margin-top: 1rem;
        }
        .btn-login:hover {
            background-color: #d63d12;
        }
        .register-link {
            text-align: center;
            margin-top: 1rem;
        }
        .register-link a {
            color: #e8491d;
            text-decoration: none;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
        .error-message {
            color: #e8491d;
            text-align: center;
            margin-bottom: 1rem;
        }
        .error-text {
            color: #e8491d;
            font-size: 0.8rem;
            margin-top: 0.25rem;
            display: block;
        }
        .form-group input.error {
            border-color: #e8491d;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login to Your Account</h2>
        
        <%-- Display error message if login failed --%>
        <% if (request.getParameter("error") != null) { %>
            <div class="error-message">
                Invalid email or password. Please try again.
            </div>
        <% } %>
        
        <%-- Display success message if redirected from registration --%>
        <% if (request.getParameter("success") != null) { %>
            <div class="success-message" style="color: #4CAF50; text-align: center; margin-bottom: 1rem;">
                Registration successful! You can now login.
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/auth" method="POST" id="loginForm">
            <input type="hidden" name="action" value="Login">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
                <span class="error-text" id="emailError"></span>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
                <span class="error-text" id="passwordError"></span>
            </div>
            <button type="submit" class="btn-login">Login</button>
        </form>
        
        <div class="register-link">
            Don't have an account? <a href="${pageContext.request.contextPath}/auth?action=Register">Register here</a>
        </div>
    </div>
    
    <script>
        // Client-side validation for login form
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            
            // Clear previous errors
            clearErrors();
            
            let isValid = true;
            
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
            }
            
            if (!isValid) {
                e.preventDefault();
            }
        });
        
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorSpan = document.getElementById(fieldId + 'Error');
            
            field.classList.add('error');
            errorSpan.textContent = message;
        }
        
        function clearErrors() {
            const inputs = document.querySelectorAll('input');
            const errorSpans = document.querySelectorAll('.error-text');
            
            inputs.forEach(input => input.classList.remove('error'));
            errorSpans.forEach(span => span.textContent = '');
        }
    </script>
</body>
</html>
