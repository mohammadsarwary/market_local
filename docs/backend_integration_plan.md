# 📋 Complete Backend Integration Plan

**Project:** Market Local Flutter App  
**Backend API:** https://market.bazarino.store/api  
**Created:** January 2, 2026  
**Status:** Ready to Start

---

## 🎯 Phase 1: Foundation (Week 1) - CRITICAL

### 1. API Infrastructure Setup

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-001** | 🔴 Critical | **Set up API client architecture** | 4-6 hours | [ ] |
| - | - | Install `dio` package | 15 min | [ ] |
| - | - | Create `ApiClient` class with base configuration | 1 hour | [ ] |
| - | - | Add interceptors (auth token, logging, error handling) | 2 hours | [ ] |
| - | - | Implement retry logic for failed requests | 1 hour | [ ] |
| - | - | Set up timeout configuration | 30 min | [ ] |

### 2. Configuration & Constants

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **NEW** | 🔴 Critical | **Create API constants file** | 1 hour | [ ] |
| - | - | Define base URL and all endpoint paths | 30 min | [ ] |
| - | - | Create environment configuration (dev/prod) | 30 min | [ ] |

### 3. Data Layer Architecture

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-002** | 🟠 High | **Implement repository pattern** | 4-6 hours | [ ] |
| - | - | Create repository interfaces | 1 hour | [ ] |
| - | - | Implement concrete repositories | 3 hours | [ ] |
| - | - | Add error handling and data transformation | 2 hours | [ ] |

| **API-003** | 🟠 High | **Create data source abstractions** | 3-4 hours | [ ] |
| - | - | Define RemoteDataSource interface | 1 hour | [ ] |
| - | - | Implement API data sources | 2 hours | [ ] |
| - | - | Set up local cache data sources | 1 hour | [ ] |

---

## 🔐 Phase 2: Authentication (Week 1-2) - HIGH PRIORITY

### 4. Authentication Integration

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-101** | 🔴 Critical | **Integrate authentication endpoints** | 6-8 hours | [ ] |
| - | - | Create AuthRepository | 1 hour | [ ] |
| - | - | Implement register API call | 1 hour | [ ] |
| - | - | Implement login API call | 1 hour | [ ] |
| - | - | Implement token refresh mechanism | 2 hours | [ ] |
| - | - | Add secure token storage (flutter_secure_storage) | 1 hour | [ ] |
| - | - | Update AuthController to use API | 2 hours | [ ] |
| - | - | Handle auth errors and validation | 1 hour | [ ] |

### 5. Token Management

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **NEW** | 🔴 Critical | **Implement token management** | 3-4 hours | [ ] |
| - | - | Auto-inject tokens in API requests | 1 hour | [ ] |
| - | - | Handle token expiration | 1 hour | [ ] |
| - | - | Implement auto-refresh on 401 errors | 2 hours | [ ] |

---

## 👤 Phase 3: User Management (Week 2) - HIGH PRIORITY

### 6. User Profile Integration

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-102** | 🟠 High | **Integrate user profile endpoints** | 5-6 hours | [ ] |
| - | - | Create UserRepository | 1 hour | [ ] |
| - | - | Implement get profile API call | 1 hour | [ ] |
| - | - | Implement update profile API call | 1 hour | [ ] |
| - | - | Update ProfileController to use API | 2 hours | [ ] |
| - | - | Handle profile update errors | 1 hour | [ ] |

### 7. Avatar Upload

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-108** | 🟠 High | **Implement avatar upload** | 3-4 hours | [ ] |
| - | - | Create multipart request for image upload | 2 hours | [ ] |
| - | - | Add upload progress tracking | 1 hour | [ ] |
| - | - | Update UI with uploaded image URL | 1 hour | [ ] |

---

## 📦 Phase 4: Categories & Ads (Week 2-3) - HIGH PRIORITY

### 8. Category Integration

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-104** | 🟠 High | **Integrate category endpoints** | 2-3 hours | [ ] |
| - | - | Create CategoryRepository | 1 hour | [ ] |
| - | - | Fetch categories from API | 1 hour | [ ] |
| - | - | Cache categories locally | 1 hour | [ ] |

### 9. Ad Listing Integration

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-103** | 🔴 Critical | **Integrate ad CRUD endpoints** | 8-10 hours | [ ] |
| - | - | Create AdRepository | 1 hour | [ ] |
| - | - | Implement get ads list with filters | 2 hours | [ ] |
| - | - | Implement get ad details | 1 hour | [ ] |
| - | - | Implement pagination | 2 hours | [ ] |
| - | - | Update HomeController to use API | 2 hours | [ ] |
| - | - | Update AdDetailsController to use API | 2 hours | [ ] |

### 10. Create Ad Integration

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **POST-008** | 🔴 Critical | **Connect Post Ad to backend** | 6-8 hours | [ ] |
| - | - | Implement create ad API call | 2 hours | [ ] |
| - | - | Implement ad image upload | 2 hours | [ ] |
| - | - | Add upload progress UI | 1 hour | [ ] |
| - | - | Handle validation errors from backend | 1 hour | [ ] |
| - | - | Update PostAdController | 2 hours | [ ] |
| - | - | Navigate to ad details on success | 1 hour | [ ] |

### 11. Ad Actions Integration

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **NEW** | 🟡 Medium | **Implement ad actions** | 4-5 hours | [ ] |
| - | - | Implement update ad API call | 1 hour | [ ] |
| - | - | Implement delete ad API call | 1 hour | [ ] |
| - | - | Implement mark as sold API call | 1 hour | [ ] |
| - | - | Implement toggle favorite API call | 2 hours | [ ] |

---

## 🔍 Phase 5: Search & Filters (Week 3) - MEDIUM PRIORITY

### 12. Search Integration

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-105** | 🟡 Medium | **Integrate search endpoints** | 5-6 hours | [ ] |
| - | - | Create SearchRepository | 1 hour | [ ] |
| - | - | Implement search with query | 2 hours | [ ] |
| - | - | Implement filters (category, price, location) | 2 hours | [ ] |
| - | - | Update SearchController to use API | 2 hours | [ ] |

### 13. Favorites Integration

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **NEW** | 🟡 Medium | **Integrate favorites** | 3-4 hours | [ ] |
| - | - | Implement get favorites API call | 1 hour | [ ] |
| - | - | Update FavoritesController to use API | 2 hours | [ ] |
| - | - | Sync favorites with backend | 1 hour | [ ] |

---

## 🖼️ Phase 6: Image Management (Week 3-4) - MEDIUM PRIORITY

### 14. Image Upload System

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-108** | 🟡 Medium | **Complete image upload system** | 4-5 hours | [ ] |
| - | - | Implement ad images upload | 2 hours | [ ] |
| - | - | Handle multiple image uploads | 1 hour | [ ] |
| - | - | Add retry on upload failure | 1 hour | [ ] |
| - | - | Display uploaded image URLs | 1 hour | [ ] |

---

## 🧪 Phase 7: Testing & Optimization (Week 4) - IMPORTANT

### 15. Integration Testing

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **NEW** | 🟠 High | **Test complete integration** | 6-8 hours | [ ] |
| - | - | Test registration and login flow | 1 hour | [ ] |
| - | - | Test profile management | 1 hour | [ ] |
| - | - | Test create ad with images | 2 hours | [ ] |
| - | - | Test search and filters | 1 hour | [ ] |
| - | - | Test favorites functionality | 1 hour | [ ] |
| - | - | Test error handling scenarios | 2 hours | [ ] |

### 16. Error Handling & UX

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **NEW** | 🟠 High | **Improve error handling** | 3-4 hours | [ ] |
| - | - | Add user-friendly error messages | 2 hours | [ ] |
| - | - | Implement retry mechanisms | 1 hour | [ ] |
| - | - | Add loading states everywhere | 1 hour | [ ] |

---

## 🚀 Phase 8: Advanced Features (Week 5+) - OPTIONAL

### 17. Offline Support

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-004** | 🟢 Low | **Implement caching layer** | 6-8 hours | [ ] |
| **API-005** | 🟢 Low | **Add offline support** | 8-10 hours | [ ] |
| **API-006** | 🟢 Low | **Implement sync mechanism** | 6-8 hours | [ ] |

### 18. Push Notifications

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-008** | 🟢 Low | **Implement push notifications** | 8-10 hours | [ ] |

### 19. Messaging System

| Task Code | Priority | Task | Estimated Time | Status |
|-----------|----------|------|----------------|--------|
| **API-106** | 🟢 Low | **Integrate chat endpoints** | 10-12 hours | [ ] |

---

## 📊 Summary

### Total Estimated Time: **80-100 hours** (2-3 weeks full-time)

### Priority Breakdown:

**🔴 Critical (Must Do First) - 18-22 hours:**
- API-001: API client setup (4-6h)
- API-101: Authentication integration (6-8h)
- API-103: Ad CRUD integration (8-10h)
- POST-008: Post Ad connection (6-8h)

**🟠 High Priority (Do Next) - 30-38 hours:**
- API-002: Repository pattern (4-6h)
- API-003: Data sources (3-4h)
- API-102: User profile integration (5-6h)
- API-104: Categories integration (2-3h)
- API-108: Image uploads (3-4h)
- Token management (3-4h)
- Integration testing (6-8h)
- Error handling (3-4h)

**🟡 Medium Priority (Important) - 12-15 hours:**
- API-105: Search integration (5-6h)
- Favorites integration (3-4h)
- Ad actions (4-5h)

**🟢 Low Priority (Future) - 20-30 hours:**
- Caching and offline support (20-26h)
- Push notifications (8-10h)
- Messaging system (10-12h)

---

## 🎯 Recommended Execution Order

### **Week 1: Foundation & Auth (Days 1-5)**

**Day 1-2: API Infrastructure**
- [ ] Install dio package
- [ ] Create API constants file
- [ ] Set up ApiClient with base configuration
- [ ] Add interceptors (auth, logging, errors)
- [ ] Implement retry logic

**Day 3-4: Authentication**
- [ ] Create AuthRepository
- [ ] Implement register/login API calls
- [ ] Add secure token storage
- [ ] Implement token refresh
- [ ] Update AuthController

**Day 5: Token Management**
- [ ] Auto-inject tokens in requests
- [ ] Handle token expiration
- [ ] Implement auto-refresh on 401

### **Week 2: Core Features (Days 6-10)**

**Day 6: Categories & Repository Pattern**
- [ ] Implement repository pattern
- [ ] Create data source abstractions
- [ ] Integrate category endpoints

**Day 7-8: Ad Listing**
- [ ] Create AdRepository
- [ ] Implement get ads with filters
- [ ] Add pagination
- [ ] Update HomeController

**Day 9-10: User Profile**
- [ ] Create UserRepository
- [ ] Implement profile endpoints
- [ ] Add avatar upload
- [ ] Update ProfileController

### **Week 3: Create Ad & Search (Days 11-15)**

**Day 11-12: Create Ad**
- [ ] Implement create ad API call
- [ ] Add ad image upload
- [ ] Handle validation errors
- [ ] Update PostAdController

**Day 13-14: Search & Actions**
- [ ] Integrate search endpoints
- [ ] Add filters support
- [ ] Implement ad actions (update, delete, favorite)

**Day 15: Favorites**
- [ ] Integrate favorites endpoints
- [ ] Update FavoritesController
- [ ] Sync with backend

### **Week 4: Testing & Polish (Days 16-20)**

**Day 16-17: Integration Testing**
- [ ] Test all authentication flows
- [ ] Test ad creation and management
- [ ] Test search and filters
- [ ] Test error scenarios

**Day 18-19: Error Handling & UX**
- [ ] Add user-friendly error messages
- [ ] Implement retry mechanisms
- [ ] Add loading states
- [ ] Polish UI feedback

**Day 20: Final Testing & Bug Fixes**
- [ ] End-to-end testing
- [ ] Fix any bugs found
- [ ] Performance optimization
- [ ] Documentation updates

---

## 📝 Implementation Checklist

### Before Starting
- [ ] Backend API is deployed and accessible
- [ ] API documentation is available
- [ ] Test credentials are ready
- [ ] Development environment is set up

### During Development
- [ ] Follow the recommended execution order
- [ ] Test each feature after implementation
- [ ] Handle errors gracefully
- [ ] Add loading states for all API calls
- [ ] Update controllers to use repositories
- [ ] Keep code clean and documented

### After Completion
- [ ] All critical features working
- [ ] Error handling implemented
- [ ] Loading states added
- [ ] Integration testing passed
- [ ] Documentation updated
- [ ] Ready for production

---

## 🚀 Quick Start Commands

### To begin Phase 1:
```
"Let's start Phase 1: Set up the API client architecture (API-001)"
```

### To implement authentication:
```
"Implement API-101: Integrate authentication endpoints"
```

### To connect Post Ad:
```
"Implement POST-008: Connect Post Ad screen to backend API"
```

### To do multiple tasks:
```
"Implement API-001, API-002, and API-003 to set up the foundation"
```

---

## 📚 Resources

### API Documentation
- **Base URL:** https://market.bazarino.store/api
- **API Reference:** `/backend/docs/api_reference.md`
- **Backend Docs:** `/backend/docs/documentation.md`

### Flutter Packages Needed
```yaml
dependencies:
  dio: ^5.4.0
  flutter_secure_storage: ^9.0.0
  get: ^4.6.6 # Already installed
  cached_network_image: ^3.3.0 # Already installed
```

### File Structure
```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart
│   │   ├── api_constants.dart
│   │   └── api_interceptors.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── user_repository.dart
│       ├── ad_repository.dart
│       └── category_repository.dart
└── features/
    └── [existing features]
```

---

## ⚠️ Important Notes

1. **Always test with production API:** https://market.bazarino.store/api
2. **Handle errors gracefully:** Show user-friendly messages
3. **Add loading states:** For all API calls
4. **Secure token storage:** Use flutter_secure_storage
5. **Auto-refresh tokens:** On 401 errors
6. **Cache when appropriate:** Categories, user profile
7. **Follow existing patterns:** Use GetX controllers
8. **Keep code clean:** Follow project structure

---

## 📞 Support

For issues or questions:
- Check API documentation
- Review backend TODO
- Test endpoints with Postman
- Check error logs

---

*Last Updated: January 2, 2026*  
*Status: Ready to Start*  
*Next Step: Phase 1 - API Infrastructure Setup*
