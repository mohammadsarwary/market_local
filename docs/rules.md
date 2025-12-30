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

### Backend Rules

| Rule | Reason |
|------|--------|
| ❌ DO NOT add real API calls yet | Backend not ready |
| ❌ DO NOT add authentication logic yet | Backend not ready |
| ❌ DO NOT add database connections | Backend not ready |
| ❌ DO NOT add Firebase or other BaaS | Not approved |
| ❌ DO NOT store sensitive data | Security risk |

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

```dart
// Controller
class HomeController extends GetxController {
  final RxInt count = 0.obs;
  void increment() => count.value++;
}

// Widget
Obx(() => Text('${controller.count.value}'))
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

## Summary Checklist

Before submitting any change, verify:

- [ ] No UI design changes
- [ ] Using constants (colors, sizes, texts)
- [ ] Using typed models
- [ ] Following naming conventions
- [ ] Imports properly ordered
- [ ] No cross-feature imports
- [ ] Controllers registered in bindings
- [ ] Routes defined in router
- [ ] Null safety handled
- [ ] No hardcoded values
- [ ] No backend/API calls
- [ ] Documentation updated if needed
