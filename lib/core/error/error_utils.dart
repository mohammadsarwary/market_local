import 'package:flutter/material.dart';
import 'error_handler.dart';
import 'error_boundary_widget.dart';
import 'error_controller.dart';

/// Utility functions for error handling
class ErrorUtils {
  /// Wrap a widget with error boundary for easy usage
  static Widget withErrorBoundary({
    required Widget child,
    String? boundaryName,
    Widget Function(Object error, VoidCallback retry)? errorBuilder,
  }) {
    return ErrorBoundary(
      boundaryName: boundaryName,
      errorBuilder: errorBuilder,
      child: child,
    );
  }

  /// Wrap a network operation with error boundary
  static Widget withNetworkErrorBoundary({
    required Widget child,
    Future<void> Function()? onRetry,
    String? operationName,
  }) {
    return NetworkErrorBoundary(
      operationName: operationName,
      onRetry: onRetry,
      child: child,
    );
  }

  /// Handle async operations with error boundary
  static Widget withAsyncErrorBoundary<T>({
    required Future<T> future,
    required Widget Function(T data) builder,
    Widget Function(Object error)? errorBuilder,
    Widget Function()? loadingBuilder,
    String? operationName,
  }) {
    return AsyncErrorBoundary<T>(
      future: future,
      builder: builder,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      operationName: operationName,
    );
  }

  /// Show error dialog manually
  static void showErrorDialog(Object error, {String? title}) {
    ErrorController.to.setGlobalError(error);
  }

  /// Show error snackbar
  static void showErrorSnackbar(Object error, {String? message}) {
    ErrorController.to.handleError(error);
  }

  /// Execute operation with error handling
  static Future<T?> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    String? operationName,
    bool showSnackbar = true,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      AppErrorHandler.handleAsyncError(error, stackTrace);
      
      if (showSnackbar) {
        ErrorController.to.handleError(error);
      }
      
      return null;
    }
  }

  /// Execute operation with retry mechanism
  static Future<T?> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    String? operationName,
  }) async {
    return await ErrorController.to.retryOperation<T>(
      operation,
      maxRetries: maxRetries,
      delay: delay,
    );
  }

  /// Create custom exception with context
  static AppException createException(
    String message, {
    String? code,
    Object? originalError,
    String? context,
  }) {
    final fullMessage = context != null ? '$context: $message' : message;
    return AppException(fullMessage, code: code, originalError: originalError);
  }

  /// Create network exception
  static NetworkException createNetworkException(
    String message, {
    String? code,
    Object? originalError,
  }) {
    return NetworkException(message, code: code, originalError: originalError);
  }

  /// Create validation exception
  static ValidationException createValidationException(
    String message, {
    String? code,
  }) {
    return ValidationException(message, code: code);
  }

  /// Create data exception
  static DataException createDataException(
    String message, {
    String? code,
    Object? originalError,
  }) {
    return DataException(message, code: code, originalError: originalError);
  }
}

/// Extension methods for easier error handling
extension ErrorHandlingExtensions on Future {
  /// Execute future with error handling
  Future<T?> withErrorHandling<T>({
    String? operationName,
    bool showSnackbar = true,
  }) {
    return ErrorUtils.executeWithErrorHandling<T>(
      () => this as Future<T>,
      operationName: operationName,
      showSnackbar: showSnackbar,
    );
  }

  /// Execute future with retry mechanism
  Future<T?> withRetry<T>({
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    String? operationName,
  }) {
    return ErrorUtils.executeWithRetry<T>(
      () => this as Future<T>,
      maxRetries: maxRetries,
      delay: delay,
      operationName: operationName,
    );
  }
}

extension WidgetErrorExtensions on Widget {
  /// Wrap widget with error boundary
  Widget withErrorBoundary({
    String? boundaryName,
    Widget Function(Object error, VoidCallback retry)? errorBuilder,
  }) {
    return ErrorUtils.withErrorBoundary(
      child: this,
      boundaryName: boundaryName,
      errorBuilder: errorBuilder,
    );
  }

  /// Wrap widget with network error boundary
  Widget withNetworkErrorBoundary({
    Future<void> Function()? onRetry,
    String? operationName,
  }) {
    return ErrorUtils.withNetworkErrorBoundary(
      child: this,
      onRetry: onRetry,
      operationName: operationName,
    );
  }
}

/// Constants for common error codes
class ErrorCodes {
  // Network errors
  static const String networkTimeout = 'NETWORK_TIMEOUT';
  static const String networkConnection = 'NETWORK_CONNECTION';
  static const String networkServerError = 'NETWORK_SERVER_ERROR';
  static const String networkNotFound = 'NETWORK_NOT_FOUND';
  
  // Validation errors
  static const String validationRequired = 'VALIDATION_REQUIRED';
  static const String validationInvalid = 'VALIDATION_INVALID';
  static const String validationFormat = 'VALIDATION_FORMAT';
  
  // Data errors
  static const String dataNotFound = 'DATA_NOT_FOUND';
  static const String dataCorrupted = 'DATA_CORRUPTED';
  static const String dataPermission = 'DATA_PERMISSION';
  
  // General errors
  static const String generalUnknown = 'GENERAL_UNKNOWN';
  static const String generalUnexpected = 'GENERAL_UNEXPECTED';
}

/// Common error messages
class ErrorMessages {
  // Network messages
  static const String networkTimeout = 'Request timed out. Please check your connection.';
  static const String networkConnection = 'No internet connection. Please check your network settings.';
  static const String networkServerError = 'Server is experiencing issues. Please try again later.';
  static const String networkNotFound = 'The requested resource was not found.';
  
  // Validation messages
  static const String validationRequired = 'This field is required.';
  static const String validationInvalid = 'Please enter a valid value.';
  static const String validationFormat = 'The format is incorrect.';
  
  // Data messages
  static const String dataNotFound = 'Data not found.';
  static const String dataCorrupted = 'Data is corrupted or invalid.';
  static const String dataPermission = 'You don\'t have permission to access this data.';
  
  // General messages
  static const String generalUnknown = 'An unknown error occurred.';
  static const String generalUnexpected = 'An unexpected error occurred. Please try again.';
}
