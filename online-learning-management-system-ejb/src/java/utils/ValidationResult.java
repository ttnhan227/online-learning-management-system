package utils;

/**
 * Utility class to hold validation results
 */
public class ValidationResult {
    private boolean valid;
    private String message;
    private String errorCode;
    
    public ValidationResult() {
        this.valid = true;
        this.message = "";
        this.errorCode = "";
    }
    
    public ValidationResult(boolean valid, String message) {
        this.valid = valid;
        this.message = message;
        this.errorCode = "";
    }
    
    public ValidationResult(boolean valid, String message, String errorCode) {
        this.valid = valid;
        this.message = message;
        this.errorCode = errorCode;
    }
    
    // Getters and Setters
    public boolean isValid() {
        return valid;
    }
    
    public void setValid(boolean valid) {
        this.valid = valid;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getErrorCode() {
        return errorCode;
    }
    
    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }
    
    // Static factory methods for common results
    public static ValidationResult success() {
        return new ValidationResult(true, "Validation successful");
    }
    
    public static ValidationResult success(String message) {
        return new ValidationResult(true, message);
    }
    
    public static ValidationResult error(String message) {
        return new ValidationResult(false, message);
    }
    
    public static ValidationResult error(String message, String errorCode) {
        return new ValidationResult(false, message, errorCode);
    }
}
