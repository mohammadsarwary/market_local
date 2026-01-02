# Backend AI Agent Task Prompt

Use this prompt template when assigning tasks to AI agents working on the Market Local Backend API.

---

## Standard Task Prompt

Copy and paste this prompt, replacing the placeholders with actual values:

```
You are working on the Market Local Backend API (PHP).

## Task Assignment
- **Task Code:** [TASK_CODE]
- **Task Description:** [TASK_DESCRIPTION]
- **Priority:** [🔴 Critical / 🟠 High / 🟡 Medium / 🟢 Low]

## Before You Start

1. Read the project documentation:
   - `/backend/docs/documentation.md` - System architecture and overview
   - `/backend/docs/api_reference.md` - API endpoint specifications
   - `/backend/README.md` - Quick start guide
   - `/backend/DEPLOYMENT_GUIDE.md` - Deployment instructions

2. Understand the backend structure:
   - `/backend/config/` - Configuration files
   - `/backend/controllers/` - Request handlers
   - `/backend/models/` - Database operations
   - `/backend/middleware/` - Authentication and validation
   - `/backend/utils/` - Helper classes

3. Follow these constraints:
   - DO use PDO prepared statements (prevent SQL injection)
   - DO use the Response utility for JSON responses
   - DO use the Validator utility for input validation
   - DO hash passwords with PASSWORD_BCRYPT
   - DO NOT expose sensitive data in responses
   - DO NOT use raw SQL queries
   - DO follow existing code patterns

## Your Task

Complete task `[TASK_CODE]`: [TASK_DESCRIPTION]

## Deliverables

1. Implement the required changes
2. Test the endpoint using curl or Postman
3. Update `/backend/docs/todo.md`:
   - Change the task status from `[ ]` to `[x]`
4. Document any new endpoints in `/backend/docs/api_reference.md`

## Completion Checklist

Before marking complete, verify:
- [ ] Code follows PHP best practices
- [ ] Using PDO prepared statements
- [ ] Input validation implemented
- [ ] Error handling added
- [ ] JSON responses use Response utility
- [ ] Endpoint tested and working
- [ ] Documentation updated
- [ ] Task marked as complete in `/backend/docs/todo.md`

## Report Format

When done, report:

Task: [TASK_CODE]
Status: Completed ✅

Changes:
- [file]: [description]
- [file]: [description]

Testing:
- Endpoint: [METHOD] [URL]
- Response: [SUCCESS/ERROR]
- Status Code: [200/201/400/etc]

Documentation:
- todo.md updated: YES
- api_reference.md updated: [YES/NO/N/A]
```

---

## Quick Task Prompts by Category

### API Endpoint Task

```
You are working on the Market Local Backend API as a **Backend Developer**.

Task Code: [API/CHAT/NOTIF/REV/ADM]-[XXX]
Task: [DESCRIPTION]

Read the project documentation:
   - `/backend/docs/documentation.md` - System architecture
   - `/backend/docs/api_reference.md` - API specifications

Rules:
- Create controller method for the endpoint
- Add route in `index.php`
- Use existing models or create new ones
- Implement proper validation
- Return standardized JSON responses
- Test with curl or Postman

After completion:
1. Test the endpoint
2. Update `/backend/docs/todo.md` - change task status from `[ ]` to `[x]`
3. Document endpoint in `/backend/docs/api_reference.md`
```

### Database Task

```
You are working on the Market Local Backend API as a **Database Developer**.

Task Code: [DB]-[XXX]
Task: [DESCRIPTION]

Rules:
- Use PDO prepared statements
- Add proper indexes
- Follow naming conventions
- Update schema.sql if needed
- Test queries for performance

After completion:
1. Test database changes
2. Update `/backend/docs/todo.md` - change task status from `[ ]` to `[x]`
```

### Security Task

```
You are working on the Market Local Backend API as a **Security Engineer**.

Task Code: [SEC]-[XXX]
Task: [DESCRIPTION]

Rules:
- Follow OWASP security guidelines
- Use prepared statements (SQL injection prevention)
- Validate and sanitize all inputs
- Use secure password hashing
- Implement proper authentication
- Add security headers

After completion:
1. Test security measures
2. Update `/backend/docs/todo.md` - change task status from `[ ]` to `[x]`
```

### Testing Task

```
You are working on the Market Local Backend API as a **QA Engineer**.

Task Code: [TEST]-[XXX]
Task: [DESCRIPTION]

Rules:
- Test all endpoints thoroughly
- Test error scenarios
- Test validation rules
- Document test cases
- Report any bugs found

After completion:
1. Document test results
2. Update `/backend/docs/todo.md` - change task status from `[ ]` to `[x]`
```

---

## How to Mark Task Complete in todo.md

### Step 1: Find the task row in the table

```markdown
| 🟠 | `CHAT-001` | [ ] | Create conversation endpoints | ... |
```

### Step 2: Change `[ ]` to `[x]`

```markdown
| 🟠 | `CHAT-001` | [x] | Create conversation endpoints | ... |
```

That's it! The task is now marked as complete.

---

## Example Complete Prompt

```
You are working on the Market Local Backend API.

## Task Assignment
- **Task Code:** CHAT-001
- **Task Description:** Create conversation endpoints
- **Priority:** 🟠 High

## Before You Start

1. Read the project documentation:
   - `/backend/docs/documentation.md` - System architecture
   - `/backend/docs/api_reference.md` - API specifications

2. Understand the database schema:
   - `conversations` table structure
   - Relationships with `users` and `ads` tables

3. Follow these constraints:
   - Use PDO prepared statements
   - Implement JWT authentication
   - Return standardized JSON responses
   - Handle errors gracefully

## Your Task

Complete task `CHAT-001`: Create conversation endpoints

Implement the following endpoints:
1. GET /conversations - Get user's conversations
2. GET /conversations/:id - Get conversation details with messages

Requirements:
- Authenticate user with JWT
- Return conversations with last message
- Include unread count
- Paginate results (20 per page)
- Handle errors (404, 401, 500)

## Deliverables

1. Create MessageController.php
2. Implement conversation endpoints
3. Add routes in index.php
4. Test endpoints with Postman
5. Update `/backend/docs/todo.md`
6. Document endpoints in `/backend/docs/api_reference.md`

## Completion Checklist

Before marking complete, verify:
- [ ] Endpoints return correct data
- [ ] Authentication working
- [ ] Pagination implemented
- [ ] Error handling added
- [ ] JSON responses standardized
- [ ] Endpoints tested
- [ ] Documentation updated
```

---

## Batch Task Prompt

For assigning multiple related tasks at once:

```
You are working on the Market Local Backend API.

## Task Assignment
Complete the following tasks in order:

1. **CHAT-001:** Create conversation endpoints
2. **CHAT-002:** Implement send message endpoint
3. **CHAT-003:** Add message pagination

## Priority: 🟠 High

## Rules
- Follow existing code patterns
- Use PDO prepared statements
- Implement proper validation
- Test each endpoint after implementation

## After Each Task
1. Test the endpoint
2. Update `/backend/docs/todo.md` - change task status from `[ ]` to `[x]`

## After All Tasks
Report summary of all changes and test results.
```

---

## Testing Endpoints

### Using curl

```bash
# Test GET endpoint
curl -X GET https://market.bazarino.store/api/endpoint

# Test POST endpoint with JSON
curl -X POST https://market.bazarino.store/api/endpoint \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'

# Test with authentication
curl -X GET https://market.bazarino.store/api/endpoint \
  -H "Authorization: Bearer {token}"

# Test file upload
curl -X POST https://market.bazarino.store/api/endpoint \
  -H "Authorization: Bearer {token}" \
  -F "image=@/path/to/image.jpg"
```

### Using Postman

1. Create new request
2. Set method (GET, POST, PUT, DELETE)
3. Enter URL: `https://market.bazarino.store/api/endpoint`
4. Add headers if needed (Authorization, Content-Type)
5. Add body for POST/PUT requests
6. Send and verify response

---

## Task Status Reference

| Status | Symbol | Meaning |
|--------|--------|---------|
| Not Started | `[ ]` | Task has not been started |
| In Progress | `[~]` | Task is currently being worked on |
| Completed | `[x]` | Task is finished and verified |
| Blocked | `[!]` | Task cannot proceed due to blocker |

---

## Priority Reference

| Priority | Symbol | Meaning | Timeline |
|----------|--------|---------|----------|
| Critical | 🔴 | Must be done immediately | This week |
| High | 🟠 | Important for next release | Next 2 weeks |
| Medium | 🟡 | Should be done soon | This month |
| Low | 🟢 | Nice to have | Future |

---

## Common Patterns

### Controller Method Structure

```php
public function methodName() {
    // 1. Get and validate input
    $data = json_decode(file_get_contents("php://input"), true);
    
    $validator = new Validator();
    $validator->required($data['field'] ?? '', 'field');
    
    if ($validator->fails()) {
        Response::validationError($validator->getErrors());
    }
    
    // 2. Perform business logic
    $result = $this->model->doSomething($data);
    
    if (!$result) {
        Response::error("Operation failed", 400);
    }
    
    // 3. Return response
    Response::success("Success message", $result);
}
```

### Adding Route in index.php

```php
// In the appropriate section
if ($resource === 'resource-name') {
    require_once __DIR__ . '/controllers/ResourceController.php';
    $controller = new ResourceController();
    
    switch ($id) {
        case 'action':
            if ($method === 'POST') {
                $controller->action();
            } else {
                Response::error('Method not allowed. Use POST', 405);
            }
            break;
    }
}
```

### Model Method Structure

```php
public function methodName($param) {
    try {
        $query = "SELECT * FROM table WHERE field = :param";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':param', $param);
        $stmt->execute();
        
        return $stmt->fetch(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        error_log("Error: " . $e->getMessage());
        return false;
    }
}
```

---

## Important Notes

- Always reference tasks by their code (e.g., `CHAT-001`, `SEC-002`)
- Always update `/backend/docs/todo.md` after completing a task
- Always test endpoints before marking complete
- If a task is blocked, change status to `[!]` and document the blocker
- Read `/backend/docs/documentation.md` before making changes
- Follow existing code patterns and conventions
- Use the Response utility for all JSON responses
- Use the Validator utility for all input validation
- Never expose sensitive data (passwords, tokens, secrets)
- Always use PDO prepared statements (prevent SQL injection)
- When in doubt, ask for clarification

---

## Production Deployment Checklist

Before deploying to production:

- [ ] All tests passing
- [ ] Error reporting disabled in production
- [ ] JWT secret key changed from default
- [ ] Database credentials updated
- [ ] BASE_URL set to production domain
- [ ] .htaccess configured correctly
- [ ] File permissions set (755 for directories, 644 for files)
- [ ] SSL certificate installed
- [ ] Backup created
- [ ] Documentation updated

---

## Support & Resources

**Production API:** https://market.bazarino.store/api

**Documentation:**
- System Architecture: `/backend/docs/documentation.md`
- API Reference: `/backend/docs/api_reference.md`
- TODO List: `/backend/docs/todo.md`
- Deployment Guide: `/backend/DEPLOYMENT_GUIDE.md`

**Database:**
- Host: localhost
- Database: bazapndu_market
- Schema: `/backend/database/schema.sql`

**Testing:**
- Use Postman or curl
- Test all success scenarios
- Test all error scenarios
- Test authentication
- Test validation

---

*Last Updated: January 2, 2026*
