package beans;

import entities.AppUser;
import entities.UserRole;
import jakarta.ejb.Local;
import java.util.List;

/**
 * Local interface for Profile session bean
 */
@Local
public interface ProfileSBLocal {
    
    /**
     * Get user profile by user ID
     * @param userId The ID of the user
     * @return AppUser object if found, null otherwise
     */
    AppUser getUserProfile(int userId);
    
    /**
     * Update user profile
     * @param user The updated user object
     * @return true if update was successful, false otherwise
     */
    boolean updateProfile(AppUser user);
    
    /**
     * Change user password
     * @param userId The ID of the user
     * @param currentPassword Current password for verification
     * @param newPassword New password to set
     * @return true if password was changed successfully, false otherwise
     */
    boolean changePassword(int userId, String currentPassword, String newPassword);
    
    /**
     * Get all roles for a user
     * @param userId The ID of the user
     * @return List of UserRole objects for the user
     */
    List<UserRole> getUserRoles(int userId);
}
