import '../constants/app_texts.dart';

/// Utility class for form validation
class Validators {
  Validators._();

  /// Validates that a field is not empty
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.validationRequired;
    }
    return null;
  }

  /// Validates email format
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
