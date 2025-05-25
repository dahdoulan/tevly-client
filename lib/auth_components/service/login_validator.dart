class LoginValidator {
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String passwordRegex = r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$';

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(emailRegex).hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (!RegExp(passwordRegex).hasMatch(password)) {
      return 'Min 8 chars, 1 uppercase, 1 symbol';
    }
    return null;
  }
}
class SignupValidator {
  static const String nameRegex = r'^[a-zA-Z]{1,12}$';
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String passwordRegex = r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$';
  static const String phoneRegex = r'^\+?[\d-]{10,}$';

  static String? validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (!RegExp(nameRegex).hasMatch(value)) {
      return 'Only letters allowed, max 12 characters';
    }
    return null;
  }

  // Add other validation methods...
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!RegExp(passwordRegex).hasMatch(value)) {
      return 'Min 8 chars, 1 uppercase, 1 symbol';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(phoneRegex).hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }
}