import '../models/auth_request.dart';
import '../models/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> register(RegisterRequest request);

  Future<AuthResponse> login(LoginRequest request);

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request);

  Future<OtpResponse> sendOtp(ForgotPasswordRequest request);

  Future<OtpResponse> resendOtp(ForgotPasswordRequest request);

  Future<AuthResponse> verifyOtp(VerifyOtpRequest request);

  Future<void> resetPassword(ResetPasswordRequest request);

  Future<LogoutResponse> logout();

  Future<void> saveAuthToken(String token);

  Future<void> saveRefreshToken(String token);

  Future<String?> getAuthToken();

  Future<String?> getRefreshToken();

  Future<void> clearTokens();

  Future<bool> isAuthenticated();
}
