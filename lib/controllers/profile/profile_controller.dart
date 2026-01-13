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

  final String appVersion = 'Version 2.4.0';

  static const List<String> tabs = ['Active', 'Sold', 'Saved'];
  
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
      final activeAds = await _userRepository.getUserAdsPaginated(
        page: 1,
        limit: 20,
        status: 'active',
      );
      items.value = activeAds.ads.map((item) => _convertUserAdToAdModel(item)).toList();

      final soldAds = await _userRepository.getUserAdsPaginated(
        page: 1,
        limit: 20,
        status: 'sold',
      );
      soldItems.value = soldAds.ads.map((item) => _convertUserAdToAdModel(item)).toList();

      final favorites = await _userRepository.getFavoritesPaginated(
        page: 1,
        limit: 20,
      );
      savedItems.value = favorites.favorites.map((item) => _convertFavoriteToAdModel(item)).toList();
    } catch (e) {
      print('Error loading tabs data: $e');
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
