<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Online Learning Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }
        .container {
            width: 80%;
            margin: auto;
            overflow: hidden;
        }
        header {
            background: #35424a;
            color: #ffffff;
            padding: 20px 0;
            text-align: center;
        }
        nav {
            background: #e8491d;
            color: #ffffff;
            padding: 10px 0;
        }
        nav ul {
            padding: 0;
            list-style: none;
            text-align: center;
        }
        nav ul li {
            display: inline;
            margin: 0 20px;
        }
        nav a {
            color: #ffffff;
            text-decoration: none;
        }
        .main {
            padding: 20px 0;
        }
        .feature-box {
            float: left;
            width: 30%;
            padding: 10px;
            margin: 1.5%;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px #ccc;
        }
        footer {
            background: #35424a;
            color: #ffffff;
            text-align: center;
            padding: 20px 0;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <h1>Online Learning Management System</h1>
        </div>
    </header>

    <nav>
        <div class="container">
            <ul>
                <li><a href="${pageContext.request.contextPath}/HomeServlet">Home</a></li>
                <li><a href="#">Courses</a></li>
                <li><a href="#">About</a></li>
                <li><a href="#">Contact</a></li>
                <%-- Check if user is logged in --%>
                <% if (session != null && session.getAttribute("user") != null) { %>
                    <li>
                        <span style="color: #ffffff;">Welcome, ${sessionScope.user.fullName}</span>
                    </li>
                    <li>
                        <form action="${pageContext.request.contextPath}/auth" method="POST" style="display: inline;">
                            <input type="hidden" name="action" value="Logout">
                            <button type="submit" style="background: none; border: none; color: #ffffff; text-decoration: underline; cursor: pointer; font-size: inherit;">Logout</button>
                        </form>
                    </li>
                <% } else { %>
                    <li>
                        <a href="${pageContext.request.contextPath}/auth?action=Login" style="color: #ffffff; text-decoration: underline;">Login</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </nav>

    <div class="container main">
        <div class="feature-box">
            <h3>Featured Courses</h3>
            <p>Explore our wide range of courses designed to enhance your skills and knowledge.</p>
            <a href="#">Browse Courses →</a>
        </div>
        <div class="feature-box">
            <h3>Learn at Your Pace</h3>
            <p>Access course materials anytime, anywhere, and learn at your own convenience.</p>
            <a href="#">Get Started →</a>
        </div>
        <div class="feature-box">
            <h3>Expert Instructors</h3>
            <p>Learn from industry experts with years of experience in their respective fields.</p>
            <a href="#">Meet Our Team →</a>
        </div>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2025 Online Learning Management System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
