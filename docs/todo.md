# Project TODO

This document tracks all pending tasks organized by priority and timeline.

**Last Updated:** January 2026

---

## Legend

### Status
- `[ ]` - Not started
- `[~]` - In progress
- `[x]` - Completed
- `[!]` - Blocked

### Task Code Format
Each task has a unique code: `[CATEGORY]-[NUMBER]`

| Prefix | Category |
|--------|----------|
| `UI` | UI Polish & Visual |
| `ANI` | Animations |
| `STM` | State Management |
| `CQ` | Code Quality |
| `AUTH` | Authentication |
| `CHAT` | Chat System |
| `SRCH` | Search & Filters |
| `POST` | Post Ad Flow |
| `PROF` | Profile & Settings |
| `API` | Backend/API Integration |
| `RT` | Real-time Features |
| `ADM` | Admin Panel |
| `ADV` | Advanced Features |
| `PERF` | Performance |
| `TEST` | Testing |
| `L10N` | Localization |
| `A11Y` | Accessibility |
| `DEBT` | Technical Debt |

---

## Short-Term (1-2 Weeks)

### UI Polish

| Code | Status | Task | Role |
|------|--------|------|------|
| `UI-001` | [x] | Add loading shimmer effects to product grids | UI Engineer |
| `UI-002` | [x] | Add pull-to-refresh on list screens | UI Engineer |
| `UI-003` | [x] | Implement empty state widgets for all lists | UI Engineer |
| `UI-004` | [x] | Add error state widgets with retry buttons | UI Engineer |
| `UI-005` | [x] | Improve image loading placeholders | UI Engineer |
| `UI-006` | [x] | Add haptic feedback on button taps | UI Engineer |
| `UI-007` | [x] | Implement skeleton loading for profile screen | UI Engineer |
| `UI-008` | [x] | Add smooth page transitions between screens | UI Engineer |
| `UI-009` | [x] | Fix any remaining overflow issues on small screens | UI Engineer |
| `UI-010` | [x] | Add scroll-to-top button on long lists | UI Engineer |

### Animations

| Code | Status | Task | Role |
|------|--------|------|------|
| `ANI-001` | [x] | Add hero animations for product images | UI Engineer |
| `ANI-002` | [x] | Implement fade transitions for tab switches | UI Engineer |
| `ANI-003` | [x] | Add scale animation on favorite button tap | UI Engineer |
| `ANI-004` | [x] | Implement slide-in animation for bottom sheets | UI Engineer |
| `ANI-005` | [x] | Add staggered animation for grid items | UI Engineer |

### State Management

| Code | Status | Task | Role |
|------|--------|------|------|
| `STM-001` | [x] | Implement proper loading states in all controllers | Feature Dev |
| `STM-002` | [x] | Add error handling states to controllers | Feature Dev |
| `STM-003` | [x] | Implement retry logic for failed operations | Feature Dev |
| `STM-004` | [x] | Add state persistence for filters | Feature Dev |
| `STM-005` | [x] | Implement optimistic updates for favorites | Feature Dev |

### Code Quality

| Code | Status | Task | Role |
|------|--------|------|------|
| `CQ-001` | [x] | Remove all remaining `withOpacity` deprecation warnings | Refactor Agent |
| `CQ-002` | [x] | Add `const` constructors where missing | Refactor Agent |
| `CQ-003` | [x] | Remove unused imports across all files | Refactor Agent |
| `CQ-004` | [x] | Add documentation comments to public APIs | Arch Guardian |
| `CQ-005` | [x] | Ensure consistent error handling patterns | Arch Guardian |

---

## Mid-Term (1-2 Months)

### Authentication

| Code | Status | Task | Role |
|------|--------|------|------|
| `AUTH-001` | [x] | Design authentication flow (login, register, forgot password) | Feature Dev |
| `AUTH-002` | [x] | Create auth screens (login, register, OTP verification) | Feature Dev |
| `AUTH-003` | [x] | Implement AuthController | Feature Dev |
| `AUTH-004` | [x] | Add secure token storage<br>**Description:** Implement secure storage for authentication tokens (access token, refresh token) using flutter_secure_storage or similar package. Tokens must be encrypted at rest and protected from unauthorized access. Include token expiry handling and automatic cleanup on logout. | Integration Eng |
| `AUTH-005` | [x] | Implement session management<br>**Description:** Create session management system to track user authentication state across app lifecycle. Handle token refresh automatically before expiry, detect invalid sessions, and redirect to login when needed. Implement session timeout after inactivity and persist session state across app restarts. | Integration Eng |
| `AUTH-006` | [ ] | Add biometric authentication option<br>**Description:** Integrate biometric authentication (fingerprint, Face ID) using local_auth package. Allow users to enable/disable biometric login in settings. Implement fallback to password if biometric fails. Check device capability before showing option and handle all error cases gracefully. | Feature Dev |
| `AUTH-007` | [ ] | Implement social login (Google, Apple)<br>**Description:** Add OAuth integration for Google Sign-In and Apple Sign-In. Configure platform-specific settings (iOS capabilities, Android SHA keys). Handle token exchange with backend, account linking for existing users, and error scenarios (cancelled login, network issues). Ensure compliance with platform guidelines. | Integration Eng |
| `AUTH-008` | [ ] | Add logout functionality<br>**Description:** Implement complete logout flow that clears all user data (tokens, cached data, preferences). Revoke tokens on backend, clear secure storage, reset all controllers to initial state, and navigate to login screen. Add confirmation dialog and handle logout from multiple entry points (settings, profile). | Feature Dev |
| `AUTH-009` | [ ] | Implement account deletion flow<br>**Description:** Create account deletion feature with proper warnings about data loss. Require re-authentication before deletion, show confirmation dialog explaining consequences (deleted ads, lost messages, etc.). Call backend deletion endpoint, clear all local data, and navigate to welcome screen. Consider grace period for account recovery. | Feature Dev |

### Chat System

| Code | Status | Task | Role |
|------|--------|------|------|
| `CHAT-001` | [ ] | Design chat data models (Message, Conversation)<br>**Description:** Create data models for chat system including Message (id, senderId, receiverId, content, timestamp, readStatus, type) and Conversation (id, participants, lastMessage, unreadCount, adReference). Include JSON serialization, proper typing, and support for different message types (text, image, system). | Feature Dev |
| `CHAT-002` | [ ] | Create ChatDetailScreen for individual conversations<br>**Description:** Build chat detail screen with message list, input field, and send button. Display messages in chronological order with sender/receiver alignment, timestamps, and read status. Include app bar with user info and ad reference. Handle keyboard behavior, scroll to bottom on new messages, and show loading states. | Feature Dev |
| `CHAT-003` | [ ] | Implement real-time message updates (mock first)<br>**Description:** Create mock real-time messaging using Stream controllers and timers to simulate incoming messages. Update conversation list and chat detail screen reactively. This provides foundation for WebSocket integration later. Include message delivery states and optimistic UI updates. | Feature Dev |
| `CHAT-004` | [ ] | Add typing indicators<br>**Description:** Implement animated typing indicator widget that shows when other user is typing. Display "User is typing..." text with animated dots below chat input. Handle show/hide logic based on typing events. Create smooth fade-in/out animations and ensure proper positioning in message list. | UI Engineer |
| `CHAT-005` | [ ] | Implement read receipts<br>**Description:** Add read receipt functionality showing message status (sent, delivered, read) with visual indicators (checkmarks). Update message status when viewed by recipient. Display read timestamp on long-press. Mark all messages as read when conversation is opened and sync status with backend. | Feature Dev |
| `CHAT-006` | [ ] | Add image sharing in chat<br>**Description:** Enable image sharing in conversations using image_picker. Add camera/gallery selection, image preview before sending, and compression. Display images in chat with thumbnail and full-screen view on tap. Show upload progress indicator and handle upload failures with retry option. | Feature Dev |
| `CHAT-007` | [ ] | Implement chat notifications<br>**Description:** Set up local and push notifications for new messages using firebase_messaging or similar. Show notification with sender name and message preview. Handle notification tap to open specific conversation. Implement notification badges, sound, and vibration. Respect user notification preferences and Do Not Disturb mode. | Integration Eng |
| `CHAT-008` | [ ] | Add message search functionality<br>**Description:** Implement search within conversations to find specific messages. Add search bar in chat detail screen with real-time filtering. Highlight matching text, scroll to results, and show match count. Support case-insensitive search and clear search functionality. Consider date-based filtering for better UX. | Feature Dev |
| `CHAT-009` | [ ] | Implement chat archiving<br>**Description:** Add ability to archive conversations to declutter chat list. Implement swipe-to-archive gesture and archive/unarchive actions. Create archived chats section accessible from chat screen. Archived chats should still receive notifications but stay hidden from main list. Include bulk archive/unarchive options. | Feature Dev |

### Search & Filters

| Code | Status | Task | Role |
|------|--------|------|------|
| `SRCH-001` | [x] | Implement search history<br>**Description:** Track and display user's search queries in search screen. Store search terms with timestamps, limit to recent 20 searches. Show history below search bar with ability to tap to re-search. Include clear individual items and clear all history options. Persist history using local storage (SharedPreferences or Hive). | Feature Dev |
| `SRCH-002` | [x] | Add recent searches persistence<br>**Description:** Ensure search history persists across app sessions using local database or SharedPreferences. Implement data migration if storage format changes. Handle edge cases like storage quota exceeded. Sync search history with user account if logged in for cross-device experience (future enhancement). | Feature Dev |
| `SRCH-003` | [x] | Implement saved searches<br>**Description:** Allow users to save search queries with filters for quick access. Create UI to save current search with custom name, view saved searches list, and execute saved searches. Include edit/delete functionality. Store search parameters (query, filters, sort) and enable notifications for new matching ads (future). | Feature Dev |
| `SRCH-004` | [x] | Add location-based filtering<br>**Description:** Implement location-based search filtering allowing users to search within specific radius or cities. Integrate location picker, distance slider (1km, 5km, 10km, 50km, nationwide). Use device location with permission handling. Display distance in search results and sort by proximity option. | Feature Dev |
| `SRCH-005` | [x] | Implement price range persistence<br>**Description:** Save user's price range filter preferences per category. Remember last used price range when returning to search. Store min/max values in local storage and restore on app launch. Allow quick access to commonly used price ranges. Clear filters option should reset to defaults. | Feature Dev |
| `SRCH-006` | [x] | Add category-specific filters<br>**Description:** Create dynamic filter options based on selected category (e.g., car filters: make, model, year, mileage; electronics: brand, condition, warranty). Build flexible filter UI that adapts to category. Store filter definitions in models and render appropriate input types (dropdown, range slider, checkboxes). | Feature Dev |
| `SRCH-007` | [x] | Implement sort preferences persistence<br>**Description:** Remember user's preferred sort order (newest, price low-high, price high-low, relevance) across sessions. Store preference per category or globally based on user behavior. Apply saved sort automatically when browsing. Provide easy sort switcher in UI and persist changes immediately. | Feature Dev |

### Post Ad Flow

| Code | Status | Task | Role |
|------|--------|------|------|
| `POST-001` | [x] | Implement image picker integration<br>**Description:** Integrate image_picker package for selecting ad photos from gallery or camera. Support multiple image selection (up to 10 images). Implement image reordering, deletion, and set main image. Handle permissions properly with fallback UI. Show image preview grid and validate image requirements (format, size). | Feature Dev |
| `POST-002` | [x] | Add image compression before upload<br>**Description:** Implement image compression using flutter_image_compress to reduce file size before upload. Maintain acceptable quality while reducing bandwidth usage. Set max dimensions (e.g., 1920x1080) and quality (85%). Show compression progress and handle compression failures. Preserve EXIF data if needed. | Feature Dev |
| `POST-003` | [x] | Implement draft saving<br>**Description:** Auto-save ad drafts locally to prevent data loss if user exits. Save form data, selected images, and category every 30 seconds or on field blur. Show "Draft saved" indicator. Allow users to resume drafts from profile/post screen. Implement draft management (view, delete, publish). Limit to 5 drafts per user. | Feature Dev |
| `POST-004` | [ ] | Add category-specific fields<br>**Description:** Create dynamic form fields based on selected category. For vehicles: make, model, year, mileage, fuel type. For electronics: brand, warranty, condition. For real estate: bedrooms, area, property type. Build reusable field components and validation rules per category. Store field definitions in category model. | Feature Dev |
| `POST-005` | [x] | Implement location picker<br>**Description:** Create location selection interface for ad posting. Integrate map view (Google Maps/OpenStreetMap) with pin placement. Support current location detection, address search, and manual pin adjustment. Display selected address and allow editing. Store coordinates and formatted address. Handle location permissions gracefully. | Feature Dev |
| `POST-006` | [ ] | Add price suggestion based on category<br>**Description:** Provide price suggestions based on similar ads in same category. Show price range (min, avg, max) from recent listings. Display as hint below price field: "Similar items: $100-$150". Calculate from mock data initially, later from backend analytics. Help users price competitively and improve listing success. | Feature Dev |
| `POST-007` | [x] | Implement ad preview before posting<br>**Description:** Create preview screen showing how ad will appear to buyers before publishing. Display all entered information in actual ad detail layout. Allow editing from preview with back navigation preserving data. Add "Looks good, post it" confirmation button. Validate all required fields before showing preview. | Feature Dev |
| `POST-008` | [x] | Connect Post Ad to backend API<br>**Description:** Integrate Post Ad screen with backend API. Call POST /ads endpoint to create ad with form data. Upload images using POST /ads/:id/images endpoint with progress tracking. Handle API responses (success, validation errors, network errors). Show loading state during submission. Navigate to ad details on success. Store returned ad ID and update local cache. Handle offline scenario with queue for later sync. | Integration Eng |

### Profile & Settings

| Code | Status | Task | Role |
|------|--------|------|------|
| `PROF-001` | [x] | Implement edit profile functionality<br>**Description:** Create edit profile screen allowing users to update name, email, phone, bio, and location. Implement form validation, show current values, and handle save/cancel actions. Display loading state during save and success/error feedback. Sync changes with backend and update local cache. Prevent navigation with unsaved changes. | Feature Dev |
| `PROF-002` | [x] | Add profile image picker<br>**Description:** Enable profile picture upload with camera/gallery selection. Show current profile image with edit overlay button. Implement image cropping to square aspect ratio, compression, and preview before saving. Handle upload progress and errors. Support image removal to revert to default avatar. Cache uploaded image locally. | Feature Dev |
| `PROF-003` | [ ] | Implement notification settings<br>**Description:** Create notification preferences screen with toggles for: new messages, ad updates, price drops, saved search alerts, promotional notifications. Include sound, vibration, and LED settings. Add quiet hours configuration. Persist preferences and sync with backend for push notification targeting. Link to system notification settings. | Feature Dev |
| `PROF-004` | [ ] | Add privacy settings<br>**Description:** Implement privacy controls: show/hide phone number, show/hide email, profile visibility (public/private), online status visibility, read receipts toggle. Add blocked users management and data sharing preferences. Display privacy policy link. Save preferences locally and sync with backend. Show impact of privacy choices to user. | Feature Dev |
| `PROF-005` | [ ] | Implement account settings<br>**Description:** Create account settings section with: change password, email verification, phone verification, linked accounts (social logins), two-factor authentication setup, active sessions management, and account deletion option. Implement security features like password strength indicator and recent login activity. | Feature Dev |
| `PROF-006` | [ ] | Add app preferences (theme, language)<br>**Description:** Implement app customization settings: theme selection (light/dark/system), language preference, default location, currency, distance unit (km/miles), date format. Add data usage options (download images on WiFi only). Persist preferences and apply changes immediately without restart. Show preview of changes where applicable. | Feature Dev |
| `PROF-007` | [ ] | Implement help & support section<br>**Description:** Create help center with FAQ, how-to guides, contact support form, and app version info. Organize by topics (buying, selling, account, safety). Implement search within help articles. Add contact options (email, chat). Include terms of service, privacy policy, and community guidelines. Show app version and build number for support. | Feature Dev |

---

## Long-Term (3+ Months)

### Backend Integration

| Code | Status | Task | Role |
|------|--------|------|------|
| `API-001` | [x] | Set up API client architecture<br>**Description:** Create HTTP client architecture using dio or http package. Implement base client with interceptors for authentication (token injection), logging, error handling, and retry logic. Set up request/response models, timeout configuration, and base URL management. Support multiple environments (dev, staging, prod). | Integration Eng |
| `API-002` | [x] | Implement repository pattern<br>**Description:** Implement repository pattern to abstract data sources from business logic. Create repositories for each domain (User, Ad, Chat, etc.) that coordinate between remote API and local cache. Define repository interfaces and concrete implementations. Handle data transformation between API models and domain models. | Integration Eng |
| `API-003` | [x] | Create data source abstractions<br>**Description:** Create separate data source layers for remote (API) and local (cache/database) data. Define interfaces for RemoteDataSource and LocalDataSource. Implement concrete classes for each domain entity. This separation enables easy testing, offline support, and flexible data source switching. | Integration Eng |
| `API-004` | [ ] | Implement caching layer<br>**Description:** Implement multi-level caching using Hive or sqflite for persistent storage and in-memory cache for frequently accessed data. Define cache strategies (cache-first, network-first, cache-then-network). Implement cache invalidation, TTL (time-to-live), and cache size limits. Cache API responses, images, and user data. | Integration Eng |
| `API-005` | [ ] | Add offline support<br>**Description:** Enable app functionality when offline by serving cached data. Detect network connectivity changes and show offline indicator. Queue user actions (post ad, send message) for later sync when connection restored. Implement conflict resolution for data modified offline. Show clear feedback about offline status and pending actions. | Integration Eng |
| `API-006` | [ ] | Implement sync mechanism<br>**Description:** Create synchronization system to keep local data in sync with backend. Implement incremental sync using timestamps or version numbers. Handle sync conflicts with merge strategies. Sync user data, favorites, search history, and settings across devices. Schedule periodic background sync and trigger on app foreground. | Integration Eng |
| `API-007` | [ ] | Add background sync for messages<br>**Description:** Implement background message synchronization using WorkManager or background fetch. Poll for new messages periodically even when app is closed. Update local database and trigger notifications for new messages. Handle battery optimization and background execution limits on Android. Ensure efficient battery usage. | Integration Eng |
| `API-008` | [ ] | Implement push notifications<br>**Description:** Integrate Firebase Cloud Messaging (FCM) for push notifications. Handle notification permissions, token registration with backend, and token refresh. Implement notification handlers for foreground, background, and terminated states. Support notification actions, deep linking from notifications, and notification grouping. | Integration Eng |

### API Endpoints

| Code | Status | Task | Role |
|------|--------|------|------|
| `API-101` | [x] | User authentication endpoints<br>**Description:** Integrate authentication API endpoints: login, register, logout, refresh token, forgot password, reset password, verify OTP, resend OTP. Handle request/response models, error mapping, and token management. Implement proper error handling for auth failures (invalid credentials, expired tokens, etc.). | Integration Eng |
| `API-102` | [ ] | User profile endpoints<br>**Description:** Integrate user profile API endpoints: get profile, update profile, upload profile image, get user's ads, get favorites, update settings. Map API responses to UserModel. Handle profile image upload with multipart requests. Implement optimistic updates for better UX and rollback on failure. | Integration Eng |
| `API-103` | [ ] | Ad CRUD endpoints<br>**Description:** Integrate ad management endpoints: create ad, get ad details, update ad, delete ad, get user's ads, mark as sold, promote ad. Handle image uploads with progress tracking. Implement pagination for ad lists. Map responses to AdModel and handle validation errors from backend. | Integration Eng |
| `API-104` | [ ] | Category endpoints<br>**Description:** Integrate category API endpoints: get all categories, get category details, get subcategories, get category-specific fields. Cache categories locally as they change infrequently. Map to CategoryModel and handle hierarchical category structures. Support dynamic category fields for different ad types. | Integration Eng |
| `API-105` | [ ] | Search endpoints<br>**Description:** Integrate search API endpoints: search ads, filter by category/price/location, sort results, autocomplete suggestions. Implement pagination and infinite scroll. Handle complex filter parameters and query building. Cache search results temporarily and implement search result ranking. Support location-based search with radius. | Integration Eng |
| `API-106` | [ ] | Chat/messaging endpoints<br>**Description:** Integrate messaging endpoints: get conversations, get messages, send message, mark as read, delete conversation, upload image in chat. Implement pagination for message history. Handle real-time updates via polling initially, WebSocket later. Map to Message and Conversation models with proper timestamp handling. | Integration Eng |
| `API-107` | [ ] | Notification endpoints<br>**Description:** Integrate notification endpoints: get notifications, mark as read, delete notification, update notification preferences, register FCM token. Implement pagination for notification list. Handle different notification types (message, ad update, system). Support notification badges and unread counts. | Integration Eng |
| `API-108` | [ ] | Image upload endpoints<br>**Description:** Integrate image upload endpoints with multipart/form-data support. Implement upload progress tracking, retry on failure, and cancellation. Handle multiple image uploads in parallel. Support different image types (ad images, profile pictures, chat images). Receive and store image URLs from backend response. | Integration Eng |

### Real-time Features

| Code | Status | Task | Role |
|------|--------|------|------|
| `RT-001` | [ ] | WebSocket connection for chat<br>**Description:** Implement WebSocket connection for real-time chat using web_socket_channel. Handle connection lifecycle (connect, disconnect, reconnect), authentication, heartbeat/ping-pong. Listen for incoming messages and typing events. Implement automatic reconnection with exponential backoff. Handle connection errors gracefully. | Integration Eng |
| `RT-002` | [ ] | Real-time notifications<br>**Description:** Implement real-time notification delivery using WebSocket or Server-Sent Events (SSE). Receive instant notifications for new messages, ad updates, and system alerts. Update notification badge in real-time. Show in-app notification banners for foreground notifications. Sync with push notifications to avoid duplicates. | Integration Eng |
| `RT-003` | [ ] | Live ad updates<br>**Description:** Implement real-time updates for ad status changes (sold, price change, deleted). Subscribe to ad updates when viewing ad details or user's own ads. Update UI reactively when changes occur. Use WebSocket or polling mechanism. Show visual indicators for recently updated ads in lists. | Integration Eng |
| `RT-004` | [ ] | Online status indicators<br>**Description:** Display user online/offline status in chat list and user profiles. Show green dot for online, gray for offline, and "last seen" timestamp. Update status in real-time using presence system. Respect user privacy settings for status visibility. Cache status locally with TTL. | Feature Dev |
| `RT-005` | [ ] | Typing indicators (real-time)<br>**Description:** Implement real-time typing indicators via WebSocket. Send typing events when user types (debounced to avoid spam). Receive and display typing status from other users. Auto-hide typing indicator after timeout. Handle multiple users typing in group scenarios (future). Optimize to minimize bandwidth usage. | Integration Eng |

### Admin Panel

| Code | Status | Task | Role |
|------|--------|------|------|
| `ADM-001` | [ ] | Design admin dashboard<br>**Description:** Create admin dashboard with overview metrics: total users, active ads, pending moderation, reports, revenue. Display charts for user growth, ad posting trends, and category distribution. Include quick actions for common admin tasks. Design responsive layout accessible from web or tablet. | Feature Dev |
| `ADM-002` | [ ] | User management<br>**Description:** Build user management interface for admins to view, search, suspend, or ban users. Display user details, activity history, posted ads, and reports. Implement user search by name, email, or ID. Add bulk actions and user status filters (active, suspended, banned). Include user verification management. | Feature Dev |
| `ADM-003` | [ ] | Ad moderation<br>**Description:** Create ad moderation queue showing pending, flagged, and reported ads. Allow admins to approve, reject, or request changes. Display ad details, images, and report reasons. Implement filters by category, status, and report type. Add bulk moderation actions and moderation history tracking. | Feature Dev |
| `ADM-004` | [ ] | Category management<br>**Description:** Build interface to create, edit, delete, and reorder categories. Manage category hierarchy (parent/subcategories), icons, and custom fields. Set category-specific validation rules and required fields. Preview category changes before publishing. Track category usage statistics. | Feature Dev |
| `ADM-005` | [ ] | Analytics dashboard<br>**Description:** Create analytics dashboard with key metrics: daily active users, ad posting rate, search queries, conversion rates. Display charts for trends over time, popular categories, and geographic distribution. Export reports as CSV/PDF. Include date range filters and comparison periods. | Feature Dev |
| `ADM-006` | [ ] | Report handling<br>**Description:** Build report management system for user-reported content (ads, users, messages). Display report queue with priority levels, report reasons, and reporter details. Allow admins to review, take action (remove content, warn user, ban), or dismiss reports. Track resolution time and admin actions. | Feature Dev |
| `ADM-007` | [ ] | Content moderation tools<br>**Description:** Implement automated content moderation tools: profanity filter, spam detection, duplicate ad detection, image content analysis. Create rules engine for auto-flagging suspicious content. Provide admin override capabilities. Log all automated actions for review and improvement. | Feature Dev |

### Advanced Features

| Code | Status | Task | Role |
|------|--------|------|------|
| `ADV-001` | [ ] | Implement ad promotion system<br>**Description:** Create ad promotion feature allowing users to boost ad visibility. Design promotion packages (featured, top of category, homepage). Implement promotion duration tracking, automatic expiry, and renewal reminders. Show promoted ads with special badges. Track promotion performance metrics. | Feature Dev |
| `ADV-002` | [ ] | Add payment integration<br>**Description:** Integrate payment gateway (Stripe, PayPal, or local provider) for ad promotions and premium features. Implement secure payment flow, transaction history, receipts, and refund handling. Support multiple payment methods (card, wallet, bank transfer). Handle payment webhooks and verify transactions. | Integration Eng |
| `ADV-003` | [ ] | Implement review/rating system<br>**Description:** Build seller rating and review system. Allow buyers to rate sellers (1-5 stars) and write reviews after transactions. Display average rating on seller profiles and ads. Implement review moderation, report abuse, and seller response capability. Calculate seller reputation score. | Feature Dev |
| `ADV-004` | [ ] | Add seller verification<br>**Description:** Create seller verification system requiring ID verification, phone verification, and email verification. Display verified badge on profiles and ads. Implement verification workflow with document upload, admin review, and approval/rejection. Track verification status and expiry. Increase trust for verified sellers. | Feature Dev |
| `ADV-005` | [ ] | Implement ad boosting<br>**Description:** Create ad boosting feature to refresh ad position in listings. Allow users to boost ads to top of search results for limited time. Implement boost credits system or pay-per-boost. Show boost history and remaining boosts. Prevent abuse with cooldown periods. Display boosted indicator on ads. | Feature Dev |
| `ADV-006` | [ ] | Add analytics tracking<br>**Description:** Integrate analytics platform (Firebase Analytics, Mixpanel) to track user behavior, screen views, button clicks, and conversion funnels. Track custom events (ad posted, search performed, message sent). Implement user properties and segmentation. Set up conversion goals and track ROI. | Integration Eng |
| `ADV-007` | [ ] | Implement A/B testing framework<br>**Description:** Set up A/B testing infrastructure using Firebase Remote Config or similar. Create framework to test UI variations, feature flags, and user flows. Implement variant assignment, tracking, and statistical analysis. Allow gradual feature rollouts and quick rollbacks. Document testing methodology. | Integration Eng |
| `ADV-008` | [ ] | Add deep linking support<br>**Description:** Implement deep linking to open specific screens from URLs (ad details, user profile, category). Configure universal links (iOS) and app links (Android). Handle deep link routing, parameter parsing, and authentication requirements. Support sharing links that open in app if installed, web otherwise. | Feature Dev |
| `ADV-009` | [ ] | Implement share functionality<br>**Description:** Add share feature for ads using share_plus package. Generate shareable links with preview metadata (title, image, description). Support sharing to social media, messaging apps, and clipboard. Track share events for analytics. Include referral tracking to measure viral growth. | Feature Dev |
| `ADV-010` | [ ] | Add QR code for ads<br>**Description:** Generate QR codes for each ad using qr_flutter package. Display QR code in ad details for easy sharing offline. Allow users to scan QR codes to view ads. Include QR code in printable ad flyers. Store QR code image for reuse and track QR code scans. | Feature Dev |

### Performance & Optimization

| Code | Status | Task | Role |
|------|--------|------|------|
| `PERF-001` | [ ] | Implement lazy loading for images<br>**Description:** Implement lazy loading for images in lists using cached_network_image with proper placeholder and error widgets. Load images only when visible in viewport. Implement progressive image loading (low-res first, then high-res). Set appropriate cache duration and memory limits. Reduce initial load time and memory usage. | Refactor Agent |
| `PERF-002` | [ ] | Add pagination for all lists<br>**Description:** Implement pagination for all list views (ads, messages, notifications) to load data in chunks. Use infinite scroll with loading indicators. Implement pull-to-refresh and load-more on scroll. Set optimal page size (20-30 items). Cache loaded pages and handle page navigation efficiently. | Feature Dev |
| `PERF-003` | [ ] | Optimize widget rebuilds<br>**Description:** Analyze and optimize unnecessary widget rebuilds using Flutter DevTools. Add const constructors where possible. Use ValueListenableBuilder and Selector for targeted rebuilds. Implement proper key usage for list items. Profile widget rebuild performance and eliminate bottlenecks. | Refactor Agent |
| `PERF-004` | [ ] | Implement memory management<br>**Description:** Optimize memory usage by disposing controllers properly, clearing image caches when needed, and limiting list sizes. Use AutomaticKeepAliveClientMixin judiciously. Monitor memory leaks using DevTools. Implement memory-efficient data structures and avoid retaining large objects unnecessarily. | Refactor Agent |
| `PERF-005` | [ ] | Add performance monitoring<br>**Description:** Integrate Firebase Performance Monitoring or similar tool to track app performance metrics: startup time, screen rendering, network requests, custom traces. Set up alerts for performance regressions. Monitor frame rate, jank, and slow operations. Track performance across different devices and OS versions. | Integration Eng |
| `PERF-006` | [ ] | Optimize app size<br>**Description:** Reduce app size by removing unused resources, enabling code shrinking (ProGuard/R8), compressing images, and using vector graphics where possible. Implement app bundles for platform-specific builds. Analyze APK/IPA size and identify large dependencies. Target <50MB download size. | Refactor Agent |
| `PERF-007` | [ ] | Implement code splitting<br>**Description:** Implement deferred loading for non-critical features to reduce initial app size and startup time. Use deferred imports for admin features, analytics, and rarely-used screens. Implement dynamic feature modules where supported. Measure impact on startup time and download size. | Refactor Agent |

### Testing

| Code | Status | Task | Role |
|------|--------|------|------|
| `TEST-001` | [x] | Set up unit testing framework<br>**Description:** Configure Flutter test framework with test, mockito, and faker packages. Set up test directory structure mirroring lib folder. Create test utilities, mocks, and fixtures. Configure test coverage reporting. Establish testing conventions and documentation for team. | QA Agent |
| `TEST-002` | [x] | Write unit tests for controllers<br>**Description:** Write comprehensive unit tests for all GetX controllers covering state management, business logic, and error handling. Test loading states, success scenarios, and error cases. Mock dependencies (repositories, services). Aim for 80%+ code coverage on controllers. Test edge cases and boundary conditions. | QA Agent |
| `TEST-003` | [x] | Write unit tests for models<br>**Description:** Write unit tests for all data models testing JSON serialization/deserialization, validation, equality, and edge cases. Test fromJson/toJson methods with valid and invalid data. Verify null safety and default values. Test model methods and computed properties. | QA Agent |
| `TEST-004` | [x] | Set up widget testing<br>**Description:** Configure widget testing environment with flutter_test. Create widget test utilities, custom finders, and test wrappers (MaterialApp, GetMaterialApp). Set up golden tests for visual regression testing. Create reusable test helpers for common widget interactions and assertions. | QA Agent |
| `TEST-005` | [x] | Write widget tests for screens<br>**Description:** Write widget tests for all screens testing UI rendering, user interactions, and state changes. Test button taps, form inputs, navigation, and error states. Verify widgets appear correctly with different data. Test responsive layouts and accessibility. Use golden tests for complex UIs. | QA Agent |
| `TEST-006` | [ ] | Set up integration testing<br>**Description:** Configure integration testing with integration_test package. Set up test environment with mock backend or test server. Create integration test utilities for authentication, navigation, and data setup. Configure test devices/emulators. Document integration test execution process. | QA Agent |
| `TEST-007` | [ ] | Write integration tests for flows<br>**Description:** Write end-to-end integration tests for critical user flows: login, post ad, search and filter, send message, complete transaction. Test multi-screen workflows with real navigation and state persistence. Verify data flow between screens. Test happy paths and common error scenarios. | QA Agent |
| `TEST-008` | [ ] | Set up CI/CD pipeline<br>**Description:** Configure CI/CD pipeline using GitHub Actions, GitLab CI, or similar. Automate testing (unit, widget, integration), code analysis (flutter analyze), and formatting checks. Set up automated builds for staging and production. Implement automated deployment to TestFlight/Play Console. Configure build notifications. | Integration Eng |
| `TEST-009` | [ ] | Add code coverage reporting<br>**Description:** Implement code coverage tracking using lcov and codecov/coveralls. Generate coverage reports in CI pipeline. Set minimum coverage thresholds (80% target). Display coverage badges in README. Identify untested code and prioritize coverage improvements. Track coverage trends over time. | QA Agent |

### Localization

| Code | Status | Task | Role |
|------|--------|------|------|
| `L10N-001` | [ ] | Set up localization framework<br>**Description:** Configure Flutter localization using flutter_localizations and intl packages. Set up ARB file structure for translations. Create localization delegate and supported locales configuration. Implement locale switching mechanism. Set up translation workflow and tools (e.g., Lokalise, Crowdin). | Feature Dev |
| `L10N-002` | [ ] | Extract all strings to ARB files<br>**Description:** Extract all hardcoded strings from code to ARB files for translation. Replace string literals with localization keys. Include placeholders for dynamic values. Add context and descriptions for translators. Organize keys by feature/screen. Verify no hardcoded strings remain in UI code. | Refactor Agent |
| `L10N-003` | [ ] | Add Persian (Farsi) translation<br>**Description:** Create Persian (Farsi) translation ARB file with all app strings. Work with native speaker for accurate translations. Handle Persian-specific formatting (numbers, dates, currency). Test Persian text rendering and ensure proper font support. Verify cultural appropriateness of content. | Feature Dev |
| `L10N-004` | [ ] | Add Arabic translation<br>**Description:** Create Arabic translation ARB file with all app strings. Work with native speaker for accurate translations. Handle Arabic-specific formatting and pluralization rules. Test Arabic text rendering with proper fonts. Consider regional variations (Egyptian, Gulf, Levantine). | Feature Dev |
| `L10N-005` | [ ] | Implement RTL support<br>**Description:** Implement right-to-left (RTL) layout support for Arabic and Persian. Use Directionality widget and TextDirection properly. Test all screens in RTL mode. Fix layout issues (padding, alignment, icons). Ensure images and icons flip appropriately. Test navigation and animations in RTL. | Feature Dev |
| `L10N-006` | [ ] | Add language switcher<br>**Description:** Create language selection UI in settings. Display available languages with native names and flags. Implement language change with app restart or hot reload. Persist selected language preference. Show current language indicator. Handle locale-specific formatting (dates, numbers, currency) based on selection. | Feature Dev |

### Accessibility

| Code | Status | Task | Role |
|------|--------|------|------|
| `A11Y-001` | [ ] | Add semantic labels to all widgets<br>**Description:** Add Semantics widgets and semantic labels to all interactive elements for screen reader support. Provide meaningful descriptions for images, buttons, and icons. Implement semantic hints for complex interactions. Test with TalkBack (Android) and VoiceOver (iOS). Ensure logical reading order. | UI Engineer |
| `A11Y-002` | [ ] | Ensure proper contrast ratios<br>**Description:** Verify all text and interactive elements meet WCAG AA contrast ratio requirements (4.5:1 for normal text, 3:1 for large text). Test with color contrast analyzers. Adjust colors in theme if needed. Ensure sufficient contrast in both light and dark modes. Test with color blindness simulators. | UI Engineer |
| `A11Y-003` | [ ] | Implement screen reader support<br>**Description:** Optimize app for screen readers (TalkBack, VoiceOver). Implement proper focus management and navigation order. Add announcements for dynamic content changes. Provide alternative text for images. Test all user flows with screen reader enabled. Handle form validation errors accessibly. | UI Engineer |
| `A11Y-004` | [ ] | Add keyboard navigation<br>**Description:** Implement keyboard navigation support for web and desktop platforms. Ensure all interactive elements are keyboard accessible with proper tab order. Add focus indicators. Implement keyboard shortcuts for common actions. Test navigation with Tab, Enter, and arrow keys. Support Escape key for dismissing dialogs. | UI Engineer |
| `A11Y-005` | [ ] | Test with accessibility tools<br>**Description:** Conduct comprehensive accessibility testing using automated tools (Accessibility Scanner, Lighthouse) and manual testing with assistive technologies. Test with screen readers, voice control, and switch access. Verify compliance with WCAG 2.1 guidelines. Document accessibility features and create accessibility statement. | QA Agent |

---

## Technical Debt

### High Priority

| Code | Status | Task | Role |
|------|--------|------|------|
| `DEBT-001` | [x] | Replace `withOpacity` with `withValues` (Flutter 3.8+ deprecation) | Refactor Agent |
| `DEBT-002` | [x] | Add proper error boundaries | Arch Guardian |
| `DEBT-003` | [x] | Implement consistent loading patterns | Arch Guardian |
| `DEBT-004` | [ ] | Standardize API response handling (for future)<br>**Description:** Create standardized API response handling pattern with consistent error types, success/failure wrappers, and response models. Implement base response class with generic typing. Define error codes and messages. Create response interceptors for common transformations. Document API integration patterns for team. | Arch Guardian |

### Medium Priority

| Code | Status | Task | Role |
|------|--------|------|------|
| `DEBT-101` | [x] | Refactor large screen files (>500 lines) | Refactor Agent |
| `DEBT-102` | [x] | Extract common widgets | Refactor Agent |
| `DEBT-103` | [x] | Improve code documentation | Arch Guardian |
| `DEBT-104` | [x] | Add missing type annotations | Refactor Agent |

### Low Priority

| Code | Status | Task | Role |
|------|--------|------|------|
| `DEBT-201` | [ ] | Optimize import statements<br>**Description:** Clean up import statements across all files: remove unused imports, organize imports (dart, package, relative), use relative imports for local files. Run dart fix and flutter analyze. Consider using import_sorter package. Ensure consistent import style throughout codebase. | Refactor Agent |
| `DEBT-202` | [ ] | Remove commented-out code<br>**Description:** Remove all commented-out code blocks that are no longer needed. Use version control for code history instead of comments. Keep only meaningful comments explaining complex logic or decisions. Clean up TODO comments by converting to issues or implementing. Improve code readability. | Refactor Agent |
| `DEBT-203` | [ ] | Standardize file headers<br>**Description:** Add standardized file headers to all source files including copyright notice, file description, and author information. Create template for file headers. Use automated tools to apply headers consistently. Include creation date and last modified date where appropriate. | Arch Guardian |
| `DEBT-204` | [ ] | Add license headers<br>**Description:** Add appropriate license headers to all source files based on project license (MIT, Apache, etc.). Include copyright year and owner. Create LICENSE file in repository root. Ensure third-party dependencies comply with license requirements. Document licensing in README. | Arch Guardian |

---

## Blocked Items

| Code | Status | Task | Blocker | Waiting On |
|------|--------|------|---------|------------|
| `RT-001` | [!] | Real-time chat | WebSocket server | Backend WebSocket implementation |
| `ADV-002` | [!] | Payment integration | Business decision | Product owner |

---

## Completed

### December 2024

| Code | Status | Task |
|------|--------|------|
| `DONE-001` | [x] | Complete UI implementation for all screens |
| `DONE-002` | [x] | Implement feature-based architecture |
| `DONE-003` | [x] | Create data models (AdModel, UserModel, CategoryModel) |
| `DONE-004` | [x] | Set up GetX state management |
| `DONE-005` | [x] | Create constants (AppColors, AppSizes, AppTexts) |
| `DONE-006` | [x] | Implement theme configuration |
| `DONE-007` | [x] | Set up navigation with GetX |
| `DONE-008` | [x] | Create mock data for all features |
| `DONE-009` | [x] | Refactor controllers to use models |
| `DONE-010` | [x] | Update screens to use constants |
| `DONE-011` | [x] | Create project documentation |

### January 2026

| Code | Status | Task |
|------|--------|------|
| `DONE-012` | [x] | Design and implement PHP backend API |
| `DONE-013` | [x] | Create database schema with 13 tables |
| `DONE-014` | [x] | Implement JWT authentication system |
| `DONE-015` | [x] | Build user management endpoints |
| `DONE-016` | [x] | Create ad/listing CRUD endpoints |
| `DONE-017` | [x] | Implement search and filter functionality |
| `DONE-018` | [x] | Add image upload system |
| `DONE-019` | [x] | Deploy backend to production (cPanel) |
| `DONE-020` | [x] | Configure SSL and production environment |

---

## Quick Reference

### Find Tasks by Role

| Role | Task Codes |
|------|------------|
| UI Engineer | `UI-*`, `ANI-*`, `CHAT-004`, `A11Y-*` |
| Feature Dev | `STM-*`, `AUTH-*`, `CHAT-*`, `SRCH-*`, `POST-*`, `PROF-*`, `ADM-*`, `ADV-*`, `L10N-*` |
| Refactor Agent | `CQ-001` to `CQ-003`, `PERF-*`, `DEBT-*`, `L10N-002` |
| Arch Guardian | `CQ-004`, `CQ-005`, `DEBT-002` to `DEBT-004`, `DEBT-103`, `DEBT-203`, `DEBT-204` |
| Integration Eng | `AUTH-004`, `AUTH-005`, `AUTH-007`, `CHAT-007`, `API-*`, `RT-*`, `ADV-002`, `ADV-006`, `ADV-007`, `PERF-005`, `TEST-008` |
| QA Agent | `TEST-*`, `A11Y-005` |

### Find Tasks by Priority

| Priority | Task Codes |
|----------|------------|
| Short-term | `UI-*`, `ANI-*`, `STM-*`, `CQ-*` |
| Mid-term | `AUTH-*`, `CHAT-*`, `SRCH-*`, `POST-*`, `PROF-*` |
| Long-term | `API-*`, `RT-*`, `ADM-*`, `ADV-*`, `PERF-*`, `TEST-*`, `L10N-*`, `A11Y-*` |
| Tech Debt | `DEBT-*` |

---

## Notes

- All UI work must preserve existing designs
- Backend integration requires approval before starting
- New dependencies must be documented
- All changes must follow rules in `/docs/rules.md`
- Reference tasks by their code when reporting progress (e.g., "Completed `UI-001`")
