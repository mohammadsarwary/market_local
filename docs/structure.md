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
│   ├── controllers/            # Global and feature controllers
│   │   ├── ads/                # Ad-related controllers
│   │   ├── auth/               # Authentication controllers
│   │   ├── profile/            # Profile controllers
│   │   └── navigation_controller.dart
│   ├── core/                   # Shared utilities and infrastructure
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
│   ├── models/                 # Shared data models
│   │   ├── ad/                 # Ad-related models
│   │   ├── auth/               # Authentication models
│   │   ├── category/           # Category models
│   │   ├── user/               # User models
│   │   └── models.dart         # Model exports
│   ├── repositories/           # Repository implementations
│   │   ├── ad/                 # Ad repositories
│   │   ├── auth/               # Auth repositories
│   │   ├── category/           # Category repositories
│   │   └── user/               # User repositories
│   ├── routes/                 # Route configuration
│   │   └── app_router.dart
│   ├── services/               # App services
│   │   ├── api_client.dart     # Dio-based HTTP client
│   │   ├── api_constants.dart  # API endpoint constants
│   │   ├── api_interceptors.dart # Auth, logging, retry interceptors
│   │   ├── api_service.dart    # API service wrapper
│   │   ├── auth_service.dart   # Authentication service
│   │   ├── loading_service.dart # Loading state service
│   │   └── storage_service.dart # Local storage service
│   ├── utils/                  # Utility functions
│   │   ├── colors.dart         # Color utilities
│   │   ├── haptic_feedback.dart # Haptic feedback utilities
│   │   ├── text_styles.dart    # Text style utilities
│   │   ├── theme.dart          # Theme utilities
│   │   └── validators.dart     # Validation utilities
│   ├── views/                  # Screen widgets
│   │   ├── auth/               # Authentication screens (5 items)
│   │   ├── chat/               # Chat screens
│   │   ├── home/               # Home screen
│   │   ├── product/            # Product-related screens (16 items)
│   │   ├── profile/            # Profile screens (2 items)
│   │   └── search/             # Search screen
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

**Purpose:** Global and feature-specific controllers.

**Contains:**
- `navigation_controller.dart` - Bottom navigation state
- `ads/` - Ad-related controllers (8 items)
- `auth/` - Authentication controllers (1 item)
- `profile/` - Profile controllers (2 items)

**Rules:**
- Feature-specific controllers organized in subdirectories
- Global controllers at root level
- Keep controllers minimal and focused
- Use GetX reactive state management

---

### `/lib/core/`

**Purpose:** Shared infrastructure, utilities, and reusable components used across all features.

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

### `/lib/models/`

**Purpose:** Centralized data models organized by domain.

**Contains:**
- `ad/` - Ad-related models
- `auth/` - Authentication models
- `category/` - Category models
- `user/` - User models
- `models.dart` - Barrel export

**Rules:**
- All models must have `fromJson()` and `toJson()` methods
- Include `copyWith()` for immutability
- Use enums for fixed value sets
- Models are immutable (use `final` fields)

---

### `/lib/repositories/`

**Purpose:** Repository implementations for data access.

**Contains:**
- `ad/` - Ad repositories (interface + implementation)
- `auth/` - Auth repositories (interface + implementation)
- `category/` - Category repositories (interface + implementation)
- `user/` - User repositories (interface + implementation)

**Rules:**
- Each domain has its own repository folder
- Contains both interface and implementation
- Extend BaseRepository for error handling
- Use ApiClient for HTTP requests
- Implement caching via LocalDataSource

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

### `/lib/services/`

**Purpose:** App-level services for API, authentication, storage, and loading.

**Contains:**
- `api_client.dart` - Dio-based HTTP client with interceptors
- `api_constants.dart` - API endpoint constants and configuration
- `api_interceptors.dart` - Auth, logging, and retry interceptors
- `api_service.dart` - Singleton API service wrapper
- `auth_service.dart` - Authentication service
- `loading_service.dart` - Loading state service
- `storage_service.dart` - Local storage service

**Rules:**
- Services are singletons
- Use ApiClient for all HTTP requests
- Define endpoints in ApiConstants
- Use interceptors for cross-cutting concerns

---

### `/lib/utils/`

**Purpose:** Utility functions and helpers.

**Contains:**
- `colors.dart` - Color utilities
- `haptic_feedback.dart` - Haptic feedback utilities
- `text_styles.dart` - Text style utilities
- `theme.dart` - Theme utilities
- `validators.dart` - Validation utilities

**Rules:**
- Pure utility functions only
- No state or side effects
- Well-documented with clear return types

---

### `/lib/views/`

**Purpose:** Screen widgets organized by feature.

**Contains:**
- `auth/` - Authentication screens (5 items)
- `chat/` - Chat screens
- `home/` - Home screen
- `product/` - Product-related screens (16 items)
- `profile/` - Profile screens (2 items)
- `search/` - Search screen

**Rules:**
- Each screen in its own file
- Organized by feature/domain
- Use GetView for controller access
- Keep UI logic minimal

---

## Ownership Rules

### Feature Ownership

| Feature | Owner | Scope |
|---------|-------|-------|
| Authentication | `views/auth/`, `controllers/auth/`, `repositories/auth/` | Login, register, OTP, password reset |
| Home | `views/home/` | Home screen, categories, product grid |
| Search | `views/search/` | Search, filters, sorting |
| Products | `views/product/`, `controllers/ads/`, `repositories/ad/` | Product details, ad management |
| Chat | `views/chat/` | Messaging list and conversations |
| Profile | `views/profile/`, `controllers/profile/`, `repositories/user/` | User profile, settings, account management |

### Core Infrastructure Ownership

| Component | Location | Used By |
|-----------|----------|---------|
| API Client | `services/api_client.dart` | All features with backend integration |
| API Constants | `services/api_constants.dart` | All API calls |
| Error Handling | `core/error/` | All features |
| Loading States | `core/loading/`, `services/loading_service.dart` | All features |
| Base Repository | `core/repositories/` | All feature repositories |
| Colors | `core/constants/app_colors.dart` | All features |
| Sizes | `core/constants/app_sizes.dart` | All features |
| Texts | `core/constants/app_texts.dart` | All features |
| Theme | `core/theme/app_theme.dart`, `utils/theme.dart` | App-wide |
| Models | `models/` | All features |
| Validators | `utils/validators.dart` | Forms |

---

## What Goes Where

### ✅ CORRECT Placement

| Code Type | Location |
|-----------|----------|
| Screen widget | `views/{feature}/{screen}_screen.dart` |
| Feature controller | `controllers/{feature}/{feature}_controller.dart` |
| Repository interface | `repositories/{feature}/{feature}_repository.dart` |
| Repository implementation | `repositories/{feature}/{feature}_repository_impl.dart` |
| API request model | `models/{feature}/{feature}_request.dart` |
| API response model | `models/{feature}/{feature}_response.dart` |
| Shared data model | `models/{domain}/{name}_model.dart` |
| API endpoint constant | `services/api_constants.dart` |
| Color constant | `core/constants/app_colors.dart` |
| Size constant | `core/constants/app_sizes.dart` |
| Text constant | `core/constants/app_texts.dart` |
| Reusable widget | `core/widgets/common_{name}.dart` |
| Validator function | `utils/validators.dart` |
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

// 6. Project imports - services
import '../../services/api_client.dart';

// 7. Project imports - repositories
import '../../repositories/ad/ad_repository.dart';

// 8. Project imports - local (same feature)
import 'home_controller.dart';
```

---

## Summary

- **Views own UI** - screen widgets organized by feature
- **Controllers manage state** - organized by domain in `/controllers/`
- **Repositories handle data** - organized by domain in `/repositories/`
- **Services provide operations** - app-level services in `/services/`
- **Core is shared** - API client, error handling, loading, constants, widgets
- **API integration** - all API calls through ApiClient with interceptors
- **Models are organized** - domain-specific models in `/models/`
- **No cross-feature imports** - use shared code in `/core/`
- **Constants over hardcoding** - always use `AppColors`, `AppSizes`, `AppTexts`, `ApiConstants`
- **Error boundaries** - wrap screens for proper error handling
- **Clean architecture** - clear separation between UI, business logic, and data layers
