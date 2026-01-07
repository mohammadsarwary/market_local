import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../services/auth_service.dart';

/// Registration screen
/// 
/// Allows new users to create an account with their phone number and details.
class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final authFlow = Get.find<AuthFlowService>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.paddingXL),
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              const Text(
                'Join MarketLocal to buy and sell items in your area.',
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32.0),
              _buildNameField(nameController),
              const SizedBox(height: AppSizes.paddingM),
              _buildEmailField(emailController),
              const SizedBox(height: AppSizes.paddingM),
              _buildPhoneField(phoneController),
              const SizedBox(height: 32.0),
              _buildTermsCheckbox(),
              const SizedBox(height: 32.0),
              _buildContinueButton(nameController, emailController, phoneController, authFlow),
              const SizedBox(height: AppSizes.paddingXL),
              _buildLoginLink(),
              const SizedBox(height: AppSizes.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(
        fontSize: AppSizes.fontL,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: 'Full Name',
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

  Widget _buildEmailField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontSize: AppSizes.fontL,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: 'Email Address',
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

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'I agree to the Terms of Service and Privacy Policy',
            style: TextStyle(
              fontSize: AppSizes.fontM,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    AuthFlowService authFlow,
  ) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeightL,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () {
                authFlow.phoneNumber.value = phoneController.text;
                authFlow.userName.value = nameController.text;
                authFlow.userEmail.value = emailController.text;
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
                'Continue',
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: TextStyle(
              fontSize: AppSizes.fontM,
              color: AppColors.textSecondary,
            ),
          ),
          GestureDetector(
            onTap: () {
              final authFlow = Get.find<AuthFlowService>();
              authFlow.startLoginFlow();
            },
            child: const Text(
              'Log in',
              style: TextStyle(
                fontSize: AppSizes.fontM,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
