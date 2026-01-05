import '../../../core/api/api_service.dart';
import '../../../core/repositories/local_data_source_impl.dart';
import '../models/user_profile_request.dart';
import '../models/user_profile_response.dart';
import 'user_repository.dart';
import 'user_repository_impl.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  late UserRepository _userRepository;

  UserService._internal();

  factory UserService() {
    return _instance;
  }

  static UserService get instance => _instance;

  void initialize() {
    final apiClient = ApiService.instance.apiClient;
    final localDataSource = LocalDataSourceImpl();
    _userRepository = UserRepositoryImpl(
      apiClient: apiClient,
      localDataSource: localDataSource,
    );
  }

  UserRepository get repository => _userRepository;

  Future<UserProfile> getProfile() async {
    try {
      return await _userRepository.getProfile();
    } catch (e) {
      final cached = await _userRepository.getCachedProfile();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  Future<UpdateProfileResponse> updateProfile({
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
    return await _userRepository.updateProfile(request);
  }

  Future<AvatarUploadResponse> uploadAvatar(String filePath) async {
    return await _userRepository.uploadAvatar(filePath);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _userRepository.changePassword(currentPassword, newPassword);
  }

  Future<void> deleteAccount() async {
    await _userRepository.deleteAccount();
  }

  Future<UserProfile> getUserProfile(String userId) async {
    return await _userRepository.getUserProfile(userId);
  }

  Future<UserAdsResponse> getUserAds({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final request = GetUserAdsRequest(
      page: page,
      limit: limit,
      status: status,
    );
    return await _userRepository.getUserAds(request);
  }

  Future<UserAdsResponse> getUserPublicAds(String userId, {int page = 1, int limit = 20}) async {
    return await _userRepository.getUserPublicAds(userId, page: page, limit: limit);
  }

  Future<FavoritesResponse> getFavorites({
    int page = 1,
    int limit = 20,
  }) async {
    final request = GetFavoritesRequest(
      page: page,
      limit: limit,
    );
    return await _userRepository.getFavorites(request);
  }

  Future<UserProfile?> getCachedProfile() async {
    return await _userRepository.getCachedProfile();
  }

  Future<void> clearProfileCache() async {
    await _userRepository.clearProfileCache();
  }

  Future<void> logout() async {
    await clearProfileCache();
  }
}
