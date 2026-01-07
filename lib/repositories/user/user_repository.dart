import '../../models/user/user_models.dart';

abstract class UserRepository {
  Future<UserProfile> getProfile();

  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request);

  Future<AvatarUploadResponse> uploadAvatar(String filePath);

  Future<void> changePassword(String currentPassword, String newPassword);

  Future<void> deleteAccount();

  Future<UserProfile> getUserProfile(String userId);

  Future<UserAdsResponse> getUserAds(GetUserAdsRequest request);

  Future<UserAdsResponse> getUserPublicAds(String userId, {int page = 1, int limit = 20});

  Future<FavoritesResponse> getFavorites(GetFavoritesRequest request);

  Future<void> saveUserProfile(UserProfile profile);

  Future<UserProfile?> getCachedProfile();

  Future<void> clearProfileCache();

  // Convenience methods
  Future<UserProfile> getProfileWithFallback();

  Future<UpdateProfileResponse> updateProfileWithDetails({
    required String name,
    required String email,
    required String phone,
    String? bio,
    String? location,
  });

  Future<UserAdsResponse> getUserAdsPaginated({
    int page = 1,
    int limit = 20,
    String? status,
  });

  Future<FavoritesResponse> getFavoritesPaginated({
    int page = 1,
    int limit = 20,
  });

  Future<void> logout();
}
