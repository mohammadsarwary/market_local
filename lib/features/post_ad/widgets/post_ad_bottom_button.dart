import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common_buttons.dart';
import '../post_ad_controller.dart';

class PostAdBottomButton extends StatelessWidget {
  const PostAdBottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostAdController>();

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 10,
        top: 10,
      ),
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
      child: AppButton(
        text: 'Preview Ad',
        onPressed: () => controller.showAdPreview(),
        icon: Icons.visibility,
        height: 56,
      ),
    );
  }
}
