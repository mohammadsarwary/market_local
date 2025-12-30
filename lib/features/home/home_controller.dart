import 'package:get/get.dart';
import '../../models/ad_model.dart';
import '../../models/category_model.dart';
import 'data/mock_data.dart';

class HomeController extends GetxController {
  final RxInt selectedCategoryIndex = 0.obs;

  List<CategoryModel> get categories => HomeMockData.categories;

  List<AdModel> get products => HomeMockData.products;

  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
  }

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
