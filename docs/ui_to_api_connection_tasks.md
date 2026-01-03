# 🔌 UI to API Connection Tasks

**Project:** Market Local Flutter App  
**Created:** January 3, 2026  
**Purpose:** Connect existing Flutter UI screens to backend API endpoints

---

## 📊 Current Status Overview

### ✅ Already Connected (Completed)
- **Authentication Flow** - Login, Register, OTP, Password Reset
- **User Profile** - Get/Update profile, Avatar upload
- **Categories** - Fetch and cache categories
- **Ads** - CRUD operations, favorites, mark as sold
- **Search** - Search with filters, pagination
- **Post Ad** - Create ad with image uploads

### 🔄 Needs Connection (Pending)

---

## 🎯 Priority 1: Critical UI Connections (Week 1)

### Task 1: Connect Home Screen to Live Ads API
**Task Code:** `UI-API-001`  
**Priority:** 🔴 Critical  
**Estimated Time:** 2-3 hours  
**Status:** [x]

**Current State:**
- HomeController uses mock data
- UI displays static product cards

**Required Changes:**
1. Update `HomeController.fetchFeaturedAds()` to call AdRepository
2. Update `HomeController.fetchRecentAds()` to call AdRepository
3. Implement pull-to-refresh with API call
4. Add pagination for infinite scroll
5. Handle loading states (show shimmer)
6. Handle error states (show error widget with retry)
7. Handle empty states (show empty state widget)
8. Cache ads locally for offline viewing

**Files to Modify:**
- `lib/features/home/home_controller.dart`
- `lib/features/home/home_screen.dart` (if needed for error handling)

**Acceptance Criteria:**
- [ ] Featured ads load from API on app launch
- [ ] Recent ads load with pagination
- [ ] Pull-to-refresh works correctly
- [ ] Loading shimmer displays during fetch
- [ ] Error handling with retry button works
- [ ] Empty state displays when no ads available

---

### Task 2: Connect Ad Details Screen to API
**Task Code:** `UI-API-002`  
**Priority:** 🔴 Critical  
**Estimated Time:** 2-3 hours  
**Status:** [ ]

**Current State:**
- AdDetailsController may use mock data
- Seller info might be static

**Required Changes:**
1. Fetch ad details from API using ad ID
2. Load seller profile information
3. Implement favorite toggle with API sync
4. Add "Contact Seller" button that checks authentication
5. Handle ad not found (404) errors
6. Implement share functionality
7. Track ad views (analytics)
8. Show related ads from API

**Files to Modify:**
- `lib/features/ad_details/ad_details_controller.dart`
- `lib/features/ad_details/ad_details_screen.dart`

**Acceptance Criteria:**
- [ ] Ad details load from API
- [ ] Favorite toggle syncs with backend
- [ ] Seller info displays correctly
- [ ] Contact seller requires authentication
- [ ] Related ads load from API
- [ ] 404 errors handled gracefully

---

### Task 3: Connect Search Screen to API
**Task Code:** `UI-API-003`  
**Priority:** 🔴 Critical  
**Estimated Time:** 3-4 hours  
**Status:** [ ]

**Current State:**
- SearchController may use mock search results
- Filters might not sync with API

**Required Changes:**
1. Connect search query to API endpoint
2. Implement real-time search with debouncing (500ms)
3. Connect all filters (category, price, location, condition)
4. Implement sort options (newest, price, relevance)
5. Add pagination for search results
6. Save search history to backend (if user logged in)
7. Implement saved searches functionality
8. Handle no results state

**Files to Modify:**
- `lib/features/search/search_controller.dart`
- `lib/features/search/search_screen.dart`

**Acceptance Criteria:**
- [ ] Search queries hit API with debouncing
- [ ] All filters work correctly
- [ ] Sort options apply to results
- [ ] Pagination works smoothly
- [ ] Search history saves (when logged in)
- [ ] No results state displays properly

---

### Task 4: Connect Favorites Screen to API
**Task Code:** `UI-API-004`  
**Priority:** 🟠 High  
**Estimated Time:** 2 hours  
**Status:** [ ]

**Current State:**
- Favorites might be stored locally only
- No sync with backend

**Required Changes:**
1. Fetch user's favorites from API on screen load
2. Sync local favorites with backend
3. Handle add/remove favorite with optimistic updates
4. Implement pull-to-refresh
5. Handle authentication requirement
6. Show empty state when no favorites
7. Add "Remove from favorites" swipe action

**Files to Modify:**
- `lib/features/favorites/favorites_controller.dart`
- `lib/features/favorites/favorites_screen.dart`

**Acceptance Criteria:**
- [ ] Favorites load from API
- [ ] Add/remove syncs with backend
- [ ] Optimistic UI updates work
- [ ] Requires user authentication
- [ ] Empty state displays correctly
- [ ] Swipe to remove works

---

### Task 5: Connect Profile Screen to API
**Task Code:** `UI-API-005`  
**Priority:** 🟠 High  
**Estimated Time:** 2-3 hours  
**Status:** [ ]

**Current State:**
- Profile data may be partially connected
- User's ads might use mock data

**Required Changes:**
1. Fetch user profile from API on screen load
2. Display user's posted ads from API
3. Show favorites count from API
4. Implement edit profile with API update
5. Add avatar upload functionality
6. Show user statistics (total ads, active ads, sold ads)
7. Handle profile not found errors
8. Add logout functionality

**Files to Modify:**
- `lib/features/profile/profile_controller.dart`
- `lib/features/profile/profile_screen.dart`
- `lib/features/profile/edit_profile_screen.dart`

**Acceptance Criteria:**
- [ ] Profile loads from API
- [ ] User's ads display correctly
- [ ] Edit profile updates backend
- [ ] Avatar upload works
- [ ] Statistics display accurately
- [ ] Logout clears tokens and navigates to login

---

## 🎯 Priority 2: Important UI Connections (Week 2)

### Task 6: Connect Post Ad Flow to API
**Task Code:** `UI-API-006`  
**Priority:** 🟠 High  
**Estimated Time:** 3-4 hours  
**Status:** [ ]

**Current State:**
- Post ad might be partially connected
- Image uploads may need refinement

**Required Changes:**
1. Verify category selection loads from API
2. Implement image upload with progress tracking
3. Handle validation errors from backend
4. Show upload progress for each image
5. Implement draft saving to backend
6. Add location picker with geocoding
7. Navigate to ad details after successful post
8. Handle network errors gracefully

**Files to Modify:**
- `lib/features/post_ad/post_ad_controller.dart`
- `lib/features/post_ad/post_ad_screen.dart`
- `lib/features/post_ad/widgets/image_picker_widget.dart`

**Acceptance Criteria:**
- [ ] Categories load from API
- [ ] Images upload with progress
- [ ] Validation errors display clearly
- [ ] Draft saving works
- [ ] Location picker functional
- [ ] Success navigation works
- [ ] Network errors handled

---

### Task 7: Connect My Ads Screen to API
**Task Code:** `UI-API-007`  
**Priority:** 🟡 Medium  
**Estimated Time:** 2-3 hours  
**Status:** [ ]

**Current State:**
- User's ads might use mock data
- Ad management actions may not be connected

**Required Changes:**
1. Fetch user's ads from API (active, sold, expired)
2. Implement filter by status (active/sold/expired)
3. Add edit ad functionality
4. Add delete ad with confirmation
5. Implement mark as sold toggle
6. Add promote ad option (if available)
7. Show ad statistics (views, favorites)
8. Implement pull-to-refresh

**Files to Modify:**
- `lib/features/profile/my_ads_screen.dart`
- `lib/features/profile/my_ads_controller.dart`

**Acceptance Criteria:**
- [ ] User's ads load from API
- [ ] Filter by status works
- [ ] Edit ad navigates correctly
- [ ] Delete ad works with confirmation
- [ ] Mark as sold syncs with backend
- [ ] Ad statistics display
- [ ] Pull-to-refresh works

---

### Task 8: Connect Category Screen to API
**Task Code:** `UI-API-008`  
**Priority:** 🟡 Medium  
**Estimated Time:** 2 hours  
**Status:** [ ]

**Current State:**
- Categories might be cached but not refreshed
- Subcategories may need connection

**Required Changes:**
1. Fetch categories from API on app launch
2. Implement category caching with TTL (24 hours)
3. Load subcategories dynamically
4. Show ad count per category from API
5. Handle category navigation to filtered search
6. Implement pull-to-refresh for categories
7. Show category icons from API URLs

**Files to Modify:**
- `lib/features/category/category_controller.dart`
- `lib/features/category/category_screen.dart`

**Acceptance Criteria:**
- [ ] Categories load from API
- [ ] Caching works with TTL
- [ ] Subcategories load dynamically
- [ ] Ad counts display correctly
- [ ] Navigation to search works
- [ ] Category icons load from URLs

---

### Task 9: Implement Authentication Guards
**Task Code:** `UI-API-009`  
**Priority:** 🟠 High  
**Estimated Time:** 2-3 hours  
**Status:** [ ]

**Current State:**
- Some screens may not check authentication
- No redirect to login when needed

**Required Changes:**
1. Add authentication check middleware
2. Redirect to login for protected screens:
   - Post Ad
   - Favorites
   - Profile
   - My Ads
   - Edit Profile
3. Show login prompt for protected actions:
   - Add to favorites
   - Contact seller
   - Post ad
4. Persist authentication state
5. Handle token expiration gracefully
6. Implement "Continue as Guest" option

**Files to Modify:**
- `lib/core/routes/app_router.dart`
- `lib/core/middleware/auth_middleware.dart` (create)
- Various screen controllers

**Acceptance Criteria:**
- [ ] Protected screens require login
- [ ] Login prompt shows for protected actions
- [ ] Token expiration handled
- [ ] Guest mode works for browsing
- [ ] Smooth redirect after login

---

### Task 10: Connect Chat/Messages Screen to API
**Task Code:** `UI-API-010`  
**Priority:** 🟡 Medium  
**Estimated Time:** 4-5 hours  
**Status:** [ ]

**Current State:**
- Chat might use mock data
- Real-time messaging not implemented

**Required Changes:**
1. Fetch conversations list from API
2. Load messages for selected conversation
3. Implement send message with API
4. Add image sharing in chat
5. Implement mark as read functionality
6. Show typing indicators (if API supports)
7. Add pagination for message history
8. Implement pull-to-refresh
9. Handle new message notifications

**Files to Modify:**
- `lib/features/chat/chat_controller.dart`
- `lib/features/chat/chat_screen.dart`
- `lib/features/chat/chat_detail_screen.dart`

**Acceptance Criteria:**
- [ ] Conversations load from API
- [ ] Messages load and display
- [ ] Send message works
- [ ] Image sharing functional
- [ ] Mark as read syncs
- [ ] Pagination works
- [ ] Notifications handled

---

## 🎯 Priority 3: Enhancement Connections (Week 3)

### Task 11: Implement Notifications Screen
**Task Code:** `UI-API-011`  
**Priority:** 🟢 Low  
**Estimated Time:** 2-3 hours  
**Status:** [ ]

**Required Changes:**
1. Fetch notifications from API
2. Implement mark as read
3. Add delete notification
4. Show notification types (message, ad update, system)
5. Implement notification navigation
6. Add pull-to-refresh
7. Show unread count badge

**Files to Create/Modify:**
- `lib/features/notifications/notifications_controller.dart`
- `lib/features/notifications/notifications_screen.dart`

---

### Task 12: Implement Settings Screen API Connections
**Task Code:** `UI-API-012`  
**Priority:** 🟢 Low  
**Estimated Time:** 2 hours  
**Status:** [ ]

**Required Changes:**
1. Fetch user settings from API
2. Update notification preferences
3. Update privacy settings
4. Sync app preferences with backend
5. Handle account deletion
6. Implement data export

**Files to Modify:**
- `lib/features/settings/settings_controller.dart`
- `lib/features/settings/settings_screen.dart`

---

### Task 13: Add Analytics Tracking
**Task Code:** `UI-API-013`  
**Priority:** 🟢 Low  
**Estimated Time:** 2-3 hours  
**Status:** [ ]

**Required Changes:**
1. Track screen views
2. Track button clicks
3. Track search queries
4. Track ad views
5. Track user actions (post ad, favorite, contact)
6. Send analytics to backend

**Files to Create:**
- `lib/core/services/analytics_service.dart`

---

## 📋 Testing Checklist

After completing all connections, verify:

### Authentication Flow
- [ ] Login works and saves token
- [ ] Register creates account and logs in
- [ ] Logout clears data and redirects
- [ ] Token refresh works automatically
- [ ] Password reset flow works end-to-end

### Home & Browse
- [ ] Home screen loads ads from API
- [ ] Categories display correctly
- [ ] Search returns relevant results
- [ ] Filters work as expected
- [ ] Pagination loads more items

### Ad Management
- [ ] Post ad creates ad on backend
- [ ] Images upload successfully
- [ ] Edit ad updates backend
- [ ] Delete ad removes from backend
- [ ] Mark as sold updates status

### User Profile
- [ ] Profile displays user data
- [ ] Edit profile updates backend
- [ ] Avatar upload works
- [ ] User's ads display correctly
- [ ] Favorites sync properly

### Interactions
- [ ] Add to favorites syncs
- [ ] Contact seller works
- [ ] Chat messages send/receive
- [ ] Notifications display

### Error Handling
- [ ] Network errors show retry option
- [ ] Validation errors display clearly
- [ ] 404 errors handled gracefully
- [ ] Token expiration redirects to login
- [ ] Offline mode shows appropriate message

---

## 🚀 Quick Start Commands

### To connect Home Screen:
```
"Implement UI-API-001: Connect Home Screen to live ads API"
```

### To connect Search:
```
"Implement UI-API-003: Connect Search Screen to API with filters"
```

### To implement auth guards:
```
"Implement UI-API-009: Add authentication guards to protected screens"
```

### To do multiple tasks:
```
"Implement UI-API-001, UI-API-002, and UI-API-003 to connect core browsing features"
```

---

## 📊 Summary

### Total Tasks: 13
- **Priority 1 (Critical):** 5 tasks - ~12-16 hours
- **Priority 2 (High/Medium):** 5 tasks - ~13-18 hours  
- **Priority 3 (Low):** 3 tasks - ~6-8 hours

### **Total Estimated Time:** 31-42 hours (1-1.5 weeks full-time)

---

## 🎯 Recommended Execution Order

**Week 1: Core Connections**
1. UI-API-001: Home Screen
2. UI-API-002: Ad Details
3. UI-API-003: Search
4. UI-API-004: Favorites
5. UI-API-009: Auth Guards

**Week 2: User Features**
6. UI-API-005: Profile
7. UI-API-006: Post Ad
8. UI-API-007: My Ads
9. UI-API-008: Categories
10. UI-API-010: Chat

**Week 3: Enhancements**
11. UI-API-011: Notifications
12. UI-API-012: Settings
13. UI-API-013: Analytics

---

*Last Updated: January 3, 2026*  
*Status: Ready to Start*  
*Next Step: UI-API-001 - Connect Home Screen*
