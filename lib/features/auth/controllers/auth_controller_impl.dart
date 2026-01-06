import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/haptic_feedback.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../repositories/auth_service.dart';

class AuthControllerImpl extends GetxController {
  final AuthService authService = AuthService.instance;

  final RxString phoneNumber = ''.obs;
  final RxString password = ''.obs;
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString otp = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool isLoggedIn = false.obs;
  final Rx<UserData?> currentUser = Rx<UserData?>(null);

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await authService.isAuthenticated();
      isLoggedIn.value = isAuth;
    } catch (e) {
      isLoggedIn.value = false;
    }
  }

  Future<void> register({
    required String phone,
    required String password,
    required String name,
    required String email,
  }) async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final request = RegisterRequest(
        phone: phone,
        password: password,
        name: name,
        email: email,
      );

      final response = await authService.register(request);
      currentUser.value = response.user;
      isLoggedIn.value = true;

      await HapticFeedback.success();

      Get.snackbar(
        'Success',
        'Registration successful',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Registration Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    print('AuthControllerImpl: login() called');
    print('AuthControllerImpl: Email: "$email"');
    print('AuthControllerImpl: Password length: ${password.length}');

    try {
      await HapticFeedback.light();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final request = LoginRequest(
        email: email,
        password: password,
      );

      print('AuthControllerImpl: LoginRequest created');
      print('AuthControllerImpl: Request JSON: ${request.toJson()}');
      print('AuthControllerImpl: Calling authService.login()...');

      final response = await authService.login(request);

      print('AuthControllerImpl: Login response received');
      print('AuthControllerImpl: Response user: ${response.user?.name ?? "null"}');
      print('AuthControllerImpl: Response user ID: ${response.user?.id ?? "null"}');
      print('AuthControllerImpl: Access token length: ${response.accessToken.length}');
      print('AuthControllerImpl: Refresh token length: ${response.refreshToken.length}');

      currentUser.value = response.user;
      isLoggedIn.value = true;

      print('AuthControllerImpl: User logged in successfully');

      await HapticFeedback.success();

      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      print('AuthControllerImpl: Login failed');
      print('AuthControllerImpl: Error: $e');
      print('AuthControllerImpl: Error type: ${e.runtimeType}');
      print('AuthControllerImpl: Stack trace: $stackTrace');

      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = _parseError(e);
      print('AuthControllerImpl: Parsed error message: $errorMessage.value');

      Get.snackbar(
        'Login Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
      print('AuthControllerImpl: login() completed');
    }
  }

  Future<void> sendOtp(String phone) async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      await authService.sendOtp(phone);

      await HapticFeedback.success();

      Get.snackbar(
        'OTP Sent',
        'Verification code sent to your phone',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = _parseError(e);
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

  Future<void> resendOtp(String phone) async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      await authService.resendOtp(phone);

      await HapticFeedback.success();

      Get.snackbar(
        'OTP Resent',
        'Verification code resent to your phone',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = _parseError(e);
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

  Future<void> verifyOtp(String phone, String otp) async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await authService.verifyOtp(phone, otp);
      currentUser.value = response.user;
      isLoggedIn.value = true;

      await HapticFeedback.success();

      Get.snackbar(
        'Success',
        'OTP verified successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Verification Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String phone, String otp, String newPassword) async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      await authService.resetPassword(phone, otp, newPassword);

      await HapticFeedback.success();

      Get.snackbar(
        'Success',
        'Password reset successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Reset Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;

      await authService.logout();
      currentUser.value = null;
      isLoggedIn.value = false;

      await HapticFeedback.success();

      Get.snackbar(
        'Logged Out',
        'You have been logged out',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      await HapticFeedback.error();
      Get.snackbar(
        'Error',
        'Failed to logout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  void updatePassword(String value) {
    password.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  void updateName(String value) {
    name.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  void updateEmail(String value) {
    email.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  void updateOtp(String value) {
    otp.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  bool isPhoneNumberValid() {
    final digitsOnly = phoneNumber.value.replaceAll(RegExp(r'[^0-9]'), '');
    return digitsOnly.length >= 10;
  }

  bool isPasswordValid() {
    return password.value.length >= 6;
  }

  bool isEmailValid() {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email.value);
  }

  bool isNameValid() {
    return name.value.trim().isNotEmpty && name.value.length >= 2;
  }

  bool isOtpValid() {
    return otp.value.length == 6 && otp.value.contains(RegExp(r'^\d+$'));
  }

  String _parseError(dynamic error) {
    if (error is Exception) {
      final message = error.toString();
      if (message.contains('Connection timeout')) {
        return 'Connection timeout. Please check your internet connection.';
      } else if (message.contains('Unauthorized')) {
        return 'Invalid credentials. Please try again.';
      } else if (message.contains('Validation error')) {
        return 'Please check your input and try again.';
      } else if (message.contains('Exception:')) {
        return message.replaceAll('Exception: ', '');
      }
    }
    return 'An error occurred. Please try again.';
  }
}
