import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Shimmer loading effect for product cards in grid layout
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder shimmer
          Expanded(
            flex: 5,
            child: Shimmer.fromColors(
              baseColor: AppColors.border,
              highlightColor: AppColors.surface,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusM),
                  ),
                ),
              ),
            ),
          ),
          // Content placeholder shimmer
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingS + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price placeholder
                  Shimmer.fromColors(
                    baseColor: AppColors.border,
                    highlightColor: AppColors.surface,
                    child: Container(
                      height: AppSizes.fontL,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.heightXS),
                  // Title placeholder
                  Shimmer.fromColors(
                    baseColor: AppColors.border,
                    highlightColor: AppColors.surface,
                    child: Container(
                      height: AppSizes.fontS + 1,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Location placeholder
                  Shimmer.fromColors(
                    baseColor: AppColors.border,
                    highlightColor: AppColors.surface,
                    child: Container(
                      height: AppSizes.fontS - 1,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer loading effect for list items
class ListItemShimmer extends StatelessWidget {
  final double height;
  final bool showAvatar;

  const ListItemShimmer({
    super.key,
    this.height = 80,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Row(
        children: [
          if (showAvatar) ...[
            Shimmer.fromColors(
              baseColor: AppColors.border,
              highlightColor: AppColors.surface,
              child: Container(
                width: height - 32,
                height: height - 32,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.border,
                  highlightColor: AppColors.surface,
                  child: Container(
                    height: AppSizes.fontM,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.heightXS),
                Shimmer.fromColors(
                  baseColor: AppColors.border,
                  highlightColor: AppColors.surface,
                  child: Container(
                    height: AppSizes.fontS,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer loading effect for profile header
class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar shimmer
        Shimmer.fromColors(
          baseColor: AppColors.border,
          highlightColor: AppColors.surface,
          child: Container(
            width: AppSizes.avatarXL,
            height: AppSizes.avatarXL,
            decoration: const BoxDecoration(
              color: AppColors.border,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        // Name shimmer
        Shimmer.fromColors(
          baseColor: AppColors.border,
          highlightColor: AppColors.surface,
          child: Container(
            height: AppSizes.fontXL,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppSizes.radiusXS),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.heightXS),
        // Bio shimmer
        Shimmer.fromColors(
          baseColor: AppColors.border,
          highlightColor: AppColors.surface,
          child: Container(
            height: AppSizes.fontS,
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppSizes.radiusXS),
            ),
          ),
        ),
      ],
    );
  }
}

/// Grid shimmer loader for multiple items
class GridShimmerLoader extends StatelessWidget {
  final int itemCount;
  final double childAspectRatio;

  const GridShimmerLoader({
    super.key,
    this.itemCount = 6,
    this.childAspectRatio = 0.62,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.heightM,
        crossAxisSpacing: AppSizes.widthS,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}

/// List shimmer loader for multiple items
class ListShimmerLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final bool showAvatar;

  const ListShimmerLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.paddingS),
        child: ListItemShimmer(
          height: itemHeight,
          showAvatar: showAvatar,
        ),
      ),
    );
  }
}
