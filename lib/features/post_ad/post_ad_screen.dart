import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/photo_section.dart';
import 'widgets/item_details_section.dart';
import 'widgets/location_section.dart';
import 'widgets/progress_bar.dart';
import 'widgets/post_ad_bottom_button.dart';
import 'post_ad_controller.dart';

class PostAdScreen extends GetView<PostAdController> {
  const PostAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Post New Ad',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[100], height: 1),
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          PostAdProgressBar(currentStep: 1, totalSteps: 3),
          
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
                      child: PhotoSection(),
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
                      child: ItemDetailsSection(),
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
                      child: LocationSection(),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PostAdBottomButton(),
    );
  }
}
