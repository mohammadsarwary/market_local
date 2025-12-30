import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PostAdProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const PostAdProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: Colors.white,
      child: Row(
        children: List.generate(
          totalSteps,
          (index) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: index < currentStep ? AppColors.primary : Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
