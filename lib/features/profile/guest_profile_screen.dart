import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';

/// Guest profile screen shown when user is not logged in
class GuestProfileScreen extends StatelessWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSizes.paddingXL),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.paddingXL,
                  horizontal: AppSizes.paddingL,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag,
                          size: 120.0,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingXL),
              const Text(
                'Join the Community',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingM),
              const Text(
                'Buy, sell, and chat with locals. Sign up now to start selling your items or finding great deals nearby.',
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingXL),
              _buildFeatureCard(
                icon: Icons.shopping_bag,
                title: 'Sell in seconds',
                description: 'List your items easily with a few taps',
              ),
              const SizedBox(height: AppSizes.paddingM),
              _buildFeatureCard(
                icon: Icons.chat_bubble,
                title: 'Chat instantly',
                description: 'Connect with buyers and sellers directly',
              ),
              const SizedBox(height: AppSizes.paddingXL),
              SizedBox(
                width: double.infinity,
                height: 56.0,
                child: ElevatedButton(
                  onPressed: () => Get.to(const SignupScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: AppSizes.fontXL,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              SizedBox(
                width: double.infinity,
                height: 56.0,
                child: OutlinedButton(
                  onPressed: () => Get.to(const LoginScreen()),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: AppSizes.fontXL,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.paddingXL),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: AppSizes.fontS,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: AppSizes.fontS,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: AppSizes.fontS,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24.0,
            ),
          ),
          const SizedBox(width: AppSizes.paddingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppSizes.fontL,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: AppSizes.fontM,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
