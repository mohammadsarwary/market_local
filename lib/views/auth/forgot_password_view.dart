import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../services/auth_service.dart';

/// Forgot password screen
/// 
/// Allows users to reset their password by entering their phone number.
class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final authFlow = Get.find<AuthFlowService>();
    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.paddingXL),
              const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              const Text(
                "Enter your phone number and we'll send you a code to reset your password.",
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32.0),
              _buildPhoneField(phoneController),
              const SizedBox(height: 32.0),
              _buildSendCodeButton(phoneController, authFlow),
              const Spacer(),
              _buildLoginLink(),
              const SizedBox(height: AppSizes.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: const TextStyle(
        fontSize: AppSizes.fontL,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: AppSizes.fontM,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingM,
        ),
      ),
    );
  }

  Widget _buildSendCodeButton(TextEditingController phoneController, AuthFlowService authFlow) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeightL,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () {
                authFlow.phoneNumber.value = phoneController.text;
                authFlow.navigateToStep(AuthStep.verifyOTP);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Send Code',
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ));
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () {
          final authFlow = Get.find<AuthFlowService>();
          authFlow.startLoginFlow();
        },
        child: const Text(
          'Back to Login',
          style: TextStyle(
            fontSize: AppSizes.fontM,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
