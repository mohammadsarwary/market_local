
import '../../../core/repositories/base_repository.dart';
import '../../models/auth/auth_models.dart';
import 'auth_repository.dart';
import 'package:market_local/services/api_client.dart';
import 'package:market_local/services/api_constants.dart';
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        AuthEndpoints.register,
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    print('AuthRepositoryImpl: login() called');
    print('AuthRepositoryImpl: Endpoint: ${AuthEndpoints.login}');
    print('AuthRepositoryImpl: Request data: ${request.toJson()}');

    return handleException(() async {
      print('AuthRepositoryImpl: Calling apiClient.post()...');
      final response = await apiClient.post(
        AuthEndpoints.login,
        data: request.toJson(),
      );

      print('AuthRepositoryImpl: API response received');
      print('AuthRepositoryImpl: Status code: ${response.statusCode}');
      print('AuthRepositoryImpl: Response data: ${response.data}');

      final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);
      print('AuthRepositoryImpl: AuthResponse parsed successfully');
      print('AuthRepositoryImpl: User: ${authResponse.user?.name ?? "null"}');

      return authResponse;
    });
  }

  @override
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        AuthEndpoints.refreshToken,
        data: request.toJson(),
      );
      return RefreshTokenResponse.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<LogoutResponse> logout() async {
    return handleException(() async {
      final response = await apiClient.post(AuthEndpoints.logout);
      return LogoutResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<AuthResponse> getCurrentUser() async {
    return handleException(() async {
      final response = await apiClient.get(AuthEndpoints.me);
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<void> saveAuthToken(String token) async {
    return handleException(() async {
      await apiClient.setAuthToken(token);
    });
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    return handleException(() async {
      await apiClient.setRefreshToken(token);
    });
  }

  @override
  Future<String?> getAuthToken() async {
    return handleException(() async {
      return await apiClient.getAuthToken();
    });
  }

  @override
  Future<String?> getRefreshToken() async {
    return handleException(() async {
      return await apiClient.getRefreshToken();
    });
  }

  @override
  Future<void> clearTokens() async {
    return handleException(() async {
      await apiClient.clearTokens();
    });
  }

  @override
  Future<bool> isAuthenticated() async {
    return handleException(() async {
      final token = await apiClient.getAuthToken();
      return token != null && token.isNotEmpty;
    });
  }

  @override
  Future<AuthResponse> registerAndSaveToken(RegisterRequest request) async {
    final response = await register(request);
    await saveAuthToken(response.accessToken);
    await saveRefreshToken(response.refreshToken);
    return response;
  }

  @override
  Future<AuthResponse> loginAndSaveToken(LoginRequest request) async {
    print('AuthRepositoryImpl: loginAndSaveToken() called');
    print('AuthRepositoryImpl: Request data: ${request.toJson()}');
    print('AuthRepositoryImpl: Calling login()...');

    final response = await login(request);

    print('AuthRepositoryImpl: Login response received');
    print('AuthRepositoryImpl: User: ${response.user?.name ?? "null"}');
    print('AuthRepositoryImpl: User ID: ${response.user?.id ?? "null"}');
    print('AuthRepositoryImpl: Access token: ${response.accessToken.substring(0, 10)}...');
    print('AuthRepositoryImpl: Saving access token...');

    await saveAuthToken(response.accessToken);
    print('AuthRepositoryImpl: Access token saved');

    print('AuthRepositoryImpl: Saving refresh token...');
    await saveRefreshToken(response.refreshToken);
    print('AuthRepositoryImpl: Refresh token saved');

    print('AuthRepositoryImpl: Login process completed successfully');
    return response;
  }

  @override
  Future<RefreshTokenResponse> refreshTokenAndSave(String refreshToken) async {
    final request = RefreshTokenRequest(refreshToken: refreshToken);
    final response = await this.refreshToken(request);
    await saveAuthToken(response.accessToken);
    await saveRefreshToken(response.refreshToken);
    return response;
  }

  @override
  Future<void> logoutAndClearTokens() async {
    try {
      await logout();
    } catch (e) {
      // Error during logout is handled silently
      // Tokens are cleared regardless
    } finally {
      await clearTokens();
    }
  }

  @override
  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<OtpResponse> sendOtp(String phone) async {
    throw UnimplementedError('OTP endpoints are not supported in the current API');
  }

  @override
  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<OtpResponse> resendOtp(String phone) async {
    throw UnimplementedError('OTP endpoints are not supported in the current API');
  }

  @override
  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<AuthResponse> verifyOtp(String phone, String otp) async {
    throw UnimplementedError('OTP endpoints are not supported in the current API');
  }

  @override
  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<void> resetPassword(String phone, String otp, String newPassword) async {
    throw UnimplementedError('OTP endpoints are not supported in the current API');
  }
}
