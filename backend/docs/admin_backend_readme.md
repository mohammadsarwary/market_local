# 🛡️ Admin Backend - Implementation Guide

## Overview

The admin backend provides a comprehensive API for managing the Market Local marketplace platform. This includes user management, ad moderation, reports handling, and analytics.

---

## 🚀 Quick Start

### 1. Database Setup

Run the migration scripts to add admin functionality:

```sql
-- Add admin fields to users table
SOURCE backend/database/migrations/add_admin_fields.sql;

-- Create admin logs table
SOURCE backend/database/migrations/create_admin_logs.sql;
```

Or apply directly to your database:

```bash
mysql -u your_username -p your_database < backend/database/migrations/add_admin_fields.sql
mysql -u your_username -p your_database < backend/database/migrations/create_admin_logs.sql
```

### 2. Create First Admin User

The migration script automatically creates a default admin account:

- **Email:** `admin@marketlocal.com`
- **Password:** `admin123` (hashed)
- **Role:** `super_admin`

**⚠️ IMPORTANT:** Change this password immediately after first login!

To create additional admin users manually:

```sql
-- Create new admin
INSERT INTO users (name, email, password, is_admin, admin_role, is_verified, is_active) 
VALUES ('Admin Name', 'admin@example.com', '$2y$10$hashedpassword', 1, 'admin', 1, 1);

-- Or promote existing user to admin
UPDATE users SET is_admin = 1, admin_role = 'admin' WHERE email = 'user@example.com';
```

### 3. Test Admin API

Test the admin login endpoint:

```bash
curl -X POST http://your-domain.com/backend/admin_api.php/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@marketlocal.com",
    "password": "admin123"
  }'
```

---

## 📁 File Structure

```
backend/
├── controllers/
│   └── AdminController.php          # Main admin controller with all endpoints
├── middleware/
│   └── AdminMiddleware.php          # Admin authentication & authorization
├── database/
│   ├── schema.sql                   # Updated schema with admin fields
│   └── migrations/
│       ├── add_admin_fields.sql     # Add is_admin field to users
│       └── create_admin_logs.sql    # Create admin logs table
├── docs/
│   ├── admin_api_documentation.md   # Complete API reference
│   ├── admin_backend_readme.md      # This file
│   └── admin_panel_plan.md          # Implementation plan
└── admin_api.php                    # Admin API router
```

---

## 🔐 Admin Roles

### Super Admin
- Full access to all features
- Can delete users permanently
- Can manage other admins
- Access to all analytics

### Admin
- User management (suspend, activate, verify)
- Ad moderation (delete, feature, promote)
- Reports management
- Analytics access
- Cannot delete users

### Moderator
- Limited content moderation
- Can review and resolve reports
- Can suspend ads
- Limited analytics access

---

## 📊 Available Endpoints

### Authentication
- `POST /login` - Admin login
- `GET /verify` - Verify admin session

### Dashboard
- `GET /stats` - Dashboard statistics
- `GET /activity` - Recent activity feed

### User Management
- `GET /users` - List all users (with filters)
- `GET /users/{id}` - Get user details
- `PUT /users/{id}/suspend` - Suspend user
- `PUT /users/{id}/activate` - Activate user
- `PUT /users/{id}/verify` - Verify user
- `DELETE /users/{id}` - Delete user (super_admin only)
- `GET /users/{id}/activity` - User activity log
- `GET /users/export` - Export users to CSV

### Ad Management
- `GET /ads` - List all ads (with filters)
- `GET /ads/{id}` - Get ad details
- `DELETE /ads/{id}` - Delete ad
- `PUT /ads/{id}/feature` - Feature/unfeature ad
- `PUT /ads/{id}/promote` - Promote ad
- `GET /ads/export` - Export ads to CSV

### Reports Management
- `GET /reports` - List reports (with filters)
- `GET /reports/{id}` - Get report details
- `PUT /reports/{id}/resolve` - Resolve report
- `PUT /reports/{id}/dismiss` - Dismiss report
- `POST /reports/{id}/action` - Take action on report
- `GET /reports/stats` - Report statistics

### Analytics
- `GET /analytics/users` - User growth over time
- `GET /analytics/ads` - Ad posting trends
- `GET /analytics/categories` - Category distribution
- `GET /analytics/locations` - Location distribution

See `admin_api_documentation.md` for complete API reference.

---

## 🔒 Security Features

### JWT Authentication
All admin endpoints require a valid JWT token with admin privileges:

```
Authorization: Bearer {access_token}
```

### Role-Based Access Control
- Endpoints check for admin privileges
- Some actions require specific roles (e.g., super_admin)
- Middleware validates admin status on every request

### Audit Logging
All admin actions are logged in the `admin_logs` table:
- Who performed the action
- What action was performed
- When it was performed
- Details about the action

### Password Security
- Passwords are hashed using bcrypt
- JWT tokens expire after 1 hour
- Refresh tokens for extended sessions

---

## 🧪 Testing

### Test Admin Login

```bash
# Login
curl -X POST http://localhost/backend/admin_api.php/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@marketlocal.com","password":"admin123"}'
```

### Test Protected Endpoint

```bash
# Get stats (requires token)
curl -X GET http://localhost/backend/admin_api.php/stats \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Test User Management

```bash
# List users
curl -X GET "http://localhost/backend/admin_api.php/users?page=1&limit=10" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Suspend user
curl -X PUT http://localhost/backend/admin_api.php/users/123/suspend \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"reason":"Terms violation"}'
```

---

## 📈 Database Schema Changes

### Users Table
Added fields:
- `is_admin` TINYINT(1) - Flag for admin users
- `admin_role` ENUM - Role: super_admin, admin, moderator
- Index on `is_admin` for performance

### Admin Logs Table
New table for audit trail:
- `admin_id` - Who performed the action
- `action` - What action was performed
- `target_id` - ID of affected resource
- `details` - Additional information
- `created_at` - Timestamp

---

## 🔧 Configuration

### Database Connection
Update credentials in `config/database.php`:

```php
private $host = "localhost";
private $db_name = "your_database";
private $username = "your_username";
private $password = "your_password";
```

### JWT Configuration
Update JWT settings in `config/jwt.php`:

```php
public static $secret_key = "your-secret-key";
public static $access_token_expiry = 3600; // 1 hour
public static $refresh_token_expiry = 2592000; // 30 days
```

---

## 🐛 Troubleshooting

### "Database connection failed"
- Check database credentials in `config/database.php`
- Ensure MySQL service is running
- Verify database exists

### "Admin access required"
- Ensure user has `is_admin = 1` in database
- Check JWT token is valid and not expired
- Verify Authorization header format: `Bearer {token}`

### "Authorization header missing"
- Include Authorization header in request
- Format: `Authorization: Bearer {access_token}`

### "Invalid or expired token"
- Token may have expired (1 hour default)
- Use refresh token to get new access token
- Re-login if refresh token expired

---

## 📝 Next Steps

### Phase 2: Frontend UI
1. Create admin login page
2. Build dashboard layout
3. Implement user management UI
4. Create ad moderation interface
5. Build reports management page
6. Add analytics visualizations

### Phase 3: Additional Features
1. Email notifications for admin actions
2. Advanced search and filtering
3. Bulk operations
4. Export to multiple formats (PDF, Excel)
5. Real-time updates with WebSockets
6. Two-factor authentication for admins

---

## 📚 Resources

- **API Documentation:** `admin_api_documentation.md`
- **Implementation Plan:** `admin_panel_plan.md`
- **Database Schema:** `database/schema.sql`
- **Migration Scripts:** `database/migrations/`

---

## ✅ Implementation Status

### Phase 1: Backend API Endpoints ✅ COMPLETED

- ✅ ADM-001: Add is_admin field to users table
- ✅ ADM-002: Create admin login endpoint
- ✅ ADM-003: Create admin middleware
- ✅ ADM-004: Create AdminController.php
- ✅ ADM-401: Dashboard stats endpoint
- ✅ ADM-402: Recent activity endpoint
- ✅ ADM-101-109: User management endpoints (all 9)
- ✅ ADM-201-210: Ad moderation endpoints (all 10)
- ✅ ADM-301-306: Reports management endpoints (all 6)
- ✅ ADM-501-506: Analytics endpoints (all 6)

**Total Endpoints Implemented:** 35+

---

**Created:** January 3, 2026  
**Status:** Phase 1 Complete ✅  
**Next:** Phase 2 - Frontend UI Implementation
