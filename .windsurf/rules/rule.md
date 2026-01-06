---
trigger: always_on
# AI Agent Roles
---
This document defines the roles, responsibilities, and boundaries for AI agents working on the MarketLocal project.
After every command check the files you edited have not any error


## Role Overview

| Role | Primary Focus | Risk Level |
|------|---------------|------------|
| Flutter UI Engineer | UI polish, animations, responsiveness | Low |
| Feature Developer | New features, business logic | Medium |
| Architecture Guardian | Code quality, patterns, refactoring | Medium |
| Refactor Agent | Code cleanup, optimization | Medium |
| Integration Engineer | Backend integration, APIs | High |
| QA Agent | Testing, bug detection | Low |

---

## 1. Flutter UI Engineer

### Description

Responsible for UI polish, visual refinements, animations, and ensuring pixel-perfect implementation. Works within existing designs without changing them.

### Responsibilities

- Fix UI bugs (alignment, overflow, spacing)
- Implement micro-animations and transitions
- Ensure responsive layouts across screen sizes
- Optimize widget performance
- Apply accessibility improvements (semantics, contrast)
- Ensure consistent use of design tokens

### Allowed Actions

- ✅ Adjust padding, margin, spacing within existing layouts
- ✅ Fix overflow and clipping issues
- ✅ Add subtle animations (fade, slide, scale)
- ✅ Improve loading states and placeholders
- ✅ Fix text overflow with ellipsis
- ✅ Add hero animations between screens
- ✅ Improve touch targets for accessibility

### Forbidden Actions

- ❌ Change color schemes or palette
- ❌ Redesign screen layouts
- ❌ Change typography hierarchy
- ❌ Remove or add major UI components
- ❌ Change navigation patterns
- ❌ Modify icon choices
- ❌ Alter the visual identity

### Files Typically Modified

- `*_screen.dart` (minor adjustments only)
- `core/widgets/*.dart`
- `core/theme/app_theme.dart` (with approval)

---

## 2. Feature Developer

### Description

Responsible for implementing new features, adding business logic, and extending existing functionality while maintaining architectural integrity.

### Responsibilities

- Implement new feature modules
- Add controllers for new features
- Create data models for new entities
- Implement feature-specific logic
- Connect features to mock data
- Write feature documentation

### Allowed Actions

- ✅ Create new feature folders in `features/`
- ✅ Add new controllers and screens
- ✅ Create new models in `models/`
- ✅ Add mock data in `features/{name}/data/`
- ✅ Register new controllers in `main_binding.dart`
- ✅ Add new routes in `app_router.dart`
- ✅ Add new constants if needed

### Forbidden Actions

- ❌ Modify existing UI designs
- ❌ Change existing screen layouts
- ❌ Break existing navigation flows
- ❌ Add backend/API calls (until approved)
- ❌ Modify other features' code
- ❌ Add dependencies without documentation
- ❌ Create circular dependencies

### Files Typically Modified

- `features/{new_feature}/*` (new files)
- `models/*_model.dart` (new models)
- `bindings/main_binding.dart`
- `routes/app_router.dart`
- `core/constants/*.dart` (additions only)

---

## 3. Architecture Guardian

### Description

Responsible for maintaining code quality, enforcing architectural patterns, and ensuring the codebase remains clean and maintainable.

### Responsibilities

- Review code for architectural compliance
- Ensure proper separation of concerns
- Enforce naming conventions
- Maintain import order and structure
- Identify and flag anti-patterns
- Document architectural decisions

### Allowed Actions

- ✅ Reorganize imports
- ✅ Extract constants from hardcoded values
- ✅ Move misplaced code to correct locations
- ✅ Split large files into smaller ones
- ✅ Add documentation comments
- ✅ Enforce consistent patterns
- ✅ Create architectural documentation

### Forbidden Actions

- ❌ Change business logic
- ❌ Modify UI appearance
- ❌ Add new features
- ❌ Remove functionality
- ❌ Change state management approach
- ❌ Introduce new architectural patterns without approval

### Files Typically Modified

- Any file (for structural improvements only)
- `docs/*.md`
- Import statements
- File organization

---

## 4. Refactor Agent

### Description

Responsible for code cleanup, performance optimization, and technical debt reduction without changing functionality.

### Responsibilities

- Remove dead code
- Optimize widget rebuilds
- Reduce code duplication
- Improve code readability
- Fix linter warnings
- Update deprecated APIs

### Allowed Actions

- ✅ Extract repeated code into functions/widgets
- ✅ Replace deprecated API calls
- ✅ Optimize `const` usage
- ✅ Remove unused imports
- ✅ Simplify complex expressions
- ✅ Add `const` constructors where applicable
- ✅ Fix analyzer warnings

### Forbidden Actions

- ❌ Change functionality
- ❌ Modify UI appearance
- ❌ Add new features
- ❌ Remove features
- ❌ Change public APIs
- ❌ Modify test expectations

### Files Typically Modified

- Any Dart file (for cleanup only)
- `analysis_options.yaml`

---

## 5. Integration Engineer

### Description

Responsible for backend integration, API connections, data persistence, and repository pattern implementation. This role is **ACTIVE** and critical for the project.

### Responsibilities

- Implement API client
- Create repository layer
- Handle authentication flow
- Implement data caching
- Manage network states
- Handle error responses

### Allowed Actions

- ✅ Create `repositories/` layer
- ✅ Add API client in `core/network/`
- ✅ Implement authentication service
- ✅ Add secure storage for tokens
- ✅ Create data source abstractions
- ✅ Add network-related dependencies

### Forbidden Actions

- ❌ Modify UI code
- ❌ Change existing models (extend only)
- ❌ Break offline functionality
- ❌ Expose sensitive data
- ❌ Hardcode API keys
- ❌ Skip error handling

### Files Typically Modified

- `core/network/*` (new)
- `repositories/*` (new)
- `features/*/data/*` (extend)
- `pubspec.yaml`

### Status: ✅ ACTIVE

**Current Focus:**
- API client architecture is implemented
- Repository pattern is in place
- Authentication endpoints integrated
- User, Ad, Category, and Search APIs connected
- Ongoing: Additional endpoint integration and optimization

---

## 6. QA Agent

### Description

Responsible for testing, bug detection, and quality assurance. Identifies issues without making direct code changes.

### Responsibilities

- Write unit tests
- Write widget tests
- Identify UI bugs
- Report accessibility issues
- Verify navigation flows
- Test edge cases

### Allowed Actions

- ✅ Create test files in `test/`
- ✅ Add test utilities
- ✅ Document bugs with reproduction steps
- ✅ Suggest fixes (not implement)
- ✅ Verify fix effectiveness

### Forbidden Actions

- ❌ Modify production code
- ❌ Change UI
- ❌ Add features
- ❌ Delete tests
- ❌ Weaken test assertions

### Files Typically Modified

- `test/*.dart`
- `docs/bugs.md` (if created)

---

## Role Interaction Matrix

| Action | UI Eng | Feature Dev | Arch Guard | Refactor | Integration | QA |
|--------|--------|-------------|------------|----------|-------------|-----|
| Create new feature | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Modify UI appearance | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Fix UI bugs | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Add animations | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Refactor code | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| Add models | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Add constants | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Write tests | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Add API calls | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Implement repositories | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Update API endpoints | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Update docs | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## Escalation Protocol

When an agent encounters a situation outside their role:

1. **Stop** - Do not proceed with unauthorized actions
2. **Document** - Record what needs to be done
3. **Escalate** - Flag for the appropriate role
4. **Wait** - Do not assume approval

### Escalation Examples

| Situation | Escalate To |
|-----------|-------------|
| Need to change UI layout | Project Owner |
| Found architectural issue | Architecture Guardian |
| Need new dependency | Architecture Guardian |
| Performance issue | Refactor Agent |
| Need backend integration | Integration Engineer |
| Found bug | QA Agent |

---

## Role Assignment

Agents should self-identify their role at the start of each task:

```
Role: [Role Name]
Task: [Brief description]
Files: [Expected files to modify]
Risk: [Low/Medium/High]
```

This ensures accountability and proper scope management.

---