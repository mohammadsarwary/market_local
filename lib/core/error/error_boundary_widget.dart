import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_texts.dart';
import 'error_handler.dart';

/// Error boundary widget that catches and handles errors in its child widget tree
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, VoidCallback retry)? errorBuilder;
  final String? boundaryName;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.boundaryName,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _resetError();
  }

  void _resetError() {
    setState(() {
      _error = null;
      _hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _error != null) {
      return widget.errorBuilder?.call(_error!, _resetError) ??
          _DefaultErrorWidget(
            error: _error!,
            retry: _resetError,
            boundaryName: widget.boundaryName,
          );
    }

    try {
      return widget.child;
    } catch (error, _) {
      AppErrorHandler.handleAsyncError(error, StackTrace.current);
      return _DefaultErrorWidget(
        error: error,
        retry: _resetError,
        boundaryName: widget.boundaryName,
      );
    }
  }
}

/// Default error widget shown when an error occurs
class _DefaultErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback retry;
  final String? boundaryName;

  const _DefaultErrorWidget({
    required this.error,
    required this.retry,
    this.boundaryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                boundaryName != null 
                    ? 'An error occurred in ${boundaryName!}'
                    : 'An unexpected error occurred',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: retry,
                icon: const Icon(Icons.refresh),
                label: const Text(AppTexts.commonRetry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Go back to previous screen or home
                  Get.back();
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Specialized error boundary for network operations
class NetworkErrorBoundary extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRetry;
  final String? operationName;

  const NetworkErrorBoundary({
    super.key,
    required this.child,
    this.onRetry,
    this.operationName,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      boundaryName: operationName ?? 'Network Operation',
      errorBuilder: (error, retry) => _NetworkErrorWidget(
        error: error,
        onRetry: onRetry ?? retry,
        operationName: operationName,
      ),
      child: child,
    );
  }
}

/// Network-specific error widget
class _NetworkErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  final String? operationName;

  const _NetworkErrorWidget({
    required this.error,
    required this.onRetry,
    this.operationName,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkError = error is NetworkException;
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isNetworkError ? Icons.wifi_off : Icons.cloud_off,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                isNetworkError ? 'Connection Error' : 'Server Error',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isNetworkError 
                    ? 'Please check your internet connection and try again.'
                    : 'The server is experiencing issues. Please try again later.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              if (operationName != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Operation: $operationName',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text(AppTexts.commonRetry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error boundary for async operations (FutureBuilder, StreamBuilder, etc.)
class AsyncErrorBoundary<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T data) builder;
  final Widget Function(Object error)? errorBuilder;
  final Widget Function()? loadingBuilder;
  final String? operationName;

  const AsyncErrorBoundary({
    super.key,
    required this.future,
    required this.builder,
    this.errorBuilder,
    this.loadingBuilder,
    this.operationName,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder?.call() ?? 
              const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return errorBuilder?.call(snapshot.error!) ??
              _AsyncErrorWidget(
                error: snapshot.error!,
                operationName: operationName,
              );
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
}

/// Async-specific error widget
class _AsyncErrorWidget extends StatelessWidget {
  final Object error;
  final String? operationName;

  const _AsyncErrorWidget({
    required this.error,
    this.operationName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: 12),
          Text(
            'Failed to load data',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (operationName != null) ...[
            const SizedBox(height: 4),
            Text(
              'Operation: $operationName',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
