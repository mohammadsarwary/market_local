import '../models/user_profile_request.dart';
import '../models/user_profile_response.dart';

abstract class UserRepository {
  Future<UserProfile> getProfile();

  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request);

  Future<AvatarUploadResponse> uploadAvatar(String filePath);

  Future<UserAdsResponse> getUserAds(GetUserAdsRequest request);

  Future<FavoritesResponse> getFavorites(GetFavoritesRequest request);

  Future<void> saveUserProfile(UserProfile profile);

  Future<UserProfile?> getCachedProfile();

  Future<void> clearProfileCache();
}
