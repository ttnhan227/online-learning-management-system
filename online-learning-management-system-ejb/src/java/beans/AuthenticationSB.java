package beans;

import entities.AppUser;
import entities.Role;
import entities.UserRole;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import utils.PasswordHasher;
import utils.ValidationUtils;
import utils.ValidationResult;

/**
 * Session Bean implementation class AuthenticationSB
 */
@Stateless
@LocalBean
public class AuthenticationSB implements AuthenticationSBLocal {
    private final EntityManagerFactory emf;
    private final EntityManager em;
    
    public AuthenticationSB() {
        emf = Persistence.createEntityManagerFactory("online-learning-management-system-ejbPU");
        em = emf.createEntityManager();
    }
    
    private void persist(Object object) {
        try {
            em.getTransaction().begin();
            em.persist(object);
            em.getTransaction().commit();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }
    
    // In-memory session storage (in a production environment, consider using a distributed cache)
    private static final ConcurrentHashMap<String, SessionData> activeSessions = new ConcurrentHashMap<>();
    private static final long SESSION_TIMEOUT = 30 * 60 * 1000; // 30 minutes
    
    private static class SessionData {
        final AppUser user;
        final long expiryTime;
        
        SessionData(AppUser user, long expiryTime) {
            this.user = user;
            this.expiryTime = expiryTime;
        }
    }

    /**
     * Test method to verify database connection and entity manager injection
     */
    @Override
    public boolean testConnection() {
        try {
            System.out.println("Testing database connection...");
            
            if (em == null || !em.isOpen()) {
                System.err.println("EntityManager is not initialized or closed");
                return false;
            }
            
            System.out.println("EntityManager is ready");
            
            // Try a simple query
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(r) FROM Role r", Long.class);
            Long count = query.getSingleResult();
            
            System.out.println("Database connection successful. Role count: " + count);
            return true;
        } catch (Exception e) {
            System.err.println("Database connection test failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public AppUser registerUser(String fullName, String email, String password, String roleName) {
        return registerUserInternal(fullName, email, password, roleName, null, null, null);
    }
    
    @Override
    public AppUser registerInstructor(String fullName, String email, String password, String roleName, 
                                   String bio, String department, String verificationDocumentPath) {
        return registerUserInternal(fullName, email, password, roleName, bio, department, verificationDocumentPath);
    }
    
    private AppUser registerUserInternal(String fullName, String email, String password, String roleName,
                                      String bio, String department, String verificationDocumentPath) {
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            
            // Sanitize inputs
            String sanitizedFullName = ValidationUtils.sanitizeInput(fullName);
            String sanitizedEmail = ValidationUtils.sanitizeInput(email);
            
            // Validate registration data
            ValidationResult validationResult = ValidationUtils.validateRegistration(
                sanitizedFullName, sanitizedEmail, password, password);
            
            if (!validationResult.isValid()) {
                System.err.println("Validation failed: " + validationResult.getMessage());
                transaction.rollback();
                return null;
            }
            
            // Check if email already exists
            TypedQuery<AppUser> query = em.createNamedQuery("AppUser.findByEmail", AppUser.class);
            query.setParameter("email", sanitizedEmail.toLowerCase());
            if (!query.getResultList().isEmpty()) {
                transaction.rollback();
                return null; // Email already exists
            }
            
            // Create new user
            AppUser newUser = new AppUser();
            newUser.setFullName(sanitizedFullName);
            newUser.setEmail(sanitizedEmail.toLowerCase());
            newUser.setPasswordHash(PasswordHasher.hashPassword(password));
            newUser.setCreatedAt(new Date());
            
            // Set instructor-specific fields if provided
            if (bio != null) {
                newUser.setBio(bio);
            }
            if (department != null) {
                newUser.setDepartment(department);
            }
            if (verificationDocumentPath != null) {
                newUser.setVerificationDocument(verificationDocumentPath);
                newUser.setIsApproved(false); // New instructors need approval
            } else {
                newUser.setIsApproved(true); // Regular users are approved by default
            }
            
            // Save the user
            em.persist(newUser);
            
            // Assign role
            TypedQuery<Role> roleQuery = em.createNamedQuery("Role.findByRoleName", Role.class);
            roleQuery.setParameter("roleName", roleName);
            List<Role> roles = roleQuery.getResultList();
            
            if (roles.isEmpty()) {
                transaction.rollback();
                return null; // Role not found
            }
            
            UserRole userRole = new UserRole();
            userRole.setUserId(newUser);
            userRole.setRoleId(roles.get(0));
            em.persist(userRole);
            
            transaction.commit();
            return newUser;
            
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return null;
        }
    }
    
    @Override
    public AppUser getUserByEmail(String email) {
        try {
            TypedQuery<AppUser> query = em.createNamedQuery("AppUser.findByEmail", AppUser.class);
            query.setParameter("email", email);
            
            List<AppUser> users = query.getResultList();
            return users.isEmpty() ? null : users.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }



    @Override
    public AppUser login(String email, String password) {
        try {
            // Clear the EntityManager cache to ensure fresh data is fetched from the database
            em.clear();
            
            // Sanitize email input
            String sanitizedEmail = ValidationUtils.sanitizeInput(email);
            
            // Validate login data
            ValidationResult validationResult = ValidationUtils.validateLogin(sanitizedEmail, password);
            if (!validationResult.isValid()) {
                System.err.println("Login validation failed: " + validationResult.getMessage());
                return null;
            }
            
            TypedQuery<AppUser> query = em.createNamedQuery("AppUser.findByEmail", AppUser.class);
            query.setParameter("email", sanitizedEmail.toLowerCase());
            List<AppUser> users = query.getResultList();
            
            if (users.isEmpty()) {
                return null; // User not found
            }
            
            AppUser user = users.get(0);
            if (PasswordHasher.verifyPassword(password, user.getPasswordHash())) {
                return user;
            }
            return null; // Invalid password
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean logout(Integer userId) {
        if (userId == null) {
            return false;
        }
        
        // Remove all sessions for this user
        boolean removed = false;
        for (var entry : activeSessions.entrySet()) {
            if (entry.getValue().user.getUserId().equals(userId)) {
                activeSessions.remove(entry.getKey());
                removed = true;
            }
        }
        return removed;
    }
    
    // Helper method to create a new session
    public String createSession(AppUser user) {
        String sessionId = UUID.randomUUID().toString();
        long expiryTime = System.currentTimeMillis() + SESSION_TIMEOUT;
        activeSessions.put(sessionId, new SessionData(user, expiryTime));
        return sessionId;
    }

    @Override
    public AppUser getCurrentUser(String sessionId) {
        if (sessionId == null) {
            return null;
        }
        
        SessionData sessionData = activeSessions.get(sessionId);
        if (sessionData == null) {
            return null;
        }
        
        // Check if session has expired
        if (System.currentTimeMillis() > sessionData.expiryTime) {
            activeSessions.remove(sessionId);
            return null;
        }
        
        // Refresh session
        sessionData = new SessionData(sessionData.user, System.currentTimeMillis() + SESSION_TIMEOUT);
        activeSessions.put(sessionId, sessionData);
        
        return sessionData.user;
    }

    @Override
    public boolean hasRole(Integer userId, String roleName) {
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(ur) FROM UserRole ur WHERE ur.userId.userId = :userId AND ur.roleId.roleName = :roleName", 
                Long.class);
            query.setParameter("userId", userId);
            query.setParameter("roleName", roleName);
            return query.getSingleResult() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean validateSession(String sessionId) {
        return getCurrentUser(sessionId) != null;
    }
    
    // Helper method to clean up expired sessions (should be called periodically)
    public void cleanupExpiredSessions() {
        long currentTime = System.currentTimeMillis();
        activeSessions.entrySet().removeIf(entry -> entry.getValue().expiryTime < currentTime);
    }
}
