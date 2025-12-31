import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? width;
  final double? height;
  final BoxShadow? boxShadow;
  final VoidCallback? onTap;
  final bool isClickable;

  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.width,
    this.height,
    this.boxShadow,
    this.onTap,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? 1,
              )
            : null,
        boxShadow: boxShadow != null ? [boxShadow!] : null,
      ),
      child: child,
    );

    if (isClickable || onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}

class AppSection extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? action;
  final bool showDivider;
  final Color? dividerColor;

  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.padding,
    this.margin,
    this.action,
    this.showDivider = true,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: margin ?? const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (action != null) action!,
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (showDivider)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 1,
            color: dividerColor ?? Colors.grey[200],
          ),
        const SizedBox(height: 16),
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
          child: child,
        ),
      ],
    );
  }
}

class AppChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final TextStyle? textStyle;
  final bool isSelected;

  const AppChip({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor ?? (isSelected ? AppColors.primary : Colors.grey[100]),
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          border: borderColor != null
              ? Border.all(color: borderColor!)
              : null,
        ),
        child: Text(
          label,
          style: textStyle ?? TextStyle(
            color: textColor ?? (isSelected ? Colors.white : Colors.grey[700]),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final TextStyle? textStyle;

  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.red,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: Text(
        text,
        style: textStyle ?? const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;
  final EdgeInsets? margin;

  const AppDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      color: color ?? Colors.grey[200],
    );
  }
}

class AppSpacer extends StatelessWidget {
  final double? height;
  final double? width;

  const AppSpacer({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}

class AppLoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget? loadingWidget;
  final Color? overlayColor;

  const AppLoadingContainer({
    super.key,
    required this.child,
    this.isLoading = false,
    this.loadingWidget,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withValues(alpha: 0.1),
            child: loadingWidget ?? const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
