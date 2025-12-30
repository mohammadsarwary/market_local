import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import 'data/mock_data.dart';

class PostAdController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController(text: PostAdMockData.defaultLocation);

  final Rx<String?> selectedCategory = Rx<String?>(null);
  final RxString selectedCondition = 'New'.obs;
  final RxList<String> images = <String>[...PostAdMockData.mockImages].obs;

  List<String> get categories => PostAdMockData.categories;

  List<String> get conditions => PostAdMockData.conditions;

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void updateCategory(String? value) {
    selectedCategory.value = value;
  }

  void updateCondition(String value) {
    selectedCondition.value = value;
  }

  void addPhoto() {
    // In a real app, use image_picker
    if (images.length < 10) {
      // Mock adding a photo
      images.add('https://images.unsplash.com/photo-1495121605193-b116b5b9c5fe?auto=format&fit=crop&q=80&w=500');
    }
  }

  void removePhoto(int index) {
    images.removeAt(index);
  }

  void resetForm() {
    formKey.currentState?.reset();
    titleController.clear();
    priceController.clear();
    descriptionController.clear();
    locationController.text = PostAdMockData.defaultLocation;
    selectedCategory.value = null;
    selectedCondition.value = 'New';
    images.clear();
  }

  void postAd() {
    if (formKey.currentState?.validate() ?? false) {
      Get.snackbar(
        'Success',
        'Ad published successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
