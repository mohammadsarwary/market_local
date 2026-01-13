import 'package:dio/dio.dart';
import 'package:market_local/services/api_client.dart';
import 'package:market_local/services/api_constants.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/repositories/local_data_source.dart';
import '../../models/user/user_models.dart';
import 'user_repository.dart';

class UserRepositoryImpl extends BaseRepository implements UserRepository {
  final ApiClient apiClient;
  final LocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<UserProfile> getProfile() async {
    return handleException(() async {
      final response = await apiClient.put(UserEndpoints.profile);
      final profile = UserProfile.fromJson(response.data as Map<String, dynamic>);
      await saveUserProfile(profile);
      return profile;
    });
  }

  @override
  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request) async {
    return handleException(() async {
      final response = await apiClient.put(
        UserEndpoints.updateProfile,
        data: request.toJson(),
      );
      final updateResponse = UpdateProfileResponse.fromJson(response as Map<String, dynamic>);
      await saveUserProfile(updateResponse.user);
      return updateResponse;
    });
  }

  @override
  Future<AvatarUploadResponse> uploadAvatar(String filePath) async {
    return handleException(() async {
      final files = [await MultipartFile.fromFile(filePath)];
      final response = await apiClient.upload(
        UserEndpoints.uploadAvatar,
        files: files,
      );
      return AvatarUploadResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    return handleException(() async {
      await apiClient.post(
        UserEndpoints.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    });
  }

  @override
  Future<void> deleteAccount() async {
    return handleException(() async {
      await apiClient.delete(UserEndpoints.deleteAccount);
    });
  }

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    return handleException(() async {
      final endpoint = UserEndpoints.getUserProfile.replaceAll('{user}', userId);
      final response = await apiClient.get(endpoint);
      return UserProfile.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<UserAdsResponse> getUserAds(GetUserAdsRequest request) async {
    return handleException(() async {
      // Try to get user ID from saved data first
      var userId = '';
      final userData = await apiClient.getUserData();
      if (userData != null && userData['id'] != null) {
        userId = userData['id'].toString();
        print('UserRepositoryImpl: Got user ID from saved data: $userId');
      } else {
        // Fallback: fetch profile to get user ID
        print('UserRepositoryImpl: User data not in storage, fetching profile...');
        final profile = await getProfile();
        userId = profile.id;
        print('UserRepositoryImpl: Got user ID from profile: $userId');
      }
      
      // Use endpoint with user ID: /users/{userId}/ads instead of /users/ads
      final endpoint = UserEndpoints.getUserAds.replaceAll('{user}', userId);
      
      final response = await apiClient.get(
        endpoint,
        queryParameters: request.toJson(),
      );
      // API returns {success, message, data: [...]} but model expects {ads, total, page, limit}
      final responseData = response.data as Map<String, dynamic>;
      final adsList = responseData['data'] as List<dynamic>? ?? [];
      
      return UserAdsResponse(
        ads: adsList
            .map((item) => UserAdItem.fromJson(item as Map<String, dynamic>))
            .toList(),
        total: adsList.length,
        page: request.page,
        limit: request.limit,
      );
    });
  }

  @override
  Future<UserAdsResponse> getUserPublicAds(String userId, {int page = 1, int limit = 20}) async {
    return handleException(() async {
      final endpoint = UserEndpoints.getUserAds.replaceAll('{user}', userId);
      final response = await apiClient.get(
        endpoint,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return UserAdsResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<FavoritesResponse> getFavorites(GetFavoritesRequest request) async {
    return handleException(() async {
      final response = await apiClient.get(
        UserEndpoints.favorites,
        queryParameters: request.toJson(),
      );
      return FavoritesResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    return handleException(() async {
      await localDataSource.save('user_profile', profile.toJson());
    });
  }

  @override
  Future<UserProfile?> getCachedProfile() async {
    return handleException(() async {
      final cached = await localDataSource.get('user_profile');
      if (cached != null) {
        return UserProfile.fromJson(cached as Map<String, dynamic>);
      }
      return null;
    });
  }

  @override
  Future<void> clearProfileCache() async {
    return handleException(() async {
      await localDataSource.delete('user_profile');
    });
  }

  @override
  Future<UserProfile> getProfileWithFallback() async {
    try {
      return await getProfile();
    } catch (e) {
      final cached = await getCachedProfile();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<UpdateProfileResponse> updateProfileWithDetails({
    required String name,
    required String email,
    required String phone,
    String? bio,
    String? location,
  }) async {
    final request = UpdateProfileRequest(
      name: name,
      email: email,
      phone: phone,
      bio: bio,
      location: location,
    );
    return await updateProfile(request);
  }

  @override
  Future<UserAdsResponse> getUserAdsPaginated({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final request = GetUserAdsRequest(
      page: page,
      limit: limit,
      status: status,
    );
    return await getUserAds(request);
  }

  @override
  Future<FavoritesResponse> getFavoritesPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    final request = GetFavoritesRequest(
      page: page,
      limit: limit,
    );
    return await getFavorites(request);
  }

  @override
  Future<void> logout() async {
    await clearProfileCache();
  }
}
