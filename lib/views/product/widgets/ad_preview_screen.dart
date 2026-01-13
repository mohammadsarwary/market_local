import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_texts.dart';
import '../../../controllers/ads/post_ad_controller.dart';

class AdPreviewScreen extends StatefulWidget {
  const AdPreviewScreen({super.key});

  @override
  State<AdPreviewScreen> createState() => _AdPreviewScreenState();
}

class _AdPreviewScreenState extends State<AdPreviewScreen> {
  final PostAdController controller = Get.find<PostAdController>();
  bool _isBannerVisible = true;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => controller.hideAdPreview(),
        ),
        title: const Text(
          AppTexts.postAdPreview,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.fontXL,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isBannerVisible) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL, vertical: AppSizes.paddingS),
                padding: const EdgeInsets.all(AppSizes.paddingL),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: const Color(0xFFFFCDD2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.remove_red_eye_outlined,
                            color: AppColors.primary, size: AppSizes.iconS),
                        const SizedBox(width: AppSizes.paddingS),
                        const Text(
                          AppTexts.postAdPreviewMode,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: AppSizes.fontM,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingXS),
                    const Text(
                      AppTexts.postAdPreviewDisclaimer,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isBannerVisible = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingL, vertical: AppSizes.paddingS),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusS),
                            side: const BorderSide(color: Color(0xFFFFCDD2)),
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          AppTexts.postAdDismiss,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: AppSizes.fontS,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
            ],

            // Image Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                child: SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      Obx(() {
                        if (controller.images.isEmpty) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image,
                                  size: AppSizes.iconXL, color: Colors.grey),
                            ),
                          );
                        }
                        return PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemCount: controller.images.length,
                          itemBuilder: (context, index) {
                            return Image.file(
                              controller.images[index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        );
                      }),
                      // Image Counter Badge
                      Obx(() => controller.images.isNotEmpty
                          ? Positioned(
                              bottom: AppSizes.paddingM,
                              right: AppSizes.paddingM,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.paddingS, vertical: AppSizes.paddingXS),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.camera_alt,
                                        color: Colors.white, size: AppSizes.iconXS),
                                    const SizedBox(width: AppSizes.paddingXS),
                                    Text(
                                      '${_currentImageIndex + 1}/${controller.images.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.fontS,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),
                ),
              ),
            ),

            // Dots Indicator
            const SizedBox(height: AppSizes.paddingM),
            Obx(() {
              if (controller.images.isEmpty) return const SizedBox.shrink();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXS),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? AppColors.primary
                          : Colors.grey[300],
                    ),
                  ),
                ),
              );
            }),

            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Heart
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.titleController.text.isEmpty
                              ? 'Untitled'
                              : controller.titleController.text,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppSizes.paddingS),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Icon(Icons.favorite_border,
                            color: Colors.grey[600], size: AppSizes.iconS),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingS),

                  // Price
                  Text(
                    controller.priceController.text.isEmpty
                        ? '\$0.00'
                        : '\$${controller.priceController.text}',
                    style: const TextStyle(
                      fontSize: AppSizes.fontXXL,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),

                  // Tags
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChip(
                            controller.selectedCategory.value ?? 'Category'),
                        const SizedBox(width: AppSizes.paddingS),
                        _buildChip(controller.selectedCondition.value),
                        const SizedBox(width: AppSizes.paddingS),
                        _buildChip('2 days ago', icon: Icons.access_time),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXL),

                  const Divider(height: 1),
                  const SizedBox(height: AppSizes.paddingL),

                  // Seller Profile
                  Row(
                    children: [
                      CircleAvatar(
                        radius: AppSizes.paddingXL,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Seller Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.fontL,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: AppSizes.iconXS),
                                const SizedBox(width: AppSizes.paddingXS),
                                Text(
                                  '4.9 (24 Reviews)',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View Profile',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  const Divider(height: 1),
                  const SizedBox(height: AppSizes.paddingXL),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => controller.hideAdPreview(),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text(AppTexts.postAdEditListing),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radiusM),
                            ),
                            foregroundColor: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  Get.back();
                                  controller.postAd();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radiusM),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  AppTexts.postAdPublishNow,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: AppSizes.fontL),
                                ),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingXL),

                  // Description
                  Text(
                    controller.descriptionController.text.isEmpty
                        ? 'No description provided.'
                        : controller.descriptionController.text,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    AppTexts.postAdReadMore,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXXL),

                  // Location
                  const Text(
                    AppTexts.postAdLocation,
                    style: TextStyle(
                      fontSize: AppSizes.fontXL,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      color: Colors.grey[200],
                    ),
                    child: Stack(
                      children: [
                        // Fallback/Mock content for map
                        const Center(
                          child: Icon(Icons.map,
                              size: AppSizes.iconXL, color: Colors.black12),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.all(AppSizes.paddingM),
                            padding: const EdgeInsets.all(AppSizes.paddingM),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppSizes.radiusM),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppTexts.postAdPickupAt,
                                        style: TextStyle(
                                          fontSize: AppSizes.fontXS,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: AppSizes.paddingXS),
                                      Text(
                                        controller.locationController.text
                                                .isEmpty
                                            ? 'No location selected'
                                            : controller.locationController.text,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.fontM,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXXL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM, vertical: AppSizes.paddingS),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFEF), // Light pinkish grey
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.fontM, color: Colors.grey[700]),
            const SizedBox(width: AppSizes.paddingXS),
          ],
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
              fontSize: AppSizes.fontS,
            ),
          ),
        ],
      ),
    );
  }
}
