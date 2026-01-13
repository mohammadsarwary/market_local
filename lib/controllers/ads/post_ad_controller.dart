import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
import '../../utils/colors.dart';
import '../../utils/haptic_feedback.dart';
import '../../repositories/ad/ad_repository.dart';
import '../../models/category/category_models.dart';
import '../../repositories/category/category_repository.dart';
import 'mock_data.dart';

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
  final Rx<String?> selectedCategoryId = Rx<String?>(null);
  final RxString selectedCondition = 'new'.obs;
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
  final RxBool validatedBeforePreview = false.obs;

  final ImagePicker _picker = ImagePicker();
  final GetStorage _storage = GetStorage();
  late final AdRepository _adRepository;
  late final CategoryRepository _categoryRepository;
  Timer? _draftTimer;
  static const String _draftKey = 'ad_draft';

  final RxList<Category> remoteCategories = <Category>[].obs;
  final RxBool isCategoryLoading = false.obs;
  final RxString categoryLoadError = ''.obs;

  List<String> get categoryOptions {
    if (remoteCategories.isNotEmpty) {
      return remoteCategories.map((c) => c.name).toList();
    }
    return PostAdMockData.categories;
  }

  List<String> get conditions => PostAdMockData.conditions;

  @override
  void onInit() {
    super.onInit();
    _adRepository = Get.find<AdRepository>();
    _categoryRepository = Get.find<CategoryRepository>();
    _loadCategories();
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
    // Find and store the category ID
    if (value != null) {
      final category = remoteCategories.firstWhere(
        (c) => c.name == value,
        orElse: () => Category(
          id: '1',
          name: value,
          adCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      selectedCategoryId.value = category.id;
    } else {
      selectedCategoryId.value = null;
    }
  }

  Future<void> _loadCategories() async {
    try {
      isCategoryLoading.value = true;
      categoryLoadError.value = '';

      final cached = await _categoryRepository.getCachedCategories();
      if (cached != null && cached.isNotEmpty) {
        remoteCategories.assignAll(cached);
      }

      final response = await _categoryRepository.getCategoriesWithFallback();
      remoteCategories
        ..clear()
        ..addAll(response.categories);
        print('Post ads controller $response');
    } catch (e) {
      if (remoteCategories.isEmpty) {
        categoryLoadError.value = 'Unable to load latest categories. Showing defaults.';
      }
    } finally {
      isCategoryLoading.value = false;
    }
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
    selectedCategoryId.value = null;
    selectedCondition.value = 'new';
    images.clear();
    imageUrls.clear();
    currentPosition.value = null;
    selectedAddress.value = '';
    hasDraft.value = false;
    draftSavedTime.value = '';
    validatedBeforePreview.value = false;
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
        'categoryId': selectedCategoryId.value,
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
        selectedCategoryId.value = draftData['categoryId'];
        selectedCondition.value = draftData['condition'] ?? 'new';
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
    print('PostAdController: showAdPreview() called');
    if (formKey.currentState?.validate() ?? false) {
      validatedBeforePreview.value = true;
      showPreview.value = true;
      print('PostAdController: Form validated, showing preview');
      return true;
    }
    print('PostAdController: Form validation failed, not showing preview');
    return false;
  }

  /// Hides the ad preview
  ///
  /// Sets the preview visibility to false to return to the form.
  void hideAdPreview() {
    showPreview.value = false;
    validatedBeforePreview.value = false;
  }

  /// Posts the ad after validation
  /// 
  /// Validates the form and sends ad data to the backend API.
  /// Creates the ad first, then uploads images separately.
  Future<void> postAd() async {
    print('PostAdController: postAd() called');
    print('PostAdController: Form key state: ${formKey.currentState}');
    print('PostAdController: Title: "${titleController.text}"');
    print('PostAdController: Price: "${priceController.text}"');
    print('PostAdController: Description: "${descriptionController.text}"');
    print('PostAdController: Category ID: ${selectedCategoryId.value}');
    print('PostAdController: Condition: ${selectedCondition.value}');
    print('PostAdController: Images count: ${images.length}');
    print('PostAdController: Location: "${locationController.text}"');
    print('PostAdController: Use current location: ${useCurrentLocation.value}');
    print('PostAdController: Current position: ${currentPosition.value}');

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('PostAdController: Validating form...');
      // Skip form validation if already validated before showing preview
      // (Form widget is unmounted when preview is shown, so formKey.currentState would be null)
      final isValid = validatedBeforePreview.value || (formKey.currentState?.validate() ?? false);
      print('PostAdController: Form validation result: $isValid (validatedBeforePreview: ${validatedBeforePreview.value})');

      if (isValid) {
        print('PostAdController: Form validation passed');

        // Validate required fields
        if (selectedCategoryId.value == null) {
          print('PostAdController: No category selected');
          hasError.value = true;
          errorMessage.value = 'Please select a category';
          await HapticFeedback.error();
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
          return;
        }

        if (images.isEmpty) {
          print('PostAdController: No images added');
          hasError.value = true;
          errorMessage.value = 'Please add at least one image';
          await HapticFeedback.error();
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
          return;
        }

        // Get location coordinates
        double latitude = 0.0;
        double longitude = 0.0;

        if (useCurrentLocation.value && currentPosition.value != null) {
          latitude = currentPosition.value!.latitude;
          longitude = currentPosition.value!.longitude;
          print('PostAdController: Using current location: $latitude, $longitude');
        } else {
          // Use default coordinates if location not available
          latitude = 35.6892; // Default: Tehran
          longitude = 51.3890;
          print('PostAdController: Using default location: $latitude, $longitude');
        }

        print('PostAdController: Preparing API request...');
        print('PostAdController: API Request Params:');
        print('  - Title: "${titleController.text.trim()}"');
        print('  - Description: "${descriptionController.text.trim()}"');
        print('  - Category ID: ${selectedCategoryId.value!}');
        print('  - Price: ${double.parse(priceController.text.trim())}');
        print('  - Location: "${locationController.text.trim()}"');
        print('  - Latitude: $latitude');
        print('  - Longitude: $longitude');
        print('  - Image paths: ${images.map((file) => file.path).toList()}');
        print('  - Custom fields: {"condition": "${selectedCondition.value}"}');

        print('PostAdController: Calling AdService.createAd()...');
        // Create the ad
        final response = await _adRepository.createAdWithDetails(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          categoryId: selectedCategoryId.value!,
          price: double.parse(priceController.text.trim()),
          location: locationController.text.trim(),
          latitude: latitude,
          longitude: longitude,
          imagePaths: images.map((file) => file.path).toList(),
          customFields: {
            'condition': selectedCondition.value.toLowerCase(),
          },
        );
        print('PostAdController: Ad created successfully with ID: ${response.ad.id}');
        print('PostAdController: API Response: ${response.message}');

        // Upload images to the created ad
        if (images.isNotEmpty) {
          try {
            print('PostAdController: Uploading ${images.length} images...');
            final imageResponse = await _adRepository.uploadAdImages(
              response.ad.id,
              images.map((file) => file.path).toList(),
            );
            print('PostAdController: Images uploaded successfully');
          } catch (imageError) {
            // Log image upload error but don't fail the entire post
            print('PostAdController: Image upload failed: $imageError');
          }
        }

        await HapticFeedback.success();

        // Clear draft after successful post
        await _storage.remove(_draftKey);
        hasDraft.value = false;
        draftSavedTime.value = '';

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );

        // Navigate back to home
        print('PostAdController: Navigating to home...');
        Get.offAllNamed('/');
      } else {
        print('PostAdController: Form validation failed - checking individual fields...');
        print('PostAdController: Title empty: ${titleController.text.trim().isEmpty}');
        print('PostAdController: Price empty: ${priceController.text.trim().isEmpty}');
        print('PostAdController: Description empty: ${descriptionController.text.trim().isEmpty}');
        print('PostAdController: Category ID null: ${selectedCategoryId.value == null}');
        print('PostAdController: Images empty: ${images.isEmpty}');
      }
    } catch (e, stackTrace) {
      print('PostAdController: Error posting ad: $e');
      print('PostAdController: Error type: ${e.runtimeType}');
      print('PostAdController: Stack trace: $stackTrace');
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = 'Failed to post ad: ${e.toString()}';

      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print('PostAdController: postAd() completed');
    }
  }
}