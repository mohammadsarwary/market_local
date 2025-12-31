# MarketLocal

A modern, feature-rich local marketplace mobile application built with Flutter. Similar to Divar, OLX, or Craigslist, this app enables users to buy and sell items locally.

## Project Status

| Component | Status |
|-----------|--------|
| UI/UX Design | ✅ Complete |
| Screen Implementation | ✅ Complete |
| Navigation | ✅ Complete |
| State Management | ✅ Complete (GetX) |
| Models & Data Layer | ✅ Complete |
| Backend Integration | ⏳ Pending |
| Authentication | ⏳ Pending |
| Real-time Chat | ⏳ Pending |

**Current Phase:** UI Complete, Backend Integration Pending

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.8+ |
| Language | Dart |
| State Management | GetX |
| Navigation | GetX Navigation |
| Image Caching | cached_network_image |
| Architecture | Feature-based Clean Architecture |

## Features

- **Home Screen** - Browse listings with category filters and search
- **Search & Filter** - Advanced filtering by category, price, condition
- **Post Ad** - Multi-step ad creation with image upload
- **Chat** - Messaging interface for buyer-seller communication
- **Profile** - User profile management with listings and settings
- **Ad Details** - Detailed product view with seller information

## Project Structure

```
lib/
├── bindings/           # GetX dependency injection
├── controllers/        # Global controllers (navigation)
├── core/
│   ├── constants/      # App-wide constants (colors, sizes, texts)
│   ├── theme/          # Theme configuration
│   ├── utils/          # Utility functions (validators)
│   └── widgets/        # Reusable widgets
├── features/           # Feature modules
│   ├── home/
│   ├── search/
│   ├── post_ad/
│   ├── chat/
│   ├── profile/
│   └── ad_details/
├── models/             # Data models
├── routes/             # Route configuration
└── main.dart           # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK 3.8.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android Emulator or iOS Simulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd market_local
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Running on Specific Platforms

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

## Architecture

This project follows **Feature-based Clean Architecture**:

- Each feature is self-contained with its own controller, screen, and data
- Shared code lives in `core/` directory
- Models are centralized in `models/` directory
- Global state management via GetX bindings

## Important Rules

### DO NOT

- ❌ Modify existing UI designs
- ❌ Redesign screens or layouts
- ❌ Change color schemes or typography
- ❌ Introduce backend logic without approval
- ❌ Add new dependencies without documentation
- ❌ Break existing navigation flows

### MUST DO

- ✅ Follow existing code patterns
- ✅ Use constants from `core/constants/`
- ✅ Use models instead of raw Maps
- ✅ Maintain feature isolation
- ✅ Write clean, readable code
- ✅ Test changes before committing

## Documentation

Comprehensive documentation is available in the `/docs` directory:

### Core Documentation
- **[Documentation](docs/documentation.md)** - Complete developer guide with API reference
- [Project Structure](docs/structure.md) - Folder organization and ownership
- [Roles](docs/roles.md) - AI agent role definitions
- [Rules](docs/rules.md) - Strict project rules and conventions
- [TODO](docs/todo.md) - Task backlog and roadmap
- [AI Workflow](docs/ai_workflow.md) - How AI agents should work

### Developer Guide Highlights

#### Architecture Overview
- **Feature-based Structure**: Each feature organized in its own directory
- **GetX State Management**: Reactive state management throughout the app
- **Error Boundaries**: Isolated error handling per screen
- **Common Widgets**: Reusable UI components for consistency

#### Key Components
- **Controllers**: Navigation, Home, Search, and feature-specific controllers
- **Models**: AdModel, CategoryModel, UserModel with JSON serialization
- **Common Widgets**: AppTextField, AppButton, AppCard, AppContainer
- **Error Handling**: AppErrorHandler, ErrorBoundary, ErrorController
- **Loading System**: LoadingController, LoadingWidgets, LoadingUtils

#### Quick Start Examples

```dart
// Navigation
final navController = Get.find<NavigationController>();
navController.changeIndex(2);

// Search
final searchController = Get.put(SearchController());
searchController.updatePriceRange(RangeValues(100, 500));

// Common Widgets
AppTextField(
  controller: _controller,
  hintText: 'Enter text',
  validator: (value) => value!.isEmpty ? 'Required' : null,
)

AppButton(
  text: 'Submit',
  onPressed: () => _handleSubmit(),
  isLoading: _isLoading,
)
```

#### Error Handling
```dart
ErrorBoundary(
  boundaryName: 'My Screen',
  child: MyScreen(),
)
```

#### Loading States
```dart
final loadingController = Get.find<LoadingController>();
loadingController.setGlobalLoadingState(LoadingState.loading);
```

## Contributing

This project is maintained by AI agents following strict guidelines. All contributions must adhere to the rules defined in `/docs/rules.md`.

## License

This project is proprietary. All rights reserved.
