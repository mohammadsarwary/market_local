import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_constants.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/repositories/local_data_source.dart';
import '../models/user_profile_request.dart';
import '../models/user_profile_response.dart';
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
      final response = await apiClient.get(UserEndpoints.profile);
      final profile = UserProfile.fromJson(response as Map<String, dynamic>);
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
  Future<UserAdsResponse> getUserAds(GetUserAdsRequest request) async {
    return handleException(() async {
      final response = await apiClient.get(
        UserEndpoints.userAds,
        queryParameters: request.toJson(),
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
}
