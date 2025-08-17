/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/J2EE/EJB40/SessionLocal.java to edit this template
 */
package beans;

import entities.Enrollment;
import jakarta.ejb.Local;
import java.math.BigDecimal;
import java.util.List;

/**
 *
 * @author Admin
 */
@Local
public interface EnrollmentSBLocal {
    Enrollment enrollStudent(Integer courseId, Integer studentId);
    Boolean isEnrolled(Integer courseId, Integer studentId);
    void unenroll (Integer courseId, Integer studentId);
    void unenrollById(Integer enrollmentId);
    
    List<Enrollment> getEnrollmentsByStudent(Integer studentId);
    
    //Cap nhat % tien do
    BigDecimal updateProgress(Integer courseId, Integer studentId, BigDecimal percent);
    
    // tinh tien do = completed/total*100(%)
    BigDecimal calculateAndUpdateProgess(Integer courseId, Integer studentId, int completed, int total);
    
}