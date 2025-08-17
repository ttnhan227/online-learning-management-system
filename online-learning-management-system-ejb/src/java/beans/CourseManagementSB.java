package beans;

import entities.Course;
import entities.AppUser;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.util.Date;
import java.util.List;

/**
 * Session Bean cho quản lý khóa học
 * @author ttnha
 */
@Stateless
public class CourseManagementSB implements CourseManagementSBLocal {

       private final EntityManagerFactory emf;
    private final EntityManager em;
    
    public CourseManagementSB() {
        emf = Persistence.createEntityManagerFactory("online-learning-management-system-ejbPU");
        em = emf.createEntityManager();
    }
    
    @Override
    public List<Course> getCoursesByInstructor(int instructorId) {
        try {
            TypedQuery<Course> query = em.createQuery(
                "SELECT c FROM Course c WHERE c.instructorId.userId = :instructorId ORDER BY c.createdAt DESC", 
                Course.class
            );
            query.setParameter("instructorId", instructorId);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Error fetching courses by instructor: " + e.getMessage());
            return null;
        }
    }

    
    public Course createCourse(String title, String description, String prerequisites, AppUser instructor) {
        try {
            em.getTransaction().begin();
            
            Course course = new Course();
            course.setTitle(title);
            course.setDescription(description);
            course.setPrerequisites(prerequisites);
            course.setInstructorId(instructor);
            course.setCreatedAt(new Date());
            
            em.persist(course);
            em.flush(); // Ensure ID is generated
            
            em.getTransaction().commit();
            return course;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    
    public Course updateCourse(Integer courseId, String title, String description, String prerequisites) {
        try {
            em.getTransaction().begin();
            
            Course course = em.find(Course.class, courseId);
            if (course != null) {
                course.setTitle(title);
                course.setDescription(description);
                course.setPrerequisites(prerequisites);
                em.merge(course);
            }
            
            em.getTransaction().commit();
            return course;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    
    public boolean deleteCourse(Integer courseId) {
        try {
            em.getTransaction().begin();
            
            Course course = em.find(Course.class, courseId);
            if (course != null) {
                em.remove(course);
                em.getTransaction().commit();
                return true;
            }
            
            em.getTransaction().rollback();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    
    public Course getCourseById(Integer courseId) {
        try {
            em.getTransaction().begin();
            Course course = em.find(Course.class, courseId);
            em.getTransaction().commit();
            return course;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    
    public List<Course> getAllCourses() {
        try {
            em.getTransaction().begin();
            TypedQuery<Course> query = em.createNamedQuery("Course.findAll", Course.class);
            List<Course> courses = query.getResultList();
            em.getTransaction().commit();
            return courses;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    
    public List<Course> getCoursesByInstructor(Integer instructorId) {
        try {
            System.out.println("=== DEBUG getCoursesByInstructor ===");
            System.out.println("Instructor ID: " + instructorId);
            
            em.getTransaction().begin();
            System.out.println("Transaction begun");
            
            TypedQuery<Course> query = em.createQuery(
                "SELECT c FROM Course c WHERE c.instructorId.userId = :instructorId", 
                Course.class
            );
            query.setParameter("instructorId", instructorId);
            System.out.println("Query created and parameter set");
            
            List<Course> courses = query.getResultList();
            System.out.println("Query executed, found " + courses.size() + " courses");
            
            em.getTransaction().commit();
            System.out.println("Transaction committed");
            
            return courses;
        } catch (Exception e) {
            System.out.println("Error in getCoursesByInstructor: " + e.getMessage());
            e.printStackTrace();
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
                System.out.println("Transaction rolled back");
            }
            throw e;
        }
    }

    
    public List<Course> searchCoursesByTitle(String title) {
        try {
            em.getTransaction().begin();
            TypedQuery<Course> query = em.createQuery(
                "SELECT c FROM Course c WHERE LOWER(c.title) LIKE LOWER(:title)", 
                Course.class
            );
            query.setParameter("title", "%" + title + "%");
            List<Course> courses = query.getResultList();
            em.getTransaction().commit();
            return courses;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

   
    public List<Course> searchCoursesByDescription(String description) {
        try {
            em.getTransaction().begin();
            TypedQuery<Course> query = em.createQuery(
                "SELECT c FROM Course c WHERE LOWER(c.description) LIKE LOWER(:description)", 
                Course.class
            );
            query.setParameter("description", "%" + description + "%");
            List<Course> courses = query.getResultList();
            em.getTransaction().commit();
            return courses;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    
    public List<Course> searchCourses(String searchTerm) {
        try {
            em.getTransaction().begin();
            TypedQuery<Course> query = em.createQuery(
                "SELECT c FROM Course c WHERE LOWER(c.title) LIKE LOWER(:searchTerm) " +
                "OR LOWER(c.description) LIKE LOWER(:searchTerm)", 
                Course.class
            );
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            List<Course> courses = query.getResultList();
            em.getTransaction().commit();
            return courses;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    /**
     * Tìm kiếm khóa học với bộ lọc và sắp xếp.
     * Vì entity hiện không có trường category/level, ta lọc dựa trên từ khóa xuất hiện trong title/description.
     */
    public List<Course> searchCourses(String searchTerm, java.util.List<String> categories, java.util.List<String> levels, String sortOption) {
        try {
            em.getTransaction().begin();

            StringBuilder jpql = new StringBuilder("SELECT c FROM Course c WHERE 1=1");

            // Base keyword search on title/description
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                jpql.append(" AND (LOWER(c.title) LIKE LOWER(:kw) OR LOWER(c.description) LIKE LOWER(:kw))");
            }

            // Category filters mapped to keywords in title/description
            if (categories != null && !categories.isEmpty()) {
                jpql.append(" AND (");
                for (int i = 0; i < categories.size(); i++) {
                    if (i > 0) jpql.append(" OR ");
                    jpql.append(" LOWER(c.title) LIKE LOWER(:cat" + i + ") OR LOWER(c.description) LIKE LOWER(:cat" + i + ")");
                }
                jpql.append(")");
            }

            // Level filters mapped to keywords in title/description
            if (levels != null && !levels.isEmpty()) {
                jpql.append(" AND (");
                for (int i = 0; i < levels.size(); i++) {
                    if (i > 0) jpql.append(" OR ");
                    jpql.append(" LOWER(c.title) LIKE LOWER(:lvl" + i + ") OR LOWER(c.description) LIKE LOWER(:lvl" + i + ")");
                }
                jpql.append(")");
            }

            // Sorting
            String sort = (sortOption != null) ? sortOption.toLowerCase() : "latest";
            switch (sort) {
                case "oldest":
                    jpql.append(" ORDER BY c.createdAt ASC");
                    break;
                case "az":
                    jpql.append(" ORDER BY c.title ASC");
                    break;
                case "za":
                    jpql.append(" ORDER BY c.title DESC");
                    break;
                case "latest":
                default:
                    jpql.append(" ORDER BY c.createdAt DESC");
                    break;
            }

            TypedQuery<Course> query = em.createQuery(jpql.toString(), Course.class);

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                query.setParameter("kw", "%" + searchTerm.trim() + "%");
            }
            if (categories != null) {
                for (int i = 0; i < categories.size(); i++) {
                    query.setParameter("cat" + i, "%" + categories.get(i).trim() + "%");
                }
            }
            if (levels != null) {
                for (int i = 0; i < levels.size(); i++) {
                    query.setParameter("lvl" + i, "%" + levels.get(i).trim() + "%");
                }
            }

            List<Course> courses = query.getResultList();
            em.getTransaction().commit();
            return courses;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    
    public List<Course> getCoursesWithPagination(int page, int pageSize) {
        try {
            em.getTransaction().begin();
            TypedQuery<Course> query = em.createNamedQuery("Course.findAll", Course.class);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            List<Course> courses = query.getResultList();
            em.getTransaction().commit();
            return courses;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    
    public long getTotalCourseCount() {
        try {
            em.getTransaction().begin();
            Query query = em.createQuery("SELECT COUNT(c) FROM Course c");
            Long count = (Long) query.getSingleResult();
            em.getTransaction().commit();
            return count;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    
    public boolean isInstructorOfCourse(Integer userId, Integer courseId) {
        try {
            em.getTransaction().begin();
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(c) FROM Course c WHERE c.courseId = :courseId AND c.instructorId.userId = :userId", 
                Long.class
            );
            query.setParameter("courseId", courseId);
            query.setParameter("userId", userId);
            Long count = query.getSingleResult();
            em.getTransaction().commit();
            return count > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }
}
