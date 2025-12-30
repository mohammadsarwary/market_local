import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Global error handler for the application
class AppErrorHandler {
  static final AppErrorHandler _instance = AppErrorHandler._internal();
  factory AppErrorHandler() => _instance;
  AppErrorHandler._internal();

  /// Initialize global error handlers
  static void initialize() {
    // Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _instance._handleFlutterError(details);
    };

    // Platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _instance._handlePlatformError(error, stack);
      return true;
    };
  }

  /// Handle Flutter framework errors
  void _handleFlutterError(FlutterErrorDetails details) {
    if (kDebugMode) {
      // In debug mode, let Flutter show the error normally
      FlutterError.presentError(details);
    } else {
      // In release mode, log and handle gracefully
      _logError(details.exception, details.stack);
      _showErrorSnackBar(details.exception);
    }
  }

  /// Handle platform-level errors
  void _handlePlatformError(Object error, StackTrace stack) {
    _logError(error, stack);
    if (!kDebugMode) {
      _showErrorSnackBar(error);
    }
  }

  /// Log error (in a real app, this would send to a logging service)
  void _logError(Object error, StackTrace? stack) {
    debugPrint('=== ERROR LOGGED ===');
    debugPrint('Error: $error');
    if (stack != null) {
      debugPrint('Stack trace: $stack');
    }
    debugPrint('===================');
    
    // TODO: Send to logging service (Firebase Crashlytics, Sentry, etc.)
  }

  /// Show error snackbar to user
  void _showErrorSnackBar(Object error) {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  /// Handle async errors in Future/Stream
  static void handleAsyncError(Object error, StackTrace stack) {
    _instance._logError(error, stack);
    if (!kDebugMode) {
      _instance._showErrorSnackBar(error);
    }
  }
}

/// Custom exception types for better error categorization
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const AppException(this.message, {this.code, this.originalError});
  
  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalError});
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

class DataException extends AppException {
  const DataException(super.message, {super.code, super.originalError});
}
