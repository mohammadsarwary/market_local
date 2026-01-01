import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_texts.dart';
import '../../models/ad_model.dart';
import '../auth/login_screen.dart';
import '../home/home_controller.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildSkeletonLoader();
        }
        if (controller.hasError.value) {
          return _buildErrorState();
        }
        return _buildContent();
      }),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Profile Info
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                      ),
                      child: Obx(() => CircleAvatar(
                        radius: 50,
                        backgroundImage: CachedNetworkImageProvider(controller.user.value.avatar),
                      )),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(() => Text(
                  controller.user.value.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
                const SizedBox(height: 6),
                Obx(() => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.user.value.rating}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ' (${controller.user.value.reviewCount} Reviews)',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 6),
                Obx(() => Text(
                  'Member since ${controller.memberSinceYear} • ${controller.user.value.location}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                  ),
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.editProfile,
                    icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.black87),
                    label: const Text('Edit Profile', style: TextStyle(color: Colors.black87)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.grey[50],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.insights, size: 18, color: Colors.black87),
                    label: const Text('Insights', style: TextStyle(color: Colors.black87)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.grey[50],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats Row
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[100]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(() => _buildStatItem(controller.user.value.activeListings.toString(), 'ACTIVE')),
                Container(height: 30, width: 1, color: Colors.grey[200]),
                Obx(() => _buildStatItem(controller.user.value.soldItems.toString(), 'SOLD')),
                Container(height: 30, width: 1, color: Colors.grey[200]),
                Obx(() => _buildStatItem(controller.user.value.followers.toString(), 'FOLLOWERS')),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Tabs
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                _buildTab('Active', 0),
                _buildTab('Sold', 1),
                _buildTab('Saved', 2),
              ],
            ),
          ),
          
          // Items Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                final item = controller.items[index];
                return _buildItemCard(item);
              },
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SETTINGS & SUPPORT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSettingsTile(Icons.account_circle_outlined, 'Account Details'),
                _buildSettingsTile(Icons.notifications_outlined, 'Notifications'),
                _buildSettingsTile(Icons.login_outlined, 'Test Login Page', onTap: () => Get.to(() => const LoginScreen())),
                _buildSettingsTile(Icons.help_outline, 'Help & Support'),
                _buildSettingsTile(Icons.logout, 'Log Out', isDestructive: true, onTap: controller.logout),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          Text(
            controller.appVersion,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 150,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 100,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(child: Container(height: 2, color: Colors.grey[300])),
                Expanded(child: Container(height: 2, color: Colors.grey[300])),
                Expanded(child: Container(height: 2, color: Colors.grey[300])),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    color: Colors.grey[200],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.retryLoadProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a statistics item widget
  /// 
  /// Creates a column displaying a value and label for user statistics.
  /// Used for showing metrics like active listings, sold items, etc.
  /// 
  /// Parameters:
  /// - [value] The statistic value to display
  /// - [label] The statistic label to display
  /// 
  /// Returns:
  /// A widget containing the statistic value and label
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  /// Builds a tab widget
  /// 
  /// Creates a selectable tab for the profile screen.
  /// The tab highlights when selected and updates the controller when tapped.
  /// 
  /// Parameters:
  /// - [label] The tab label text
  /// - [index] The tab index
  /// 
  /// Returns:
  /// A widget representing the selectable tab
  Widget _buildTab(String label, int index) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedTabIndex.value == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: GestureDetector(
            onTap: () => controller.changeTab(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.6,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Builds an item card widget for displaying user listings
  /// 
  /// Creates a card showing an item's image, title, price, and other details.
  /// Used in the profile screen to display user's active or sold items.
  /// 
  /// Parameters:
  /// - [item] The AdModel containing item information
  /// 
  /// Returns:
  /// A widget representing the item card
  Widget _buildItemCard(AdModel item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusM)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(item.images.isNotEmpty ? item.images.first : ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: AppSizes.paddingS,
                  right: AppSizes.paddingS,
                  child: GestureDetector(
                    onTap: () {
                      final homeController = Get.find<HomeController>();
                      homeController.toggleFavorite(item.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Obx(() {
                        final homeController = Get.find<HomeController>();
                        final isFav = homeController.isFavorite(item.id);
                        return Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: isFav ? AppColors.primary : Colors.grey,
                        );
                      }),
                    ),
                  ),
                ),
                if (item.isPromoted)
                  Positioned(
                    bottom: AppSizes.paddingS,
                    left: AppSizes.paddingS,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                      ),
                      child: Text(
                        AppTexts.commonPromoted.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.fontS + 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.categoryName,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: AppSizes.fontS - 1,
                      ),
                    ),
                    Text(
                      '${AppTexts.currencySymbol}${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.fontS + 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a settings tile widget
  /// 
  /// Creates a tappable tile for settings options with an icon and title.
  /// Can be styled as destructive (for logout) and includes an optional tap handler.
  /// 
  /// Parameters:
  /// - [icon] The icon to display
  /// - [title] The tile title text
  /// - [isDestructive] Whether the tile should be styled as destructive (red color)
  /// - [onTap] Optional callback when the tile is tapped
  /// 
  /// Returns:
  /// A widget representing the settings tile
  Widget _buildSettingsTile(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive ? Colors.red[50] : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: isDestructive ? AppColors.error : AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDestructive ? AppColors.error : Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, size: 18, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
