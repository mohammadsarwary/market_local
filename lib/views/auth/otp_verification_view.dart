import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../services/auth_service.dart';

/// OTP verification screen
/// 
/// Allows users to enter the verification code sent to their phone number.
class OTPVerificationView extends GetView<AuthController> {
  const OTPVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final authFlow = Get.find<AuthFlowService>();
    final phoneNumber = Get.arguments as String? ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => authFlow.goBack(),
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
                'Enter the code',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              Text(
                'We sent a code to $phoneNumber',
                style: const TextStyle(
                  fontSize: AppSizes.fontL,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48.0),
              _buildOTPInput(),
              const SizedBox(height: 32.0),
              _buildResendButton(),
              const Spacer(),
              _buildVerifyButton(),
              const SizedBox(height: AppSizes.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => _OTPDigitField(
          autoFocus: index == 0,
          index: index,
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              FocusScope.of(Get.context!).nextFocus();
            }
          },
        ),
      ),
    );
  }

  Widget _buildResendButton() {
    return Center(
      child: TextButton(
        onPressed: controller.retrySendCode,
        child: const Text(
          "Didn't receive a code? Resend",
          style: TextStyle(
            fontSize: AppSizes.fontM,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeightL,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () {
                final authFlow = Get.find<AuthFlowService>();
                authFlow.completeAuth();
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
                'Verify',
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ));
  }
}

class _OTPDigitField extends StatelessWidget {
  final bool autoFocus;
  final int index;
  final ValueChanged<String>? onChanged;

  const _OTPDigitField({
    required this.autoFocus,
    required this.index,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
      ),
    );
  }
}
