import '../../../core/api/api_service.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import 'auth_repository.dart';
import 'auth_repository_impl.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  late AuthRepository _authRepository;

  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  static AuthService get instance => _instance;

  void initialize() {
    final apiClient = ApiService.instance.apiClient;
    _authRepository = AuthRepositoryImpl(apiClient: apiClient);
  }

  AuthRepository get repository => _authRepository;

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _authRepository.register(request);
    await _authRepository.saveAuthToken(response.accessToken);
    await _authRepository.saveRefreshToken(response.refreshToken);
    return response;
  }

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _authRepository.login(request);
    await _authRepository.saveAuthToken(response.accessToken);
    await _authRepository.saveRefreshToken(response.refreshToken);
    return response;
  }

  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    final request = RefreshTokenRequest(refreshToken: refreshToken);
    final response = await _authRepository.refreshToken(request);
    await _authRepository.saveAuthToken(response.accessToken);
    await _authRepository.saveRefreshToken(response.refreshToken);
    return response;
  }

  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<OtpResponse> sendOtp(String phone) async {
    throw UnimplementedError('OTP endpoints are not supported in the current API');
  }

  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<OtpResponse> resendOtp(String phone) async {
    throw UnimplementedError('OTP endpoints are not supported in the current API');
  }

  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<AuthResponse> verifyOtp(String phone, String otp) async {
    throw UnimplementedError('OTP endpoints are not supported in the current API');
  }

  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<void> resetPassword(String phone, String otp, String newPassword) async {
    throw UnimplementedError('OTP endpoints are not supported in the current API');
  }

  Future<AuthResponse> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      // Error during logout is handled silently
      // Tokens are cleared regardless
    } finally {
      await _authRepository.clearTokens();
    }
  }

  Future<bool> isAuthenticated() async {
    return await _authRepository.isAuthenticated();
  }

  Future<String?> getAuthToken() async {
    return await _authRepository.getAuthToken();
  }

  Future<void> clearTokens() async {
    await _authRepository.clearTokens();
  }
}
