import 'package:get/get.dart';
import '../../models/ad_model.dart';
import '../../models/category_model.dart';
import 'data/mock_data.dart';

/// Controller for managing the home screen state and data
/// 
/// This controller handles the main home screen functionality including:
/// - Category selection and filtering
/// - Product listing management
/// - Time formatting for post timestamps
/// 
/// The controller uses mock data for demonstration purposes but is structured
/// to easily integrate with real API calls.
/// 
/// Usage:
/// ```dart
/// final controller = Get.put(HomeController());
/// 
/// // Get categories
/// List<CategoryModel> categories = controller.categories;
/// 
/// // Change selected category
/// controller.changeCategory(2);
/// 
/// // Format time
/// String timeAgo = controller.getTimeAgo(DateTime.now());
/// ```
class HomeController extends GetxController {
  /// Currently selected category index for filtering products
  /// 
  /// Defaults to 0 (all categories). When changed, the UI can filter
  /// products based on the selected category.
  final RxInt selectedCategoryIndex = 0.obs;

  /// List of available categories for filtering
  /// 
  /// Returns mock data from [HomeMockData.categories]. In a production
  /// app, this would be populated from an API call.
  List<CategoryModel> get categories => HomeMockData.categories;

  /// List of products/ads to display
  /// 
  /// Returns mock data from [HomeMockData.products]. In a production
  /// app, this would be filtered based on the selected category and
  /// populated from API calls.
  List<AdModel> get products => HomeMockData.products;

  /// Changes the selected category index
  /// 
  /// Updates the [selectedCategoryIndex] to the provided [index].
  /// This can be used to filter products by category in the UI.
  /// 
  /// Parameters:
  /// - [index] The index of the category to select from [categories]
  /// 
  /// Example:
  /// ```dart
  /// controller.changeCategory(1); // Selects second category
  /// ```
  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  /// Formats a DateTime into a human-readable "time ago" string
  /// 
  /// Converts the provided [dateTime] into a relative time string
  /// such as "2h ago", "3d ago", or "Just now".
  /// 
  /// Parameters:
  /// - [dateTime] The DateTime to format
  /// 
  /// Returns:
  /// A string representing how long ago the [dateTime] was
  /// 
  /// Examples:
  /// ```dart
  /// controller.getTimeAgo(DateTime.now()); // "Just now"
  /// controller.getTimeAgo(DateTime.now().subtract(Duration(hours: 2))); // "2h ago"
  /// controller.getTimeAgo(DateTime.now().subtract(Duration(days: 10))); // "1w ago"
  /// ```
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}
