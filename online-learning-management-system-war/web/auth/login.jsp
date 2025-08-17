<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Online Learning Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
        }
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/header.jsp"/>
    <main class="main-content">
        <div class="auth-container">
        <h2>Login to Your Account</h2>
        
        <%-- Display error message if login failed --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <%-- Display success message if redirected from registration --%>
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/auth" method="POST" id="loginForm" novalidate>
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
            <button type="submit" class="btn btn-primary">Login</button>
        </form>
        
        <div class="auth-link">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/auth?action=Register">Register here</a></p>
        </div>
        </div>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp"/>
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
        
        function showError(field, message) {
            const errorSpan = document.getElementById(field + 'Error');
            if (errorSpan) {
                errorSpan.textContent = message;
            }
        }
        
        function clearErrors() {
            const errorSpans = document.querySelectorAll('.error-text');
            errorSpans.forEach(span => span.textContent = '');
        }
    </script>
</body>
</html>
