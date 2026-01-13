import 'package:get/get.dart';
import 'auth/auth_controller.dart';

/// Controller for managing bottom navigation bar state
/// 
/// This controller handles the navigation between different sections
/// of the app using a bottom navigation bar. It maintains the currently
/// selected tab index and provides methods to change the selection.
/// 
/// Usage:
/// ```dart
/// final controller = Get.put(NavigationController());
/// 
/// // Get current index
/// int currentIndex = controller.selectedIndex.value;
/// 
/// // Change selected tab
/// controller.changeIndex(2);
/// ```
class NavigationController extends GetxController {
  /// Currently selected bottom navigation tab index
  /// 
  /// Defaults to 0 (first tab). Use [changeIndex] to update this value.
  /// The UI should listen to this reactive value to update the navigation bar.
  final RxInt selectedIndex = 0.obs;

  /// Changes the selected bottom navigation tab
  /// 
  /// Updates the [selectedIndex] to the provided [index].
  /// This will automatically notify any UI components listening to the
  /// [selectedIndex] value.
  /// 
  /// If attempting to access the post ad screen (index 2) without being logged in,
  /// redirects to the guest profile screen instead.
  /// 
  /// Parameters:
  /// - [index] The index of the tab to select (0-based)
  /// 
  /// Example:
  /// ```dart
  /// controller.changeIndex(1); // Selects second tab
  /// ```
  void changeIndex(int index) {
    final authController = Get.find<AuthController>();
    
    // Protected routes: Post Ad (2), Chat (3), Profile (4)
    if ((index == 2 || index == 3 || index == 4)) {
      if (authController.isCheckingAuth.value) {
        // Still checking auth status, don't navigate yet
        Get.snackbar(
          'Checking...',
          'Verifying authentication status',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
        return;
      }
      
      if (!authController.isLoggedIn.value) {
        Get.snackbar(
          'Authentication Required',
          'Please log in to access this feature',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed('/login');
        return;
      }
    }
    
    selectedIndex.value = index;
  }
}
