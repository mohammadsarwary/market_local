import 'text_styles.dart';

/// Utility class for form validation
/// 
/// Provides static methods for validating common form inputs including
/// required fields, email addresses, phone numbers, length constraints,
/// and numeric values. All validators return null if validation passes,
/// or an error message string if validation fails.
/// 
/// Example:
/// ```dart
/// // Single validator
/// String? error = Validators.required(value);
/// 
/// // Combined validators
/// String? error = Validators.combine(value, [
///   Validators.required,
///   Validators.email,
///   (v) => Validators.minLength(v, 6),
/// ]);
/// ```
class Validators {
  Validators._();

  /// Validates that a field is not empty
  /// 
  /// Returns null if the value is not empty, otherwise returns
  /// a required field error message.
  /// 
  /// Parameters:
  /// - [value] The string value to validate
  /// 
  /// Returns:
  /// An error message string if validation fails, null otherwise
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.validationRequired;
    }
    return null;
  }

  /// Validates email format
  /// 
  /// Checks if the value is a valid email address format.
  /// The email must contain an @ symbol and a valid domain.
  /// 
  /// Parameters:
  /// - [value] The email address to validate
  /// 
  /// Returns:
  /// An error message string if validation fails, null otherwise
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.validationRequired;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return AppTexts.validationEmail;
    }
    return null;
  }

  /// Validates phone number format
  /// 
  /// Checks if the value is a valid phone number with at least 10 digits.
  /// Accepts optional + prefix, spaces, and hyphens.
  /// 
  /// Parameters:
  /// - [value] The phone number to validate
  /// 
  /// Returns:
  /// An error message string if validation fails, null otherwise
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.validationRequired;
    }
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return AppTexts.validationPhone;
    }
    return null;
  }

  /// Validates minimum length
  /// 
  /// Ensures the value has at least [min] characters.
  /// 
  /// Parameters:
  /// - [value] The string value to validate
  /// - [min] The minimum required length
  /// 
  /// Returns:
  /// An error message string if validation fails, null otherwise
  static String? minLength(String? value, int min) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.validationRequired;
    }
    if (value.length < min) {
      return '${AppTexts.validationMinLength} $min';
    }
    return null;
  }

  /// Validates maximum length
  /// 
  /// Ensures the value has at most [max] characters.
  /// 
  /// Parameters:
  /// - [value] The string value to validate
  /// - [max] The maximum allowed length
  /// 
  /// Returns:
  /// An error message string if validation fails, null otherwise
  static String? maxLength(String? value, int max) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.validationRequired;
    }
    if (value.length > max) {
      return '${AppTexts.validationMaxLength} $max';
    }
    return null;
  }

  /// Validates price format (positive number)
  /// 
  /// Ensures the value is a valid positive number.
  /// 
  /// Parameters:
  /// - [value] The price string to validate
  /// 
  /// Returns:
  /// An error message string if validation fails, null otherwise
  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.validationRequired;
    }
    final price = double.tryParse(value);
    if (price == null || price < 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  /// Combines multiple validators
  /// 
  /// Runs each validator in order and returns the first error encountered.
  /// Returns null if all validators pass.
  /// 
  /// Parameters:
  /// - [value] The value to validate
  /// - [validators] A list of validator functions to apply
  /// 
  /// Returns:
  /// The first error message encountered, or null if all pass
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
