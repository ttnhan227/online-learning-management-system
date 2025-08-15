package beans;

import entities.AppUser;
import jakarta.ejb.Local;

/**
 * Local interface for authentication-related business logic
 */
@Local
public interface AuthenticationSBLocal {
    
    /**
     * Tests the database connection and entity manager injection
     * @return true if connection is successful, false otherwise
     */
    boolean testConnection();
    
    /**
     * Registers a new user with the system
     * @param fullName User's full name
     * @param email User's email (must be unique)
     * @param password User's password (will be hashed)
     * @param roleName Role to assign to the user (e.g., "Student", "Instructor", "Administrator")
     * @return The created AppUser object if successful, null otherwise
     */
    AppUser registerUser(String fullName, String email, String password, String roleName);
    
    /**
     * Authenticates a user with email and password
     * @param email User's email
     * @param password User's password
     * @return Authenticated AppUser if successful, null otherwise
     */
    AppUser login(String email, String password);
    
    /**
     * Logs out the current user
     * @param userId ID of the user to log out
     * @return true if logout was successful, false otherwise
     */
    boolean logout(Integer userId);
    
    /**
     * Gets the currently logged-in user by session ID
     * @param sessionId The session ID
     * @return The logged-in user or null if not found/expired
     */
    AppUser getCurrentUser(String sessionId);
    
    /**
     * Checks if a user has a specific role
     * @param userId The user ID to check
     * @param roleName The role name to verify
     * @return true if user has the role, false otherwise
     */
    boolean hasRole(Integer userId, String roleName);
    
    /**
     * Validates if a session is still active
     * @param sessionId The session ID to validate
     * @return true if session is valid, false otherwise
     */
    boolean validateSession(String sessionId);
}
