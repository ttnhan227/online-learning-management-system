<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Learning Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/header.jsp"/>
    

    <main class="container main">
        <section class="hero">
            <h2>Unlock Your Potential</h2>
            <p>Join our community and start your journey to mastering new skills today.</p>

            </div>
        </section>

        <div class="feature-grid">
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
    </main>

    <jsp:include page="/WEB-INF/fragments/footer.jsp"/>
</body>
</html>
