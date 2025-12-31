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
  void logout() {
    // Implement logout logic
  }
}
