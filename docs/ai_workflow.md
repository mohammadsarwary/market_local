# AI Workflow Guide

This document defines how AI agents should work on the MarketLocal project. It provides step-by-step procedures for common tasks and guidelines for handling uncertainty.

---

## General Principles

### Before Starting Any Task

1. **Read the documentation** - Review `/docs/rules.md` and `/docs/structure.md`
2. **Identify your role** - Determine which role applies (see `/docs/roles.md`)
3. **Understand the scope** - Know what you can and cannot do
4. **Check the TODO** - See if the task is already tracked in `/docs/todo.md`

### During Task Execution

1. **Make minimal changes** - Only modify what's necessary
2. **Follow patterns** - Match existing code style
3. **Test changes** - Run `flutter analyze` before finishing
4. **Document changes** - Update relevant documentation

### After Completing a Task

1. **Verify no regressions** - Ensure existing functionality works
2. **Update TODO** - Mark completed items, add new ones
3. **Summarize changes** - Provide clear summary of what was done

---

## How to Start a Task

### Step 1: Understand the Request

```
Questions to answer:
- What is being asked?
- What files are involved?
- What is the expected outcome?
- Are there any constraints?
```

### Step 2: Identify Your Role

```
Role: [Flutter UI Engineer / Feature Developer / etc.]
Scope: [What you're allowed to do]
Risk Level: [Low / Medium / High]
```

### Step 3: Plan the Approach

```
1. List files to read
2. List files to modify
3. Identify potential risks
4. Define success criteria
```

### Step 4: Gather Context

```dart
// Read relevant files before making changes
// Understand existing patterns
// Check for dependencies
```

### Step 5: Execute Changes

```dart
// Make changes incrementally
// Test after each significant change
// Keep changes focused and minimal
```

### Step 6: Verify and Report

```bash
# Run analysis
flutter analyze

# Report results
- Files modified: [list]
- Changes made: [summary]
- Tests passed: [yes/no]
```

---

## How to Integrate an API Endpoint

### Step 1: Define Models

```dart
// Request model
class CreateAdRequest {
  final String title;
  final double price;
  
  CreateAdRequest({required this.title, required this.price});
  
  Map<String, dynamic> toJson() => {
    'title': title,
    'price': price,
  };
}

// Response model
class CreateAdResponse {
  final Ad ad;
  final String message;
  
  CreateAdResponse({required this.ad, required this.message});
  
  factory CreateAdResponse.fromJson(Map<String, dynamic> json) => 
    CreateAdResponse(
      ad: Ad.fromJson(json['data']['ad']),
      message: json['message'],
    );
}
```

### Step 2: Add Endpoint Constant

```dart
// lib/core/api/api_constants.dart
class AdEndpoints {
  static const String createAd = '/ads';
  static const String getAd = '/ads/{ad}';
}
```

### Step 3: Implement Repository

```dart
// Repository interface
abstract class AdRepository {
  Future<CreateAdResponse> createAd(CreateAdRequest request);
}

// Repository implementation
class AdRepositoryImpl extends BaseRepository implements AdRepository {
  final ApiClient apiClient;
  
  @override
  Future<CreateAdResponse> createAd(CreateAdRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        AdEndpoints.createAd,
        data: request.toJson(),
      );
      return CreateAdResponse.fromJson(response);
    });
  }
}
```

### Step 4: Create Service

```dart
// Service layer
class AdService {
  final AdRepository _repository;
  
  Future<CreateAdResponse> createAd({
    required String title,
    required double price,
  }) async {
    final request = CreateAdRequest(title: title, price: price);
    return await _repository.createAd(request);
  }
}
```

### Step 5: Use in Controller

```dart
class PostAdController extends GetxController {
  final AdService _service = AdService.instance;
  final RxBool isLoading = false.obs;
  
  Future<void> submitAd() async {
    isLoading.value = true;
    try {
      final response = await _service.createAd(
        title: titleController.text,
        price: double.parse(priceController.text),
      );
      Get.snackbar('Success', response.message);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

## How to Add a New Feature

### Phase 1: Planning

1. **Define the feature scope**
   - What screens are needed?
   - What data models are required?
   - What state needs to be managed?

2. **Check for conflicts**
   - Does this overlap with existing features?
   - Are there shared components to reuse?

3. **Plan the file structure**
   ```
   lib/features/{feature_name}/
   ├── data/
   │   └── mock_data.dart
   ├── {feature_name}_controller.dart
   └── {feature_name}_screen.dart
   ```

### Phase 2: Implementation

1. **Create the data model** (if needed)
   ```dart
   // lib/models/{name}_model.dart
   class NewModel {
     final String id;
     final String name;
     // ... fields
     
     const NewModel({required this.id, required this.name});
     
     factory NewModel.fromJson(Map<String, dynamic> json) => ...
     Map<String, dynamic> toJson() => ...
     NewModel copyWith({String? id, String? name}) => ...
   }
   ```

2. **Create mock data**
   ```dart
   // lib/features/{feature}/data/mock_data.dart
   class FeatureMockData {
     static const List<NewModel> items = [...];
   }
   ```

3. **Create the controller**
   ```dart
   // lib/features/{feature}/{feature}_controller.dart
   import 'package:get/get.dart';
   import 'data/mock_data.dart';
   
   class FeatureController extends GetxController {
     final RxBool isLoading = false.obs;
     
     List<NewModel> get items => FeatureMockData.items;
   }
   ```

4. **Create the screen**
   ```dart
   // lib/features/{feature}/{feature}_screen.dart
   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import '../../core/constants/app_colors.dart';
   import '../../core/constants/app_sizes.dart';
   import '{feature}_controller.dart';
   
   class FeatureScreen extends GetView<FeatureController> {
     const FeatureScreen({super.key});
     
     @override
     Widget build(BuildContext context) {
       return Scaffold(...);
     }
   }
   ```

5. **Register the controller**
   ```dart
   // lib/bindings/main_binding.dart
   Get.lazyPut<FeatureController>(() => FeatureController());
   ```

6. **Add the route**
   ```dart
   // lib/routes/app_router.dart
   GetPage(
     name: '/feature',
     page: () => const FeatureScreen(),
   ),
   ```

### Phase 3: Verification

1. Run `flutter analyze`
2. Test navigation to the new screen
3. Verify all states work correctly
4. Check for any UI issues

---

## How to Modify Existing Code

### Step 1: Read First

```dart
// Always read the file before modifying
// Understand the existing structure
// Identify patterns being used
```

### Step 2: Plan Changes

```
- What needs to change?
- What should NOT change?
- Are there dependencies?
```

### Step 3: Make Minimal Edits

```dart
// ❌ WRONG - Rewriting entire file
// ✅ CORRECT - Targeted edits only
```

### Step 4: Preserve Patterns

```dart
// Match existing:
// - Naming conventions
// - Code style
// - Import order
// - Comment style
```

### Step 5: Verify

```bash
flutter analyze
# Check for errors and warnings
```

---

## How to Fix a Bug

### Step 1: Reproduce

```
- Understand the bug
- Identify the symptoms
- Find the root cause
```

### Step 2: Locate

```dart
// Find the exact file and line
// Understand why it's happening
// Check for related issues
```

### Step 3: Fix

```dart
// Make the minimal fix
// Don't refactor unrelated code
// Don't change behavior beyond the fix
```

### Step 4: Verify

```
- Bug is fixed
- No new bugs introduced
- Existing functionality preserved
```

---

## How to Handle Uncertainty

### When You're Not Sure What to Do

1. **Stop** - Don't guess
2. **Ask** - Request clarification
3. **Document** - Note what's unclear

```
I need clarification on:
- [Specific question 1]
- [Specific question 2]

Options I see:
- Option A: [description]
- Option B: [description]

Which approach should I take?
```

### When You Find Conflicting Information

1. **Document the conflict**
2. **List the options**
3. **Ask for guidance**

```
I found conflicting information:
- Source 1 says: [X]
- Source 2 says: [Y]

Which should I follow?
```

### When You Encounter an Error

1. **Read the error message**
2. **Identify the cause**
3. **Try to fix it**
4. **If stuck, ask for help**

```
I encountered an error:
- Error: [message]
- File: [path]
- Line: [number]

I tried:
- [Attempt 1]
- [Attempt 2]

The error persists. How should I proceed?
```

### When a Task Seems Outside Your Role

1. **Stop** - Don't proceed
2. **Identify the correct role**
3. **Escalate**

```
This task requires [Role X] permissions.
I am operating as [Role Y].

Should I:
- Proceed anyway?
- Wait for [Role X]?
- Get approval?
```

---

## Common Workflows

### Adding a New Constant

```dart
// 1. Identify the type (color, size, text)
// 2. Open the appropriate file
// 3. Add the constant following existing patterns
// 4. Use the constant in your code

// Example: Adding a new color
// lib/core/constants/app_colors.dart
static const Color newColor = Color(0xFF123456);
```

### Creating a Reusable Widget

```dart
// 1. Verify it's used in 2+ places
// 2. Create in lib/core/widgets/
// 3. Make it fully customizable
// 4. Add documentation

/// A reusable widget for [purpose].
/// 
/// Example:
/// ```dart
/// NewWidget(
///   property: value,
/// )
/// ```
class NewWidget extends StatelessWidget {
  final String property;
  
  const NewWidget({super.key, required this.property});
  
  @override
  Widget build(BuildContext context) => ...;
}
```

### Updating a Model

```dart
// 1. Add new fields
// 2. Update constructor
// 3. Update fromJson
// 4. Update toJson
// 5. Update copyWith
// 6. Update mock data
```

### Adding a New Screen to Navigation

```dart
// 1. Create the screen widget
// 2. Create the controller (if needed)
// 3. Register controller in main_binding.dart
// 4. Add route in app_router.dart
// 5. Navigate using Get.toNamed('/route')
```

---

## Quality Checklist

Before completing any task, verify:

### Code Quality
- [ ] No analyzer errors
- [ ] No analyzer warnings (or documented exceptions)
- [ ] Follows naming conventions
- [ ] Uses constants (no hardcoded values)
- [ ] Uses typed models (no raw Maps)
- [ ] Proper null handling

### Architecture
- [ ] Files in correct locations
- [ ] No cross-feature imports
- [ ] Controllers registered in bindings
- [ ] Routes defined in router

### Documentation
- [ ] Code is self-documenting
- [ ] Complex logic has comments
- [ ] Public APIs have doc comments
- [ ] TODO updated if needed

### Testing
- [ ] Changes tested manually
- [ ] No regressions introduced
- [ ] Edge cases considered

---

## Error Recovery

### If You Break Something

1. **Stop immediately**
2. **Identify what broke**
3. **Revert if possible**
4. **Report the issue**

### If You're Stuck in a Loop

1. **Stop and reassess**
2. **Try a different approach**
3. **Ask for help if needed**

### If You Made Unauthorized Changes

1. **Acknowledge the mistake**
2. **Revert the changes**
3. **Ask for proper authorization**

---

## Communication Templates

### Starting a Task

```
Starting task: [description]
Role: [role]
Files to modify: [list]
Expected outcome: [description]
```

### Completing a Task

```
Task completed: [description]

Changes made:
- [file]: [change description]
- [file]: [change description]

Verification:
- flutter analyze: [pass/fail]
- Manual testing: [pass/fail]

Notes: [any additional information]
```

### Reporting an Issue

```
Issue encountered: [description]

Context:
- Task: [what I was doing]
- File: [where]
- Error: [message]

Attempted solutions:
1. [attempt 1]
2. [attempt 2]

Current status: [blocked/workaround found/resolved]
```

---

## Summary

1. **Read before writing** - Understand context
2. **Plan before coding** - Know what you'll change
3. **Minimal changes** - Only modify what's necessary
4. **Follow patterns** - Match existing code
5. **Verify always** - Run analysis, test manually
6. **Ask when unsure** - Don't guess
7. **Document changes** - Keep records updated
