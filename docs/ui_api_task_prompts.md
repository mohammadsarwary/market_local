# UI-to-API Connection Task Prompts

Professional prompts for connecting Flutter UI screens to backend API endpoints.

---

## Task UI-API-001: Connect Home Screen to Live Ads API

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-001
Task: Connect Home Screen to live ads API

Current State:
- HomeController uses mock data
- UI displays static product cards

Your Mission:
Connect the Home Screen to fetch real ads from the backend API, implementing proper loading states, error handling, and pagination.

Rules:
- Read /docs/rules.md - Follow all project rules
- Use existing AdRepository for API calls
- Implement proper loading states (shimmer effects)
- Handle errors gracefully with retry mechanism
- DO NOT modify UI design or colors
- Follow existing patterns in other controllers
- Use GetX reactive state management
- Implement pagination for infinite scroll
- Cache ads for offline viewing

Required Changes:
1. Update HomeController.fetchFeaturedAds() to call AdRepository.getFeaturedAds()
2. Update HomeController.fetchRecentAds() to call AdRepository.getRecentAds()
3. Implement pull-to-refresh functionality
4. Add pagination with infinite scroll
5. Handle loading states (show shimmer during fetch)
6. Handle error states (show error widget with retry button)
7. Handle empty states (show empty state widget)
8. Implement local caching for offline viewing

Files to Modify:
- lib/features/home/home_controller.dart
- lib/features/home/home_screen.dart (only if needed for error handling)

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - Pull-to-refresh works
   - Pagination loads more items
   - Error handling with retry works
   - Loading shimmer displays correctly
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-001 status from [ ] to [x]
```

---

## Task UI-API-002: Connect Ad Details Screen to API

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-002
Task: Connect Ad Details Screen to API

Current State:
- AdDetailsController may use mock data
- Seller information might be static

Your Mission:
Connect the Ad Details Screen to fetch real ad data from the backend API, including seller information, favorite status, and related ads.

Rules:
- Read /docs/rules.md - Follow all project rules
- Use existing AdRepository for API calls
- Handle 404 errors gracefully (ad not found)
- Implement favorite toggle with optimistic updates
- DO NOT modify UI design or colors
- Follow existing patterns
- Require authentication for "Contact Seller"
- Handle network errors with retry

Required Changes:
1. Fetch ad details from API using ad ID parameter
2. Load seller profile information from API
3. Implement favorite toggle with backend sync
4. Add authentication check for "Contact Seller" button
5. Handle ad not found (404) errors gracefully
6. Implement share functionality
7. Track ad views for analytics
8. Show related ads from API

Files to Modify:
- lib/features/ad_details/ad_details_controller.dart
- lib/features/ad_details/ad_details_screen.dart

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - Ad details load correctly
   - Favorite toggle syncs with backend
   - Contact seller requires login
   - 404 errors show appropriate message
   - Related ads display
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-002 status from [ ] to [x]
```

---

## Task UI-API-003: Connect Search Screen to API

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-003
Task: Connect Search Screen to API with filters and pagination

Current State:
- SearchController may use mock search results
- Filters might not sync with API

Your Mission:
Connect the Search Screen to the backend search API with full filter support, debouncing, and pagination.

Rules:
- Read /docs/rules.md - Follow all project rules
- Use existing SearchRepository for API calls
- Implement search debouncing (500ms delay)
- Handle all filter types (category, price, location, condition)
- DO NOT modify UI design or colors
- Follow existing patterns
- Implement pagination for results
- Cache search results temporarily

Required Changes:
1. Connect search query to API endpoint with debouncing
2. Implement real-time search with 500ms debounce
3. Connect all filters: category, price range, location, condition
4. Implement sort options (newest, price low-high, price high-low, relevance)
5. Add pagination for search results
6. Save search history to backend (if user logged in)
7. Implement saved searches functionality
8. Handle no results state appropriately

Files to Modify:
- lib/features/search/search_controller.dart
- lib/features/search/search_screen.dart

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - Search with debouncing works
   - All filters apply correctly
   - Sort options work
   - Pagination loads more results
   - No results state displays
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-003 status from [ ] to [x]
```

---

## Task UI-API-004: Connect Favorites Screen to API

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-004
Task: Connect Favorites Screen to API with sync

Current State:
- Favorites might be stored locally only
- No backend synchronization

Your Mission:
Connect the Favorites Screen to fetch and sync user's favorite ads with the backend API.

Rules:
- Read /docs/rules.md - Follow all project rules
- Use existing AdRepository for favorites API calls
- Implement optimistic updates for better UX
- Require user authentication
- DO NOT modify UI design or colors
- Follow existing patterns
- Handle sync conflicts gracefully

Required Changes:
1. Fetch user's favorites from API on screen load
2. Sync local favorites with backend
3. Handle add/remove favorite with optimistic updates
4. Implement pull-to-refresh
5. Require authentication (redirect to login if not authenticated)
6. Show empty state when no favorites
7. Add "Remove from favorites" swipe action

Files to Modify:
- lib/features/favorites/favorites_controller.dart
- lib/features/favorites/favorites_screen.dart

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - Favorites load from API
   - Add/remove syncs with backend
   - Optimistic updates work smoothly
   - Authentication required
   - Empty state displays
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-004 status from [ ] to [x]
```

---

## Task UI-API-005: Connect Profile Screen to API

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-005
Task: Connect Profile Screen to API

Current State:
- Profile data may be partially connected
- User's ads might use mock data

Your Mission:
Connect the Profile Screen to fetch user profile data, posted ads, and statistics from the backend API.

Rules:
- Read /docs/rules.md - Follow all project rules
- Use existing UserRepository for profile API calls
- Use existing AdRepository for user's ads
- Handle profile updates with validation
- DO NOT expose sensitive data (tokens, passwords)
- DO NOT modify UI design or colors
- Follow existing patterns
- Implement avatar upload with progress

Required Changes:
1. Fetch user profile from API on screen load
2. Display user's posted ads from API
3. Show favorites count from API
4. Implement edit profile with API update
5. Add avatar upload functionality with progress tracking
6. Show user statistics (total ads, active ads, sold ads)
7. Handle profile not found errors
8. Add logout functionality (clear tokens and navigate to login)

Files to Modify:
- lib/features/profile/profile_controller.dart
- lib/features/profile/profile_screen.dart
- lib/features/profile/edit_profile_screen.dart

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - Profile loads from API
   - User's ads display correctly
   - Edit profile updates backend
   - Avatar upload works with progress
   - Logout clears data and redirects
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-005 status from [ ] to [x]
```

---

## Task UI-API-006: Connect Post Ad Flow to API

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-006
Task: Connect Post Ad Flow to API with image uploads

Current State:
- Post ad might be partially connected
- Image uploads may need refinement

Your Mission:
Ensure the Post Ad flow is fully connected to the backend API with proper image upload, validation, and error handling.

Rules:
- Read /docs/rules.md - Follow all project rules
- Use existing AdRepository for ad creation
- Implement image upload with progress tracking
- Handle validation errors from backend
- DO NOT modify UI design or colors
- Follow existing patterns
- Support draft saving
- Handle network errors gracefully

Required Changes:
1. Verify category selection loads from API
2. Implement image upload with progress tracking for each image
3. Handle validation errors from backend (display field-specific errors)
4. Show upload progress for each image
5. Implement draft saving to backend
6. Add location picker with geocoding
7. Navigate to ad details after successful post
8. Handle network errors with retry option

Files to Modify:
- lib/features/post_ad/post_ad_controller.dart
- lib/features/post_ad/post_ad_screen.dart
- lib/features/post_ad/widgets/image_picker_widget.dart

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - Categories load from API
   - Images upload with progress
   - Validation errors display clearly
   - Draft saving works
   - Success navigation works
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-006 status from [ ] to [x]
```

---

## Task UI-API-007: Connect My Ads Screen to API

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-007
Task: Connect My Ads Screen to API with management actions

Current State:
- User's ads might use mock data
- Ad management actions may not be connected

Your Mission:
Connect the My Ads Screen to fetch user's ads from the backend and implement all ad management actions.

Rules:
- Read /docs/rules.md - Follow all project rules
- Use existing AdRepository for API calls
- Implement confirmation dialogs for destructive actions
- Handle optimistic updates for better UX
- DO NOT modify UI design or colors
- Follow existing patterns
- Show ad statistics (views, favorites)

Required Changes:
1. Fetch user's ads from API (active, sold, expired)
2. Implement filter by status (active/sold/expired)
3. Add edit ad functionality (navigate to edit screen)
4. Add delete ad with confirmation dialog
5. Implement mark as sold toggle
6. Add promote ad option (if available in API)
7. Show ad statistics (views, favorites count)
8. Implement pull-to-refresh

Files to Modify:
- lib/features/profile/my_ads_screen.dart
- lib/features/profile/my_ads_controller.dart

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - User's ads load from API
   - Filter by status works
   - Edit ad navigates correctly
   - Delete ad works with confirmation
   - Mark as sold syncs
   - Ad statistics display
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-007 status from [ ] to [x]
```

---

## Task UI-API-008: Connect Category Screen to API

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-008
Task: Connect Category Screen to API with caching

Current State:
- Categories might be cached but not refreshed
- Subcategories may need connection

Your Mission:
Connect the Category Screen to fetch categories from the backend API with proper caching and refresh mechanism.

Rules:
- Read /docs/rules.md - Follow all project rules
- Use existing CategoryRepository for API calls
- Implement caching with TTL (24 hours)
- Load category icons from API URLs
- DO NOT modify UI design or colors
- Follow existing patterns
- Handle subcategories dynamically

Required Changes:
1. Fetch categories from API on app launch
2. Implement category caching with TTL (24 hours)
3. Load subcategories dynamically when category selected
4. Show ad count per category from API
5. Handle category navigation to filtered search
6. Implement pull-to-refresh for categories
7. Show category icons from API URLs (use cached_network_image)

Files to Modify:
- lib/features/category/category_controller.dart
- lib/features/category/category_screen.dart

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - Categories load from API
   - Caching works (check by going offline)
   - Subcategories load dynamically
   - Ad counts display correctly
   - Navigation to search works
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-008 status from [ ] to [x]
```

---

## Task UI-API-009: Implement Authentication Guards

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-009
Task: Implement authentication guards for protected screens

Current State:
- Some screens may not check authentication
- No redirect to login when needed

Your Mission:
Implement authentication middleware to protect screens that require login and show appropriate prompts for protected actions.

Rules:
- Read /docs/rules.md - Follow all project rules
- Use existing AuthService to check authentication
- Implement smooth redirect after login
- DO NOT modify UI design or colors
- Follow existing patterns
- Handle token expiration gracefully
- Support "Continue as Guest" for browsing

Required Changes:
1. Create authentication middleware for route protection
2. Protect screens that require login:
   - Post Ad Screen
   - Favorites Screen
   - Profile Screen
   - My Ads Screen
   - Edit Profile Screen
3. Show login prompt for protected actions:
   - Add to favorites
   - Contact seller
   - Post ad button
4. Persist authentication state across app restarts
5. Handle token expiration with redirect to login
6. Implement "Continue as Guest" option for browsing
7. Redirect to intended screen after successful login

Files to Create/Modify:
- lib/core/middleware/auth_middleware.dart (create)
- lib/core/routes/app_router.dart
- lib/features/home/home_controller.dart
- lib/features/ad_details/ad_details_controller.dart

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - Protected screens require login
   - Login prompt shows for protected actions
   - Token expiration handled
   - Guest mode works for browsing
   - Redirect after login works
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-009 status from [ ] to [x]
```

---

## Task UI-API-010: Connect Chat/Messages Screen to API

```
You are working on the MarketLocal Flutter project as an Integration Engineer.

Task Code: UI-API-010
Task: Connect Chat/Messages Screen to API

Current State:
- Chat might use mock data
- Real-time messaging not implemented

Your Mission:
Connect the Chat Screen to the backend messaging API with conversation list, message sending, and image sharing.

Rules:
- Read /docs/rules.md - Follow all project rules
- Create ChatRepository for messaging API calls
- Implement pagination for message history
- Handle image uploads in chat
- DO NOT modify UI design or colors
- Follow existing patterns
- Implement optimistic updates for sent messages
- Handle message delivery status

Required Changes:
1. Fetch conversations list from API
2. Load messages for selected conversation with pagination
3. Implement send message with API call
4. Add image sharing in chat with upload
5. Implement mark as read functionality
6. Show typing indicators (if API supports)
7. Add pagination for message history (load older messages)
8. Implement pull-to-refresh for conversations
9. Handle new message notifications

Files to Create/Modify:
- lib/features/chat/repositories/chat_repository.dart (create)
- lib/features/chat/repositories/chat_repository_impl.dart (create)
- lib/features/chat/chat_controller.dart
- lib/features/chat/chat_screen.dart
- lib/features/chat/chat_detail_screen.dart

After completion:
1. Run flutter analyze
2. Test on device/emulator:
   - Conversations load from API
   - Messages load and display correctly
   - Send message works
   - Image sharing functional
   - Mark as read syncs
   - Pagination works
3. Update /docs/ui_to_api_connection_tasks.md - change UI-API-010 status from [ ] to [x]
```

---

## General Guidelines for All Tasks

### Before Starting Any Task:
1. Read `/docs/rules.md` - Understand all project rules
2. Read `/docs/structure.md` - Understand folder structure
3. Check existing repository implementations for patterns
4. Review the specific task requirements carefully

### During Implementation:
- Use existing repositories (don't create new ones unless specified)
- Follow GetX state management patterns
- Implement proper error handling with user-friendly messages
- Add loading states for all async operations
- Use optimistic updates where appropriate
- Handle network errors with retry mechanisms
- Cache data when appropriate for offline support
- DO NOT modify UI designs, colors, or layouts
- DO NOT expose sensitive data (tokens, passwords)
- Follow existing code patterns and conventions

### Testing Requirements:
- Run `flutter analyze` and fix any issues
- Test on physical device or emulator
- Test all success scenarios
- Test all error scenarios
- Test offline behavior
- Test loading states
- Verify data persistence

### After Completion:
1. Run `flutter analyze` - ensure no errors
2. Test thoroughly on device/emulator
3. Update task status in `/docs/ui_to_api_connection_tasks.md`
4. Document any issues or blockers encountered

---

## Quick Command Reference

### To start a task:
```
"Implement UI-API-001: Connect Home Screen to live ads API"
```

### To do multiple tasks:
```
"Implement UI-API-001, UI-API-002, and UI-API-003"
```

### To check task status:
```
"Show status of UI-to-API connection tasks"
```

---

*Last Updated: January 3, 2026*
