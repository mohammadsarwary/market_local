import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double? borderRadius;
  final BorderSide? side;
  final TextStyle? textStyle;
  final ButtonStyle? style;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.side,
    this.textStyle,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      disabledBackgroundColor: disabledBackgroundColor ?? Colors.grey[300],
      disabledForegroundColor: disabledForegroundColor ?? Colors.grey[600],
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        side: side ?? BorderSide.none,
      ),
    );

    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: foregroundColor ?? Colors.white,
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: textStyle),
          if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon, size: 18),
          ],
        ],
      );
    } else {
      child = Text(text, style: textStyle);
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double? borderRadius;
  final TextStyle? textStyle;
  final ButtonStyle? style;

  const AppOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? OutlinedButton.styleFrom(
      side: BorderSide(color: borderColor ?? AppColors.primary),
      foregroundColor: textColor ?? AppColors.primary,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
    );

    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: textColor ?? AppColors.primary,
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    } else {
      child = Text(text, style: textStyle);
    }

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final Color? textColor;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final ButtonStyle? style;

  const AppTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.textColor,
    this.padding,
    this.textStyle,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? TextButton.styleFrom(
      foregroundColor: textColor ?? AppColors.primary,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );

    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: textColor ?? AppColors.primary,
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: textStyle),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 16),
          ],
        ],
      );
    } else {
      child = Text(text, style: textStyle);
    }

    return TextButton(
      onPressed: (isDisabled || isLoading) ? null : onPressed,
      style: buttonStyle,
      child: child,
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final EdgeInsets? padding;
  final double? borderRadius;
  final BorderSide? side;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.padding,
    this.borderRadius,
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: size ?? 24,
        height: size ?? 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: iconColor ?? Colors.white,
        ),
      );
    } else {
      child = Icon(
        icon,
        size: size ?? 24,
        color: iconColor ?? Colors.white,
      );
    }

    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: side != null ? Border.fromBorderSide(side!) : null,
      ),
      child: child,
    );
  }
}
