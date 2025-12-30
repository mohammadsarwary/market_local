import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/error/error_handler.dart';
import 'core/error/error_boundary_widget.dart';
import 'core/error/error_controller.dart';
import 'core/loading/loading_controller.dart';
import 'features/home/home_screen.dart';
import 'features/search/search_screen.dart';
import 'features/post_ad/post_ad_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/profile/profile_screen.dart';
import 'bindings/main_binding.dart';
import 'controllers/navigation_controller.dart';

void main() {
  // Initialize global error handling
  AppErrorHandler.initialize();
  
  // Initialize controllers
  Get.put(ErrorController());
  Get.put(LoadingController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      boundaryName: 'Main App',
      child: GetMaterialApp(
        title: 'MarketLocal',
        theme: AppTheme.lightTheme,
        initialBinding: MainBinding(),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();
    
    final List<Widget> screens = [
      const ErrorBoundary(
        boundaryName: 'Home Screen',
        child: HomeScreen(),
      ),
      const ErrorBoundary(
        boundaryName: 'Search Screen',
        child: SearchScreen(),
      ),
      const ErrorBoundary(
        boundaryName: 'Post Ad Screen',
        child: PostAdScreen(),
      ),
      const ErrorBoundary(
        boundaryName: 'Chat Screen',
        child: ChatScreen(),
      ),
      const ErrorBoundary(
        boundaryName: 'Profile Screen',
        child: ProfileScreen(),
      ),
    ];

    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changeIndex,
          backgroundColor: Colors.white,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              selectedIcon: Icon(Icons.add_circle),
              label: 'Sell',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
