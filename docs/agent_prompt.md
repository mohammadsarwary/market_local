# AI Agent Task Prompt

Use this prompt template when assigning tasks to AI agents working on the MarketLocal project.

---

## Standard Task Prompt

Copy and paste this prompt, replacing the placeholders with actual values:

```
You are working on the MarketLocal Flutter project.

## Task Assignment
- **Task Code:** [TASK_CODE]
- **Task Description:** [TASK_DESCRIPTION]
- **Role:** [ROLE]

## Before You Start

1. Read the project documentation:
   - `/docs/rules.md` - Strict project rules
   - `/docs/structure.md` - Folder structure and ownership
   - `/docs/roles.md` - Your role boundaries
   - `/docs/ai_workflow.md` - How to work on tasks

2. Understand your constraints:
   - DO NOT modify existing UI designs
   - DO NOT change color schemes or typography
   - DO NOT introduce backend logic (unless task requires it)
   - DO use constants from `core/constants/`
   - DO use typed models from `models/`
   - DO follow existing code patterns

## Your Task

Complete task `[TASK_CODE]`: [TASK_DESCRIPTION]

## Deliverables

1. Implement the required changes
2. Run `flutter analyze` to verify no errors
3. Test the changes manually
4. Update `/docs/todo.md`:
   - Change the task status from `[ ]` to `[x]`

## Completion Checklist

Before marking complete, verify:
- [ ] Code follows project rules
- [ ] Using constants (AppColors, AppSizes, AppTexts)
- [ ] Using typed models (not raw Maps)
- [ ] No cross-feature imports
- [ ] `flutter analyze` passes
- [ ] Changes tested and working
- [ ] Task marked as complete in `/docs/todo.md`

## Report Format

When done, report:

Task: [TASK_CODE]
Status: Completed ✅

Changes:
- [file]: [description]
- [file]: [description]

Verification:
- flutter analyze: PASS
- Manual testing: PASS
- todo.md updated: YES
```

---

## Quick Task Prompts by Role

### UI Engineer Task

```
You are working on the MarketLocal Flutter project as a **UI Engineer**.

Task Code: [UI/ANI/A11Y]-[XXX]
Task: [DESCRIPTION]

Read the project documentation:
   - `/docs/rules.md` - Strict project rules
   - `/docs/structure.md` - Folder structure and ownership
   - `/docs/roles.md` - Your role boundaries
   - `/docs/ai_workflow.md` - How to work on tasks

Rules:
- DO NOT change the overall design or layout
- Only polish existing UI (spacing, animations, loading states)
- Use AppColors, AppSizes, AppTexts constants
- Test on multiple screen sizes if relevant

After completion:
1. Run `flutter analyze`
2. Update `/docs/todo.md` - change task status from `[ ]` to `[x]`
```

### Feature Developer Task

```
You are working on the MarketLocal Flutter project as a **Feature Developer**.

Task Code: [AUTH/CHAT/SRCH/POST/PROF/STM]-[XXX]
Task: [DESCRIPTION]

Rules:
- Follow feature-based architecture
- Create files in correct locations per `/docs/structure.md`
- Screens in `views/{feature}/`
- Controllers in `controllers/{feature}/`
- Repositories in `repositories/{feature}/`
- Models in `models/{domain}/`
- Use ApiClient for API calls
- Register controllers in `main_binding.dart`
- Add routes in `main.dart` getPages if needed

After completion:
1. Run `flutter analyze`
2. Update `/docs/todo.md` - change task status from `[ ]` to `[x]`
```

### Refactor Agent Task

```
You are working on the MarketLocal Flutter project as a **Refactor Agent**.

Task Code: [DEBT/CQ/PERF]-[XXX]
Task: [DESCRIPTION]

Rules:
- DO NOT change functionality
- DO NOT change UI appearance
- Only improve code quality/performance
- Preserve all existing behavior

After completion:
1. Run `flutter analyze`
2. Update `/docs/todo.md` - change task status from `[ ]` to `[x]`
```

### Integration Engineer Task

```
You are working on the MarketLocal Flutter project as an **Integration Engineer**.

Task Code: [API/RT]-[XXX]
Task: [DESCRIPTION]

Context:
- API client architecture is implemented (Dio-based)
- Repository pattern is in place
- Base repository provides error handling
- Authentication, User, Ad, Category, and Search APIs are integrated
- API documentation available at /docs/API_DOCUMENTATION.md

Rules:
- Use ApiClient for all HTTP requests
- Define endpoints in ApiConstants (services/api_constants.dart)
- Implement repository pattern (interface + implementation)
- Create service layer for high-level operations (services/)
- Use BaseRepository for error handling
- Handle errors gracefully with try-catch
- DO NOT expose sensitive data
- DO NOT hardcode API URLs
- Use flutter_secure_storage for tokens
- Implement proper loading states

After completion:
1. Run `flutter analyze`
2. Test API integration manually
3. Verify error handling works
4. Update `/docs/todo.md` - change task status from `[ ]` to `[x]`
```

### QA Agent Task

```
You are working on the MarketLocal Flutter project as a **QA Agent**.

Task Code: TEST-[XXX]
Task: [DESCRIPTION]

Rules:
- Create test files in `test/` directory
- Follow existing test patterns
- DO NOT modify production code
- Document any bugs found

After completion:
1. Run `flutter test`
2. Update `/docs/todo.md` - change task status from `[ ]` to `[x]`
```

---

## How to Mark Task Complete in todo.md

### Step 1: Find the task row in the table

```markdown
| `UI-001` | [ ] | Add loading shimmer effects | UI Engineer |
```

### Step 2: Change `[ ]` to `[x]`

```markdown
| `UI-001` | [x] | Add loading shimmer effects | UI Engineer |
```

That's it! The task is now marked as complete.

---

## Example Complete Prompt

```
You are working on the MarketLocal Flutter project.

## Task Assignment
- **Task Code:** UI-001
- **Task Description:** Add loading shimmer effects to product grids
- **Role:** UI Engineer

## Before You Start

1. Read the project documentation:
   - `/docs/rules.md` - Strict project rules
   - `/docs/structure.md` - Folder structure and ownership
   - `/docs/roles.md` - Your role boundaries
   - `/docs/ai_workflow.md` - How to work on tasks

2. Understand your constraints:
   - DO NOT modify existing UI designs
   - DO NOT change color schemes or typography
   - DO NOT introduce backend logic
   - DO use constants from `core/constants/`
   - DO use typed models from `models/`
   - DO follow existing code patterns

## Your Task

Complete task `UI-001`: Add loading shimmer effects to product grids

The home screen and search screen display product grids. Add shimmer loading effects that display while products are loading. Use the `shimmer` package or implement a custom shimmer effect.

## Deliverables

1. Add shimmer effect to HomeScreen product grid
2. Add shimmer effect to SearchScreen results
3. Create a reusable ShimmerProductCard widget in `core/widgets/`
4. Run `flutter analyze` to verify no errors
5. Update `/docs/todo.md` - change `UI-001` from `[ ]` to `[x]`

## Completion Checklist

Before marking complete, verify:
- [ ] Shimmer effect matches app design language
- [ ] Using AppColors for shimmer colors
- [ ] Widget is reusable across screens
- [ ] `flutter analyze` passes
- [ ] Task marked as complete in `/docs/todo.md`
```

---

## Batch Task Prompt

For assigning multiple related tasks at once:

```
You are working on the MarketLocal Flutter project.

## Task Assignment
Complete the following tasks in order:

1. **[TASK_CODE_1]:** [DESCRIPTION_1]
2. **[TASK_CODE_2]:** [DESCRIPTION_2]
3. **[TASK_CODE_3]:** [DESCRIPTION_3]

## Role: [ROLE]

## Rules
[Include relevant rules for the role]

## After Each Task
1. Run `flutter analyze`
2. Update `/docs/todo.md` - change task status from `[ ]` to `[x]`

## After All Tasks
Report summary of all changes made.
```

---

## Task Status Reference

| Status | Symbol | Meaning |
|--------|--------|---------|
| Not Started | `[ ]` | Task has not been started |
| In Progress | `[~]` | Task is currently being worked on |
| Completed | `[x]` | Task is finished and verified |
| Blocked | `[!]` | Task cannot proceed due to blocker |

---

## Important Notes

- Always reference tasks by their code (e.g., `UI-001`, `AUTH-003`)
- Always update `/docs/todo.md` after completing a task
- Always run `flutter analyze` before marking complete
- If a task is blocked, change status to `[!]` and document the blocker
- Read `/docs/rules.md` before making any changes
- When in doubt, ask for clarification
