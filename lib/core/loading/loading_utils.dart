import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loading_widgets.dart';
import 'loading_controller.dart';

/// Utility functions for consistent loading patterns
class LoadingUtils {
  /// Execute operation with loading overlay
  static Future<T?> executeWithOverlay<T>(
    Future<T> Function() operation, {
    String? loadingMessage,
    BuildContext? context,
  }) async {
    // This would integrate with a loading overlay system
    // For now, just execute the operation
    try {
      return await operation();
    } catch (error) {
      rethrow;
    }
  }

  /// Create debounced loading operation
  /// 
  /// Creates a function that will execute the [operation] after the specified [delay].
  /// If called multiple times within the delay period, only the last call will execute.
  /// 
  /// Parameters:
  /// - [operation] The operation to execute after delay
  /// - [delay] The delay duration before executing (default: 500ms)
  /// 
  /// Returns:
  /// A function that when called will execute the operation after delay
  static VoidCallback debouncedLoading(
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
  /// 
  /// Creates a function that will execute the [operation] but limit execution
  /// to once per [interval]. Subsequent calls within the interval will be ignored.
  /// 
  /// Parameters:
  /// - [operation] The operation to throttle
  /// - [interval] The minimum time between executions (default: 1000ms)
  /// 
  /// Returns:
  /// A function that when called will execute the operation with throttling
  static VoidCallback throttledLoading(
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

  /// Show loading dialog
  static void showLoadingDialog({
    String? message,
    bool barrierDismissible = false,
  }) {
    Get.dialog(
      PopScope(
        canPop: barrierDismissible,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingWidgets.circularLarge(),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Execute operation with loading dialog
  static Future<T?> executeWithLoadingDialog<T>(
    Future<T> Function() operation, {
    String? loadingMessage,
    bool barrierDismissible = false,
  }) async {
    try {
      showLoadingDialog(message: loadingMessage, barrierDismissible: barrierDismissible);
      final result = await operation();
      return result;
    } finally {
      hideLoadingDialog();
    }
  }

  /// Create loading future builder
  static Widget loadingFutureBuilder<T>({
    required Future<T> future,
    required Widget Function(T data) builder,
    Widget Function()? loadingBuilder,
    Widget Function(Object error)? errorBuilder,
    String? loadingMessage,
  }) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder?.call() ??
              LoadingWidgets.centeredWithText(text: loadingMessage);
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          if (error != null) {
            return errorBuilder?.call(error) ??
                Center(
                  child: Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
          }
        }

        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data != null) {
            return builder(data);
          }
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Create loading stream builder
  static Widget loadingStreamBuilder<T>({
    required Stream<T> stream,
    required Widget Function(T data) builder,
    Widget Function()? loadingBuilder,
    Widget Function(Object error)? errorBuilder,
    Widget Function()? emptyBuilder,
    String? loadingMessage,
  }) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder?.call() ??
              LoadingWidgets.centeredWithText(text: loadingMessage);
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          if (error != null) {
            return errorBuilder?.call(error) ??
                Center(
                  child: Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
          }
        }

        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data != null) {
            return builder(data);
          }
        }

        return emptyBuilder?.call() ??
            LoadingWidgets.centeredWithText(text: 'No data available');
      },
    );
  }

  /// Wrap widget with loading state
  static Widget withLoadingState({
    required bool isLoading,
    required Widget child,
    Widget? loadingWidget,
    String? loadingMessage,
  }) {
    if (isLoading) {
      return loadingWidget ??
          LoadingWidgets.centeredWithText(text: loadingMessage);
    }
    return child;
  }

  /// Create paginated loading widget
  static Widget paginatedLoading<T>({
    required List<T> items,
    required bool isLoading,
    required bool hasMore,
    required VoidCallback onLoadMore,
    required Widget Function(T item) itemBuilder,
    Widget Function()? loadingWidget,
    Widget Function()? emptyWidget,
    ScrollController? scrollController,
  }) {
    if (items.isEmpty && !isLoading) {
      return emptyWidget?.call() ??
          const Center(
            child: Text(
              'No items found',
              style: TextStyle(color: Colors.grey),
            ),
          );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!isLoading && hasMore && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: items.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return itemBuilder(items[index]);
                } else {
                  return loadingWidget?.call() ??
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(child: LoadingWidgets.circular()),
                      );
                }
              },
            ),
          ),
          if (hasMore && !isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: onLoadMore,
                child: const Text('Load More'),
              ),
            ),
        ],
      ),
    );
  }

  /// Create infinite scroll loading widget
  static Widget infiniteScrollLoading<T>({
    required List<T> items,
    required bool isLoading,
    required bool hasMore,
    required VoidCallback onLoadMore,
    required Widget Function(T item) itemBuilder,
    Widget Function()? loadingWidget,
    Widget Function()? emptyWidget,
  }) {
    final scrollController = ScrollController();

    return paginatedLoading<T>(
      items: items,
      isLoading: isLoading,
      hasMore: hasMore,
      onLoadMore: onLoadMore,
      itemBuilder: itemBuilder,
      loadingWidget: loadingWidget,
      emptyWidget: emptyWidget,
      scrollController: scrollController,
    );
  }
}

/// Extension methods for easier loading patterns
extension LoadingExtensions on Future {
  /// Execute future with loading state
  Future<T?> withLoading<T>({
    String? message,
    bool showDialog = false,
    bool showGlobal = false,
  }) {
    if (showDialog) {
      return LoadingUtils.executeWithLoadingDialog<T>(
        () => this as Future<T>,
        loadingMessage: message,
      );
    } else if (showGlobal) {
      return LoadingController.to.executeWithLoading<T>(
        () => this as Future<T>,
        loadingMessage: message,
        showGlobalLoading: true,
      );
    } else {
      return LoadingUtils.executeWithOverlay<T>(
        () => this as Future<T>,
        loadingMessage: message,
      );
    }
  }

  /// Execute future with timeout and loading
  Future<T?> withTimeoutAndLoading<T>({
    Duration? timeout,
    String? message,
    bool showGlobal = false,
  }) {
    return LoadingController.to.executeWithTimeout<T>(
      () => this as Future<T>,
      timeout: timeout ?? const Duration(seconds: 30),
      loadingMessage: message,
      showGlobalLoading: showGlobal,
    );
  }
}

extension WidgetLoadingExtensions on Widget {
  /// Wrap widget with loading state
  Widget withLoading({
    required bool isLoading,
    Widget? loadingWidget,
    String? loadingMessage,
  }) {
    return LoadingUtils.withLoadingState(
      isLoading: isLoading,
      child: this,
      loadingWidget: loadingWidget,
      loadingMessage: loadingMessage,
    );
  }

  /// Wrap widget with loading overlay
  Widget withLoadingOverlay({
    required bool isLoading,
    String? loadingMessage,
    Widget? loadingWidget,
  }) {
    return LoadingOverlay(
      isLoading: isLoading,
      loadingText: loadingMessage,
      loadingWidget: loadingWidget,
      child: this,
    );
  }
}

/// Hook for managing loading state (if using flutter_hooks)
class LoadingHook {
  final Rx<LoadingState> _state = LoadingState.idle.obs;
  final RxString _message = ''.obs;
  final Rxn<Object> _error = Rxn<Object>();

  LoadingState get state => _state.value;
  String get message => _message.value;
  Object? get error => _error.value;
  bool get isLoading => _state.value == LoadingState.loading;

  void setLoading(String? message) {
    _state.value = LoadingState.loading;
    if (message != null) _message.value = message;
  }

  void setIdle() {
    _state.value = LoadingState.idle;
    _message.value = '';
    _error.value = null;
  }

  void setError(Object error) {
    _state.value = LoadingState.error;
    _error.value = error;
  }

  void setSuccess() {
    _state.value = LoadingState.success;
  }
}

