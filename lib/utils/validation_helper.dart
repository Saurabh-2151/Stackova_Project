class ValidationHelper {
  // Email validation
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Phone number validation
  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;
    
    // Remove all non-digit characters
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check if it's a valid length (10-15 digits)
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }

  // Name validation
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    
    // Check minimum length
    if (name.trim().length < 2) return false;
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    return nameRegex.hasMatch(name.trim());
  }

  // URL validation
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Password strength validation
  static PasswordStrength getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.empty;
    
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) score++; // lowercase
    if (password.contains(RegExp(r'[A-Z]'))) score++; // uppercase
    if (password.contains(RegExp(r'[0-9]'))) score++; // numbers
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++; // special chars
    
    // Return strength based on score
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  // Form field validation
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!isValidName(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional in most cases
    }
    if (!isValidUrl(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    final strength = getPasswordStrength(value);
    switch (strength) {
      case PasswordStrength.empty:
        return 'Password is required';
      case PasswordStrength.weak:
        return 'Password is too weak. Use at least 8 characters with mixed case, numbers, and symbols';
      case PasswordStrength.medium:
      case PasswordStrength.strong:
        return null;
    }
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Number validation
  static String? validateNumber(String? value, {double? min, double? max, String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (min != null && number < min) {
      return '${fieldName ?? 'Value'} must be at least $min';
    }
    
    if (max != null && number > max) {
      return '${fieldName ?? 'Value'} must not exceed $max';
    }
    
    return null;
  }

  // Date validation
  static String? validateDate(String? value, {DateTime? minDate, DateTime? maxDate}) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    
    try {
      final date = DateTime.parse(value);
      
      if (minDate != null && date.isBefore(minDate)) {
        return 'Date must be after ${_formatDate(minDate)}';
      }
      
      if (maxDate != null && date.isAfter(maxDate)) {
        return 'Date must be before ${_formatDate(maxDate)}';
      }
      
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }

  // Custom validation
  static String? validateCustom(String? value, bool Function(String) validator, String errorMessage) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    
    if (!validator(value)) {
      return errorMessage;
    }
    
    return null;
  }

  // Multi-field validation
  static Map<String, String?> validateForm(Map<String, dynamic> formData, Map<String, String? Function(dynamic)> validators) {
    final errors = <String, String?>{};
    
    validators.forEach((field, validator) {
      final value = formData[field];
      final error = validator(value);
      if (error != null) {
        errors[field] = error;
      }
    });
    
    return errors;
  }

  // Sanitization helpers
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String sanitizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  static String sanitizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+\-\(\)\s]'), '');
  }

  // Helper methods
  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Validation result helpers
  static bool isFormValid(Map<String, String?> errors) {
    return errors.values.every((error) => error == null);
  }

  static List<String> getFormErrors(Map<String, String?> errors) {
    return errors.values.where((error) => error != null).cast<String>().toList();
  }

  // Real-time validation debouncing
  static String? validateWithDelay(
    String? value,
    String? Function(String?) validator,
    Duration delay,
  ) {
    // This would typically be implemented with a Timer in a StatefulWidget
    // For now, it's a placeholder for the concept
    return validator(value);
  }
}

enum PasswordStrength {
  empty,
  weak,
  medium,
  strong,
}

// Extension for easy validation
extension StringValidation on String? {
  bool get isValidEmail => ValidationHelper.isValidEmail(this ?? '');
  bool get isValidPhone => ValidationHelper.isValidPhoneNumber(this ?? '');
  bool get isValidName => ValidationHelper.isValidName(this ?? '');
  bool get isValidUrl => ValidationHelper.isValidUrl(this ?? '');
  
  String? validateAsEmail() => ValidationHelper.validateEmail(this);
  String? validateAsPhone() => ValidationHelper.validatePhone(this);
  String? validateAsName() => ValidationHelper.validateName(this);
  String? validateAsRequired({String? fieldName}) => ValidationHelper.validateRequired(this, fieldName: fieldName);
}