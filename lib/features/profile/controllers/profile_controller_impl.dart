import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/haptic_feedback.dart';
import '../models/user_profile_response.dart';
import '../repositories/user_service.dart';

class ProfileControllerImpl extends GetxController {
  final UserService userService = UserService.instance;

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final RxList<UserAdItem> userAds = RxList<UserAdItem>([]);
  final RxList<FavoriteItem> favorites = RxList<FavoriteItem>([]);

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString bio = ''.obs;
  final RxString location = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxInt currentAdsPage = 1.obs;
  final RxInt currentFavoritesPage = 1.obs;
  final RxBool hasMoreAds = true.obs;
  final RxBool hasMoreFavorites = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final profile = await userService.getProfile();
      userProfile.value = profile;

      name.value = profile.name;
      email.value = profile.email;
      phone.value = profile.phone;
      bio.value = profile.bio ?? '';
      location.value = profile.location ?? '';
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      await HapticFeedback.light();
      isUpdating.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await userService.updateProfile(
        name: name.value,
        email: email.value,
        phone: phone.value,
        bio: bio.value.isEmpty ? null : bio.value,
        location: location.value.isEmpty ? null : location.value,
      );

      userProfile.value = response.user;

      await HapticFeedback.success();

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Update Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> uploadAvatar(String filePath) async {
    try {
      await HapticFeedback.light();
      isUpdating.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await userService.uploadAvatar(filePath);

      if (userProfile.value != null) {
        userProfile.value = userProfile.value!.copyWith(avatar: response.avatarUrl);
      }

      await HapticFeedback.success();

      Get.snackbar(
        'Success',
        'Avatar uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Upload Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> loadUserAds({bool refresh = false}) async {
    try {
      if (refresh) {
        currentAdsPage.value = 1;
        userAds.clear();
        hasMoreAds.value = true;
      }

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await userService.getUserAds(
        page: currentAdsPage.value,
        limit: 20,
      );

      if (refresh) {
        userAds.value = response.ads;
      } else {
        userAds.addAll(response.ads);
      }

      hasMoreAds.value = (currentAdsPage.value * 20) < response.total;
      currentAdsPage.value++;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFavorites({bool refresh = false}) async {
    try {
      if (refresh) {
        currentFavoritesPage.value = 1;
        favorites.clear();
        hasMoreFavorites.value = true;
      }

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await userService.getFavorites(
        page: currentFavoritesPage.value,
        limit: 20,
      );

      if (refresh) {
        favorites.value = response.favorites;
      } else {
        favorites.addAll(response.favorites);
      }

      hasMoreFavorites.value = (currentFavoritesPage.value * 20) < response.total;
      currentFavoritesPage.value++;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateName(String value) {
    name.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  void updateEmail(String value) {
    email.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  void updatePhone(String value) {
    phone.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  void updateBio(String value) {
    bio.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  void updateLocation(String value) {
    location.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  bool isNameValid() {
    return name.value.trim().isNotEmpty && name.value.length >= 2;
  }

  bool isEmailValid() {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email.value);
  }

  bool isPhoneValid() {
    final digitsOnly = phone.value.replaceAll(RegExp(r'[^0-9]'), '');
    return digitsOnly.length >= 10;
  }

  bool canUpdateProfile() {
    return isNameValid() && isEmailValid() && isPhoneValid();
  }

  String _parseError(dynamic error) {
    if (error is Exception) {
      final message = error.toString();
      if (message.contains('Connection timeout')) {
        return 'Connection timeout. Please check your internet connection.';
      } else if (message.contains('Unauthorized')) {
        return 'Unauthorized. Please log in again.';
      } else if (message.contains('Validation error')) {
        return 'Please check your input and try again.';
      } else if (message.contains('Exception:')) {
        return message.replaceAll('Exception: ', '');
      }
    }
    return 'An error occurred. Please try again.';
  }

  Future<void> logout() async {
    await userService.logout();
  }
}

extension UserProfileCopyWith on UserProfile {
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? bio,
    String? location,
    bool? isVerified,
    int? totalAds,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      isVerified: isVerified ?? this.isVerified,
      totalAds: totalAds ?? this.totalAds,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
