import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_texts.dart';
import '../../models/ad_model.dart';
import '../ad_details/ad_details_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Location Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                      ),
                      child: const Icon(Icons.person, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: AppSizes.fontXS,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Brooklyn, NY',
                              style: TextStyle(
                                fontSize: AppSizes.fontM,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down, size: AppSizes.iconS, color: AppColors.textSecondary),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: const Icon(Icons.notifications, color: AppColors.textOnPrimary, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.search, color: AppColors.textSecondary),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: AppTexts.homeSearchHint,
                            hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: AppSizes.fontM),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                        ),
                        child: Icon(Icons.tune, color: AppColors.textSecondary, size: AppSizes.iconS),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Category Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: AppSizes.heightXL,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return Obx(() {
                      final isSelected = controller.selectedCategoryIndex.value == index;
                      return GestureDetector(
                        onTap: () => controller.changeCategory(index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category.icon,
                                size: AppSizes.iconS,
                                color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: AppSizes.fontS + 1,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ),

            // Promo Banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D3436), Color(0xFF636E72)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                      ),
                      child: const Text(
                        'LIMITED TIME',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.fontXS,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.heightS),
                    const Text(
                      'Summer Sale',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppSizes.fontXL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.heightXS),
                    Text(
                      'Up to 50% off on outdoor gear',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: AppSizes.fontM,
                      ),
                    ),
                    const SizedBox(height: AppSizes.heightS),
                    Row(
                      children: [
                        Text(
                          'Check it out',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: AppSizes.fontM,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: AppSizes.widthXS),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: AppSizes.iconS),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Fresh Finds Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fresh finds near you',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppTexts.homeSeeAll,
                      style: TextStyle(
                        fontSize: AppSizes.fontM,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSizes.heightM,
                  crossAxisSpacing: AppSizes.widthS,
                  childAspectRatio: 0.62,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = controller.products[index];
                    return GestureDetector(
                      onTap: () => Get.to(() => const AdDetailsScreen(), arguments: product),
                      child: _ProductCard(
                        product: product,
                        timeAgo: controller.getTimeAgo(product.createdAt),
                      ),
                    );
                  },
                  childCount: controller.products.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final AdModel product;
  final String timeAgo;

  const _ProductCard({required this.product, required this.timeAgo});

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
          // Image Section
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusM)),
                    child: CachedNetworkImage(
                      imageUrl: product.images.isNotEmpty ? product.images.first : '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.border,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.border,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                // Condition Badge
                if (product.condition == AdCondition.newItem || product.condition == AdCondition.used)
                  Positioned(
                    bottom: AppSizes.paddingS,
                    left: AppSizes.paddingS,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.condition == AdCondition.newItem 
                            ? AppColors.primary 
                            : AppColors.textPrimary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                      ),
                      child: Text(
                        product.condition.displayName.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: AppSizes.fontXS - 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Favorite Button
                Positioned(
                  top: AppSizes.paddingS,
                  right: AppSizes.paddingS,
                  child: Container(
                    width: AppSizes.avatarS,
                    height: AppSizes.avatarS,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      product.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: AppSizes.iconS - 2,
                      color: product.isFavorite ? AppColors.primary : AppColors.textHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info Section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingS + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Time
                  Row(
                    children: [
                      Text(
                        '${AppTexts.currencySymbol}${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: AppSizes.fontS - 1,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.heightXS),
                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: AppSizes.fontS + 1,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: AppSizes.fontS, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          product.location,
                          style: const TextStyle(
                            fontSize: AppSizes.fontS - 1,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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