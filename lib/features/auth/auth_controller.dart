import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_feedback.dart';

/// Controller for authentication functionality
class AuthController extends GetxController {
  /// Phone number input
  final RxString phoneNumber = ''.obs;

  /// Loading state for verification code sending
  final RxBool isLoading = false.obs;

  /// Error message to display
  final RxString errorMessage = ''.obs;

  /// Send verification code to phone number
  Future<void> sendVerificationCode() async {
    try {
      await HapticFeedback.light();
      isLoading.value = true;
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
    errorMessage.value = '';
  }

  /// Validate phone number
  bool isPhoneNumberValid() {
    // Basic validation - check if phone number has at least 10 digits
    final digitsOnly = phoneNumber.value.replaceAll(RegExp(r'[^0-9]'), '');
    return digitsOnly.length >= 10;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with empty phone number
    phoneNumber.value = '';
  }
}
