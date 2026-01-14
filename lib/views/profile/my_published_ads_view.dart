import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../models/ad/ad_models.dart';

class MyPublishedAdsView extends GetView<ProfileController> {
  const MyPublishedAdsView({super.key});
  // NOTE: This page intentionally has no bottom navigation bar as it's a detail/sub-page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            _buildFilterSegmentedControl(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (controller.filteredAds.isEmpty) {
                  return _buildEmptyState();
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  itemCount: controller.filteredAds.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredAds[index];
                    return _buildAdCard(item);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingL,
        AppSizes.paddingL,
        AppSizes.paddingL,
        AppSizes.paddingS,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: AppSizes.buttonHeightM,
              height: AppSizes.buttonHeightM,
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.textPrimary,
                size: AppSizes.iconM,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'My Published Ads',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppSizes.fontXL,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: AppSizes.buttonHeightM,
            height: AppSizes.buttonHeightM,
            alignment: Alignment.center,
            child: const Icon(
              Icons.add_circle,
              color: AppColors.primary,
              size: AppSizes.iconL,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: const BoxDecoration(
        color: AppColors.surface,
      ),
      child: Container(
        height: AppSizes.heightXL,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        // NOTE: No Obx wrapper here - each _buildFilterOption has its own Obx to avoid nested Obx error
        padding: const EdgeInsets.all(AppSizes.paddingXS),
        child: Row(
          children: [
            Expanded(
              child: _buildFilterOption('All', 0),
            ),
            Expanded(
              child: _buildFilterOption('Active', 1),
            ),
            Expanded(
              child: _buildFilterOption('Inactive', 2),
            ),
            Expanded(
              child: _buildFilterOption('Pending', 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, int index) {
    return Obx(() {
      final isSelected = controller.selectedFilterIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeFilter(index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.grey[600],
              fontSize: AppSizes.fontS,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: AppSizes.paddingL),
          Text(
            'No listings yet',
            style: TextStyle(
              fontSize: AppSizes.fontXL,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            'Start selling by posting your first ad',
            style: TextStyle(
              fontSize: AppSizes.fontM,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: AppSizes.paddingXL),
          ElevatedButton(
            onPressed: () => Get.toNamed('/post-ad'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXL,
                vertical: AppSizes.paddingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
            ),
            child: const Text(
              'Post an Ad',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.fontL,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard(AdModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: AppColors.border,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusBadge(item),
                          const SizedBox(height: AppSizes.paddingXS),
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppSizes.fontL,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingXS),
                          Text(
                            '\$${item.price.toStringAsFixed(2)} • Posted Oct 12',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: AppSizes.fontM,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      _buildStatsRow(item),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    image: item.images.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(item.images.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[200],
                  ),
                  child: item.images.isEmpty
                      ? Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey[400],
                        )
                      : null,
                ),
              ],
            ),
          ),
          _buildActionButtons(item),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(AdModel item) {
    Color dotColor;
    String statusText;
    
    final status = item.status?.toLowerCase() ?? 'active';
    
    switch (status) {
      case 'active':
        dotColor = AppColors.success;
        statusText = 'Active';
        break;
      case 'sold':
        dotColor = Colors.grey[400]!;
        statusText = 'Sold';
        break;
      case 'inactive':
        dotColor = Colors.orange;
        statusText = 'Inactive';
        break;
      case 'pending':
        dotColor = Colors.amber;
        statusText = 'Pending';
        break;
      default:
        dotColor = AppColors.success;
        statusText = 'Active';
    }
    
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSizes.paddingXS),
        Text(
          statusText.toUpperCase(),
          style: TextStyle(
            color: dotColor,
            fontSize: AppSizes.fontXS,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(AdModel item) {
    return Container(
      padding: const EdgeInsets.only(top: AppSizes.paddingM),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.visibility,
                size: AppSizes.iconM,
                color: Colors.grey[400],
              ),
              const SizedBox(width: AppSizes.paddingXS),
              Text(
                '${item.viewCount} views',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: AppSizes.fontXS,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSizes.paddingL),
          Row(
            children: [
              Icon(
                Icons.favorite,
                size: AppSizes.iconM,
                color: Colors.grey[400],
              ),
              const SizedBox(width: AppSizes.paddingXS),
              Text(
                '${item.isFavorite ? 1 : 0} likes',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: AppSizes.fontXS,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AdModel item) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: Colors.grey[50]!.withValues(alpha: 0.5),
        border: const Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: _getActionButtons(item),
      ),
    );
  }

  List<Widget> _getActionButtons(AdModel item) {
    if (item.isSold) {
      return [
        _buildActionButton('Relist Item', false),
        const SizedBox(width: AppSizes.paddingM),
        _buildActionButton('Delete History', false, isDanger: true),
      ];
    } else {
      return [
        _buildActionButton('Edit', false),
        const SizedBox(width: AppSizes.paddingM),
        _buildActionButton('Deactivate', false),
        const SizedBox(width: AppSizes.paddingM),
        _buildActionButton('Promote', true),
      ];
    }
  }

  Widget _buildActionButton(String text, bool isPrimary, {bool isDanger = false}) {
    return Expanded(
      child: Container(
        height: AppSizes.buttonHeightS,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
          border: isPrimary
              ? null
              : Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (text == 'Promote') ...[
              const Icon(
                Icons.trending_up,
                size: AppSizes.iconM,
                color: Colors.white,
              ),
              const SizedBox(width: AppSizes.paddingXS),
            ],
            Text(
              text,
              style: TextStyle(
                color: isPrimary
                    ? Colors.white
                    : isDanger
                        ? AppColors.error
                        : AppColors.textPrimary,
                fontSize: AppSizes.fontM,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
