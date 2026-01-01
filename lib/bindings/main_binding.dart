import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../features/home/home_controller.dart';
import '../features/search/search_controller.dart';
import '../features/chat/chat_controller.dart';
import '../features/post_ad/post_ad_controller.dart';
import '../features/profile/profile_controller.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/auth_flow_service.dart';
import '../core/services/storage_service.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchController>(() => SearchController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<PostAdController>(() => PostAdController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<AuthFlowService>(() => AuthFlowService(), fenix: true);
  }
}
