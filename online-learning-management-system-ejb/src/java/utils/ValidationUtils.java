package utils;

import java.util.regex.Pattern;

/**
 * Utility class for validation operations
 */
public class ValidationUtils {
    
    // Email regex pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    );
    
    // Password regex pattern - requires at least 6 chars, 1 uppercase, 1 lowercase, 1 digit
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
    );
    
    /**
     * Validates user registration data
     */
    public static ValidationResult validateRegistration(String fullName, String email, String password, String confirmPassword) {
        // Validate full name
        ValidationResult nameResult = validateFullName(fullName);
        if (!nameResult.isValid()) {
            return nameResult;
        }
        
        // Validate email
        ValidationResult emailResult = validateEmail(email);
        if (!emailResult.isValid()) {
            return emailResult;
        }
        
        // Validate password
        ValidationResult passwordResult = validatePassword(password);
        if (!passwordResult.isValid()) {
            return passwordResult;
        }
        
        // Validate password confirmation
        ValidationResult confirmResult = validatePasswordConfirmation(password, confirmPassword);
        if (!confirmResult.isValid()) {
            return confirmResult;
        }
        
        return ValidationResult.success("All validation checks passed");
    }
    
    /**
     * Validates login data
     */
    public static ValidationResult validateLogin(String email, String password) {
        // Validate email
        ValidationResult emailResult = validateEmail(email);
        if (!emailResult.isValid()) {
            return emailResult;
        }
        
        // Validate password (basic check for login)
        if (password == null || password.trim().isEmpty()) {
            return ValidationResult.error("Password is required", "PASSWORD_REQUIRED");
        }
        
        return ValidationResult.success("Login validation passed");
    }
    
    /**
     * Validates full name
     */
    public static ValidationResult validateFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return ValidationResult.error("Full name is required", "NAME_REQUIRED");
        }
        
        String trimmedName = fullName.trim();
        if (trimmedName.length() < 2) {
            return ValidationResult.error("Full name must be at least 2 characters long", "NAME_TOO_SHORT");
        }
        
        if (trimmedName.length() > 50) {
            return ValidationResult.error("Full name cannot exceed 50 characters", "NAME_TOO_LONG");
        }
        
        // Check if name contains only letters, spaces, and common punctuation
        if (!trimmedName.matches("^[a-zA-Z\\s\\-']+$")) {
            return ValidationResult.error("Full name can only contain letters, spaces, hyphens, and apostrophes", "NAME_INVALID_CHARS");
        }
        
        return ValidationResult.success();
    }
    
    /**
     * Validates email address
     */
    public static ValidationResult validateEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return ValidationResult.error("Email is required", "EMAIL_REQUIRED");
        }
        
        String trimmedEmail = email.trim().toLowerCase();
        
        if (!EMAIL_PATTERN.matcher(trimmedEmail).matches()) {
            return ValidationResult.error("Please enter a valid email address", "EMAIL_INVALID_FORMAT");
        }
        
        if (trimmedEmail.length() > 100) {
            return ValidationResult.error("Email address is too long", "EMAIL_TOO_LONG");
        }
        
        return ValidationResult.success();
    }
    
    /**
     * Validates password strength
     */
    public static ValidationResult validatePassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return ValidationResult.error("Password is required", "PASSWORD_REQUIRED");
        }
        
        if (password.length() < 6) {
            return ValidationResult.error("Password must be at least 6 characters long", "PASSWORD_TOO_SHORT");
        }
        
        if (password.length() > 128) {
            return ValidationResult.error("Password is too long", "PASSWORD_TOO_LONG");
        }
        
        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            return ValidationResult.error(
                "Password must contain at least one uppercase letter, one lowercase letter, and one number", 
                "PASSWORD_WEAK"
            );
        }
        
        return ValidationResult.success();
    }
    
    /**
     * Validates password confirmation
     */
    public static ValidationResult validatePasswordConfirmation(String password, String confirmPassword) {
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            return ValidationResult.error("Please confirm your password", "CONFIRM_PASSWORD_REQUIRED");
        }
        
        if (!password.equals(confirmPassword)) {
            return ValidationResult.error("Passwords do not match", "PASSWORD_MISMATCH");
        }
        
        return ValidationResult.success();
    }
    
    /**
     * Sanitizes input string to prevent XSS
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return "";
        }
        
        return input.trim()
                   .replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;")
                   .replaceAll("&", "&amp;");
    }
    
    /**
     * Checks if string contains only safe characters
     */
    public static boolean isSafeString(String input) {
        if (input == null) {
            return false;
        }
        
        // Allow letters, numbers, spaces, and common punctuation
        return input.matches("^[a-zA-Z0-9\\s\\-_.@!?#$%&*()+=:;,\\/]+$");
    }
}
