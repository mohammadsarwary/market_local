import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/ad_model.dart';
import '../../models/category_model.dart';
import '../../core/utils/haptic_feedback.dart';
import '../../core/services/storage_service.dart';
import '../../core/repositories/local_data_source_impl.dart';
import '../ad_details/repositories/ad_service.dart';
import '../ad_details/models/ad_response.dart';
import 'data/mock_data.dart';

/// Controller for managing the home screen state and data
/// 
/// This controller handles the main home screen functionality including:
/// - Category selection and filtering
/// - Product listing management
/// - Time formatting for post timestamps
/// - Fetching ads from API with pagination
/// - Local caching for offline viewing
/// 
/// Usage:
/// ```dart
/// final controller = Get.put(HomeController());
/// 
/// // Get categories
/// List<CategoryModel> categories = controller.categories;
/// 
/// // Change selected category
/// controller.changeCategory(2);
/// 
/// // Format time
/// String timeAgo = controller.getTimeAgo(DateTime.now());
/// ```
class HomeController extends GetxController {
  /// Loading state for the home screen
  final RxBool isLoading = false.obs;

  /// Error state for the home screen
  final RxBool hasError = false.obs;

  /// Error message to display
  final RxString errorMessage = ''.obs;

  /// Storage service for persisting favorites
  late final StorageService _storageService;

  /// Local data source for caching
  late final LocalDataSourceImpl _localDataSource;

  /// Ad service for API calls
  late final AdService _adService;

  /// Set of favorite item IDs for quick lookup
  final RxSet<String> favoriteIds = <String>{}.obs;

  /// Currently selected category index for filtering products
  /// 
  /// Defaults to 0 (all categories). When changed, the UI can filter
  /// products based on the selected category.
  final RxInt selectedCategoryIndex = 0.obs;

  /// List of products/ads to display
  final RxList<AdModel> _products = <AdModel>[].obs;

  /// Pagination state
  final RxInt _currentPage = 1.obs;
  final RxInt _totalPages = 1.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxBool _hasMoreData = true.obs;

  /// List of available categories for filtering
  /// 
  /// Returns mock data from [HomeMockData.categories]. In a production
  /// app, this would be populated from an API call.
  List<CategoryModel> get categories => HomeMockData.categories;

  /// List of products/ads to display
  List<AdModel> get products => _products;

  /// Check if loading more items
  bool get isLoadingMore => _isLoadingMore.value;

  /// Check if has more data to load
  bool get hasMoreData => _hasMoreData.value;

  @override
  void onInit() {
    super.onInit();
    _storageService = Get.find<StorageService>();
    _localDataSource = LocalDataSourceImpl();
    _adService = AdService.instance;
    _loadFavorites();
    loadInitialData();
  }

  /// Load favorite IDs from storage
  void _loadFavorites() {
    final savedFavorites = _storageService.loadFavorites();
    favoriteIds.assignAll(savedFavorites);
  }

  /// Load initial data for the home screen
  Future<void> loadInitialData() async {
    await refreshData();
  }

  /// Refresh data from the server
  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      _currentPage.value = 1;
      _hasMoreData.value = true;

      await _fetchAds(page: 1, clearExisting: true);
      
      await HapticFeedback.success();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load data. Please try again.';
      await HapticFeedback.error();
      
      await _loadCachedAds();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch ads from API
  Future<void> _fetchAds({required int page, bool clearExisting = false}) async {
    try {
      final categoryId = selectedCategoryIndex.value == 0 
          ? null 
          : categories[selectedCategoryIndex.value].id;

      final response = await _adService.getAds(
        page: page,
        limit: 20,
        categoryId: categoryId,
        sortBy: 'created_at',
      );

      final fetchedAds = response.ads.map((ad) => _mapAdToAdModel(ad)).toList();

      if (clearExisting) {
        _products.value = fetchedAds;
      } else {
        _products.addAll(fetchedAds);
      }

      _currentPage.value = response.page;
      _totalPages.value = (response.total / response.limit).ceil();
      _hasMoreData.value = response.page < _totalPages.value;

      await _cacheAds(fetchedAds);
    } catch (e) {
      rethrow;
    }
  }

  /// Load more ads for pagination
  Future<void> loadMoreAds() async {
    if (_isLoadingMore.value || !_hasMoreData.value || isLoading.value) {
      return;
    }

    try {
      _isLoadingMore.value = true;
      await _fetchAds(page: _currentPage.value + 1);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load more items',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoadingMore.value = false;
    }
  }

  /// Map API Ad model to app AdModel
  AdModel _mapAdToAdModel(Ad ad) {
    return AdModel(
      id: ad.id,
      title: ad.title,
      description: ad.description,
      price: ad.price,
      currency: 'USD',
      images: ad.images,
      categoryId: ad.categoryId,
      categoryName: ad.categoryName,
      sellerId: ad.userId,
      sellerName: ad.userName,
      sellerAvatar: ad.userAvatar ?? '',
      isSellerVerified: false,
      location: ad.location,
      latitude: ad.latitude,
      longitude: ad.longitude,
      createdAt: ad.createdAt,
      updatedAt: ad.updatedAt,
      isPromoted: false,
      isSold: ad.status == 'sold',
      isFavorite: ad.isFavorite,
      viewCount: ad.views,
      condition: AdCondition.used,
    );
  }

  /// Cache ads locally
  Future<void> _cacheAds(List<AdModel> ads) async {
    try {
      final adsJson = ads.map((ad) => ad.toJson()).toList();
      await _localDataSource.save('home_ads', adsJson);
      await _localDataSource.save('home_ads_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      // Silently fail caching
    }
  }

  /// Load cached ads
  Future<void> _loadCachedAds() async {
    try {
      final cached = await _localDataSource.get('home_ads');
      if (cached != null && cached is List) {
        final cachedAds = cached
            .map((item) => AdModel.fromJson(item as Map<String, dynamic>))
            .toList();
        _products.value = cachedAds;
      }
    } catch (e) {
      // Silently fail loading cache
    }
  }

  /// Retries loading data
  /// 
  /// Clears error state and loads data again.
  Future<void> retryLoadData() async {
    await refreshData();
  }

  /// Check if an item is favorited
  bool isFavorite(String itemId) {
    return favoriteIds.contains(itemId);
  }

  /// Toggle favorite status with optimistic update
  /// 
  /// Optimistically updates the UI immediately, then persists the change.
  /// If the operation fails, the state is reverted.
  /// 
  /// Parameters:
  /// - [itemId] The ID of the item to toggle favorite status for
  Future<void> toggleFavorite(String itemId) async {
    final wasFavorite = isFavorite(itemId);
    
    // Optimistic update - update UI immediately
    if (wasFavorite) {
      favoriteIds.remove(itemId);
      await HapticFeedback.light();
    } else {
      favoriteIds.add(itemId);
      await HapticFeedback.medium();
    }

    try {
      // Persist the change
      await _storageService.saveFavorites(favoriteIds.toList());
      await HapticFeedback.success();
    } catch (e) {
      // Revert on error
      if (wasFavorite) {
        favoriteIds.add(itemId);
      } else {
        favoriteIds.remove(itemId);
      }
      await HapticFeedback.error();
      
      Get.snackbar(
        'Error',
        'Failed to update favorites. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Changes the selected category index
  /// 
  /// Updates the [selectedCategoryIndex] to the provided [index].
  /// This can be used to filter products by category in the UI.
  /// 
  /// Parameters:
  /// - [index] The index of the category to select from [categories]
  /// 
  /// Example:
  /// ```dart
  /// controller.changeCategory(1); // Selects second category
  /// ```
  void changeCategory(int index) async {
    await HapticFeedback.selection();
    selectedCategoryIndex.value = index;
    await refreshData();
  }

  /// Formats a DateTime into a human-readable "time ago" string
  /// 
  /// Converts the provided [dateTime] into a relative time string
  /// such as "2h ago", "3d ago", or "Just now".
  /// 
  /// Parameters:
  /// - [dateTime] The DateTime to format
  /// 
  /// Returns:
  /// A string representing how long ago the [dateTime] was
  /// 
  /// Examples:
  /// ```dart
  /// controller.getTimeAgo(DateTime.now()); // "Just now"
  /// controller.getTimeAgo(DateTime.now().subtract(Duration(hours: 2))); // "2h ago"
  /// controller.getTimeAgo(DateTime.now().subtract(Duration(days: 10))); // "1w ago"
  /// ```
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}
