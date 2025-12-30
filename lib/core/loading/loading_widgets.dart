import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Consistent loading widgets for different contexts
class LoadingWidgets {
  /// Default circular progress indicator
  static Widget circular({
    double? size,
    Color? color,
    double strokeWidth = 3.0,
  }) {
    return SizedBox(
      width: size ?? 24.0,
      height: size ?? 24.0,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
        strokeWidth: strokeWidth,
      ),
    );
  }

  /// Small circular progress indicator
  static Widget circularSmall({Color? color}) {
    return circular(
      size: 16.0,
      strokeWidth: 2.0,
      color: color,
    );
  }

  /// Large circular progress indicator
  static Widget circularLarge({Color? color}) {
    return circular(
      size: 48.0,
      strokeWidth: 4.0,
      color: color,
    );
  }

  /// Linear progress indicator
  static Widget linear({
    Color? color,
    double? height,
  }) {
    return SizedBox(
      height: height ?? 4.0,
      child: LinearProgressIndicator(
        color: color ?? AppColors.primary,
        backgroundColor: AppColors.border,
      ),
    );
  }

  /// Centered loading with text
  static Widget centeredWithText({
    String? text,
    Widget? child,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child ?? circular(),
          if (text != null) ...[
            const SizedBox(height: AppSizes.heightS),
            Text(
              text,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: AppSizes.fontS,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Full screen loading
  static Widget fullScreen({
    String? text,
    Widget? child,
  }) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child ?? circularLarge(),
            if (text != null) ...[
              const SizedBox(height: AppSizes.heightM),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: AppSizes.fontM,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Inline loading (for buttons, cards, etc.)
  static Widget inline({
    Widget? child,
    Color? color,
  }) {
    return child ?? circularSmall(color: color);
  }

  /// Skeleton loading placeholder
  static Widget skeleton({
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }

  /// Skeleton text placeholder
  static Widget skeletonText({
    double? width,
    int lines = 1,
    double lineHeight = 16.0,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? 4.0 : 0.0),
          child: skeleton(
            width: width ?? (index == lines - 1 ? 80.0 : double.infinity),
            height: lineHeight,
          ),
        ),
      ),
    );
  }

  /// Skeleton card placeholder
  static Widget skeletonCard({
    double? height,
    double? width,
    bool showImage = true,
    bool showText = true,
    int textLines = 3,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showImage) ...[
            skeleton(
              height: 120.0,
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            const SizedBox(height: AppSizes.heightS),
          ],
          if (showText) ...[
            skeletonText(lines: textLines),
          ],
        ],
      ),
    );
  }

  /// Shimmer loading effect
  static Widget shimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return _ShimmerLoading(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: child,
    );
  }
}

/// Shimmer loading effect widget
class _ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const _ShimmerLoading({
    required this.child,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<_ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<_ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(_animation.value * 3.14159 / 2),
        ).createShader(bounds);
      },
      child: widget.child,
    );
  }
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingText;
  final Widget? loadingWidget;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingText,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  loadingWidget ?? LoadingWidgets.circularLarge(),
                  if (loadingText != null) ...[
                    const SizedBox(height: AppSizes.heightM),
                    Text(
                      loadingText!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppSizes.fontM,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Loading button widget
class LoadingButton extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final String? loadingText;

  const LoadingButton({
    super.key,
    required this.child,
    required this.isLoading,
    this.onPressed,
    this.style,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingWidgets.circularSmall(color: Colors.white),
                if (loadingText != null) ...[
                  const SizedBox(width: 8),
                  Text(loadingText!),
                ],
              ],
            )
          : child,
    );
  }
}

/// Loading state enum
enum LoadingState {
  idle,
  loading,
  success,
  error,
}

/// Loading state widget builder
class LoadingStateWidget<T> extends StatelessWidget {
  final LoadingState state;
  final Widget Function() idleBuilder;
  final Widget Function() loadingBuilder;
  final Widget Function(T data) successBuilder;
  final Widget Function(Object error) errorBuilder;
  final T? data;
  final Object? error;

  const LoadingStateWidget({
    super.key,
    required this.state,
    required this.idleBuilder,
    required this.loadingBuilder,
    required this.successBuilder,
    required this.errorBuilder,
    this.data,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case LoadingState.idle:
        return idleBuilder();
      case LoadingState.loading:
        return loadingBuilder();
      case LoadingState.success:
        if (data != null) {
          return successBuilder(data as T);
        }
        return idleBuilder();
      case LoadingState.error:
        return errorBuilder(error ?? Exception('Unknown error'));
    }
  }
}
