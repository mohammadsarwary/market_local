import 'package:get/get.dart';
import '../../models/ad_model.dart';
import '../../models/user_model.dart';
import 'data/mock_data.dart';

class ProfileController extends GetxController {
  final Rx<UserModel> user = ProfileMockData.currentUser.obs;
  
  final RxInt selectedTabIndex = 0.obs;

  final String appVersion = 'Version 2.4.0';

  List<String> get tabs => ProfileMockData.tabs;
  
  List<AdModel> get items => ProfileMockData.userItems;

  String get memberSinceYear => user.value.createdAt.year.toString();

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void editProfile() {
    // Navigate to edit profile screen
  }

  void logout() {
    // Implement logout logic
  }
}
