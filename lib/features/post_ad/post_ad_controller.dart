import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
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
  final RxList<File> images = <File>[].obs;
  final RxList<String> imageUrls = <String>[...PostAdMockData.mockImages].obs;
  final RxBool useCurrentLocation = true.obs;
  final RxBool isCompressing = false.obs;
  final RxBool isPickingLocation = false.obs;
  final RxBool hasDraft = false.obs;
  final RxString draftSavedTime = ''.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxString selectedAddress = ''.obs;
  final RxBool showPreview = false.obs;

  final ImagePicker _picker = ImagePicker();
  final GetStorage _storage = GetStorage();
  Timer? _draftTimer;
  static const String _draftKey = 'ad_draft';

  List<String> get categories => PostAdMockData.categories;

  List<String> get conditions => PostAdMockData.conditions;

  @override
  void onInit() {
    super.onInit();
    _loadDraft();
    _startDraftAutoSave();
  }

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    _draftTimer?.cancel();
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

  /// Gets the current device location
  /// 
  /// Requests location permissions and retrieves the current position.
  /// Updates [currentPosition] and [selectedAddress] with the location data.
  Future<void> getCurrentLocation() async {
    try {
      isPickingLocation.value = true;
      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Disabled',
          'Please enable location services',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.warning,
          colorText: Colors.white,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permissions are denied',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.warning,
            colorText: Colors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied',
          'Location permissions are permanently denied',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      
      currentPosition.value = position;
      
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        selectedAddress.value = '${place.locality}, ${place.administrativeArea}';
        locationController.text = selectedAddress.value;
      }
      
      await HapticFeedback.success();
    } catch (e) {
      await HapticFeedback.error();
      Get.snackbar(
        'Error',
        'Failed to get location',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isPickingLocation.value = false;
    }
  }

  /// Updates the location preference
  /// 
  /// Sets the [useCurrentLocation] to the provided [value].
  /// If true, automatically gets the current location.
  /// 
  /// Parameters:
  /// - [value] True to use current location, false for manual location entry
  void updateLocationPreference(bool value) {
    useCurrentLocation.value = value;
    if (value) {
      getCurrentLocation();
    }
  }

  /// Picks images from gallery or camera
  /// 
  /// Opens image picker to select photos from gallery or camera.
  /// Supports multiple image selection up to 10 images.
  /// Images are automatically compressed after selection.
  /// 
  /// Parameters:
  /// - [source] ImageSource to pick from (gallery or camera)
  Future<void> pickImages(ImageSource source) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFiles.isNotEmpty) {
        isCompressing.value = true;
        
        for (var file in pickedFiles) {
          if (images.length >= 10) break;
          
          final compressedFile = await _compressImage(File(file.path));
          if (compressedFile != null) {
            images.add(compressedFile);
          }
        }
        
        isCompressing.value = false;
        await HapticFeedback.success();
      }
    } catch (e) {
      isCompressing.value = false;
      await HapticFeedback.error();
      Get.snackbar(
        'Error',
        'Failed to pick images',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  /// Compresses an image file
  /// 
  /// Compresses the image to reduce file size while maintaining quality.
  /// 
  /// Parameters:
  /// - [file] The image file to compress
  /// 
  /// Returns:
  /// - Compressed File or null if compression fails
  Future<File?> _compressImage(File file) async {
    try {
      final dir = await Directory.systemTemp.createTemp();
      final targetPath = '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        minWidth: 800,
        minHeight: 600,
        format: CompressFormat.jpeg,
      );

      if (result == null) return null;
      return File(result.path);
    } catch (e) {
      return null;
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

  /// Reorders photos in the images list
  /// 
  /// Moves a photo from [oldIndex] to [newIndex].
  /// 
  /// Parameters:
  /// - [oldIndex] The current index of the photo
  /// - [newIndex] The new index for the photo
  void reorderPhotos(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = images.removeAt(oldIndex);
    images.insert(newIndex, item);
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
    imageUrls.clear();
    currentPosition.value = null;
    selectedAddress.value = '';
    hasDraft.value = false;
    draftSavedTime.value = '';
    _storage.remove(_draftKey);
  }

  /// Saves the current form data as a draft
  /// 
  /// Stores form data, images, and selections locally for later recovery.
  /// Updates [hasDraft] and [draftSavedTime] to indicate draft status.
  Future<void> saveDraft() async {
    try {
      final draftData = {
        'title': titleController.text,
        'price': priceController.text,
        'description': descriptionController.text,
        'location': locationController.text,
        'category': selectedCategory.value,
        'condition': selectedCondition.value,
        'useCurrentLocation': useCurrentLocation.value,
        'images': images.map((file) => file.path).toList(),
        'savedTime': DateTime.now().toIso8601String(),
      };
      
      await _storage.write(_draftKey, draftData);
      hasDraft.value = true;
      draftSavedTime.value = 'Draft saved at ${_formatTime(DateTime.now())}';
    } catch (e) {
      // Silent fail for draft saving
    }
  }

  /// Loads the saved draft data
  /// 
  /// Restores form data, images, and selections from the saved draft.
  /// Updates [hasDraft] if a draft exists.
  Future<void> _loadDraft() async {
    try {
      final draftData = _storage.read(_draftKey);
      if (draftData != null) {
        titleController.text = draftData['title'] ?? '';
        priceController.text = draftData['price'] ?? '';
        descriptionController.text = draftData['description'] ?? '';
        locationController.text = draftData['location'] ?? PostAdMockData.defaultLocation;
        selectedCategory.value = draftData['category'];
        selectedCondition.value = draftData['condition'] ?? 'New';
        useCurrentLocation.value = draftData['useCurrentLocation'] ?? true;
        
        final imagePaths = List<String>.from(draftData['images'] ?? []);
        images.clear();
        for (var path in imagePaths) {
          final file = File(path);
          if (await file.exists()) {
            images.add(file);
          }
        }
        
        hasDraft.value = true;
        draftSavedTime.value = 'Draft saved at ${_formatTime(DateTime.parse(draftData['savedTime']))}';
      }
    } catch (e) {
      // Silent fail for draft loading
    }
  }

  /// Starts automatic draft saving
  /// 
  /// Sets up a timer to save the draft every 30 seconds.
  void _startDraftAutoSave() {
    _draftTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      saveDraft();
    });
  }

  /// Formats time for display
  /// 
  /// Parameters:
  /// - [time] The DateTime to format
  /// 
  /// Returns:
  /// - Formatted time string (e.g., "2:30 PM")
  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Shows the ad preview
  /// 
  /// Validates the form and shows preview if valid.
  /// 
  /// Returns:
  /// - True if preview can be shown, false otherwise
  bool showAdPreview() {
    if (formKey.currentState?.validate() ?? false) {
      showPreview.value = true;
      return true;
    }
    return false;
  }

  /// Hides the ad preview
  void hideAdPreview() {
    showPreview.value = false;
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

        // Clear draft after successful post
        await _storage.remove(_draftKey);
        hasDraft.value = false;
        draftSavedTime.value = '';

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
