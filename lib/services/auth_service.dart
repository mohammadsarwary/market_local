import 'package:get/get.dart';

/// Authentication flow service
/// 
/// Manages the navigation and state transitions for the authentication process.
/// This service coordinates between different auth screens and ensures proper flow.
class AuthFlowService extends GetxController {
  /// Current step in the authentication flow
  final Rx<AuthStep> currentStep = AuthStep.login.obs;

  /// Phone number entered by user
  final RxString phoneNumber = ''.obs;

  /// Verification code sent to user
  final RxString verificationCode = ''.obs;

  /// User's name (for registration)
  final RxString userName = ''.obs;

  /// User's email (for registration)
  final RxString userEmail = ''.obs;

  /// Navigate to the next step in the auth flow
  void navigateToStep(AuthStep step) {
    currentStep.value = step;
    switch (step) {
      case AuthStep.login:
        Get.toNamed('/auth/login');
        break;
      case AuthStep.register:
        Get.toNamed('/auth/register');
        break;
      case AuthStep.verifyOTP:
        Get.toNamed('/auth/verify-otp', arguments: phoneNumber.value);
        break;
      case AuthStep.forgotPassword:
        Get.toNamed('/auth/forgot-password');
        break;
      case AuthStep.resetPassword:
        Get.toNamed('/auth/reset-password');
        break;
      case AuthStep.complete:
        Get.offAllNamed('/');
        break;
    }
  }

  /// Start login flow
  void startLoginFlow() {
    phoneNumber.value = '';
    verificationCode.value = '';
    navigateToStep(AuthStep.login);
  }

  /// Start registration flow
  void startRegistrationFlow() {
    phoneNumber.value = '';
    userName.value = '';
    userEmail.value = '';
    navigateToStep(AuthStep.register);
  }

  /// Start forgot password flow
  void startForgotPasswordFlow() {
    phoneNumber.value = '';
    navigateToStep(AuthStep.forgotPassword);
  }

  /// Complete authentication and navigate to home
  void completeAuth() {
    navigateToStep(AuthStep.complete);
  }

  /// Go back to previous step
  void goBack() {
    switch (currentStep.value) {
      case AuthStep.verifyOTP:
        navigateToStep(AuthStep.login);
        break;
      case AuthStep.resetPassword:
        navigateToStep(AuthStep.forgotPassword);
        break;
      default:
        Get.back();
    }
  }
}

/// Authentication flow steps
enum AuthStep {
  /// Initial login screen
  login,

  /// Registration screen
  register,

  /// OTP verification screen
  verifyOTP,

  /// Forgot password screen
  forgotPassword,

  /// Reset password screen
  resetPassword,

  /// Authentication complete
  complete,
}
