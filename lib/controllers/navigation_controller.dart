import 'package:get/get.dart';

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
  /// Parameters:
  /// - [index] The index of the tab to select (0-based)
  /// 
  /// Example:
  /// ```dart
  /// controller.changeIndex(1); // Selects second tab
  /// ```
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
