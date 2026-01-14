import 'package:get/get.dart';
import '../../models/ad/ad_models.dart';
import '../../models/user/user_models.dart';
import '../../repositories/user/user_repository.dart';
import '../../utils/haptic_feedback.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository;

  ProfileController(this._userRepository);
  /// Loading state for profile operations
  final RxBool isLoading = false.obs;

  /// Error state for profile operations
  final RxBool hasError = false.obs;

  /// Error message to display
  final RxString errorMessage = ''.obs;

  final Rx<UserModel> user = UserModel(
    id: '',
    name: '',
    email: '',
    createdAt: DateTime.now(),
  ).obs;
  
  final RxInt selectedTabIndex = 0.obs;

  final RxInt selectedFilterIndex = 0.obs;

  final String appVersion = 'Version 2.4.0';

  static const List<String> tabs = ['Active', 'Sold', 'Saved'];

  static const List<String> filters = ['All', 'Active', 'Inactive', 'Pending'];

  final RxList<AdModel> allAds = <AdModel>[].obs;
  
  final RxList<AdModel> items = <AdModel>[].obs;
  final RxList<AdModel> soldItems = <AdModel>[].obs;
  final RxList<AdModel> savedItems = <AdModel>[].obs;

  List<AdModel> get currentItems {
    switch (selectedTabIndex.value) {
      case 0:
        return items;
      case 1:
        return soldItems;
      case 2:
        return savedItems;
      default:
        return items;
    }
  }

  String get memberSinceYear => user.value.createdAt.year.toString();

  /// Changes the selected tab index
  /// 
  /// Updates the [selectedTabIndex] to the provided [index].
  /// This is typically called when the user taps on a tab.
  /// 
  /// Parameters:
  /// - [index] The index of the tab to select
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void changeFilter(int index) {
    selectedFilterIndex.value = index;
  }

  List<AdModel> get filteredAds {
    if (selectedFilterIndex.value == 0) {
      return allAds;
    }
    final filter = filters[selectedFilterIndex.value].toLowerCase();
    // Handle null status by defaulting to empty string to prevent comparison issues
    return allAds.where((ad) => (ad.status ?? '').toLowerCase() == filter).toList();
  }

  /// Navigates to the edit profile screen
  /// 
  /// This method would typically navigate to a profile editing screen
  /// where users can update their personal information.
  void editProfile() {
    // Navigate to edit profile screen
  }

  /// Logs out the current user
  /// 
  /// This method handles the logout process, including clearing
   /// user data and navigating to the login screen.
  Future<void> logout() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Simulate logout delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would clear user session and tokens
      await HapticFeedback.success();

      // Navigate to login screen
      Get.back();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Logout failed. Please try again.';
      await HapticFeedback.error();
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads user profile data from API
  Future<void> loadProfileData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final profile = await _userRepository.getProfileWithFallback();
      user.value = _convertToUserModel(profile);

      await loadUserTabsData();

      await HapticFeedback.success();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load profile: ${e.toString()}';
      print('Profile load error: $e');
      await HapticFeedback.error();
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads data for all tabs (Active, Sold, Saved)
  Future<void> loadUserTabsData() async {
    try {
      print('ProfileController: Loading all ads...');
      final allUserAds = await _userRepository.getUserAdsPaginated(
        page: 1,
        limit: 20,
      );
      print('ProfileController: All ads loaded: ${allUserAds.ads.length} ads');
      allAds.value = allUserAds.ads.map((item) => _convertUserAdToAdModel(item)).toList();
      print('ProfileController: All ads list length: ${allAds.length}');

      print('ProfileController: Loading active ads...');
      final activeAds = allUserAds.ads.where((ad) => ad.status.toLowerCase() == 'active').toList();
      items.value = activeAds.map((item) => _convertUserAdToAdModel(item)).toList();
      print('ProfileController: Active ads loaded: ${items.length} ads');

      print('ProfileController: Loading sold ads...');
      final soldAds = allUserAds.ads.where((ad) => ad.status.toLowerCase() == 'sold').toList();
      soldItems.value = soldAds.map((item) => _convertUserAdToAdModel(item)).toList();
      print('ProfileController: Sold ads loaded: ${soldItems.length} ads');

      print('ProfileController: Loading favorites...');
      final favorites = await _userRepository.getFavoritesPaginated(
        page: 1,
        limit: 20,
      );
      print('ProfileController: Favorites loaded: ${favorites.favorites.length} favorites');
      savedItems.value = favorites.favorites.map((item) => _convertFavoriteToAdModel(item)).toList();
    } catch (e) {
      print('Error loading tabs data: $e');
      print('Error type: ${e.runtimeType}');
      // Don't fail the entire profile load if tabs fail
    }
  }

  /// Converts UserAdItem to AdModel for UI display
  AdModel _convertUserAdToAdModel(UserAdItem item) {
    return AdModel(
      id: item.id,
      title: item.title,
      description: '',
      price: item.price,
      images: item.image != null ? [item.image!] : [],
      categoryId: '',
      categoryName: 'Category',
      sellerId: user.value.id,
      sellerName: user.value.name,
      location: user.value.location,
      createdAt: item.createdAt,
      isSold: item.status == 'sold',
      status: item.status,
      condition: AdCondition.used,
    );
  }

  /// Converts FavoriteItem to AdModel for UI display
  AdModel _convertFavoriteToAdModel(FavoriteItem item) {
    return AdModel(
      id: item.id,
      title: item.title,
      description: '',
      price: item.price,
      images: item.image != null ? [item.image!] : [],
      categoryId: '',
      categoryName: item.category,
      sellerId: '',
      sellerName: '',
      location: '',
      createdAt: item.createdAt,
      isFavorite: true,
      condition: AdCondition.used,
    );
  }

  /// Converts UserProfile API response to UserModel for UI
  UserModel _convertToUserModel(UserProfile profile) {
    return UserModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      phone: profile.phone,
      avatar: profile.avatar ?? '',
      isVerified: profile.isVerified,
      rating: profile.rating,
      reviewCount: profile.reviewCount,
      activeListings: profile.activeListings,
      soldItems: profile.soldItems,
      followers: profile.followers,
      following: 0,
      location: profile.location ?? '',
      createdAt: profile.createdAt,
      lastActive: profile.updatedAt,
    );
  }

  /// Retries loading profile data
  Future<void> retryLoadProfile() async {
    await loadProfileData();
  }

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }
}
