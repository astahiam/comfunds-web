class ValidationUtils {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    // More comprehensive email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null;
  }

  // Password validation for login (simpler)
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return null;
  }

  // Password validation for registration (stronger)
  static String? validateRegistrationPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung huruf kecil';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password harus mengandung karakter khusus';
    }
    
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (value != password) {
      return 'Password tidak cocok';
    }
    
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    
    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }
    
    return null;
  }

  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    
    // Remove all non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length < 10) {
      return 'Nomor telepon minimal 10 digit';
    }
    
    if (digitsOnly.length > 15) {
      return 'Nomor telepon maksimal 15 digit';
    }
    
    return null;
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat tidak boleh kosong';
    }
    
    if (value.length < 10) {
      return 'Alamat minimal 10 karakter';
    }
    
    return null;
  }

  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  // Password strength checker for UI feedback
  static Map<String, bool> checkPasswordStrength(String password) {
    return {
      'hasMinLength': password.length >= 8,
      'hasUppercase': password.contains(RegExp(r'[A-Z]')),
      'hasLowercase': password.contains(RegExp(r'[a-z]')),
      'hasNumber': password.contains(RegExp(r'[0-9]')),
      'hasSpecialChar': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };
  }

  // Calculate password strength score (0-5)
  static int getPasswordStrengthScore(String password) {
    final strength = checkPasswordStrength(password);
    return strength.values.where((requirement) => requirement).length;
  }

  // Get password strength text
  static String getPasswordStrengthText(String password) {
    final score = getPasswordStrengthScore(password);
    switch (score) {
      case 0:
      case 1:
        return 'Sangat Lemah';
      case 2:
        return 'Lemah';
      case 3:
        return 'Sedang';
      case 4:
        return 'Kuat';
      case 5:
        return 'Sangat Kuat';
      default:
        return 'Tidak Valid';
    }
  }

  // Get password strength color
  static String getPasswordStrengthColor(String password) {
    final score = getPasswordStrengthScore(password);
    switch (score) {
      case 0:
      case 1:
        return '#F44336'; // Red
      case 2:
        return '#FF9800'; // Orange
      case 3:
        return '#FFC107'; // Amber
      case 4:
        return '#8BC34A'; // Light Green
      case 5:
        return '#4CAF50'; // Green
      default:
        return '#9E9E9E'; // Grey
    }
  }
}
