import '../../models/auth/auth_models.dart';

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

  Future<void> saveUserData(Map<String, dynamic> userData);

  Future<Map<String, dynamic>?> getUserData();

  Future<void> clearUserData();

  bool isTokenValid(String token);

  DateTime? getTokenExpiryTime(String token);

  bool isTokenExpiringSoon(String token);

  // Convenience methods
  Future<AuthResponse> registerAndSaveToken(RegisterRequest request);

  Future<AuthResponse> loginAndSaveToken(LoginRequest request);

  Future<RefreshTokenResponse> refreshTokenAndSave(String refreshToken);

  Future<void> logoutAndClearTokens();

  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<OtpResponse> sendOtp(String phone);

  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<OtpResponse> resendOtp(String phone);

  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<AuthResponse> verifyOtp(String phone, String otp);

  @Deprecated('OTP endpoints are not in the current API documentation')
  Future<void> resetPassword(String phone, String otp, String newPassword);
}
