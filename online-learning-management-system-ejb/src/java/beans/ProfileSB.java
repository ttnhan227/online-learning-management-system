package beans;

import entities.AppUser;
import entities.UserRole;
import jakarta.ejb.Stateless;
import jakarta.ejb.LocalBean;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.util.List;
import utils.PasswordHasher;
import utils.ValidationUtils;
import utils.ValidationResult;

@Stateless
@LocalBean
public class ProfileSB implements ProfileSBLocal {

    private final EntityManagerFactory emf;
    private final EntityManager em;

    public ProfileSB() {
        emf = Persistence.createEntityManagerFactory("online-learning-management-system-ejbPU");
        em = emf.createEntityManager();
    }
    
    // Helper method for transactions
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
    public AppUser getUserProfile(int userId) {
        try {
            return em.find(AppUser.class, userId);
        } catch (Exception e) {
            System.err.println("Error fetching user profile: " + e.getMessage());
            return null;
        }
    }

    @Override
    public boolean updateProfile(AppUser user) {
        try {
            // Get the existing user to preserve some fields
            AppUser existingUser = em.find(AppUser.class, user.getUserId());
            if (existingUser == null) {
                System.err.println("User not found with ID: " + user.getUserId());
                return false;
            }
            
            // Sanitize and validate inputs
            user.setFullName(ValidationUtils.sanitizeInput(user.getFullName()));
            user.setEmail(ValidationUtils.sanitizeInput(user.getEmail()));
            
            // Sanitize optional fields
            if (user.getPhotoUrl() != null) {
                user.setPhotoUrl(ValidationUtils.sanitizeInput(user.getPhotoUrl()));
            }
            if (user.getDepartment() != null) {
                user.setDepartment(ValidationUtils.sanitizeInput(user.getDepartment()));
            }
            if (user.getBio() != null) {
                user.setBio(ValidationUtils.sanitizeInput(user.getBio()));
            }
            
            // Preserve verification status and document if not being updated
            if (existingUser.getVerificationDocument() != null && 
                (user.getVerificationDocument() == null || user.getVerificationDocument().isEmpty())) {
                user.setVerificationDocument(existingUser.getVerificationDocument());
                user.setIsApproved(existingUser.getIsApproved());
            }
            
            // Validate full name
            ValidationResult nameResult = ValidationUtils.validateFullName(user.getFullName());
            if (!nameResult.isValid()) {
                System.err.println("Invalid full name: " + nameResult.getMessage());
                return false;
            }
            
            // Validate email
            ValidationResult emailResult = ValidationUtils.validateEmail(user.getEmail());
            if (!emailResult.isValid()) {
                System.err.println("Invalid email: " + emailResult.getMessage());
                return false;
            }
            
            // Check if email is already taken by another user
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(u) FROM AppUser u WHERE u.email = :email AND u.userId != :userId", 
                Long.class
            );
            query.setParameter("email", user.getEmail());
            query.setParameter("userId", user.getUserId());
            
            long count = query.getSingleResult();
            if (count > 0) {
                System.err.println("Email is already in use by another account");
                return false;
            }
            
            // Update the user in a transaction
            tx(() -> em.merge(user));
            return true;
            
        } catch (Exception e) {
            System.err.println("Error updating profile: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<UserRole> getUserRoles(int userId) {
        try {
            TypedQuery<UserRole> query = em.createQuery(
                "SELECT ur FROM UserRole ur WHERE ur.userId.userId = :userId", 
                UserRole.class
            );
            query.setParameter("userId", userId);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Error fetching user roles: " + e.getMessage());
            return null;
        }
    }
    
    @Override
    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        try {
            // Validate new password
            ValidationResult passwordResult = ValidationUtils.validatePassword(newPassword);
            if (!passwordResult.isValid()) {
                System.err.println("Invalid password: " + passwordResult.getMessage());
                return false;
            }
            
            // Get the user
            AppUser user = em.find(AppUser.class, userId);
            if (user == null) {
                System.err.println("User not found");
                return false;
            }
            
            // Verify current password
            if (!PasswordHasher.verifyPassword(currentPassword, user.getPasswordHash())) {
                System.err.println("Current password is incorrect");
                return false;
            }
            
            // Hash and set new password
            String newPasswordHash = PasswordHasher.hashPassword(newPassword);
            user.setPasswordHash(newPasswordHash);
            
            // Update the user in a transaction
            tx(() -> em.merge(user));
            return true;
            
        } catch (Exception e) {
            System.err.println("Error changing password: " + e.getMessage());
            return false;
        }
    }
}
