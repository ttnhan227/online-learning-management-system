package beans;

import entities.Course;
import entities.AppUser;
import java.util.List;

/**
 * Local Interface cho Course Management Session Bean
 * @author ttnha
 */
public interface CourseManagementSBLocal {
    
    /**
     * Tạo khóa học mới
     */
    Course createCourse(String title, String description, String prerequisites, AppUser instructor);
    
    /**
     * Cập nhật thông tin khóa học
     */
    Course updateCourse(Integer courseId, String title, String description, String prerequisites);
    
    /**
     * Xóa khóa học
     */
    boolean deleteCourse(Integer courseId);
    
    /**
     * Lấy khóa học theo ID
     */
    Course getCourseById(Integer courseId);
    
    /**
     * Lấy tất cả khóa học
     */
    List<Course> getAllCourses();
    
    /**
     * Lấy khóa học theo instructor
     */
    List<Course> getCoursesByInstructor(Integer instructorId);
    
    /**
     * Tìm kiếm khóa học theo tiêu đề
     */
    List<Course> searchCoursesByTitle(String title);
    
    /**
     * Tìm kiếm khóa học theo mô tả
     */
    List<Course> searchCoursesByDescription(String description);
    
    /**
     * Tìm kiếm khóa học tổng hợp (tiêu đề + mô tả)
     */
    List<Course> searchCourses(String searchTerm);

    /**
     * Tìm kiếm khóa học với bộ lọc và sắp xếp
     * @param searchTerm từ khóa tìm kiếm áp dụng cho title hoặc description
     * @param categories danh sách category (ví dụ: programming, design, business, language)
     * @param levels danh sách level (ví dụ: beginner, intermediate, advanced)
     * @param sortOption tiêu chí sắp xếp: latest, oldest, az, za
     */
    List<Course> searchCourses(String searchTerm, java.util.List<String> categories, java.util.List<String> levels, String sortOption);
    
    /**
     * Lấy danh sách khóa học có phân trang
     */
    List<Course> getCoursesWithPagination(int page, int pageSize);
    
    /**
     * Đếm tổng số khóa học
     */
    long getTotalCourseCount();
    
    /**
     * Kiểm tra xem người dùng có phải là instructor của khóa học không
     */
    boolean isInstructorOfCourse(Integer userId, Integer courseId);
}
