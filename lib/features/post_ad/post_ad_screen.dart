import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/photo_section.dart';
import 'widgets/item_details_section.dart';
import 'widgets/location_section.dart';
import 'widgets/progress_bar.dart';
import 'widgets/post_ad_bottom_button.dart';
import 'widgets/ad_preview_screen.dart';
import 'post_ad_controller.dart';

class PostAdScreen extends GetView<PostAdController> {
  const PostAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostAdController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => _showCloseDialog(controller),
        ),
        title: const Text(
          'Post New Ad',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Obx(() {
            if (controller.hasDraft.value) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    controller.draftSavedTime.value,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[100], height: 1),
        ),
      ),
      body: Obx(() {
        if (controller.showPreview.value) {
          return const AdPreviewScreen();
        }
        return Column(
          children: [
            // Progress Bar
            const PostAdProgressBar(currentStep: 1, totalSteps: 3),
            
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photos Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const PhotoSection(),
                      ),
                      
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 8,
                        color: Colors.grey[100],
                      ),
                      const SizedBox(height: 32),

                      // Item Details Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const ItemDetailsSection(),
                      ),
                      
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 8,
                        color: Colors.grey[100],
                      ),
                      const SizedBox(height: 32),

                      // Location Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const LocationSection(),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.showPreview.value) {
          return const SizedBox.shrink();
        }
        return const PostAdBottomButton();
      }),
    );
  }

  void _showCloseDialog(PostAdController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Discraft Ad?'),
        content: const Text('You have unsaved changes. Are you sure you want to close?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.resetForm();
              Get.back();
            },
            child: const Text('Discraft', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.saveDraft().then((_) {
                Get.back();
              });
            },
            child: const Text('Save Draft'),
          ),
        ],
      ),
    );
  }
}
