import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_texts.dart';

/// Reusable error state widget with retry functionality
class ErrorStateWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? buttonText;

  const ErrorStateWidget({
    super.key,
    this.title,
    this.subtitle,
    this.onRetry,
    this.icon,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.avatarXL * 1.5,
              height: AppSizes.avatarXL * 1.5,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: AppSizes.iconXL,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              title ?? AppTexts.errorTitle,
              style: TextStyle(
                fontSize: AppSizes.fontXL,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              subtitle ?? AppTexts.errorSubtitle,
              style: TextStyle(
                fontSize: AppSizes.fontM,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSizes.paddingL),
              ElevatedButton.icon(
                onPressed: () async {
                  // Add haptic feedback
                  try {
                    await Vibration.vibrate(duration: 50);
                  } catch (e) {
                    // Vibration not supported, continue
                  }
                  onRetry!();
                },
                icon: const Icon(Icons.refresh),
                label: Text(buttonText ?? 'Try again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL,
                    vertical: AppSizes.paddingS,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error state widget
class NetworkErrorStateWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorStateWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      icon: Icons.wifi_off,
      title: 'No internet connection',
      subtitle: 'Please check your internet connection and try again',
      onRetry: onRetry,
      buttonText: 'Retry',
    );
  }
}

/// Server error state widget
class ServerErrorStateWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorStateWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      icon: Icons.cloud_off,
      title: 'Server error',
      subtitle: 'Something went wrong on our end. Please try again in a moment',
      onRetry: onRetry,
      buttonText: 'Try again',
    );
  }
}

/// Generic loading error state widget
class LoadingErrorStateWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const LoadingErrorStateWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      icon: Icons.refresh,
      title: 'Failed to load',
      subtitle: 'We couldn\'t load the content. Please try again',
      onRetry: onRetry,
      buttonText: 'Try again',
    );
  }
}

/// Image loading error widget
class ImageErrorWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onRetry;

  const ImageErrorWidget({
    super.key,
    this.width,
    this.height,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: AppSizes.iconL,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSizes.heightXS),
          Text(
            'Failed to load image',
            style: TextStyle(
              fontSize: AppSizes.fontS,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

/// Location error state widget
class LocationErrorStateWidget extends StatelessWidget {
  final VoidCallback? onEnableLocation;
  final VoidCallback? onRetry;

  const LocationErrorStateWidget({
    super.key,
    this.onEnableLocation,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      icon: Icons.location_off,
      title: 'Location access needed',
      subtitle: 'We need your location to show items near you',
      onRetry: onRetry,
      buttonText: 'Enable location',
    );
  }
}

/// Permission error state widget
class PermissionErrorStateWidget extends StatelessWidget {
  final String? permissionType;
  final VoidCallback? onGrantPermission;

  const PermissionErrorStateWidget({
    super.key,
    this.permissionType,
    this.onGrantPermission,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      icon: Icons.lock,
      title: 'Permission required',
      subtitle: permissionType != null
          ? 'We need $permissionType permission to continue'
          : 'We need additional permissions to continue',
      onRetry: onGrantPermission,
      buttonText: 'Grant permission',
    );
  }
}

/// Timeout error state widget
class TimeoutErrorStateWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const TimeoutErrorStateWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      icon: Icons.timer,
      title: 'Request timed out',
      subtitle: 'The request took too long. Please check your connection and try again',
      onRetry: onRetry,
      buttonText: 'Try again',
    );
  }
}
