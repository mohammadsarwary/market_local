import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Improved image loading widget with better placeholders
class ImprovedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showShimmer;

  const ImprovedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      placeholder: placeholder != null
          ? (context, url) => placeholder!
          : showShimmer
              ? (context, url) => _buildShimmerPlaceholder()
              : (context, url) => _buildDefaultPlaceholder(),
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!
          : (context, url, error) => _buildErrorWidget(),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Icon(
            Icons.image,
            size: AppSizes.iconL,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: AppSizes.iconL,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSizes.heightXS),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: AppSizes.fontS,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: borderRadius,
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
            'Failed to load',
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

/// Circular avatar with improved image loading
class ImprovedNetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Widget? fallbackChild;

  const ImprovedNetworkAvatar({
    super.key,
    required this.imageUrl,
    this.size = AppSizes.avatarM,
    this.fallbackChild,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ImprovedNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}

/// Product image with hero animation and improved loading
class ProductImage extends StatelessWidget {
  final String imageUrl;
  final String productId;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.productId,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product_$productId',
      child: ImprovedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
    );
  }
}

/// Category icon with improved loading
class CategoryIcon extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;
  final double size;
  final Color? iconColor;

  const CategoryIcon({
    super.key,
    this.imageUrl,
    required this.fallbackIcon,
    this.size = AppSizes.iconL,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: ImprovedNetworkImage(
          imageUrl: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(size / 2),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(
        fallbackIcon,
        size: size * 0.6,
        color: iconColor ?? AppColors.textSecondary,
      ),
    );
  }
}
