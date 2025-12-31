# Project TODO

This document tracks all pending tasks organized by priority and timeline.

**Last Updated:** December 2024

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
| `ANI-001` | [ ] | Add hero animations for product images | UI Engineer |
| `ANI-002` | [ ] | Implement fade transitions for tab switches | UI Engineer |
| `ANI-003` | [ ] | Add scale animation on favorite button tap | UI Engineer |
| `ANI-004` | [ ] | Implement slide-in animation for bottom sheets | UI Engineer |
| `ANI-005` | [ ] | Add staggered animation for grid items | UI Engineer |

### State Management

| Code | Status | Task | Role |
|------|--------|------|------|
| `STM-001` | [x] | Implement proper loading states in all controllers | Feature Dev |
| `STM-002` | [x] | Add error handling states to controllers | Feature Dev |
| `STM-003` | [x] | Implement retry logic for failed operations | Feature Dev |
| `STM-004` | [ ] | Add state persistence for filters | Feature Dev |
| `STM-005` | [ ] | Implement optimistic updates for favorites | Feature Dev |

### Code Quality

| Code | Status | Task | Role |
|------|--------|------|------|
| `CQ-001` | [x] | Remove all remaining `withOpacity` deprecation warnings | Refactor Agent |
| `CQ-002` | [x] | Add `const` constructors where missing | Refactor Agent |
| `CQ-003` | [x] | Remove unused imports across all files | Refactor Agent |
| `CQ-004` | [ ] | Add documentation comments to public APIs | Arch Guardian |
| `CQ-005` | [ ] | Ensure consistent error handling patterns | Arch Guardian |

---

## Mid-Term (1-2 Months)

### Authentication

| Code | Status | Task | Role |
|------|--------|------|------|
| `AUTH-001` | [ ] | Design authentication flow (login, register, forgot password) | Feature Dev |
| `AUTH-002` | [x] | Create auth screens (login, register, OTP verification) | Feature Dev |
| `AUTH-003` | [x] | Implement AuthController | Feature Dev |
| `AUTH-004` | [ ] | Add secure token storage | Integration Eng |
| `AUTH-005` | [ ] | Implement session management | Integration Eng |
| `AUTH-006` | [ ] | Add biometric authentication option | Feature Dev |
| `AUTH-007` | [ ] | Implement social login (Google, Apple) | Integration Eng |
| `AUTH-008` | [ ] | Add logout functionality | Feature Dev |
| `AUTH-009` | [ ] | Implement account deletion flow | Feature Dev |

### Chat System

| Code | Status | Task | Role |
|------|--------|------|------|
| `CHAT-001` | [ ] | Design chat data models (Message, Conversation) | Feature Dev |
| `CHAT-002` | [ ] | Create ChatDetailScreen for individual conversations | Feature Dev |
| `CHAT-003` | [ ] | Implement real-time message updates (mock first) | Feature Dev |
| `CHAT-004` | [ ] | Add typing indicators | UI Engineer |
| `CHAT-005` | [ ] | Implement read receipts | Feature Dev |
| `CHAT-006` | [ ] | Add image sharing in chat | Feature Dev |
| `CHAT-007` | [ ] | Implement chat notifications | Integration Eng |
| `CHAT-008` | [ ] | Add message search functionality | Feature Dev |
| `CHAT-009` | [ ] | Implement chat archiving | Feature Dev |

### Search & Filters

| Code | Status | Task | Role |
|------|--------|------|------|
| `SRCH-001` | [ ] | Implement search history | Feature Dev |
| `SRCH-002` | [ ] | Add recent searches persistence | Feature Dev |
| `SRCH-003` | [ ] | Implement saved searches | Feature Dev |
| `SRCH-004` | [ ] | Add location-based filtering | Feature Dev |
| `SRCH-005` | [ ] | Implement price range persistence | Feature Dev |
| `SRCH-006` | [ ] | Add category-specific filters | Feature Dev |
| `SRCH-007` | [ ] | Implement sort preferences persistence | Feature Dev |

### Post Ad Flow

| Code | Status | Task | Role |
|------|--------|------|------|
| `POST-001` | [ ] | Implement image picker integration | Feature Dev |
| `POST-002` | [ ] | Add image compression before upload | Feature Dev |
| `POST-003` | [ ] | Implement draft saving | Feature Dev |
| `POST-004` | [ ] | Add category-specific fields | Feature Dev |
| `POST-005` | [ ] | Implement location picker | Feature Dev |
| `POST-006` | [ ] | Add price suggestion based on category | Feature Dev |
| `POST-007` | [ ] | Implement ad preview before posting | Feature Dev |

### Profile & Settings

| Code | Status | Task | Role |
|------|--------|------|------|
| `PROF-001` | [ ] | Implement edit profile functionality | Feature Dev |
| `PROF-002` | [ ] | Add profile image picker | Feature Dev |
| `PROF-003` | [ ] | Implement notification settings | Feature Dev |
| `PROF-004` | [ ] | Add privacy settings | Feature Dev |
| `PROF-005` | [ ] | Implement account settings | Feature Dev |
| `PROF-006` | [ ] | Add app preferences (theme, language) | Feature Dev |
| `PROF-007` | [ ] | Implement help & support section | Feature Dev |

---

## Long-Term (3+ Months)

### Backend Integration

| Code | Status | Task | Role |
|------|--------|------|------|
| `API-001` | [ ] | Set up API client architecture | Integration Eng |
| `API-002` | [ ] | Implement repository pattern | Integration Eng |
| `API-003` | [ ] | Create data source abstractions | Integration Eng |
| `API-004` | [ ] | Implement caching layer | Integration Eng |
| `API-005` | [ ] | Add offline support | Integration Eng |
| `API-006` | [ ] | Implement sync mechanism | Integration Eng |
| `API-007` | [ ] | Add background sync for messages | Integration Eng |
| `API-008` | [ ] | Implement push notifications | Integration Eng |

### API Endpoints

| Code | Status | Task | Role |
|------|--------|------|------|
| `API-101` | [ ] | User authentication endpoints | Integration Eng |
| `API-102` | [ ] | User profile endpoints | Integration Eng |
| `API-103` | [ ] | Ad CRUD endpoints | Integration Eng |
| `API-104` | [ ] | Category endpoints | Integration Eng |
| `API-105` | [ ] | Search endpoints | Integration Eng |
| `API-106` | [ ] | Chat/messaging endpoints | Integration Eng |
| `API-107` | [ ] | Notification endpoints | Integration Eng |
| `API-108` | [ ] | Image upload endpoints | Integration Eng |

### Real-time Features

| Code | Status | Task | Role |
|------|--------|------|------|
| `RT-001` | [ ] | WebSocket connection for chat | Integration Eng |
| `RT-002` | [ ] | Real-time notifications | Integration Eng |
| `RT-003` | [ ] | Live ad updates | Integration Eng |
| `RT-004` | [ ] | Online status indicators | Feature Dev |
| `RT-005` | [ ] | Typing indicators (real-time) | Integration Eng |

### Admin Panel

| Code | Status | Task | Role |
|------|--------|------|------|
| `ADM-001` | [ ] | Design admin dashboard | Feature Dev |
| `ADM-002` | [ ] | User management | Feature Dev |
| `ADM-003` | [ ] | Ad moderation | Feature Dev |
| `ADM-004` | [ ] | Category management | Feature Dev |
| `ADM-005` | [ ] | Analytics dashboard | Feature Dev |
| `ADM-006` | [ ] | Report handling | Feature Dev |
| `ADM-007` | [ ] | Content moderation tools | Feature Dev |

### Advanced Features

| Code | Status | Task | Role |
|------|--------|------|------|
| `ADV-001` | [ ] | Implement ad promotion system | Feature Dev |
| `ADV-002` | [ ] | Add payment integration | Integration Eng |
| `ADV-003` | [ ] | Implement review/rating system | Feature Dev |
| `ADV-004` | [ ] | Add seller verification | Feature Dev |
| `ADV-005` | [ ] | Implement ad boosting | Feature Dev |
| `ADV-006` | [ ] | Add analytics tracking | Integration Eng |
| `ADV-007` | [ ] | Implement A/B testing framework | Integration Eng |
| `ADV-008` | [ ] | Add deep linking support | Feature Dev |
| `ADV-009` | [ ] | Implement share functionality | Feature Dev |
| `ADV-010` | [ ] | Add QR code for ads | Feature Dev |

### Performance & Optimization

| Code | Status | Task | Role |
|------|--------|------|------|
| `PERF-001` | [ ] | Implement lazy loading for images | Refactor Agent |
| `PERF-002` | [ ] | Add pagination for all lists | Feature Dev |
| `PERF-003` | [ ] | Optimize widget rebuilds | Refactor Agent |
| `PERF-004` | [ ] | Implement memory management | Refactor Agent |
| `PERF-005` | [ ] | Add performance monitoring | Integration Eng |
| `PERF-006` | [ ] | Optimize app size | Refactor Agent |
| `PERF-007` | [ ] | Implement code splitting | Refactor Agent |

### Testing

| Code | Status | Task | Role |
|------|--------|------|------|
| `TEST-001` | [ ] | Set up unit testing framework | QA Agent |
| `TEST-002` | [ ] | Write unit tests for controllers | QA Agent |
| `TEST-003` | [ ] | Write unit tests for models | QA Agent |
| `TEST-004` | [ ] | Set up widget testing | QA Agent |
| `TEST-005` | [ ] | Write widget tests for screens | QA Agent |
| `TEST-006` | [ ] | Set up integration testing | QA Agent |
| `TEST-007` | [ ] | Write integration tests for flows | QA Agent |
| `TEST-008` | [ ] | Set up CI/CD pipeline | Integration Eng |
| `TEST-009` | [ ] | Add code coverage reporting | QA Agent |

### Localization

| Code | Status | Task | Role |
|------|--------|------|------|
| `L10N-001` | [ ] | Set up localization framework | Feature Dev |
| `L10N-002` | [ ] | Extract all strings to ARB files | Refactor Agent |
| `L10N-003` | [ ] | Add Persian (Farsi) translation | Feature Dev |
| `L10N-004` | [ ] | Add Arabic translation | Feature Dev |
| `L10N-005` | [ ] | Implement RTL support | Feature Dev |
| `L10N-006` | [ ] | Add language switcher | Feature Dev |

### Accessibility

| Code | Status | Task | Role |
|------|--------|------|------|
| `A11Y-001` | [ ] | Add semantic labels to all widgets | UI Engineer |
| `A11Y-002` | [ ] | Ensure proper contrast ratios | UI Engineer |
| `A11Y-003` | [ ] | Implement screen reader support | UI Engineer |
| `A11Y-004` | [ ] | Add keyboard navigation | UI Engineer |
| `A11Y-005` | [ ] | Test with accessibility tools | QA Agent |

---

## Technical Debt

### High Priority

| Code | Status | Task | Role |
|------|--------|------|------|
| `DEBT-001` | [x] | Replace `withOpacity` with `withValues` (Flutter 3.8+ deprecation) | Refactor Agent |
| `DEBT-002` | [x] | Add proper error boundaries | Arch Guardian |
| `DEBT-003` | [x] | Implement consistent loading patterns | Arch Guardian |
| `DEBT-004` | [ ] | Standardize API response handling (for future) | Arch Guardian |

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
| `DEBT-201` | [ ] | Optimize import statements | Refactor Agent |
| `DEBT-202` | [ ] | Remove commented-out code | Refactor Agent |
| `DEBT-203` | [ ] | Standardize file headers | Arch Guardian |
| `DEBT-204` | [ ] | Add license headers | Arch Guardian |

---

## Blocked Items

| Code | Status | Task | Blocker | Waiting On |
|------|--------|------|---------|------------|
| `API-001` | [!] | API integration | Backend not ready | Backend team |
| `API-008` | [!] | Push notifications | Backend not ready | Backend team |
| `RT-001` | [!] | Real-time chat | WebSocket server | Backend team |
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
