import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/search/search_screen.dart';
import '../features/post_ad/post_ad_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/otp_verification_screen.dart';
import '../features/auth/forgot_password_screen.dart';

/// App-wide route configuration using GoRouter
/// All navigation routes should be defined here
class AppRouter {
  AppRouter._();

  // Route names
  static const String home = '/';
  static const String search = '/search';
  static const String postAd = '/post-ad';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String adDetails = '/ad/:id';
  static const String chatDetail = '/chat/:id';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  
  // Auth routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOTP = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      // Authentication routes (outside shell)
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: verifyOTP,
        name: 'verifyOTP',
        builder: (context, state) => const OTPVerificationScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // Main shell route with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Home branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Search branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: search,
                name: 'search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          // Post Ad branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: postAd,
                name: 'postAd',
                builder: (context, state) => const PostAdScreen(),
              ),
            ],
          ),
          // Chat branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: chat,
                name: 'chat',
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          // Profile branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}

/// Main shell widget with bottom navigation bar
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
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
    );
  }
}
