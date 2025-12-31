import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_feedback.dart';
import 'data/mock_data.dart';

class PostAdController extends GetxController {
  /// Loading state for ad posting operations
  final RxBool isLoading = false.obs;

  /// Error state for ad posting operations
  final RxBool hasError = false.obs;

  /// Error message to display
  final RxString errorMessage = ''.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController(text: PostAdMockData.defaultLocation);

  final Rx<String?> selectedCategory = Rx<String?>(null);
  final RxString selectedCondition = 'New'.obs;
  final RxList<String> images = <String>[...PostAdMockData.mockImages].obs;
  final RxBool useCurrentLocation = true.obs;

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

  /// Updates the selected category
  /// 
  /// Sets the [selectedCategory] to the provided [value].
  /// This is typically called when the user selects a category from the dropdown.
  /// 
  /// Parameters:
  /// - [value] The category name to select, or null to clear selection
  void updateCategory(String? value) {
    selectedCategory.value = value;
  }

  /// Updates the selected item condition
  /// 
  /// Sets the [selectedCondition] to the provided [value].
  /// This is typically called when the user selects a condition option.
  /// 
  /// Parameters:
  /// - [value] The condition string to select (e.g., 'New', 'Like New', 'Used')
  void updateCondition(String value) {
    selectedCondition.value = value;
  }

  /// Updates the location preference
  /// 
  /// Sets the [useCurrentLocation] to the provided [value].
  /// This determines whether to use the device's current location.
  /// 
  /// Parameters:
  /// - [value] True to use current location, false for manual location entry
  void updateLocationPreference(bool value) {
    useCurrentLocation.value = value;
  }

  /// Adds a photo to the images list
  /// 
  /// Adds a new photo URL to the [images] list if the maximum limit
  /// of 10 photos hasn't been reached. In a real app, this would use
  /// the image_picker package to select photos from the device.
  void addPhoto() {
    // In a real app, use image_picker
    if (images.length < 10) {
      // Mock adding a photo
      images.add('https://images.unsplash.com/photo-1495121605193-b116b5b9c5fe?auto=format&fit=crop&q=80&w=500');
    }
  }

  /// Removes a photo from the images list
  /// 
  /// Removes the photo at the specified [index] from the [images] list.
  /// 
  /// Parameters:
  /// - [index] The index of the photo to remove
  void removePhoto(int index) {
    images.removeAt(index);
  }

  /// Resets the form to its initial state
  /// 
  /// Clears all form fields, resets selections, and clears the images list.
  /// This is typically called to start over with a new ad posting.
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

  /// Posts the ad after validation
  /// 
  /// Validates the form and shows a success message if valid.
  /// In a real app, this would send the ad data to the backend API.
  Future<void> postAd() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      if (formKey.currentState?.validate() ?? false) {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 2));

        // In a real app, this would send ad data to an API
        await HapticFeedback.success();

        Get.snackbar(
          'Success',
          'Ad published successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to publish ad. Please try again.';
      await HapticFeedback.error();

      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Retries posting the ad
  /// 
  /// Clears error state and attempts to post the ad again.
  Future<void> retryPostAd() async {
    await postAd();
  }
}
