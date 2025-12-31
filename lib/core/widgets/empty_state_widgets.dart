import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_texts.dart';

/// Reusable empty state widget for lists and grids
class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.action,
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
              width: AppSizes.avatarXL * 2,
              height: AppSizes.avatarXL * 2,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                  width: 2,
                ),
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: AppSizes.iconXL,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              title ?? AppTexts.emptyStateTitle,
              style: TextStyle(
                fontSize: AppSizes.fontXL,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              subtitle ?? AppTexts.emptyStateSubtitle,
              style: TextStyle(
                fontSize: AppSizes.fontM,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSizes.paddingL),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget specifically for product searches
class EmptySearchStateWidget extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback? onClearSearch;

  const EmptySearchStateWidget({
    super.key,
    this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: searchQuery != null 
          ? 'No results for "$searchQuery"'
          : 'No search results',
      subtitle: searchQuery != null
          ? 'Try adjusting your search terms or filters'
          : 'Start by searching for something you\'re interested in',
      action: searchQuery != null && onClearSearch != null
          ? OutlinedButton(
              onPressed: onClearSearch,
              child: const Text('Clear search'),
            )
          : null,
    );
  }
}

/// Empty state widget for favorites
class EmptyFavoritesStateWidget extends StatelessWidget {
  final VoidCallback? onBrowseProducts;

  const EmptyFavoritesStateWidget({
    super.key,
    this.onBrowseProducts,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'No favorites yet',
      subtitle: 'Start adding items to your favorites to see them here',
      action: onBrowseProducts != null
          ? ElevatedButton(
              onPressed: onBrowseProducts,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: const Text('Browse products'),
            )
          : null,
    );
  }
}

/// Empty state widget for chat/conversations
class EmptyChatStateWidget extends StatelessWidget {
  final VoidCallback? onStartMessaging;

  const EmptyChatStateWidget({
    super.key,
    this.onStartMessaging,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.chat_bubble_outline,
      title: 'No conversations yet',
      subtitle: 'Start chatting with sellers to see your conversations here',
      action: onStartMessaging != null
          ? ElevatedButton(
              onPressed: onStartMessaging,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: const Text('Start messaging'),
            )
          : null,
    );
  }
}

/// Empty state widget for user profile (no items)
class EmptyProfileItemsStateWidget extends StatelessWidget {
  final String? profileType;
  final VoidCallback? onPostAd;

  const EmptyProfileItemsStateWidget({
    super.key,
    this.profileType = 'items',
    this.onPostAd,
  });

  @override
  Widget build(BuildContext context) {
    String title, subtitle;
    IconData icon;
    
    switch (profileType) {
      case 'active':
        title = 'No active listings';
        subtitle = 'Your active items will appear here';
        icon = Icons.storefront_outlined;
        break;
      case 'sold':
        title = 'No sold items yet';
        subtitle = 'Items you\'ve sold will appear here';
        icon = Icons.sell_outlined;
        break;
      case 'saved':
        title = 'No saved items';
        subtitle = 'Items you save for later will appear here';
        icon = Icons.bookmark_border;
        break;
      default:
        title = 'No items yet';
        subtitle = 'Your items will appear here';
        icon = Icons.inventory_2_outlined;
    }

    return EmptyStateWidget(
      icon: icon,
      title: title,
      subtitle: subtitle,
      action: profileType == 'active' && onPostAd != null
          ? ElevatedButton(
              onPressed: onPostAd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: const Text('Post your first ad'),
            )
          : null,
    );
  }
}

/// Empty state widget for notifications
class EmptyNotificationsStateWidget extends StatelessWidget {
  const EmptyNotificationsStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.notifications_none,
      title: 'No notifications',
      subtitle: 'You\'ll see your notifications here when they arrive',
    );
  }
}

/// Empty state widget for categories
class EmptyCategoryStateWidget extends StatelessWidget {
  final String? categoryName;

  const EmptyCategoryStateWidget({
    super.key,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.category_outlined,
      title: categoryName != null 
          ? 'No items in $categoryName'
          : 'No items in this category',
      subtitle: 'Check back later or browse other categories',
    );
  }
}
