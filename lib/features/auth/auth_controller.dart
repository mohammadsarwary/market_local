import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_feedback.dart';
import '../auth/repositories/auth_service.dart';
import '../auth/models/auth_request.dart';

/// Controller for authentication functionality
class AuthController extends GetxController {
  /// Phone number input
  final RxString phoneNumber = ''.obs;

  /// Loading state for verification code sending
  final RxBool isLoading = false.obs;

  /// Error state for authentication operations
  final RxBool hasError = false.obs;

  /// Error message to display
  final RxString errorMessage = ''.obs;

  /// User login status
  final RxBool isLoggedIn = false.obs;

  /// Auth service for API calls
  final AuthService _authService = AuthService.instance;

  @override
  void onInit() {
    super.onInit();
    _authService.initialize();
    _checkAuthStatus();
    // Initialize with empty phone number
    phoneNumber.value = '';
  }

  /// Check if user is logged in
  Future<void> _checkAuthStatus() async {
    isLoggedIn.value = await _authService.isAuthenticated();
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final request = LoginRequest(
        email: email.trim(),
        password: password,
      );

      print('AuthController: Calling login with email: ${email.trim()}');
      final response = await _authService.login(request);
      print('AuthController: Login successful, user: ${response.user.name}');
      print('AuthController: Access token: ${_previewToken(response.accessToken)}');

      await HapticFeedback.success();
      isLoggedIn.value = true;

      Get.snackbar(
        'Success',
        'Welcome back, ${response.user.name}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );

      // Navigate to home screen
      Get.offAllNamed('/');
    } catch (e, stackTrace) {
      print('AuthController: Login error: $e');
      print('AuthController: Stack trace: $stackTrace');
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = e.toString();
      
      Get.snackbar(
        'Login Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final request = RegisterRequest(
        name: name.trim(),
        email: email.trim(),
        password: password,
        phone: phone ?? '',
      );

      final response = await _authService.register(request);

      await HapticFeedback.success();
      isLoggedIn.value = true;

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );

      // Navigate to home screen
      Get.offAllNamed('/');
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = 'Registration failed. Please try again.';
      
      Get.snackbar(
        'Registration Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      // Error during logout is handled silently
    } finally {
      isLoggedIn.value = false;
      Get.snackbar(
        'Logged Out',
        'You have been logged out',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed('/login');
    }
  }

  /// Send verification code to phone number
  Future<void> sendVerificationCode() async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, this would call an API to send SMS
      // For now, we'll just navigate to verification screen
      
      await HapticFeedback.success();
      
      // TODO: Navigate to verification screen
      // Get.toNamed('/verify', arguments: phoneNumber.value);
      
      // For now, just show success message
      Get.snackbar(
        'Code Sent',
        'Verification code sent to your phone',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = 'Failed to send verification code. Please try again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Retries sending verification code
  /// 
  /// Clears error state and attempts to send code again.
  Future<void> retrySendCode() async {
    await sendVerificationCode();
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      await HapticFeedback.light();
      
      // Simulate Apple Sign In
      await Future.delayed(const Duration(seconds: 1));
      
      await HapticFeedback.success();
      
      // TODO: Implement actual Apple Sign In
      Get.snackbar(
        'Apple Sign In',
        'Apple Sign In would be implemented here',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      Get.snackbar(
        'Error',
        'Failed to sign in with Apple',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      await HapticFeedback.light();
      
      // Simulate Google Sign In
      await Future.delayed(const Duration(seconds: 1));
      
      await HapticFeedback.success();
      
      // TODO: Implement actual Google Sign In
      Get.snackbar(
        'Google Sign In',
        'Google Sign In would be implemented here',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      Get.snackbar(
        'Error',
        'Failed to sign in with Google',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    }
  }

  /// Update phone number
  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  /// Validate phone number
  bool isPhoneNumberValid() {
    // Basic validation - check if phone number has at least 10 digits
    final digitsOnly = phoneNumber.value.replaceAll(RegExp(r'[^0-9]'), '');
    return digitsOnly.length >= 10;
  }

  String _previewToken(String token, [int maxChars = 20]) {
    if (token.isEmpty) return '';
    if (token.length <= maxChars) return token;
    return '${token.substring(0, maxChars)}...';
  }
}
