# MarketLocal Flutter Documentation

## Overview

MarketLocal is a Flutter marketplace application built with GetX for state management. This document provides comprehensive documentation for developers working on the project.

## Architecture

### Project Structure

```
lib/
├── core/                   # Core application utilities
│   ├── constants/         # App-wide constants (colors, sizes, texts)
│   ├── error/             # Error handling system
│   ├── loading/           # Loading state management
│   ├── theme/             # App theming
│   ├── utils/             # Utility functions
│   └── widgets/           # Reusable UI components
├── features/              # Feature modules
│   ├── home/             # Home screen and related components
│   ├── search/           # Search functionality
│   ├── post_ad/          # Ad posting workflow
│   ├── chat/             # Messaging system
│   └── profile/          # User profile management
├── models/                # Data models
├── controllers/           # Global controllers
├── bindings/             # Dependency injection bindings
└── main.dart             # App entry point
```

### Key Architectural Patterns

1. **Feature-Based Structure**: Each feature is organized in its own directory
2. **GetX State Management**: Reactive state management with GetX
3. **Error Boundaries**: Isolated error handling per screen
4. **Dependency Injection**: GetX binding system for DI
5. **Common Widgets**: Reusable UI components in core/widgets

## Core Components

### Error Handling System

The app uses a comprehensive error handling system:

- **AppErrorHandler**: Global error handler for framework and platform errors
- **ErrorBoundary**: Widget boundary for catching and handling errors in UI
- **ErrorController**: Global error state management
- **ErrorUtils**: Utility functions for error handling

### Loading System

Consistent loading patterns throughout the app:

- **LoadingController**: Global loading state management
- **LoadingWidgets**: Reusable loading indicators
- **LoadingUtils**: Utility functions for loading operations

### Common Widgets

Reusable UI components for consistent design:

- **Common Input Fields**: Standardized text inputs, search fields, price fields
- **Common Buttons**: Primary, outlined, text, and icon buttons
- **Common Cards**: Product cards, info cards, status cards
- **Common Containers**: Flexible containers with consistent styling
- **Common App Bar**: Standardized app bar variants

## Controllers

### NavigationController

Manages bottom navigation state:

```dart
final controller = Get.put(NavigationController());

// Get current selected index
int currentIndex = controller.selectedIndex.value;

// Change selected tab
controller.changeIndex(2);
```

### HomeController

Manages home screen state:

```dart
final controller = Get.put(HomeController());

// Get categories and products
List<CategoryModel> categories = controller.categories;
List<AdModel> products = controller.products;

// Change selected category
controller.changeCategory(1);

// Format time
String timeAgo = controller.getTimeAgo(DateTime.now());
```

### SearchController

Manages search functionality and filters:

```dart
final controller = Get.put(SearchController());

// Search query
controller.searchController.text = "laptop";

// Update price range
controller.updatePriceRange(RangeValues(100, 500));

// Toggle filters
controller.toggleFilter("Nearby", true);

// Reset all filters
controller.resetFilters();
```

## Models

### AdModel

Represents a marketplace listing:

```dart
AdModel ad = AdModel(
  id: '1',
  title: 'iPhone 13',
  price: 699.99,
  description: 'Like new iPhone 13',
  images: ['url1', 'url2'],
  location: 'Seattle, WA',
  category: 'Electronics',
  condition: AdCondition.likeNew,
  isFavorite: false,
  postedAt: DateTime.now(),
);
```

### CategoryModel

Represents a product category:

```dart
CategoryModel category = CategoryModel(
  id: '1',
  name: 'Electronics',
  icon: Icons.phone,
  subcategories: ['Phones', 'Laptops'],
);
```

### UserModel

Represents a user profile:

```dart
UserModel user = UserModel(
  id: '1',
  name: 'John Doe',
  email: 'john@example.com',
  avatar: 'avatar_url',
  isVerified: true,
  lastActive: DateTime.now(),
);
```

## Common Widgets Usage

### AppTextField

Standardized text input field:

```dart
AppTextField(
  controller: _nameController,
  hintText: 'Enter your name',
  prefixIcon: Icons.person,
  validator: (value) => value!.isEmpty ? 'Required' : null,
)
```

### AppButton

Primary action button:

```dart
AppButton(
  text: 'Submit',
  onPressed: () => _handleSubmit(),
  icon: Icons.send,
  isLoading: _isLoading,
)
```

### AppOutlinedButton

Secondary action button:

```dart
AppOutlinedButton(
  text: 'Cancel',
  onPressed: () => _handleCancel(),
  borderColor: Colors.grey,
)
```

### AppImageCard

Card with image and metadata:

```dart
AppImageCard(
  imageUrl: 'https://example.com/image.jpg',
  title: 'Product Title',
  price: '\$99.99',
  tags: ['Electronics', 'New'],
  onTap: () => _navigateToDetails(),
  showFavorite: true,
  isFavorite: false,
  onFavoriteTap: () => _toggleFavorite(),
)
```

## Error Handling

### Using Error Boundaries

Wrap screens or widgets with error boundaries:

```dart
ErrorBoundary(
  boundaryName: 'Home Screen',
  child: HomeScreen(),
)
```

### Custom Error Handling

Use ErrorController for global error management:

```dart
final errorController = Get.find<ErrorController>();

// Show error dialog
errorController.showErrorDialog(
  title: 'Error',
  message: 'Something went wrong',
  onRetry: () => _retryOperation(),
);
```

## Loading States

### Using LoadingController

Manage global loading states:

```dart
final loadingController = Get.find<LoadingController>();

// Show loading
loadingController.setGlobalLoadingState(
  LoadingState.loading,
  message: 'Loading data...',
);

// Hide loading
loadingController.setGlobalLoadingState(LoadingState.idle);
```

### Loading Utilities

Execute operations with loading indicators:

```dart
await LoadingUtils.executeWithOverlay(
  context,
  operation: () => _fetchData(),
  message: 'Loading...',
);
```

## Theme and Styling

### App Colors

Use centralized color constants:

```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

### App Sizes

Use standardized size constants:

```dart
Container(
  padding: EdgeInsets.all(AppSizes.paddingM),
  margin: EdgeInsets.symmetric(vertical: AppSizes.marginS),
)
```

### App Texts

Use centralized text constants:

```dart
Text(
  AppTexts.homeSearchHint,
  style: TextStyle(fontSize: AppSizes.fontM),
)
```

## Development Guidelines

### Code Style

1. Follow Dart/Flutter linting rules
2. Use meaningful variable and function names
3. Add comprehensive documentation
4. Keep functions focused and small
5. Use GetX for state management consistently

### File Organization

1. Group related files in feature directories
2. Use barrel exports for clean imports
3. Separate UI, logic, and data layers
4. Keep widget files focused on single responsibilities

### Error Handling

1. Always wrap screens in ErrorBoundary
2. Handle async operations with proper error handling
3. Use LoadingUtils for loading states
4. Provide meaningful error messages

### Performance

1. Use const constructors where possible
2. Optimize widget rebuilds with GetX reactive programming
3. Use CachedNetworkImage for remote images
4. Implement proper disposal of controllers

## Testing

### Unit Testing

Test controllers and business logic:

```dart
test('HomeController should change category', () {
  final controller = HomeController();
  controller.changeCategory(1);
  expect(controller.selectedCategoryIndex.value, 1);
});
```

### Widget Testing

Test UI components:

```dart
testWidgets('AppTextField should render correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AppTextField(
          hintText: 'Test',
        ),
      ),
    ),
  );
  
  expect(find.byType(AppTextField), findsOneWidget);
  expect(find.text('Test'), findsOneWidget);
});
```

## Deployment

### Build Commands

```bash
# Development build
flutter build apk --debug

# Production build
flutter build apk --release

# iOS build
flutter build ios --release
```

### Environment Configuration

Configure different environments:

```dart
class AppConfig {
  static const String apiBaseUrl = kDebugMode 
    ? 'https://api-dev.marketlocal.com'
    : 'https://api.marketlocal.com';
}
```

## Contributing

1. Follow the existing code style and patterns
2. Add comprehensive documentation for new features
3. Write tests for new functionality
4. Update this documentation when making architectural changes
5. Use meaningful commit messages

## Troubleshooting

### Common Issues

1. **GetX Controller Not Found**: Ensure controller is registered with Get.put()
2. **Error Boundary Not Working**: Check that ErrorBoundary wraps the correct widget
3. **Loading State Not Updating**: Verify LoadingController is properly initialized
4. **Theme Not Applied**: Ensure AppTheme is correctly configured in MaterialApp

### Debug Tips

1. Use GetX debugging tools: `Get.log('Debug message')`
2. Check controller lifecycle with onInit() and onClose()
3. Monitor error boundaries with error handling logs
4. Use Flutter DevTools for performance profiling

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Material Design Guidelines](https://material.io/design)
