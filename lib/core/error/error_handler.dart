import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Global error handler for the application
/// 
/// Provides centralized error handling for Flutter framework errors,
/// platform errors, and async errors. Logs errors and optionally shows
/// user-facing error messages.
/// 
/// Features:
/// - Captures Flutter framework errors
/// - Captures platform-level errors
/// - Provides async error handling for Futures/Streams
/// - Logs errors with stack traces
/// - Shows user-friendly error messages in release mode
/// 
/// Usage:
/// ```dart
/// // Initialize in main.dart
/// AppErrorHandler.initialize();
/// 
/// // Handle async errors
/// try {
///   await riskyOperation();
/// } catch (e, stack) {
///   AppErrorHandler.handleAsyncError(e, stack);
/// }
/// ```
class AppErrorHandler {
  static final AppErrorHandler _instance = AppErrorHandler._internal();
  factory AppErrorHandler() => _instance;
  AppErrorHandler._internal();

  /// Initialize global error handlers
  /// 
  /// Sets up error handlers for Flutter framework errors and platform errors.
  /// Should be called once during app initialization (typically in main.dart).
  /// 
  /// In debug mode, Flutter errors are shown normally.
  /// In release mode, errors are logged and user-friendly messages are shown.
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
  /// 
  /// Use this method to catch and handle errors from async operations.
  /// Logs the error and shows a user-facing message in release mode.
  /// 
  /// Parameters:
  /// - [error] The error object that was thrown
  /// - [stack] The stack trace associated with the error
  /// 
  /// Example:
  /// ```dart
  /// myFuture().catchError((e, stack) {
  ///   AppErrorHandler.handleAsyncError(e, stack);
  /// });
  /// ```
  static void handleAsyncError(Object error, StackTrace stack) {
    _instance._logError(error, stack);
    if (!kDebugMode) {
      _instance._showErrorSnackBar(error);
    }
  }
}

/// Custom exception types for better error categorization
/// 
/// Base class for application-specific exceptions that provides
/// structured error information including message, error code, and
/// original error details.
/// 
/// Subclasses:
/// - [NetworkException]: For network-related errors
/// - [ValidationException]: For input validation errors
/// - [DataException]: For data parsing/processing errors
/// 
/// Example:
/// ```dart
/// throw NetworkException(
///   'Failed to fetch data',
///   code: 'NETWORK_ERROR',
///   originalError: e,
/// );
/// ```
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
/// Creates an application exception
  /// 
  /// Parameters:
  /// - [message] Human-readable error message
  /// - [code] Optional error code for programmatic handling
  /// - [originalError] The original error that caused this exception
  const AppException(this.message, {this.code, this.originalError});
  
  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception for network-related errors
/// 
/// Use this exception when operations involving network requests fail.
/// Examples: no internet connection, timeout, server errors.
/// 
/// Example:
/// ```dart
/// if (!await hasConnection()) {
///   throw NetworkException('No internet connection');
/// }
/// ```
class NetworkException extends AppException {
/// Creates a network exception
  /// 
  /// Parameters:
  /// - [message] Human-readable error message
  /// - [code] Optional error code for programmatic handling
  /// - [originalError] The original error that caused this exception
  const NetworkException(super.message, {super.code, super.originalError});
}

/// Exception for input validation errors
/// 
/// Use this exception when user input fails validation rules.
/// Examples: invalid email, missing required fields, format errors.
/// 
/// Example:
/// ```dart
/// if (email.isEmpty) {
///   throw ValidationException('Email is required');
/// }
/// ```
class ValidationException extends AppException {
/// Creates a validation exception
  /// 
  /// Parameters:
  /// - [message] Human-readable error message
  /// - [code] Optional error code for programmatic handling
  const ValidationException(super.message, {super.code});
}

/// Exception for data-related errors
/// 
/// Use this exception when data parsing, processing, or storage fails.
/// Examples: invalid JSON format, data type mismatch, storage errors.
/// 
/// Example:
/// ```dart
/// if (data == null) {
///   throw DataException('Product not found', code: 'NOT_FOUND');
/// }
/// ```
class DataException extends AppException {
/// Creates a data exception
  /// 
  /// Parameters:
  /// - [message] Human-readable error message
  /// - [code] Optional error code for programmatic handling
  /// - [originalError] The original error that caused this exception
  const DataException(super.message, {super.code, super.originalError});
}
