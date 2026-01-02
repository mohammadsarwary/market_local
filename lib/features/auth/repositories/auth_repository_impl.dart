import '../../../core/api/api_client.dart';
import '../../../core/api/api_constants.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import 'auth_repository.dart';

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
      return AuthResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        AuthEndpoints.login,
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        AuthEndpoints.refreshToken,
        data: request.toJson(),
      );
      return RefreshTokenResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<OtpResponse> sendOtp(ForgotPasswordRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        AuthEndpoints.forgotPassword,
        data: request.toJson(),
      );
      return OtpResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<OtpResponse> resendOtp(ForgotPasswordRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        AuthEndpoints.resendOtp,
        data: request.toJson(),
      );
      return OtpResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<AuthResponse> verifyOtp(VerifyOtpRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        AuthEndpoints.verifyOtp,
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    return handleException(() async {
      await apiClient.post(
        AuthEndpoints.resetPassword,
        data: request.toJson(),
      );
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
      return await apiClient.getAuthToken();
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
}
