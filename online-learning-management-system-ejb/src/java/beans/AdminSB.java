package beans;

import entities.AppUser;
import entities.Role;
import entities.UserRole;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.util.List;
import utils.ValidationResult;

/**
 * Session Bean implementation class AdminSB
 */
@Stateless
public class AdminSB implements AdminSBLocal {
    private final EntityManagerFactory emf;
    private final EntityManager em;
    
    public AdminSB() {
        emf = Persistence.createEntityManagerFactory("online-learning-management-system-ejbPU");
        em = emf.createEntityManager();
    }
    
    private void beginTransaction() {
        if (!em.getTransaction().isActive()) {
            em.getTransaction().begin();
        }
    }
    
    private void commitTransaction() {
        if (em.getTransaction().isActive()) {
            em.getTransaction().commit();
        }
    }
    
    private void rollbackTransaction() {
        if (em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }
    }
    
    // User Management
    public List<AppUser> getAllUsers() {
        TypedQuery<AppUser> query = em.createNamedQuery("AppUser.findAll", AppUser.class);
        return query.getResultList();
    }
    
    public List<AppUser> getUsersByRole(String roleName) {
        TypedQuery<AppUser> query = em.createQuery(
            "SELECT DISTINCT u FROM AppUser u JOIN u.userRoleList ur JOIN ur.roleId r WHERE r.roleName = :roleName", 
            AppUser.class
        );
        query.setParameter("roleName", roleName);
        return query.getResultList();
    }
    
    public AppUser getUserById(Integer userId) {
        return em.find(AppUser.class, userId);
    }
    
    public ValidationResult updateUser(AppUser user) {
        try {
            beginTransaction();
            em.merge(user);
            commitTransaction();
            return new ValidationResult(true, "User updated successfully");
        } catch (Exception e) {
            rollbackTransaction();
            return new ValidationResult(false, "Failed to update user: " + e.getMessage());
        }
    }
    
    public ValidationResult approveInstructor(Integer userId) {
        try {
            AppUser user = em.find(AppUser.class, userId);
            if (user == null) {
                return new ValidationResult(false, "User not found");
            }
            
            // Check if user has instructor role
            boolean isInstructor = user.getUserRoleList().stream()
                .anyMatch(ur -> "INSTRUCTOR".equalsIgnoreCase(ur.getRoleId().getRoleName()));
                
            if (!isInstructor) {
                return new ValidationResult(false, "User is not an instructor");
            }
            
            beginTransaction();
            user.setIsApproved(true);
            em.merge(user);
            commitTransaction();
            
            return new ValidationResult(true, "Instructor approved successfully");
        } catch (Exception e) {
            rollbackTransaction();
            return new ValidationResult(false, "Failed to approve instructor: " + e.getMessage());
        }
    }
    
    public ValidationResult deleteUser(Integer userId) {
        try {
            AppUser user = em.find(AppUser.class, userId);
            if (user == null) {
                return new ValidationResult(false, "User not found");
            }
            
            beginTransaction();
            // First delete user roles to avoid foreign key constraint
            TypedQuery<UserRole> roleQuery = em.createQuery(
                "SELECT ur FROM UserRole ur WHERE ur.userId.userId = :userId", 
                UserRole.class
            );
            roleQuery.setParameter("userId", userId);
            List<UserRole> userRoles = roleQuery.getResultList();
            
            for (UserRole ur : userRoles) {
                em.remove(ur);
            }
            
            // Then delete the user
            em.remove(em.contains(user) ? user : em.merge(user));
            commitTransaction();
            
            return new ValidationResult(true, "User deleted successfully");
        } catch (Exception e) {
            rollbackTransaction();
            return new ValidationResult(false, "Failed to delete user: " + e.getMessage());
        }
    }
    
    // Role Management
    public List<Role> getAllRoles() {
        TypedQuery<Role> query = em.createNamedQuery("Role.findAll", Role.class);
        return query.getResultList();
    }
    
    public Role getRoleByName(String roleName) {
        try {
            TypedQuery<Role> query = em.createNamedQuery("Role.findByRoleName", Role.class);
            query.setParameter("roleName", roleName);
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }
    
    public void close() {
        if (em != null && em.isOpen()) {
            em.close();
        }
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
