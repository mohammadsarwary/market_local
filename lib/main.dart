import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/api_service.dart';
import 'utils/theme.dart';
import 'core/error/error_handler.dart';
import 'core/error/error_boundary_widget.dart';
import 'core/error/error_controller.dart';
import 'services/loading_service.dart';
import 'views/home/home_view.dart';
import 'views/search/search_view.dart';
import 'views/product/product_view.dart';
import 'views/chat/chat_view.dart';
import 'views/profile/profile_view.dart';
import 'views/profile/my_published_ads_view.dart';
import 'views/auth/login_view.dart';
import 'views/splash/splash_view.dart';
import 'bindings/main_binding.dart';
import 'controllers/navigation_controller.dart';

/// Custom page transition for smooth navigation
class FadeInTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curve ?? Curves.easeInOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.05),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve ?? Curves.easeInOut,
        )),
        child: child,
      ),
    );
  }
}

/// Entry point for the MarketLocal Flutter application
/// 
/// This file initializes the app and sets up global services including:
/// - API client and services
/// - Error handling and boundaries
/// - Loading state management
/// - Navigation controller
/// - Theme configuration
/// 
/// The app uses GetX for state management and dependency injection.
/// 
/// Architecture:
/// - Error boundaries wrap individual screens for error isolation
/// - Global controllers handle cross-cutting concerns
/// - Main binding sets up feature-specific dependencies
/// 
/// Run the app with: flutter run
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // Initialize API service first before any controllers
  ApiService.instance.initialize();
  
  // Initialize global error handling
  // This sets up error handlers for Flutter framework and platform errors
  AppErrorHandler.initialize();
  
  // Initialize global controllers
  // These controllers manage app-wide state and services
  Get.put(ErrorController()); // Handles global error state and recovery
  Get.put(LoadingController()); // Manages global loading states
  
  // Start the application
  runApp(const MyApp());
}

/// Root widget of the MarketLocal application
/// 
/// This widget sets up the application with:
/// - Error boundary for global error handling
/// - Material app with GetX navigation
/// - App theme configuration
/// - Initial binding for dependency injection
/// 
/// The app structure uses a main screen with bottom navigation
/// and individual screens wrapped in error boundaries for isolation.
class MyApp extends StatelessWidget {
  /// Creates the root application widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the entire app in an error boundary to catch and handle
    // any unhandled errors at the application level
    return ErrorBoundary(
      boundaryName: 'Main App',
      child: GetMaterialApp(
        title: 'MarketLocal',
        theme: AppTheme.lightTheme,
        initialBinding: MainBinding(),
        home: const SplashView(),
        debugShowCheckedModeBanner: false,
        transitionDuration: const Duration(milliseconds: 300),
        defaultTransition: Transition.fadeIn,
        customTransition: FadeInTransition(),
        getPages: [
          GetPage(name: '/login', page: () => const LoginView()),
          // Add MyPublishedAds route to GetX routing (not GoRouter)
          GetPage(name: '/myPublishedAds', page: () => const MyPublishedAdsView()),
        ],
      ),
    );
  }
}

/// Main screen with bottom navigation bar
/// 
/// This widget provides the primary navigation structure for the app.
/// It consists of:
/// - A bottom navigation bar for switching between main sections
/// - Individual screens wrapped in error boundaries for isolation
/// - Reactive navigation using GetX controller
/// 
/// The screens include:
/// - Home: Browse listings and categories
/// - Search: Advanced search and filtering
/// - Post Ad: Create new listings
/// - Chat: Messaging and communication
/// - Profile: User account and settings
/// 
/// Each screen is wrapped in an ErrorBoundary to prevent errors
/// in one screen from affecting the entire app.
class MainScreen extends StatelessWidget {
  /// Creates the main screen with bottom navigation
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the navigation controller to manage tab selection
    final controller = Get.find<NavigationController>();
    
    // Define all main screens of the application
    // Each screen is wrapped in an ErrorBoundary for error isolation
    final List<Widget> screens = [
      const ErrorBoundary(
        boundaryName: 'Home Screen',
        child: HomeView(),
      ),
      const ErrorBoundary(
        boundaryName: 'Search Screen',
        child: SearchView(),
      ),
      const ErrorBoundary(
        boundaryName: 'Post Ad Screen',
        child: ProductView(),
      ),
      const ErrorBoundary(
        boundaryName: 'Chat Screen',
        child: ChatView(),
      ),
      const ErrorBoundary(
        boundaryName: 'Profile Screen',
        child: ProfileView(),
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
