import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/common_buttons.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: const Offset(0.0, 0.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AppOutlinedButton(
                text: 'Call',
                onPressed: () {},
                icon: Icons.call,
                height: 56,
                borderColor: const Color(0xFFE53935),
                textColor: const Color(0xFFE53935),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppButton(
                text: 'Message',
                onPressed: () {
                  Get.snackbar(
                    'Message Sent',
                    'Your message has been sent to the seller',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.primary,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                  );
                },
                icon: Icons.message,
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
