# Course Management System - Hệ thống Quản lý Khóa học

## Tổng quan
Hệ thống quản lý khóa học được xây dựng với đầy đủ các chức năng CRUD (Create, Read, Update, Delete) và các tính năng nâng cao như tìm kiếm, phân trang, và dashboard cho instructor.

## Các chức năng chính

### 1. Tạo và chỉnh sửa khóa học
- **Tạo khóa học mới**: Form tạo khóa học với validation đầy đủ
- **Chỉnh sửa khóa học**: Cập nhật thông tin khóa học với preview real-time
- **Xóa khóa học**: Xóa khóa học với xác nhận

### 2. Xem danh sách khóa học (Course Catalog)
- Hiển thị tất cả khóa học với giao diện card đẹp mắt
- Phân trang với 10 khóa học mỗi trang
- Thống kê tổng quan về số lượng khóa học
- Responsive design cho mobile và desktop

### 3. Chi tiết khóa học và yêu cầu
- Hiển thị đầy đủ thông tin khóa học
- Yêu cầu trước khi học (prerequisites)
- Thông tin giảng viên
- Các nút hành động phù hợp với vai trò người dùng

### 4. Dashboard cho Instructor
- Thống kê tổng quan về khóa học
- Danh sách khóa học của instructor
- Hoạt động gần đây
- Hành động nhanh (Quick Actions)
- Mẹo và tài nguyên

### 5. Tìm kiếm khóa học
- Tìm kiếm theo tiêu đề và mô tả
- Highlight từ khóa tìm kiếm
- Bộ lọc theo danh mục và cấp độ
- Gợi ý tìm kiếm liên quan

## Cấu trúc file

### Backend (EJB)
```
online-learning-management-system-ejb/src/java/
├── beans/
│   ├── CourseManagementSB.java          # Session Bean chính
│   └── CourseManagementSBLocal.java     # Local Interface
├── entities/
│   ├── Course.java                      # Entity Course
│   └── AppUser.java                     # Entity User
└── utils/
    └── ValidationUtils.java             # Utility classes
```

### Frontend (WAR)
```
online-learning-management-system-war/src/java/controllers/
└── CourseServlet.java                   # Controller chính

online-learning-management-system-war/web/WEB-INF/
├── courses/
│   ├── course-list.jsp                  # Danh sách khóa học
│   ├── course-detail.jsp                # Chi tiết khóa học
│   ├── course-create.jsp                # Form tạo khóa học
│   ├── course-edit.jsp                  # Form chỉnh sửa
│   └── course-search.jsp                # Kết quả tìm kiếm
├── instructor/
│   └── dashboard.jsp                    # Dashboard instructor
└── error.jsp                           # Trang lỗi chung
```

## API Endpoints

### Course Management
- `GET /courses` - Danh sách tất cả khóa học
- `GET /course/view?id={id}` - Xem chi tiết khóa học
- `GET /course/create` - Form tạo khóa học mới
- `POST /course/create` - Tạo khóa học mới
- `GET /course/edit?id={id}` - Form chỉnh sửa khóa học
- `POST /course/edit` - Cập nhật khóa học
- `POST /course/delete` - Xóa khóa học
- `GET /course/search?q={term}` - Tìm kiếm khóa học

### Instructor Dashboard
- `GET /instructor/dashboard` - Dashboard cho instructor

## Tính năng nổi bật

### 1. Giao diện hiện đại
- Sử dụng Bootstrap 5 và Font Awesome
- Gradient backgrounds và animations
- Responsive design
- Card-based layout

### 2. Validation và Security
- Form validation client-side và server-side
- Kiểm tra quyền truy cập
- Xác nhận trước khi xóa
- Character count với visual feedback

### 3. User Experience
- Real-time preview khi chỉnh sửa
- Breadcrumb navigation
- Loading states và error handling
- Auto-refresh dashboard

### 4. Performance
- Phân trang để tối ưu hiệu suất
- Lazy loading cho images
- Efficient database queries
- Caching strategies

## Database Schema

### Course Table
```sql
CREATE TABLE course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    prerequisites TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES app_user(user_id)
);
```

## Cách sử dụng

### 1. Tạo khóa học mới
1. Đăng nhập với tài khoản instructor
2. Vào Dashboard → "Tạo khóa học mới"
3. Điền thông tin bắt buộc (tiêu đề, mô tả)
4. Thêm yêu cầu trước khi học (tùy chọn)
5. Nhấn "Tạo khóa học"

### 2. Chỉnh sửa khóa học
1. Vào Dashboard → Chọn khóa học cần sửa
2. Nhấn nút "Chỉnh sửa"
3. Cập nhật thông tin
4. Xem preview real-time
5. Nhấn "Cập nhật khóa học"

### 3. Tìm kiếm khóa học
1. Vào trang "Khóa học"
2. Sử dụng thanh tìm kiếm
3. Áp dụng bộ lọc (tùy chọn)
4. Xem kết quả với highlight từ khóa

### 4. Xem Dashboard
1. Đăng nhập với tài khoản instructor
2. Vào "Dashboard"
3. Xem thống kê và quản lý khóa học

## Tính năng mở rộng trong tương lai

### 1. Content Management
- Upload và quản lý video bài giảng
- Tạo bài tập và quiz
- Quản lý tài liệu học tập

### 2. Student Management
- Đăng ký khóa học
- Theo dõi tiến độ học tập
- Đánh giá và feedback

### 3. Analytics
- Thống kê chi tiết về học viên
- Báo cáo hiệu suất khóa học
- Dashboard analytics nâng cao

### 4. Communication
- Hệ thống tin nhắn nội bộ
- Forum thảo luận
- Thông báo real-time

## Công nghệ sử dụng

### Backend
- **Java EE 10** với Jakarta Persistence
- **EJB 4.0** cho business logic
- **JPA/Hibernate** cho database access
- **MySQL** database

### Frontend
- **JSP** với JSTL
- **Bootstrap 5** cho UI framework
- **Font Awesome** cho icons
- **JavaScript** cho interactions

### Development Tools
- **NetBeans IDE**
- **Apache Tomcat** server
- **Maven** build tool

## Hướng dẫn triển khai

### 1. Cài đặt dependencies
```bash
# Đảm bảo có Java EE 10 và MySQL
# Import project vào NetBeans
```

### 2. Cấu hình database
```sql
-- Chạy script online-learning-management-system.sql
-- Cấu hình persistence.xml
```

### 3. Build và Deploy
```bash
# Clean and Build project
# Deploy to Tomcat server
# Access tại http://localhost:8080/online-learning-management-system-war/
```

## Troubleshooting

### Lỗi thường gặp
1. **Database connection**: Kiểm tra cấu hình persistence.xml
2. **Session timeout**: Tăng session-timeout trong web.xml
3. **Permission denied**: Kiểm tra quyền truy cập database

### Debug
- Sử dụng NetBeans debugger
- Kiểm tra server logs
- Verify database connections

## Đóng góp

Để đóng góp vào dự án:
1. Fork repository
2. Tạo feature branch
3. Commit changes
4. Push và tạo Pull Request

## License

Dự án này được phát triển cho mục đích học tập và nghiên cứu.

---

**Tác giả**: ttnha  
**Ngày tạo**: 2024  
**Phiên bản**: 1.0
