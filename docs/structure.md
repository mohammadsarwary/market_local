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
│   ├── API_DOCUMENTATION.md    # Backend API reference (DO NOT MODIFY)
│   ├── structure.md            # This file
│   ├── roles.md                # AI agent role definitions
│   ├── rules.md                # Project rules and conventions
│   ├── todo.md                 # Task backlog
│   ├── ai_workflow.md          # AI workflow guidelines
│   ├── agent_prompt.md         # AI agent prompts
│   └── documentation.md        # High-level project overview
├── lib/                        # Main Dart source code
│   ├── bindings/               # GetX dependency injection
│   │   └── main_binding.dart   # App-wide bindings
│   ├── controllers/            # Global controllers
│   │   └── navigation_controller.dart
│   ├── core/                   # Shared utilities and infrastructure
│   │   ├── api/                # API client infrastructure
│   │   │   ├── api_client.dart
│   │   │   ├── api_service.dart
│   │   │   ├── api_constants.dart
│   │   │   └── api_interceptors.dart
│   │   ├── constants/          # App-wide constants
│   │   │   ├── app_colors.dart
│   │   │   ├── app_sizes.dart
│   │   │   └── app_texts.dart
│   │   ├── error/              # Error handling system
│   │   │   ├── app_error_handler.dart
│   │   │   ├── error_boundary.dart
│   │   │   ├── error_controller.dart
│   │   │   └── error_utils.dart
│   │   ├── loading/            # Loading state management
│   │   │   ├── loading_controller.dart
│   │   │   ├── loading_utils.dart
│   │   │   └── loading_widgets.dart
│   │   ├── repositories/       # Base repository abstractions
│   │   │   ├── base_repository.dart
│   │   │   ├── local_data_source.dart
│   │   │   └── local_data_source_impl.dart
│   │   ├── services/           # Core services
│   │   │   └── storage_service.dart
│   │   ├── theme/              # Theme configuration
│   │   │   └── app_theme.dart
│   │   ├── utils/              # Utility functions
│   │   │   ├── validators.dart
│   │   │   └── date_utils.dart
│   │   └── widgets/            # Reusable widgets
│   │       ├── common_app_bar.dart
│   │       ├── common_button.dart
│   │       ├── common_card.dart
│   │       ├── common_container.dart
│   │       ├── common_image.dart
│   │       ├── common_input.dart
│   │       └── ... (13 widget files)
│   ├── features/               # Feature modules
│   │   ├── auth/               # Authentication feature
│   │   │   ├── controllers/
│   │   │   │   └── auth_controller_impl.dart
│   │   │   ├── models/
│   │   │   │   ├── auth_request.dart
│   │   │   │   └── auth_response.dart
│   │   │   ├── repositories/
│   │   │   │   ├── auth_repository.dart
│   │   │   │   ├── auth_repository_impl.dart
│   │   │   │   └── auth_service.dart
│   │   │   ├── auth_controller.dart
│   │   │   ├── auth_flow_service.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   ├── forgot_password_screen.dart
│   │   │   └── otp_verification_screen.dart
│   │   ├── profile/            # User profile feature
│   │   │   ├── controllers/
│   │   │   │   └── profile_controller_impl.dart
│   │   │   ├── data/
│   │   │   │   └── mock_data.dart
│   │   │   ├── models/
│   │   │   │   ├── user_profile_request.dart
│   │   │   │   └── user_profile_response.dart
│   │   │   ├── repositories/
│   │   │   │   ├── user_repository.dart
│   │   │   │   ├── user_repository_impl.dart
│   │   │   │   └── user_service.dart
│   │   │   ├── profile_controller.dart
│   │   │   └── profile_screen.dart
│   │   ├── ad_details/         # Ad details feature
│   │   │   ├── models/
│   │   │   │   ├── ad_request.dart
│   │   │   │   └── ad_response.dart
│   │   │   ├── repositories/
│   │   │   │   ├── ad_repository.dart
│   │   │   │   ├── ad_repository_impl.dart
│   │   │   │   └── ad_service.dart
│   │   │   ├── widgets/
│   │   │   │   └── ... (8 widget files)
│   │   │   ├── ad_details_screen.dart
│   │   │   └── ad_details_screen_original.dart
│   │   ├── category/           # Category feature
│   │   │   ├── models/
│   │   │   │   └── category_response.dart
│   │   │   ├── repositories/
│   │   │   │   ├── category_repository.dart
│   │   │   │   ├── category_repository_impl.dart
│   │   │   │   └── category_service.dart
│   │   │   └── category_screen.dart
│   │   ├── search/             # Search feature
│   │   │   ├── controllers/
│   │   │   │   └── search_controller_impl.dart
│   │   │   ├── data/
│   │   │   │   └── mock_data.dart
│   │   │   ├── models/
│   │   │   │   ├── search_request.dart
│   │   │   │   └── search_response.dart
│   │   │   ├── repositories/
│   │   │   │   ├── search_repository.dart
│   │   │   │   ├── search_repository_impl.dart
│   │   │   │   └── search_service.dart
│   │   │   ├── search_controller.dart
│   │   │   └── search_screen.dart
│   │   ├── post_ad/            # Post ad feature
│   │   │   ├── data/
│   │   │   │   └── mock_data.dart
│   │   │   ├── widgets/
│   │   │   │   └── ... (widget files)
│   │   │   ├── post_ad_controller.dart
│   │   │   └── post_ad_screen.dart
│   │   ├── home/               # Home screen feature
│   │   │   ├── data/
│   │   │   │   └── mock_data.dart
│   │   │   ├── home_controller.dart
│   │   │   └── home_screen.dart
│   │   └── chat/               # Chat feature
│   │       ├── data/
│   │       │   └── mock_data.dart
│   │       ├── chat_controller.dart
│   │       └── chat_screen.dart
│   ├── models/                 # Shared data models
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

**Purpose:** Shared infrastructure, utilities, and reusable components used across all features.

#### `/lib/core/api/`

**Contains:**
- `api_client.dart` - Dio-based HTTP client with interceptors
- `api_service.dart` - Singleton API service wrapper
- `api_constants.dart` - API endpoint constants and configuration
- `api_interceptors.dart` - Auth, logging, and retry interceptors

**Rules:**
- All API calls must go through ApiClient
- Endpoint constants defined in api_constants.dart
- Never hardcode API URLs in features
- Use interceptors for cross-cutting concerns (auth, logging, retry)

#### `/lib/core/constants/`

**Contains:**
- `app_colors.dart` - Color palette (primary, secondary, text, status colors)
- `app_sizes.dart` - Spacing, padding, radius, font sizes
- `app_texts.dart` - Static text strings, labels, messages

**Rules:**
- All hardcoded values must be extracted here
- Use semantic naming (e.g., `paddingM` not `padding16`)
- Never use magic numbers in feature code

#### `/lib/core/error/`

**Contains:**
- `app_error_handler.dart` - Global error handler
- `error_boundary.dart` - Widget-level error boundaries
- `error_controller.dart` - Error state management
- `error_utils.dart` - Error handling utilities

**Rules:**
- Wrap screens in ErrorBoundary widgets
- Use ErrorController for global error state
- Provide user-friendly error messages
- Log errors for debugging

#### `/lib/core/loading/`

**Contains:**
- `loading_controller.dart` - Global loading state
- `loading_utils.dart` - Loading operation helpers
- `loading_widgets.dart` - Reusable loading indicators

**Rules:**
- Use LoadingController for app-wide loading states
- Use LoadingUtils for async operations with loading
- Consistent loading UI across features

#### `/lib/core/repositories/`

**Contains:**
- `base_repository.dart` - Base repository with error handling
- `local_data_source.dart` - Local storage interface
- `local_data_source_impl.dart` - Local storage implementation

**Rules:**
- All repositories extend BaseRepository
- Repositories coordinate between API and local storage
- Handle exceptions and transform data

#### `/lib/core/services/`

**Contains:**
- `storage_service.dart` - Local storage service

**Rules:**
- Core services used across features
- Singleton pattern for services
- Well-defined interfaces

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
- `date_utils.dart` - Date formatting utilities

**Rules:**
- Pure utility functions only
- No state, no side effects
- Well-documented with clear return types

#### `/lib/core/widgets/`

**Contains:**
- `common_app_bar.dart` - Standardized app bars
- `common_button.dart` - Button variants
- `common_card.dart` - Card components
- `common_container.dart` - Container variants
- `common_image.dart` - Image widgets with caching
- `common_input.dart` - Input field components
- And 7 more reusable widgets

**Rules:**
- Must be used in 2+ features to qualify
- Fully customizable via parameters
- No feature-specific logic
- Follow consistent naming: `common_*`

---

### `/lib/features/`

**Purpose:** Self-contained feature modules following clean architecture.

**Structure per feature (with API integration):**
```
feature_name/
├── controllers/
│   └── feature_controller_impl.dart  # Controller implementation
├── models/
│   ├── feature_request.dart          # API request models
│   └── feature_response.dart         # API response models
├── repositories/
│   ├── feature_repository.dart       # Repository interface
│   ├── feature_repository_impl.dart  # Repository implementation
│   └── feature_service.dart          # Service layer
├── data/
│   └── mock_data.dart                # Mock data (if needed)
├── widgets/
│   └── feature_widgets.dart          # Feature-specific widgets
├── feature_controller.dart           # Main controller
└── feature_screen.dart               # Main screen widget
```

**Architecture Layers:**
1. **Screen** - UI layer, uses controllers
2. **Controller** - State management, business logic
3. **Service** - High-level API operations
4. **Repository** - Data source coordination (API + local cache)
5. **Models** - Data transfer objects

**Rules:**
- Each feature owns its UI, controller, repository, and models
- Features must not import from other features
- Shared code goes in `/core/`
- Use models from `/models/` for shared data structures
- Repositories handle API calls and caching
- Services provide high-level operations for controllers

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
| Authentication | `features/auth/` | Login, register, OTP, password reset |
| Home | `features/home/` | Home screen, categories, product grid |
| Search | `features/search/` | Search, filters, sorting |
| Post Ad | `features/post_ad/` | Ad creation flow |
| Chat | `features/chat/` | Messaging list and conversations |
| Profile | `features/profile/` | User profile, settings, account management |
| Ad Details | `features/ad_details/` | Product detail view, ad actions |
| Category | `features/category/` | Category browsing and filtering |

### Core Infrastructure Ownership

| Component | Location | Used By |
|-----------|----------|---------|
| API Client | `core/api/` | All features with backend integration |
| Error Handling | `core/error/` | All features |
| Loading States | `core/loading/` | All features |
| Base Repository | `core/repositories/` | All feature repositories |
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
| Controller implementation | `features/{name}/controllers/{name}_controller_impl.dart` |
| API request model | `features/{name}/models/{name}_request.dart` |
| API response model | `features/{name}/models/{name}_response.dart` |
| Repository interface | `features/{name}/repositories/{name}_repository.dart` |
| Repository implementation | `features/{name}/repositories/{name}_repository_impl.dart` |
| Service layer | `features/{name}/repositories/{name}_service.dart` |
| Feature mock data | `features/{name}/data/mock_data.dart` |
| Feature widgets | `features/{name}/widgets/{widget_name}.dart` |
| Shared data model | `models/{name}_model.dart` |
| API endpoint constant | `core/api/api_constants.dart` |
| Color constant | `core/constants/app_colors.dart` |
| Size constant | `core/constants/app_sizes.dart` |
| Text constant | `core/constants/app_texts.dart` |
| Reusable widget | `core/widgets/common_{name}.dart` |
| Validator function | `core/utils/validators.dart` |
| Route definition | `routes/app_router.dart` |
| Controller binding | `bindings/main_binding.dart` |

### ❌ INCORRECT Placement

| Anti-pattern | Why It's Wrong |
|--------------|----------------|
| Hardcoded colors in screens | Use `AppColors` |
| Hardcoded sizes in screens | Use `AppSizes` |
| Hardcoded strings in screens | Use `AppTexts` |
| Hardcoded API URLs | Use `ApiConstants` |
| Feature importing another feature | Violates isolation |
| Business logic in widgets | Use controllers |
| API calls in controllers | Use services/repositories |
| Direct Dio calls in features | Use ApiClient |
| Shared models in feature folders | Centralize in `/models/` |
| Feature-specific models in `/models/` | Keep in feature |
| Widgets used once in `/core/widgets/` | Keep in feature |
| Skipping error boundaries | Breaks error handling |

---

## File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Screen | `{feature}_screen.dart` | `home_screen.dart` |
| Controller | `{feature}_controller.dart` | `home_controller.dart` |
| Controller Impl | `{feature}_controller_impl.dart` | `auth_controller_impl.dart` |
| Repository | `{feature}_repository.dart` | `auth_repository.dart` |
| Repository Impl | `{feature}_repository_impl.dart` | `auth_repository_impl.dart` |
| Service | `{feature}_service.dart` | `auth_service.dart` |
| Request Model | `{feature}_request.dart` | `auth_request.dart` |
| Response Model | `{feature}_response.dart` | `auth_response.dart` |
| Shared Model | `{name}_model.dart` | `ad_model.dart` |
| Constants | `app_{type}.dart` | `app_colors.dart` |
| Common Widget | `common_{name}.dart` | `common_button.dart` |
| Feature Widget | `{name}.dart` (snake_case) | `product_card.dart` |
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

- **Features own their code** - screens, controllers, repositories, services, models
- **Repository pattern** - repositories coordinate between API and local storage
- **Service layer** - services provide high-level operations for controllers
- **Core is shared** - API client, error handling, loading, constants, widgets
- **API integration** - all API calls through ApiClient with interceptors
- **Models are layered** - shared models in `/models/`, feature-specific in feature folders
- **No cross-feature imports** - use shared code in `/core/`
- **Constants over hardcoding** - always use `AppColors`, `AppSizes`, `AppTexts`, `ApiConstants`
- **Error boundaries** - wrap screens for proper error handling
- **Clean architecture** - clear separation between UI, business logic, and data layers
