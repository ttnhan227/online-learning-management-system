# Online Learning Management System (LMS) - Group 4

A web-based Learning Management System designed to enable educational institutions to deliver courses, assignments, and assessments to students remotely.

## 📋 Project Description

This Online Learning Management System (LMS) provides a user-friendly platform for course creation, enrollment, content delivery, and student progress tracking. The system incorporates essential features such as user authentication, role-based access control (RBAC), discussion forums, and grading functionality to facilitate effective online learning.

## 🎯 Functional Requirements

### 1. User Authentication & Role Management (Nhan)
- User registration and login system
- Password hashing and security
- User profile management
- Role assignment (Student, Instructor, Administrator)
- Session management

### 2. Course Management (Vi)
- Create and edit courses
- View course catalog
- Course details and prerequisites
- Instructor dashboard
- Course search functionality

### 3. Assignment System (Anh)
- Create and manage assignments
- Set due dates and descriptions
- View assignment lists by course
- Basic assignment submission tracking
- Progress calculation

### 4. Enrollment System (Phat)
- Student course enrollment
- Enrollment status tracking
- Progress calculation
- View enrolled courses
- Student dashboard

### Database Schema (Chạy file query online-learning-management-system.sql)
```
1. role (role_id, role_name)
2. user (user_id, full_name, email, password_hash, created_at)
3. user_role (user_role_id, user_id, role_id)
4. course (course_id, title, description, prerequisites, instructor_id, created_at)
5. assignment (assignment_id, course_id, title, description, due_date)
6. enrollment (enrollment_id, course_id, student_id, enrolled_at, progress)
```

### Shared Responsibilities
- Database implementation
- API endpoints
- Basic UI implementation
- Testing core functionality

## 🗂️ Project Structure

```
online-learning-management-system/
│   build.xml                    # Ant build configuration
│   online-learning-management-system.sql  # Database schema
│   README.md
│
├── build/                       # Compiled classes and build artifacts
│   ├── META-INF/
│   │   └── MANIFEST.MF
│   └── lib/                     # Library dependencies
│
├── dist/                        # Distribution files
│   └── online-learning-management-system.ear
│
├── nbproject/                   # NetBeans project configuration
│   ├── private/
│   ├── ant-deploy.xml
│   └── build-impl.xml
│
├── online-learning-management-system-ejb/  # EJB Module
│   ├── build/                   # Compiled classes
│   ├── dist/                    # EJB JAR file
│   ├── nbproject/               # Module-specific NetBeans config
│   └── src/                     # Source files
│       ├── conf/                # Configuration files
│       └── java/                # Java source code
│
├── online-learning-management-system-war/  # Web Module
│   ├── build/                   # Compiled classes and web resources
│   ├── dist/                    # WAR file
│   ├── nbproject/               # Module-specific NetBeans config
│   └── src/                     # Source files
│       ├── conf/                # Configuration files
│       └── java/                # Java source code
│
└── src/                         # Root source folder
    └── conf/                    # Common configuration files
```

### Key Directories
- **EJB Module**: Contains business logic, entities, and data access code
- **Web Module**: Contains web interfaces, JSF pages, and web resources
- **Shared Resources**: Configuration files and resources used across modules

## 🛠️ Technical Requirements

### 1. Application Architecture
- Java EE Enterprise Application with 2 modules:
  - Web Module (WAR): Contains web interfaces and controllers
  - EJB Module (JAR): Contains business logic and data access
- MVC (Model-View-Controller) design pattern
- Servlets and JSP for web interfaces
- EJB for business logic
- JPA for database operations

### 2. Required JARs

Dependencies are managed through the NetBeans project and included in the `build/lib` directory during build.

### EJB Module Dependencies   
- `jakarta.el-api-5.0.1.jar`
- `hibernate-validator-8.0.1.Final.jar`
- `jakarta.validation-api-3.0.1.jar`
- `jakarta.ejb-api-4.0.1.jar`
- `jakarta.transaction-api-2.0.1.jar`
- `jakarta.persistence-api-3.1.0.jar`
- `postgresql-42.7.7.jar` (PostgreSQL Driver)
- `jbcrypt-0.4.jar` (Password hashing)
- `hibernatehibernate-core-6.4.0.Final.jar`

### Web Module Dependencies
- `jakarta.servlet-api-6.0.0.jar`
- `jakarta.servlet.jsp-api-3.1.0.jar`
- `jakarta.servlet.jsp.jstl-api-3.0.0.jar`
- `jakarta.ejb-api-4.0.1.jar`

### 3. Database
- PostgreSQL 14+ database
- Connection pooling
- JPA with Hibernate as the provider

### 4. Security
- Java EE Security API
- Role-based access control (RBAC)
- Password hashing with BCrypt
- Protection against common web vulnerabilities
- Input validation and sanitization

## 🚀 Getting Started

### Prerequisites
- **JDK 8 or later**
- **Apache Ant** 1.10.0+
- **GlassFish/Payara Server** (or any Java EE compatible server)
- **PostgreSQL** 14+
- **Git** for version control
- **NetBeans IDE** (recommended) with Java EE support

### Installation

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd online-learning-management-system
   ```

2. **Database Setup**
   - Create a new database in PostgreSQL
   - Import the database schema from `online-learning-management-system.sql`
   - Update database configuration in the appropriate persistence.xml file

3. **Build the Application**
   ```bash
   ant build
   ```
   or build from NetBeans IDE

4. **Deploy to Application Server**
   - In NetBeans, right-click the project and select "Deploy"
   - Or use the Ant target: `ant deploy`

5. **Access the Application**
   - Open your browser and navigate to the deployed application URL (typically `http://localhost:8080/online-learning-management-system-war/`)

## 🔒 Security
- Password hashing using BCrypt
- CSRF protection
- XSS prevention
- SQL injection prevention using prepared statements
- Session management
- Role-based access control

## 📚 Source Code Organization

```
online-learning-management-system-ejb/src/java/
├── entities/           # JPA Entity classes
│   ├── User.java
│   ├── Course.java
│   └── ...
└── session/           # EJB Session Beans
    ├── UserSB.java
    ├── CourseSB.java
    └── ...

online-learning-management-system-war/src/java/
└── servlets/          # Servlet Controllers
    ├── AuthServlet.java
    ├── CourseServlet.java
    └── ...

online-learning-management-system-war/web/
├── auth/              # Authentication pages
│   ├── login.jsp
│   └── register.jsp
├── course/            # Course-related pages
│   ├── list.jsp
│   └── view.jsp
├── resources/         # Static assets (CSS, JS, images)
└── WEB-INF/
    ├── web.xml       # Web deployment descriptor
    └── lib/          # Library dependencies
```

## 🧪 Testing
Run the test suite using Ant:
```bash
ant test
```
Or through NetBeans IDE by right-clicking the project and selecting "Test"

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments
- [Bootstrap](https://getbootstrap.com/)
- [Font Awesome](https://fontawesome.com/)
- [jQuery](https://jquery.com/)

---

<div align="center">
  <h3>📬 Contact</h3>
  <p>For any inquiries or support, please contact the development team.</p>
  
  <p>Made with ❤️ by [Your Team Name]</p>
</div>
