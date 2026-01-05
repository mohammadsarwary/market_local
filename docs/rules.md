# Project Rules

This document contains the strict, unambiguous rules that all contributors (human and AI) must follow when working on the MarketLocal project.

---

## Absolute DO NOT Rules

These rules are non-negotiable. Violation requires immediate rollback.

### UI/Design Rules

| Rule | Reason |
|------|--------|
| ❌ DO NOT change the color palette | UI design is finalized |
| ❌ DO NOT modify typography styles | UI design is finalized |
| ❌ DO NOT redesign screen layouts | UI design is finalized |
| ❌ DO NOT change icon selections | UI design is finalized |
| ❌ DO NOT alter spacing/padding significantly | UI design is finalized |
| ❌ DO NOT add new UI components without approval | UI design is finalized |
| ❌ DO NOT remove existing UI elements | UI design is finalized |

### Architecture Rules

| Rule | Reason |
|------|--------|
| ❌ DO NOT import one feature into another | Violates feature isolation |
| ❌ DO NOT put business logic in widgets | Separation of concerns |
| ❌ DO NOT use raw `Map<String, dynamic>` for data | Use typed models |
| ❌ DO NOT hardcode colors, sizes, or strings | Use constants |
| ❌ DO NOT create circular dependencies | Breaks architecture |
| ❌ DO NOT bypass GetX state management | Consistency |

### API Integration Rules

| Rule | Reason |
|------|--------|
| ✅ USE ApiClient for all HTTP requests | Centralized API management |
| ✅ USE ApiConstants for endpoint definitions | Consistency |
| ✅ USE repository pattern for data access | Clean architecture |
| ✅ IMPLEMENT proper error handling | User experience |
| ✅ USE interceptors for auth/logging/retry | Cross-cutting concerns |
| ❌ DO NOT hardcode API URLs | Use ApiConstants |
| ❌ DO NOT make direct Dio calls in features | Use repositories |
| ❌ DO NOT skip error boundaries | Breaks error handling |
| ❌ DO NOT store tokens insecurely | Use flutter_secure_storage |
| ❌ DO NOT expose sensitive data in logs | Security risk |

### Dependency Rules

| Rule | Reason |
|------|--------|
| ❌ DO NOT add dependencies without documentation | Traceability |
| ❌ DO NOT remove existing dependencies | May break features |
| ❌ DO NOT upgrade major versions without testing | Stability |
| ❌ DO NOT add platform-specific dependencies without approval | Cross-platform |

---

## Mandatory Rules

These rules must be followed for all code changes.

### Code Style

| Rule | Implementation |
|------|----------------|
| ✅ Use `const` constructors where possible | Reduces rebuilds |
| ✅ Use `final` for immutable variables | Prevents mutation |
| ✅ Use trailing commas | Better formatting |
| ✅ Keep lines under 80 characters | Readability |
| ✅ Use meaningful variable names | Self-documenting |
| ✅ Follow Dart naming conventions | Consistency |

### Constants Usage

| Type | Source | Example |
|------|--------|---------|
| Colors | `AppColors` | `AppColors.primary` |
| Sizes | `AppSizes` | `AppSizes.paddingM` |
| Strings | `AppTexts` | `AppTexts.appName` |
| Theme | `AppTheme` | `AppTheme.lightTheme` |

```dart
// ❌ WRONG
Container(
  padding: EdgeInsets.all(16),
  color: Color(0xFFE53935),
  child: Text('Hello'),
)

// ✅ CORRECT
Container(
  padding: EdgeInsets.all(AppSizes.paddingM),
  color: AppColors.primary,
  child: Text(AppTexts.greeting),
)
```

### Model Usage

| Rule | Implementation |
|------|----------------|
| ✅ Use typed models for data | `AdModel`, `UserModel`, etc. |
| ✅ Models must have `fromJson`/`toJson` | Serialization ready |
| ✅ Models must have `copyWith` | Immutability |
| ✅ Use enums for fixed values | Type safety |

```dart
// ❌ WRONG
final product = {'title': 'Bike', 'price': 100};

// ✅ CORRECT
final product = AdModel(title: 'Bike', price: 100);
```

### State Management

| Rule | Implementation |
|------|----------------|
| ✅ Use GetX controllers | `GetxController` |
| ✅ Use `.obs` for reactive state | `RxInt`, `RxString`, etc. |
| ✅ Use `Obx()` for reactive widgets | Automatic rebuilds |
| ✅ Register controllers in bindings | `main_binding.dart` |
| ✅ Use services for business logic | Separate from controllers |
| ✅ Use repositories for data access | Clean separation |

```dart
// Controller
class HomeController extends GetxController {
  final HomeService _service = HomeService.instance;
  final RxBool isLoading = false.obs;
  final RxList<Ad> ads = <Ad>[].obs;
  
  Future<void> loadAds() async {
    isLoading.value = true;
    try {
      final response = await _service.getAds();
      ads.value = response.ads;
    } finally {
      isLoading.value = false;
    }
  }
}

// Widget
Obx(() => controller.isLoading.value 
  ? CircularProgressIndicator()
  : ListView.builder(...))
```

---

## Navigation Rules

### Route Definitions

| Rule | Implementation |
|------|----------------|
| ✅ Define all routes in `app_router.dart` | Centralized |
| ✅ Use named routes | `Get.toNamed('/home')` |
| ✅ Pass typed arguments | `Get.toNamed('/details', arguments: adModel)` |
| ✅ Handle null arguments | Null safety |

### Navigation Patterns

```dart
// ❌ WRONG - Direct widget navigation
Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));

// ✅ CORRECT - Named route
Get.toNamed('/home');

// ❌ WRONG - Untyped arguments
Get.toNamed('/details', arguments: {'id': 1});

// ✅ CORRECT - Typed arguments
Get.toNamed('/details', arguments: adModel);
```

### Bottom Navigation

| Rule | Implementation |
|------|----------------|
| ✅ Use `NavigationController` | Centralized state |
| ✅ Maintain navigation state | Preserve scroll position |
| ✅ Use indexed stack | Lazy loading |

---

## Styling Rules

### Colors

| Usage | Constant |
|-------|----------|
| Primary brand color | `AppColors.primary` |
| Secondary accent | `AppColors.secondary` |
| Background | `AppColors.background` |
| Surface/Card | `AppColors.surface` |
| Primary text | `AppColors.textPrimary` |
| Secondary text | `AppColors.textSecondary` |
| Hint text | `AppColors.textHint` |
| Error state | `AppColors.error` |
| Success state | `AppColors.success` |
| Warning state | `AppColors.warning` |
| Borders | `AppColors.border` |

### Spacing

| Size | Constant | Value |
|------|----------|-------|
| Extra Small | `AppSizes.paddingXS` | 4.0 |
| Small | `AppSizes.paddingS` | 8.0 |
| Medium | `AppSizes.paddingM` | 16.0 |
| Large | `AppSizes.paddingL` | 24.0 |
| Extra Large | `AppSizes.paddingXL` | 32.0 |

### Border Radius

| Size | Constant | Value |
|------|----------|-------|
| Extra Small | `AppSizes.radiusXS` | 4.0 |
| Small | `AppSizes.radiusS` | 8.0 |
| Medium | `AppSizes.radiusM` | 12.0 |
| Large | `AppSizes.radiusL` | 16.0 |
| Extra Large | `AppSizes.radiusXL` | 24.0 |

### Typography

| Style | Usage |
|-------|-------|
| `fontXS` (10) | Labels, badges |
| `fontS` (12) | Captions, hints |
| `fontM` (14) | Body text |
| `fontL` (16) | Subtitles |
| `fontXL` (18) | Titles |
| `fontXXL` (24) | Headlines |

---

## File & Naming Conventions

### File Names

| Type | Convention | Example |
|------|------------|---------|
| Screens | `{feature}_screen.dart` | `home_screen.dart` |
| Controllers | `{feature}_controller.dart` | `home_controller.dart` |
| Models | `{name}_model.dart` | `ad_model.dart` |
| Constants | `app_{type}.dart` | `app_colors.dart` |
| Widgets | `{name}.dart` | `product_card.dart` |
| Utils | `{name}.dart` | `validators.dart` |

### Class Names

| Type | Convention | Example |
|------|------------|---------|
| Screens | `{Feature}Screen` | `HomeScreen` |
| Controllers | `{Feature}Controller` | `HomeController` |
| Models | `{Name}Model` | `AdModel` |
| Widgets | `{Name}` | `ProductCard` |
| Enums | `{Name}` | `AdCondition` |

### Variable Names

| Type | Convention | Example |
|------|------------|---------|
| Local variables | camelCase | `userName` |
| Private variables | _camelCase | `_isLoading` |
| Constants | camelCase | `primaryColor` |
| Static constants | camelCase | `AppColors.primary` |

### Folder Names

| Convention | Example |
|------------|---------|
| snake_case | `post_ad/` |
| Lowercase | `models/` |
| Plural for collections | `features/` |

---

## Import Rules

### Order

1. Dart SDK imports
2. Flutter SDK imports
3. Third-party package imports
4. Project core imports
5. Project model imports
6. Local feature imports

### Example

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter SDK
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 4. Core
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_texts.dart';

// 5. Models
import '../../models/ad_model.dart';
import '../../models/user_model.dart';

// 6. Local
import 'home_controller.dart';
import 'data/mock_data.dart';
```

### Rules

| Rule | Implementation |
|------|----------------|
| ✅ Use relative imports for project files | `import '../core/...'` |
| ✅ Group imports by category | Blank line between groups |
| ✅ Alphabetize within groups | Easier to find |
| ❌ DO NOT use `package:` for local imports | Consistency |
| ❌ DO NOT import unused packages | Clean code |

---

## Error Handling Rules

### Widget Errors

```dart
// ✅ CORRECT - Handle null/empty states
if (items.isEmpty) {
  return const EmptyStateWidget();
}

// ✅ CORRECT - Handle loading states
if (controller.isLoading.value) {
  return const CircularProgressIndicator();
}

// ✅ CORRECT - Handle errors
if (controller.hasError.value) {
  return ErrorWidget(message: controller.errorMessage.value);
}
```

### Null Safety

```dart
// ❌ WRONG - Force unwrap
final name = user!.name;

// ✅ CORRECT - Null check
final name = user?.name ?? 'Unknown';

// ✅ CORRECT - Early return
if (user == null) return const SizedBox.shrink();
```

---

## Testing Rules

| Rule | Implementation |
|------|----------------|
| ✅ Test files mirror source structure | `test/features/home/...` |
| ✅ Name tests descriptively | `should_return_empty_when_no_items` |
| ✅ Test edge cases | Empty, null, error states |
| ❌ DO NOT delete existing tests | Regression prevention |
| ❌ DO NOT weaken assertions | Maintain coverage |

---

## Documentation Rules

| Rule | Implementation |
|------|----------------|
| ✅ Document public APIs | `///` doc comments |
| ✅ Document complex logic | Inline comments |
| ✅ Update docs when changing behavior | Keep in sync |
| ❌ DO NOT over-comment obvious code | Noise reduction |
| ❌ DO NOT leave TODO comments without tickets | Traceability |

---

## API Integration Patterns

### Repository Pattern

```dart
// Repository Interface
abstract class UserRepository {
  Future<UserProfile> getProfile();
  Future<void> updateProfile(UpdateProfileRequest request);
}

// Repository Implementation
class UserRepositoryImpl extends BaseRepository implements UserRepository {
  final ApiClient apiClient;
  final LocalDataSource localDataSource;
  
  @override
  Future<UserProfile> getProfile() async {
    return handleException(() async {
      final response = await apiClient.get('/users/profile');
      final profile = UserProfile.fromJson(response);
      await localDataSource.save('profile', profile.toJson());
      return profile;
    });
  }
}

// Service Layer
class UserService {
  final UserRepository _repository;
  
  Future<UserProfile> getProfile() async {
    return await _repository.getProfile();
  }
}
```

### Error Handling

```dart
// Wrap screens in ErrorBoundary
ErrorBoundary(
  boundaryName: 'Profile Screen',
  child: ProfileScreen(),
)

// Use try-catch in repositories
try {
  final response = await apiClient.get(endpoint);
  return Model.fromJson(response);
} catch (e) {
  throw ApiException(message: 'Failed to load data');
}
```

---

## Summary Checklist

Before submitting any change, verify:

- [ ] No UI design changes
- [ ] Using constants (colors, sizes, texts, API endpoints)
- [ ] Using typed models (requests, responses)
- [ ] Following naming conventions
- [ ] Imports properly ordered
- [ ] No cross-feature imports
- [ ] Controllers registered in bindings
- [ ] Routes defined in router
- [ ] Null safety handled
- [ ] No hardcoded values (including API URLs)
- [ ] API calls through repositories
- [ ] Error boundaries implemented
- [ ] Loading states handled
- [ ] Documentation updated if needed
