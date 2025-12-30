# Project Structure

This document defines the folder structure, ownership rules, and guidelines for where code should be placed in the MarketLocal project.

## Directory Tree

```
market_local/
├── android/                    # Android platform-specific code
├── ios/                        # iOS platform-specific code
├── linux/                      # Linux platform-specific code
├── macos/                      # macOS platform-specific code
├── web/                        # Web platform-specific code
├── windows/                    # Windows platform-specific code
├── test/                       # Unit and widget tests
├── docs/                       # Project documentation
│   ├── structure.md            # This file
│   ├── roles.md                # AI agent role definitions
│   ├── rules.md                # Project rules and conventions
│   ├── todo.md                 # Task backlog
│   └── ai_workflow.md          # AI workflow guidelines
├── lib/                        # Main Dart source code
│   ├── bindings/               # GetX dependency injection
│   │   └── main_binding.dart   # App-wide bindings
│   ├── controllers/            # Global controllers
│   │   └── navigation_controller.dart
│   ├── core/                   # Shared utilities and constants
│   │   ├── constants/          # App-wide constants
│   │   │   ├── app_colors.dart
│   │   │   ├── app_sizes.dart
│   │   │   └── app_texts.dart
│   │   ├── theme/              # Theme configuration
│   │   │   └── app_theme.dart
│   │   ├── utils/              # Utility functions
│   │   │   └── validators.dart
│   │   └── widgets/            # Reusable widgets
│   │       ├── category_chip.dart
│   │       └── product_card.dart
│   ├── features/               # Feature modules
│   │   ├── home/
│   │   │   ├── data/
│   │   │   │   └── mock_data.dart
│   │   │   ├── home_controller.dart
│   │   │   └── home_screen.dart
│   │   ├── search/
│   │   │   ├── data/
│   │   │   │   └── mock_data.dart
│   │   │   ├── search_controller.dart
│   │   │   └── search_screen.dart
│   │   ├── post_ad/
│   │   │   ├── data/
│   │   │   │   └── mock_data.dart
│   │   │   ├── post_ad_controller.dart
│   │   │   └── post_ad_screen.dart
│   │   ├── chat/
│   │   │   ├── data/
│   │   │   │   └── mock_data.dart
│   │   │   ├── chat_controller.dart
│   │   │   └── chat_screen.dart
│   │   ├── profile/
│   │   │   ├── data/
│   │   │   │   └── mock_data.dart
│   │   │   ├── profile_controller.dart
│   │   │   └── profile_screen.dart
│   │   └── ad_details/
│   │       └── ad_details_screen.dart
│   ├── models/                 # Data models
│   │   ├── ad_model.dart
│   │   ├── user_model.dart
│   │   └── category_model.dart
│   ├── routes/                 # Route configuration
│   │   └── app_router.dart
│   └── main.dart               # App entry point
├── pubspec.yaml                # Dependencies
├── pubspec.lock                # Locked dependencies
├── analysis_options.yaml       # Linter configuration
└── README.md                   # Project overview
```

---

## Folder Explanations

### `/lib/bindings/`

**Purpose:** GetX dependency injection bindings.

**Contains:**
- `main_binding.dart` - Registers all controllers for lazy initialization

**Rules:**
- All controllers must be registered here
- Use `Get.lazyPut()` for lazy initialization
- Do not put business logic here

---

### `/lib/controllers/`

**Purpose:** Global controllers that are not feature-specific.

**Contains:**
- `navigation_controller.dart` - Bottom navigation state

**Rules:**
- Only truly global controllers belong here
- Feature-specific controllers go in their feature folder
- Keep controllers minimal and focused

---

### `/lib/core/`

**Purpose:** Shared code used across multiple features.

#### `/lib/core/constants/`

**Contains:**
- `app_colors.dart` - Color palette (primary, secondary, text, status colors)
- `app_sizes.dart` - Spacing, padding, radius, font sizes
- `app_texts.dart` - Static text strings, labels, messages

**Rules:**
- All hardcoded values must be extracted here
- Use semantic naming (e.g., `paddingM` not `padding16`)
- Never use magic numbers in feature code

#### `/lib/core/theme/`

**Contains:**
- `app_theme.dart` - Material theme configuration

**Rules:**
- Single source of truth for app theming
- Uses constants from `app_colors.dart` and `app_sizes.dart`
- Do not override theme in individual widgets

#### `/lib/core/utils/`

**Contains:**
- `validators.dart` - Form validation functions

**Rules:**
- Pure utility functions only
- No state, no side effects
- Well-documented with clear return types

#### `/lib/core/widgets/`

**Contains:**
- Reusable widgets used across multiple features

**Rules:**
- Must be used in 2+ features to qualify
- Fully customizable via parameters
- No feature-specific logic

---

### `/lib/features/`

**Purpose:** Self-contained feature modules.

**Structure per feature:**
```
feature_name/
├── data/
│   └── mock_data.dart      # Mock data for development
├── feature_controller.dart  # GetX controller
└── feature_screen.dart      # Main screen widget
```

**Rules:**
- Each feature owns its UI, controller, and data
- Features must not import from other features
- Shared code goes in `/core/`
- Use models from `/models/` for data structures

---

### `/lib/models/`

**Purpose:** Centralized data models.

**Contains:**
- `ad_model.dart` - Advertisement/listing model
- `user_model.dart` - User profile model
- `category_model.dart` - Category model

**Rules:**
- All models must have `fromJson()` and `toJson()` methods
- Include `copyWith()` for immutability
- Use enums for fixed value sets
- Models are immutable (use `final` fields)

---

### `/lib/routes/`

**Purpose:** Navigation and routing configuration.

**Contains:**
- `app_router.dart` - Route definitions and navigation setup

**Rules:**
- All routes defined in one place
- Use named routes
- Do not hardcode route strings in features

---

## Ownership Rules

### Feature Ownership

| Feature | Owner | Scope |
|---------|-------|-------|
| Home | `features/home/` | Home screen, categories, product grid |
| Search | `features/search/` | Search, filters, sorting |
| Post Ad | `features/post_ad/` | Ad creation flow |
| Chat | `features/chat/` | Messaging list and conversations |
| Profile | `features/profile/` | User profile, settings |
| Ad Details | `features/ad_details/` | Product detail view |

### Shared Ownership

| Component | Location | Used By |
|-----------|----------|---------|
| Colors | `core/constants/app_colors.dart` | All features |
| Sizes | `core/constants/app_sizes.dart` | All features |
| Texts | `core/constants/app_texts.dart` | All features |
| Theme | `core/theme/app_theme.dart` | App-wide |
| Models | `models/` | All features |
| Validators | `core/utils/validators.dart` | Forms |

---

## What Goes Where

### ✅ CORRECT Placement

| Code Type | Location |
|-----------|----------|
| Feature screen | `features/{name}/{name}_screen.dart` |
| Feature controller | `features/{name}/{name}_controller.dart` |
| Feature mock data | `features/{name}/data/mock_data.dart` |
| Data model | `models/{name}_model.dart` |
| Color constant | `core/constants/app_colors.dart` |
| Size constant | `core/constants/app_sizes.dart` |
| Text constant | `core/constants/app_texts.dart` |
| Reusable widget | `core/widgets/{name}.dart` |
| Validator function | `core/utils/validators.dart` |
| Route definition | `routes/app_router.dart` |
| Controller binding | `bindings/main_binding.dart` |

### ❌ INCORRECT Placement

| Anti-pattern | Why It's Wrong |
|--------------|----------------|
| Hardcoded colors in screens | Use `AppColors` |
| Hardcoded sizes in screens | Use `AppSizes` |
| Hardcoded strings in screens | Use `AppTexts` |
| Feature importing another feature | Violates isolation |
| Business logic in widgets | Use controllers |
| API calls in controllers | Not yet implemented |
| Models defined in features | Centralize in `/models/` |
| Widgets used once in `/core/widgets/` | Keep in feature |

---

## File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Screen | `{feature}_screen.dart` | `home_screen.dart` |
| Controller | `{feature}_controller.dart` | `home_controller.dart` |
| Model | `{name}_model.dart` | `ad_model.dart` |
| Constants | `app_{type}.dart` | `app_colors.dart` |
| Widget | `{name}.dart` (snake_case) | `product_card.dart` |
| Mock data | `mock_data.dart` | `mock_data.dart` |

---

## Import Order

Follow this order for imports:

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Third-party packages
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 4. Project imports - core
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

// 5. Project imports - models
import '../../models/ad_model.dart';

// 6. Project imports - local (same feature)
import 'home_controller.dart';
import 'data/mock_data.dart';
```

---

## Summary

- **Features own their code** - screens, controllers, mock data
- **Core is shared** - constants, theme, utilities, reusable widgets
- **Models are centralized** - all data structures in `/models/`
- **No cross-feature imports** - use shared code in `/core/`
- **Constants over hardcoding** - always use `AppColors`, `AppSizes`, `AppTexts`
