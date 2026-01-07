import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/ads/home_controller.dart';
import '../controllers/ads/search_controller.dart';
import '../controllers/ads/chat_controller.dart';
import '../controllers/ads/post_ad_controller.dart';
import '../controllers/profile/profile_controller.dart';
import '../controllers/auth/auth_controller.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../core/api/api_service.dart';
import '../core/repositories/local_data_source_impl.dart';
import '../repositories/ad/ad_repository.dart';
import '../repositories/ad/ad_repository_impl.dart';
import '../repositories/auth/auth_repository.dart';
import '../repositories/auth/auth_repository_impl.dart';
import '../repositories/category/category_repository.dart';
import '../repositories/category/category_repository_impl.dart';
import '../repositories/user/user_repository.dart';
import '../repositories/user/user_repository_impl.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Infrastructure services
    Get.lazyPut(() => ApiService(), fenix: true);
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
    Get.lazyPut(() => LocalDataSourceImpl(), fenix: true);

    // Repositories
    Get.lazyPut<AdRepository>(() => AdRepositoryImpl(
      apiClient: ApiService.instance.apiClient,
      localDataSource: Get.find<LocalDataSourceImpl>(),
    ), fenix: true);

    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
      apiClient: ApiService.instance.apiClient,
    ), fenix: true);

    Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(
      apiClient: ApiService.instance.apiClient,
      localDataSource: Get.find<LocalDataSourceImpl>(),
    ), fenix: true);

    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(
      apiClient: ApiService.instance.apiClient,
      localDataSource: Get.find<LocalDataSourceImpl>(),
    ), fenix: true);

    // Controllers
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchController>(() => SearchController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<PostAdController>(() => PostAdController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<AuthFlowService>(() => AuthFlowService(), fenix: true);
  }
}
