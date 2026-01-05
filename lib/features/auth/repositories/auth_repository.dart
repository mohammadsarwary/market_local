import '../models/auth_request.dart';
import '../models/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> register(RegisterRequest request);

  Future<AuthResponse> login(LoginRequest request);

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request);

  Future<LogoutResponse> logout();

  Future<AuthResponse> getCurrentUser();

  Future<void> saveAuthToken(String token);

  Future<void> saveRefreshToken(String token);

  Future<String?> getAuthToken();

  Future<String?> getRefreshToken();

  Future<void> clearTokens();

  Future<bool> isAuthenticated();
}
