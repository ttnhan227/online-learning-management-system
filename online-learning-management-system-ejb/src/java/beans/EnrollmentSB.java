/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/J2EE/EJB40/StatelessEjbClass.java to edit this template
 */
package beans;

import entities.AppUser;
import entities.Course;
import entities.Enrollment;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Admin
 */
@Stateless
@LocalBean
public class EnrollmentSB implements EnrollmentSBLocal {

    private final EntityManagerFactory emf;
    private final EntityManager em;

    public EnrollmentSB() {
        emf = Persistence.createEntityManagerFactory("online-learning-management-system-ejbPU");
        em = emf.createEntityManager();
    }

    //helper
    private void tx(Runnable r) {
        try {
            em.getTransaction().begin();
            r.run();
            em.getTransaction().commit();
        } catch (RuntimeException ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        }
    }

    @Override
    public Enrollment enrollStudent(Integer courseId, Integer studentId) {
        if (isEnrolled(courseId, studentId)) {
            return findByCourseAndStudent(courseId, studentId);
        }
        Course course = em.find(Course.class, courseId);
        AppUser student = em.find(AppUser.class, studentId);
        if (course == null || student == null) {
            throw new IllegalArgumentException("courseId hoặc studentId không hợp lệ.");
        }
        Enrollment e = new Enrollment();
        e.setCourseId(course);                            // field theo entity hiện có
        e.setStudentId(student);                          // field theo entity hiện có
        e.setEnrolledAt(new Date());                      // entity dùng java.util.Date
        e.setProgress(BigDecimal.ZERO);                   // progress dùng BigDecimal

        tx(() -> em.persist(e));
        return e;
    }

    @Override
    public Boolean isEnrolled(Integer courseId, Integer studentId) {
        return findByCourseAndStudent(courseId, studentId) != null;
    }

    @Override
    public void unenroll(Integer courseId, Integer studentId) {
        Enrollment e = findByCourseAndStudent(courseId, studentId);
        if (e != null) {
            Enrollment managed = em.contains(e) ? e : em.merge(e);
            tx(() -> em.remove(managed));
        }
    }

    @Override
    public void unenrollById(Integer enrollmentId) {
        Enrollment e = em.find(Enrollment.class, enrollmentId);
        if (e != null) {
            tx(() -> em.remove(e));
        }
    }

    @Override
    public List<Enrollment> getEnrollmentsByStudent(Integer studentId) {
        // join fetch để lấy luôn courseId (Course) dùng trong view
        TypedQuery<Enrollment> q = em.createQuery(
                "SELECT e FROM Enrollment e JOIN FETCH e.courseId WHERE e.studentId.userId = :sid ORDER BY e.enrolledAt DESC",
                Enrollment.class);
        q.setParameter("sid", studentId);
        return q.getResultList();
    }

    @Override
    public BigDecimal updateProgress(Integer courseId, Integer studentId, BigDecimal percent) {
        Enrollment e = requireEnrollment(courseId, studentId);
        BigDecimal clamped = clampPercent(percent);
        e.setProgress(clamped);
        tx(() -> em.merge(e));
        return clamped;
    }

    @Override
    public BigDecimal calculateAndUpdateProgess(Integer courseId, Integer studentId, int completed, int total) {
        BigDecimal pct = BigDecimal.ZERO;
        if (total > 0) {
            pct = new BigDecimal(completed)
                    .multiply(new BigDecimal(100))
                    .divide(new BigDecimal(total), 2, RoundingMode.HALF_UP);
        }
        return updateProgress(courseId, studentId, pct);
    }

    //Truy van noi bo
    private Enrollment findByCourseAndStudent(Integer courseId, Integer studentId) {
        List<Enrollment> result = em.createQuery(
                "SELECT e FROM Enrollment e WHERE e.courseId.courseId = :cid AND e.studentId.userId = :sid",
                Enrollment.class)
                .setParameter("cid", courseId)
                .setParameter("sid", studentId)
                .setMaxResults(1)
                .getResultList();
        return result.isEmpty() ? null : result.get(0);
    }

    private Enrollment requireEnrollment(Integer courseId, Integer studentId) {
        Enrollment e = findByCourseAndStudent(courseId, studentId);
        if (e == null) {
            throw new IllegalStateException("Sinh viên chưa ghi danh học phần này.");
        }
        return e;
    }

    private static BigDecimal clampPercent(BigDecimal val) {
        if (val == null) {
            return BigDecimal.ZERO;
        }
        if (val.compareTo(BigDecimal.ZERO) < 0) {
            return BigDecimal.ZERO;
        }
        if (val.compareTo(new BigDecimal("100")) > 0) {
            return new BigDecimal("100");
        }
        // scale 2 cho đẹp
        return val.setScale(2, RoundingMode.HALF_UP);
    }
}