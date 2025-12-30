# Project TODO

This document tracks all pending tasks organized by priority and timeline.

**Last Updated:** December 2024

---

## Legend

- `[ ]` - Not started
- `[~]` - In progress
- `[x]` - Completed
- `[!]` - Blocked

---

## Short-Term (1-2 Weeks)

### UI Polish

- [ ] Add loading shimmer effects to product grids
- [ ] Add pull-to-refresh on list screens
- [ ] Implement empty state widgets for all lists
- [ ] Add error state widgets with retry buttons
- [ ] Improve image loading placeholders
- [ ] Add haptic feedback on button taps
- [ ] Implement skeleton loading for profile screen
- [ ] Add smooth page transitions between screens
- [ ] Fix any remaining overflow issues on small screens
- [ ] Add scroll-to-top button on long lists

### Animations

- [ ] Add hero animations for product images
- [ ] Implement fade transitions for tab switches
- [ ] Add scale animation on favorite button tap
- [ ] Implement slide-in animation for bottom sheets
- [ ] Add staggered animation for grid items

### State Management

- [ ] Implement proper loading states in all controllers
- [ ] Add error handling states to controllers
- [ ] Implement retry logic for failed operations
- [ ] Add state persistence for filters
- [ ] Implement optimistic updates for favorites

### Code Quality

- [ ] Remove all remaining `withOpacity` deprecation warnings
- [ ] Add `const` constructors where missing
- [ ] Remove unused imports across all files
- [ ] Add documentation comments to public APIs
- [ ] Ensure consistent error handling patterns

---

## Mid-Term (1-2 Months)

### Authentication

- [ ] Design authentication flow (login, register, forgot password)
- [ ] Create auth screens (login, register, OTP verification)
- [ ] Implement AuthController
- [ ] Add secure token storage
- [ ] Implement session management
- [ ] Add biometric authentication option
- [ ] Implement social login (Google, Apple)
- [ ] Add logout functionality
- [ ] Implement account deletion flow

### Chat System

- [ ] Design chat data models (Message, Conversation)
- [ ] Create ChatDetailScreen for individual conversations
- [ ] Implement real-time message updates (mock first)
- [ ] Add typing indicators
- [ ] Implement read receipts
- [ ] Add image sharing in chat
- [ ] Implement chat notifications
- [ ] Add message search functionality
- [ ] Implement chat archiving

### Search & Filters

- [ ] Implement search history
- [ ] Add recent searches persistence
- [ ] Implement saved searches
- [ ] Add location-based filtering
- [ ] Implement price range persistence
- [ ] Add category-specific filters
- [ ] Implement sort preferences persistence

### Post Ad Flow

- [ ] Implement image picker integration
- [ ] Add image compression before upload
- [ ] Implement draft saving
- [ ] Add category-specific fields
- [ ] Implement location picker
- [ ] Add price suggestion based on category
- [ ] Implement ad preview before posting

### Profile & Settings

- [ ] Implement edit profile functionality
- [ ] Add profile image picker
- [ ] Implement notification settings
- [ ] Add privacy settings
- [ ] Implement account settings
- [ ] Add app preferences (theme, language)
- [ ] Implement help & support section

---

## Long-Term (3+ Months)

### Backend Integration

- [ ] Set up API client architecture
- [ ] Implement repository pattern
- [ ] Create data source abstractions
- [ ] Implement caching layer
- [ ] Add offline support
- [ ] Implement sync mechanism
- [ ] Add background sync for messages
- [ ] Implement push notifications

### API Endpoints

- [ ] User authentication endpoints
- [ ] User profile endpoints
- [ ] Ad CRUD endpoints
- [ ] Category endpoints
- [ ] Search endpoints
- [ ] Chat/messaging endpoints
- [ ] Notification endpoints
- [ ] Image upload endpoints

### Real-time Features

- [ ] WebSocket connection for chat
- [ ] Real-time notifications
- [ ] Live ad updates
- [ ] Online status indicators
- [ ] Typing indicators

### Admin Panel

- [ ] Design admin dashboard
- [ ] User management
- [ ] Ad moderation
- [ ] Category management
- [ ] Analytics dashboard
- [ ] Report handling
- [ ] Content moderation tools

### Advanced Features

- [ ] Implement ad promotion system
- [ ] Add payment integration
- [ ] Implement review/rating system
- [ ] Add seller verification
- [ ] Implement ad boosting
- [ ] Add analytics tracking
- [ ] Implement A/B testing framework
- [ ] Add deep linking support
- [ ] Implement share functionality
- [ ] Add QR code for ads

### Performance & Optimization

- [ ] Implement lazy loading for images
- [ ] Add pagination for all lists
- [ ] Optimize widget rebuilds
- [ ] Implement memory management
- [ ] Add performance monitoring
- [ ] Optimize app size
- [ ] Implement code splitting

### Testing

- [ ] Set up unit testing framework
- [ ] Write unit tests for controllers
- [ ] Write unit tests for models
- [ ] Set up widget testing
- [ ] Write widget tests for screens
- [ ] Set up integration testing
- [ ] Write integration tests for flows
- [ ] Set up CI/CD pipeline
- [ ] Add code coverage reporting

### Localization

- [ ] Set up localization framework
- [ ] Extract all strings to ARB files
- [ ] Add Persian (Farsi) translation
- [ ] Add Arabic translation
- [ ] Implement RTL support
- [ ] Add language switcher

### Accessibility

- [ ] Add semantic labels to all widgets
- [ ] Ensure proper contrast ratios
- [ ] Implement screen reader support
- [ ] Add keyboard navigation
- [ ] Test with accessibility tools

---

## Technical Debt

### High Priority

- [ ] Replace `withOpacity` with `withValues` (Flutter 3.8+ deprecation)
- [ ] Add proper error boundaries
- [ ] Implement consistent loading patterns
- [ ] Standardize API response handling (for future)

### Medium Priority

- [ ] Refactor large screen files (>500 lines)
- [ ] Extract common widgets
- [ ] Improve code documentation
- [ ] Add missing type annotations

### Low Priority

- [ ] Optimize import statements
- [ ] Remove commented-out code
- [ ] Standardize file headers
- [ ] Add license headers

---

## Blocked Items

| Item | Blocker | Waiting On |
|------|---------|------------|
| API integration | Backend not ready | Backend team |
| Push notifications | Backend not ready | Backend team |
| Real-time chat | WebSocket server | Backend team |
| Payment integration | Business decision | Product owner |

---

## Completed

### December 2024

- [x] Complete UI implementation for all screens
- [x] Implement feature-based architecture
- [x] Create data models (AdModel, UserModel, CategoryModel)
- [x] Set up GetX state management
- [x] Create constants (AppColors, AppSizes, AppTexts)
- [x] Implement theme configuration
- [x] Set up navigation with GetX
- [x] Create mock data for all features
- [x] Refactor controllers to use models
- [x] Update screens to use constants
- [x] Create project documentation

---

## Notes

- All UI work must preserve existing designs
- Backend integration requires approval before starting
- New dependencies must be documented
- All changes must follow rules in `/docs/rules.md`
