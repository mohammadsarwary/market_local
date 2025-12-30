import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loading_widgets.dart';

/// Controller for managing loading states across the application
class LoadingController extends GetxController {
  static LoadingController get to => Get.find();

  final Rx<LoadingState> _globalLoadingState = LoadingState.idle.obs;
  final RxString _globalLoadingMessage = ''.obs;
  final Rxn<Object> _globalError = Rxn<Object>();

  /// Global loading state
  LoadingState get globalLoadingState => _globalLoadingState.value;
  
  /// Global loading message
  String get globalLoadingMessage => _globalLoadingMessage.value;
  
  /// Global error
  Object? get globalError => _globalError.value;

  /// Set global loading state
  void setGlobalLoadingState(LoadingState state, {String? message, Object? error}) {
    _globalLoadingState.value = state;
    if (message != null) _globalLoadingMessage.value = message;
    if (error != null) _globalError.value = error;
  }

  /// Show global loading
  void showGlobalLoading({String? message}) {
    setGlobalLoadingState(LoadingState.loading, message: message);
  }

  /// Hide global loading
  void hideGlobalLoading() {
    setGlobalLoadingState(LoadingState.idle);
  }

  /// Show global success
  void showGlobalSuccess({String? message}) {
    setGlobalLoadingState(LoadingState.success, message: message);
  }

  /// Show global error
  void showGlobalError(Object error, {String? message}) {
    setGlobalLoadingState(LoadingState.error, error: error, message: message);
  }

  /// Clear global state
  void clearGlobalState() {
    setGlobalLoadingState(LoadingState.idle);
    _globalLoadingMessage.value = '';
    _globalError.value = null;
  }

  /// Execute async operation with loading state management
  Future<T?> executeWithLoading<T>(
    Future<T> Function() operation, {
    String? loadingMessage,
    bool showGlobalLoading = false,
    bool handleError = true,
  }) async {
    try {
      if (showGlobalLoading) {
        setGlobalLoadingState(LoadingState.loading, message: loadingMessage);
      }

      final result = await operation();

      if (showGlobalLoading) {
        hideGlobalLoading();
      }

      return result;
    } catch (error) {
      if (showGlobalLoading) {
        showGlobalError(error);
      }

      if (handleError) {
        // Handle error (could show snackbar, etc.)
        Get.snackbar(
          'Error',
          error.toString(),
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }

      rethrow;
    }
  }

  /// Execute operation with timeout and loading
  Future<T?> executeWithTimeout<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(seconds: 30),
    String? loadingMessage,
    bool showGlobalLoading = false,
  }) async {
    try {
      if (showGlobalLoading) {
        setGlobalLoadingState(LoadingState.loading, message: loadingMessage);
      }

      final result = await operation().timeout(timeout);

      if (showGlobalLoading) {
        hideGlobalLoading();
      }

      return result;
    } catch (error) {
      if (showGlobalLoading) {
        showGlobalError(error);
      }
      
      rethrow;
    }
  }
}

/// Mixin for easy loading state management in controllers
mixin LoadingMixin on GetxController {
  final Rx<LoadingState> _loadingState = LoadingState.idle.obs;
  final RxString _loadingMessage = ''.obs;
  final Rxn<Object> _error = Rxn<Object>();

  /// Current loading state
  LoadingState get loadingState => _loadingState.value;
  
  /// Loading message
  String get loadingMessage => _loadingMessage.value;
  
  /// Current error
  Object? get error => _error.value;

  /// Check if currently loading
  bool get isLoading => _loadingState.value == LoadingState.loading;
  
  /// Check if there's an error
  bool get hasError => _loadingState.value == LoadingState.error;
  
  /// Check if operation succeeded
  bool get isSuccess => _loadingState.value == LoadingState.success;

  /// Set loading state
  void setLoadingState(LoadingState state, {String? message, Object? error}) {
    _loadingState.value = state;
    if (message != null) _loadingMessage.value = message;
    if (error != null) _error.value = error;
  }

  /// Show loading state
  void showLoading({String? message}) {
    setLoadingState(LoadingState.loading, message: message);
  }

  /// Hide loading state
  void hideLoading() {
    setLoadingState(LoadingState.idle);
  }

  /// Show success state
  void showSuccess({String? message}) {
    setLoadingState(LoadingState.success, message: message);
  }

  /// Show error state
  void showError(Object error, {String? message}) {
    setLoadingState(LoadingState.error, error: error, message: message);
  }

  /// Clear state
  void clearState() {
    setLoadingState(LoadingState.idle);
    _loadingMessage.value = '';
    _error.value = null;
  }

  /// Execute async operation with loading state
  Future<T?> executeWithLoading<T>(
    Future<T> Function() operation, {
    String? loadingMessage,
    Duration? timeout,
    bool handleError = true,
  }) async {
    try {
      showLoading(message: loadingMessage);

      final result = timeout != null
          ? await operation().timeout(timeout)
          : await operation();

      showSuccess();
      return result;
    } catch (error) {
      showError(error);

      if (handleError) {
        // Handle error (could show snackbar, etc.)
        Get.snackbar(
          'Error',
          error.toString(),
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }

      rethrow;
    }
  }

  /// Execute multiple operations with loading state
  Future<List<T?>> executeMultipleWithLoading<T>(
    List<Future<T> Function()> operations, {
    String? loadingMessage,
    bool handleErrorsIndividually = true,
  }) async {
    showLoading(message: loadingMessage ?? 'Processing...');

    final results = <T?>[];
    
    for (final operation in operations) {
      try {
        final result = await operation();
        results.add(result);
      } catch (error) {
        if (handleErrorsIndividually) {
          results.add(null);
        } else {
          showError(error);
          rethrow;
        }
      }
    }

    showSuccess();
    return results;
  }

  /// Retry operation with loading state
  Future<T?> retryWithLoading<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    String? loadingMessage,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await executeWithLoading<T>(
          operation,
          loadingMessage: loadingMessage ?? (attempts == 0 ? null : 'Retrying... (${attempts + 1}/$maxRetries)'),
        );
      } catch (error) {
        attempts++;
        
        if (attempts >= maxRetries) {
          showError(error);
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(delay * attempts);
      }
    }

    return null;
  }
}

/// Utility class for loading operations
class LoadingUtils {
  /// Execute operation with loading overlay
  static Future<T?> executeWithOverlay<T>(
    Future<T> Function() operation, {
    String? loadingMessage,
    BuildContext? context,
  }) async {
    if (context != null) {
      // Show loading overlay logic here
      // This would require access to a loading overlay widget
    }

    try {
      return await operation();
    } finally {
      if (context != null) {
        // Hide loading overlay logic here
      }
    }
  }

  /// Create debounced loading operation
  static Function() debouncedLoading(
    VoidCallback operation, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    Timer? timer;
    
    return () {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      timer = Timer(delay, operation);
    };
  }

  /// Create throttled loading operation
  static Function() throttledLoading(
    VoidCallback operation, {
    Duration interval = const Duration(milliseconds: 1000),
  }) {
    bool isThrottled = false;
    
    return () {
      if (isThrottled) return;
      
      isThrottled = true;
      operation();
      
      Timer(interval, () {
        isThrottled = false;
      });
    };
  }
}
