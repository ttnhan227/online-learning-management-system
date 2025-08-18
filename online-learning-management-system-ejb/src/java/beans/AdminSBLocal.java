package beans;

import entities.AppUser;
import entities.Role;
import java.util.List;
import jakarta.ejb.Local;
import utils.ValidationResult;

/**
 * Local interface for AdminSB session bean
 */
@Local
public interface AdminSBLocal {
    // User Management
    List<AppUser> getAllUsers();
    List<AppUser> getUsersByRole(String roleName);
    AppUser getUserById(Integer userId);
    ValidationResult updateUser(AppUser user);
    ValidationResult approveInstructor(Integer userId);
    ValidationResult deleteUser(Integer userId);
    
    // Role Management
    List<Role> getAllRoles();
    Role getRoleByName(String roleName);
    
    // Utility
    void close();
}
