import 'package:get/get.dart';
import '../../models/ad/ad_models.dart';
import '../../models/user/user_models.dart';
import '../../utils/haptic_feedback.dart';
import 'mock_data.dart';

class ProfileController extends GetxController {
  /// Loading state for profile operations
  final RxBool isLoading = false.obs;

  /// Error state for profile operations
  final RxBool hasError = false.obs;

  /// Error message to display
  final RxString errorMessage = ''.obs;

  final Rx<UserModel> user = ProfileMockData.currentUser.obs;
  
  final RxInt selectedTabIndex = 0.obs;

  final String appVersion = 'Version 2.4.0';

  List<String> get tabs => ProfileMockData.tabs;
  
  List<AdModel> get items => ProfileMockData.userItems;

  String get memberSinceYear => user.value.createdAt.year.toString();

  /// Changes the selected tab index
  /// 
  /// Updates the [selectedTabIndex] to the provided [index].
  /// This is typically called when the user taps on a tab.
  /// 
  /// Parameters:
  /// - [index] The index of the tab to select
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  /// Navigates to the edit profile screen
  /// 
  /// This method would typically navigate to a profile editing screen
  /// where users can update their personal information.
  void editProfile() {
    // Navigate to edit profile screen
  }

  /// Logs out the current user
  /// 
  /// This method handles the logout process, including clearing
   /// user data and navigating to the login screen.
  Future<void> logout() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Simulate logout delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would clear user session and tokens
      await HapticFeedback.success();

      // Navigate to login screen
      Get.back();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Logout failed. Please try again.';
      await HapticFeedback.error();
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads user profile data
  /// 
  /// Simulates loading profile data with loading and error states.
  /// In a real app, this would fetch user data from an API.
  Future<void> loadProfileData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would fetch user data from an API
      await HapticFeedback.success();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load profile. Please try again.';
      await HapticFeedback.error();
    } finally {
      isLoading.value = false;
    }
  }

  /// Retries loading profile data
  /// 
  /// Clears error state and loads profile data again.
  Future<void> retryLoadProfile() async {
    await loadProfileData();
  }
}
