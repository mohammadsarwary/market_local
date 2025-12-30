import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'error_handler.dart';

/// Controller for managing global error states and recovery
class ErrorController extends GetxController {
  static ErrorController get to => Get.find();

  final Rxn<Object> _globalError = Rxn<Object>();
  final RxBool _isErrorShowing = false.obs;

  /// Get current global error
  Object? get globalError => _globalError.value;

  /// Check if error dialog is currently showing
  bool get isErrorShowing => _isErrorShowing.value;

  /// Set a global error that can be handled app-wide
  void setGlobalError(Object error) {
    _globalError.value = error;
    _showGlobalErrorDialog();
  }

  /// Clear the global error
  void clearGlobalError() {
    _globalError.value = null;
    _isErrorShowing.value = false;
  }

  /// Show global error dialog
  void _showGlobalErrorDialog() {
    if (_isErrorShowing.value) return;

    _isErrorShowing.value = true;
    
    String title = 'Error';
    String message = 'An unexpected error occurred.';

    if (_globalError.value is AppException) {
      title = 'Application Error';
      message = (_globalError.value as AppException).message;
    } else if (_globalError.value is NetworkException) {
      title = 'Network Error';
      message = (_globalError.value as NetworkException).message;
    } else if (_globalError.value is ValidationException) {
      title = 'Validation Error';
      message = (_globalError.value as ValidationException).message;
    } else if (_globalError.value is DataException) {
      title = 'Data Error';
      message = (_globalError.value as DataException).message;
    }

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Get.theme.colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: clearGlobalError,
            child: const Text('Dismiss'),
          ),
          if (_globalError.value is NetworkException)
            TextButton(
              onPressed: () {
                clearGlobalError();
                // Trigger retry mechanism if applicable
                Get.snackbar(
                  'Retry',
                  'Retrying operation...',
                  duration: const Duration(seconds: 2),
                );
              },
              child: const Text('Retry'),
            ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Handle specific error types with appropriate actions
  void handleError(Object error) {
    if (error is NetworkException) {
      _handleNetworkError(error);
    } else if (error is ValidationException) {
      _handleValidationError(error);
    } else if (error is DataException) {
      _handleDataError(error);
    } else {
      _handleGenericError(error);
    }
  }

  void _handleNetworkError(NetworkException error) {
    Get.snackbar(
      'Connection Error',
      error.message,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.wifi_off),
    );
  }

  void _handleValidationError(ValidationException error) {
    Get.snackbar(
      'Validation Error',
      error.message,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning),
    );
  }

  void _handleDataError(DataException error) {
    Get.snackbar(
      'Data Error',
      error.message,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error),
    );
  }

  void _handleGenericError(Object error) {
    Get.snackbar(
      'Error',
      'An unexpected error occurred. Please try again.',
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline),
    );
  }

  /// Retry mechanism for failed operations
  Future<T?> retryOperation<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (error) {
        attempts++;
        
        if (attempts >= maxRetries) {
          // Final attempt failed, handle the error
          handleError(error);
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(delay * attempts);
      }
    }

    return null;
  }
}

/// Mixin for easy error handling in controllers
mixin ErrorHandlingMixin on GetxController {
  /// Handle errors with automatic logging and user notification
  void handleError(Object error, [StackTrace? stackTrace]) {
    AppErrorHandler.handleAsyncError(error, stackTrace ?? StackTrace.current);
    ErrorController.to.handleError(error);
  }

  /// Execute async operation with error handling
  Future<T?> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
      return null;
    }
  }

  /// Execute operation with retry mechanism
  Future<T?> executeWithRetry<T>(
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
}
