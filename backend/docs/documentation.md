# Market Local Backend - Documentation

**Version:** 1.0.0  
**Last Updated:** January 2, 2026  
**Production URL:** https://market.bazarino.store/api

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Database Schema](#database-schema)
6. [API Endpoints](#api-endpoints)
7. [Authentication](#authentication)
8. [Error Handling](#error-handling)
9. [File Uploads](#file-uploads)
10. [Security](#security)
11. [Deployment](#deployment)
12. [Development Guide](#development-guide)

---

## Overview

Market Local Backend is a RESTful API built with pure PHP for a marketplace application. It provides comprehensive functionality for user management, ad listings, messaging, and more.

### Key Features

- ✅ JWT-based authentication
- ✅ User registration and profile management
- ✅ Ad/listing CRUD operations
- ✅ Advanced search and filtering
- ✅ Image upload and management
- ✅ Favorites system
- ✅ Category management
- ✅ Review and rating system (schema ready)
- ✅ Messaging system (schema ready)
- ✅ Notification system (schema ready)

### Production Status

- **Environment:** Production
- **Server:** cPanel Shared Hosting
- **Database:** MySQL/MariaDB
- **SSL:** Enabled (HTTPS)
- **Status:** ✅ Live and Operational

---

## Architecture

### Design Pattern

The backend follows a **layered architecture** pattern:

```
┌─────────────────────────────────────┐
│         HTTP Request                │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      index.php (Router)             │
│  - Parse URI                        │
│  - Route to Controller              │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Controllers                 │
│  - AuthController                   │
│  - UserController                   │
│  - AdController                     │
│  - CategoryController               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│           Models                    │
│  - User Model                       │
│  - Ad Model                         │
│  - Business Logic                   │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Database (MySQL)            │
│  - 13 Tables                        │
│  - Relationships                    │
└─────────────────────────────────────┘
```

### Core Components

1. **Router (index.php)**: Central entry point, handles URL routing
2. **Controllers**: Handle HTTP requests and responses
3. **Models**: Database operations and business logic
4. **Middleware**: Authentication and request validation
5. **Utilities**: Helper classes (Response, Validator, JWT)
6. **Config**: Configuration files for database, JWT, and app settings

---

## Technology Stack

### Backend

- **Language:** PHP 8.0+
- **Database:** MySQL 5.7+ / MariaDB 10.3+
- **Web Server:** Apache with mod_rewrite
- **Authentication:** JWT (JSON Web Tokens)

### Key Libraries

- **PDO:** Database abstraction layer
- **Custom JWT:** Lightweight JWT implementation
- **Custom Validator:** Input validation
- **Custom Response Handler:** Standardized JSON responses

### No External Dependencies

The backend is built with **pure PHP** - no Composer dependencies required. This makes deployment to shared hosting extremely simple.

---

## Project Structure

```
backend/
├── config/
│   ├── config.php          # General configuration
│   ├── database.php        # Database connection
│   └── jwt.php             # JWT configuration
│
├── controllers/
│   ├── AuthController.php  # Authentication endpoints
│   ├── UserController.php  # User management
│   ├── AdController.php    # Ad/listing management
│   └── CategoryController.php # Category endpoints
│
├── models/
│   ├── User.php            # User model
│   └── Ad.php              # Ad model
│
├── middleware/
│   └── AuthMiddleware.php  # JWT authentication
│
├── utils/
│   ├── Response.php        # JSON response helper
│   ├── Validator.php       # Input validation
│   └── JWT.php             # JWT encode/decode
│
├── database/
│   └── schema.sql          # Database schema
│
├── uploads/
│   ├── avatars/            # User profile images
│   └── ads/                # Ad images
│
├── docs/
│   ├── documentation.md    # This file
│   ├── api_reference.md    # API endpoint reference
│   └── todo.md             # Backend tasks
│
├── .htaccess               # Apache rewrite rules
├── index.php               # Main entry point
├── README.md               # Quick start guide
└── DEPLOYMENT_GUIDE.md     # Deployment instructions
```

---

## Database Schema

### Overview

The database consists of **13 tables** with proper relationships and indexes.

### Core Tables

#### 1. users
Stores user account information.

**Key Fields:**
- `id`, `name`, `email`, `phone`, `password`
- `avatar`, `bio`, `location`
- `rating`, `review_count`
- `active_listings`, `sold_items`, `followers`
- `is_verified`, `is_active`

#### 2. categories
Product categories with hierarchical support.

**Key Fields:**
- `id`, `name`, `slug`, `icon`
- `parent_id` (for subcategories)
- `display_order`, `is_active`

#### 3. ads
Product listings/advertisements.

**Key Fields:**
- `id`, `user_id`, `category_id`
- `title`, `description`, `price`
- `condition` (new, like_new, good, fair, poor)
- `location`, `latitude`, `longitude`
- `status` (active, sold, expired, deleted)
- `views`, `favorites`
- `is_promoted`, `is_featured`

#### 4. ad_images
Images for each ad (multiple images per ad).

**Key Fields:**
- `id`, `ad_id`, `image_url`
- `display_order`, `is_primary`

#### 5. favorites
User's favorited ads.

**Key Fields:**
- `id`, `user_id`, `ad_id`

#### 6. conversations
Chat conversations between users.

**Key Fields:**
- `id`, `ad_id`, `buyer_id`, `seller_id`
- `last_message`, `last_message_at`
- `is_read_by_buyer`, `is_read_by_seller`

#### 7. messages
Individual messages in conversations.

**Key Fields:**
- `id`, `conversation_id`, `sender_id`
- `message`, `image_url`
- `is_read`

#### 8. reviews
User reviews and ratings.

**Key Fields:**
- `id`, `reviewer_id`, `reviewed_user_id`, `ad_id`
- `rating` (1-5), `comment`

#### 9. notifications
User notifications.

**Key Fields:**
- `id`, `user_id`, `type`
- `title`, `message`, `related_id`
- `is_read`

#### 10. refresh_tokens
JWT refresh tokens for authentication.

**Key Fields:**
- `id`, `user_id`, `token`
- `expires_at`

#### 11. reports
User-reported content.

**Key Fields:**
- `id`, `reporter_id`, `reported_type`, `reported_id`
- `reason`, `description`, `status`

### Relationships

```
users (1) ──── (N) ads
users (1) ──── (N) favorites
users (1) ──── (N) reviews (as reviewer)
users (1) ──── (N) reviews (as reviewed)
users (1) ──── (N) conversations (as buyer)
users (1) ──── (N) conversations (as seller)
users (1) ──── (N) messages
users (1) ──── (N) notifications

categories (1) ──── (N) ads
categories (1) ──── (N) categories (parent/child)

ads (1) ──── (N) ad_images
ads (1) ──── (N) favorites
ads (1) ──── (N) conversations

conversations (1) ──── (N) messages
```

### Indexes

All tables have appropriate indexes for:
- Primary keys
- Foreign keys
- Frequently queried fields (email, location, status, etc.)
- Full-text search (title, description in ads table)

---

## API Endpoints

### Base URL

```
Production: https://market.bazarino.store/api
```

### Response Format

All endpoints return JSON in this format:

**Success Response:**
```json
{
  "success": true,
  "message": "Success message",
  "data": { ... }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Error message",
  "errors": { ... }  // Optional validation errors
}
```

### Endpoint Categories

1. **Authentication** (`/auth/*`)
   - Register, Login, Logout, Refresh Token, Get Current User

2. **Users** (`/users/*`)
   - Get Profile, Update Profile, Upload Avatar, Change Password, Delete Account

3. **Ads** (`/ads/*`)
   - CRUD operations, Search, Filter, Mark as Sold, Upload Images, Favorites

4. **Categories** (`/categories`)
   - Get all categories

For detailed endpoint documentation, see [API Reference](api_reference.md).

---

## Authentication

### JWT (JSON Web Tokens)

The API uses JWT for stateless authentication.

#### Token Types

1. **Access Token**
   - Expires: 1 hour
   - Used for API requests
   - Sent in Authorization header

2. **Refresh Token**
   - Expires: 30 days
   - Used to get new access token
   - Stored in database

#### Authentication Flow

```
1. User registers/logs in
   ↓
2. Server generates access_token + refresh_token
   ↓
3. Client stores both tokens
   ↓
4. Client sends access_token in Authorization header
   ↓
5. When access_token expires:
   - Client sends refresh_token to /auth/refresh
   - Server returns new access_token
```

#### Using Authentication

**Include in request headers:**
```
Authorization: Bearer {access_token}
```

**Example:**
```bash
curl -X GET https://market.bazarino.store/api/auth/me \
  -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc..."
```

---

## Error Handling

### HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `405` - Method Not Allowed
- `409` - Conflict (e.g., email already exists)
- `422` - Validation Error
- `500` - Internal Server Error

### Error Response Examples

**Validation Error (422):**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": "Invalid email format",
    "password": "Password must be at least 6 characters"
  }
}
```

**Authentication Error (401):**
```json
{
  "success": false,
  "message": "Invalid or expired token"
}
```

**Not Found (404):**
```json
{
  "success": false,
  "message": "Resource not found"
}
```

---

## File Uploads

### Supported Operations

1. **Profile Avatar Upload** (`POST /users/avatar`)
2. **Ad Images Upload** (`POST /ads/:id/images`)

### Upload Specifications

- **Max File Size:** 5MB
- **Allowed Types:** JPEG, PNG, JPG, WebP
- **Content-Type:** `multipart/form-data`

### Upload Process

1. Client selects image
2. Client sends multipart request
3. Server validates file (type, size)
4. Server saves file to `uploads/` directory
5. Server returns public URL

### Example Upload

```bash
curl -X POST https://market.bazarino.store/api/users/avatar \
  -H "Authorization: Bearer {token}" \
  -F "avatar=@/path/to/image.jpg"
```

**Response:**
```json
{
  "success": true,
  "message": "Avatar updated successfully",
  "data": {
    "avatar": "https://market.bazarino.store/api/uploads/avatars/avatar_123_1234567890.jpg"
  }
}
```

---

## Security

### Implemented Security Measures

1. **Password Hashing**
   - Uses `PASSWORD_BCRYPT` algorithm
   - Automatic salt generation

2. **JWT Authentication**
   - Signed tokens with secret key
   - Token expiration
   - Refresh token rotation

3. **SQL Injection Prevention**
   - PDO prepared statements
   - Parameter binding

4. **Input Validation**
   - Server-side validation for all inputs
   - Type checking and sanitization

5. **CORS Configuration**
   - Configurable allowed origins
   - Preflight request handling

6. **HTTPS Enforcement**
   - SSL certificate installed
   - Secure data transmission

7. **File Upload Security**
   - File type validation
   - File size limits
   - Unique filename generation

8. **Security Headers**
   - X-Content-Type-Options: nosniff
   - X-Frame-Options: SAMEORIGIN
   - X-XSS-Protection: 1; mode=block

### Security Best Practices

- ✅ Never commit sensitive data (passwords, keys) to version control
- ✅ Use environment-specific configuration
- ✅ Regularly update JWT secret key
- ✅ Monitor error logs for suspicious activity
- ✅ Implement rate limiting (future enhancement)
- ✅ Regular database backups

---

## Deployment

### Production Environment

- **Hosting:** cPanel Shared Hosting
- **Domain:** market.bazarino.store
- **Path:** `/public_html/api/`
- **Database:** bazapndu_market
- **SSL:** Let's Encrypt (Auto-renewed)

### Deployment Checklist

- [x] Database created and schema imported
- [x] Configuration files updated
- [x] JWT secret key set
- [x] File permissions configured
- [x] .htaccess uploaded
- [x] SSL certificate installed
- [x] Base URL configured
- [x] Error reporting disabled in production
- [x] API tested and verified

### Monitoring

**Check API Status:**
```bash
curl https://market.bazarino.store/api/
```

**Expected Response:**
```json
{
  "success": true,
  "message": "API is running",
  "data": {
    "name": "Market Local API",
    "version": "1.0.0",
    "status": "running"
  }
}
```

---

## Development Guide

### Local Setup

1. **Install XAMPP/WAMP/MAMP**
2. **Clone repository to htdocs**
3. **Create database:**
   ```sql
   CREATE DATABASE market_local;
   ```
4. **Import schema:**
   ```bash
   mysql -u root -p market_local < database/schema.sql
   ```
5. **Update config/database.php**
6. **Access:** `http://localhost/backend/`

### Testing

**Test Registration:**
```bash
curl -X POST http://localhost/backend/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "location": "Test City"
  }'
```

### Debugging

1. **Enable error display** (in config/config.php):
   ```php
   error_reporting(E_ALL);
   ini_set('display_errors', 1);
   ```

2. **Check error logs:**
   - cPanel: Error Logs section
   - Local: Apache error.log

3. **Use debug files:**
   - `test_register.php` - Test registration flow
   - `test_simple.php` - Simple registration test
   - `debug.php` - Request debugging

### Code Style

- Use PSR-12 coding standard
- Add PHPDoc comments for all methods
- Use meaningful variable names
- Keep functions focused and small
- Follow existing patterns

---

## Support & Maintenance

### Regular Tasks

- **Daily:** Monitor error logs
- **Weekly:** Database backup
- **Monthly:** Security audit, dependency updates

### Backup Strategy

1. **Database Backup:**
   - Automated via cPanel
   - Manual backup before major changes

2. **File Backup:**
   - Version control (Git)
   - cPanel backup system

### Troubleshooting

**Common Issues:**

1. **Empty Response**
   - Check .htaccess file
   - Verify mod_rewrite enabled
   - Check PHP error logs

2. **Database Connection Failed**
   - Verify credentials in config/database.php
   - Check database exists
   - Verify user permissions

3. **401 Unauthorized**
   - Check token in Authorization header
   - Verify token hasn't expired
   - Check JWT secret key matches

---

## Version History

### v1.0.0 (January 2, 2026)

**Initial Release**

- ✅ Complete RESTful API
- ✅ JWT authentication
- ✅ User management
- ✅ Ad/listing system
- ✅ Search and filtering
- ✅ Image uploads
- ✅ Favorites system
- ✅ Production deployment

**Database:**
- 13 tables with relationships
- Proper indexes and constraints
- Sample data (categories)

**Documentation:**
- API reference
- Deployment guide
- Development guide

---

## Future Enhancements

### Planned Features

1. **WebSocket Support** - Real-time chat
2. **Push Notifications** - FCM integration
3. **Rate Limiting** - API throttling
4. **Caching Layer** - Redis/Memcached
5. **Admin Dashboard** - Web-based admin panel
6. **Analytics** - Usage tracking and reporting
7. **Email Service** - Transactional emails
8. **SMS Service** - OTP and notifications

### Scalability Considerations

- Database replication for read scaling
- CDN for static assets and images
- Load balancer for multiple app servers
- Queue system for background jobs
- Microservices architecture (future)

---

## Contact & Support

**Project:** Market Local Backend API  
**Version:** 1.0.0  
**Status:** Production  
**Documentation:** https://market.bazarino.store/api/docs/

For issues or questions, refer to:
- API Reference documentation
- Deployment guide
- Backend TODO list

---

*Last Updated: January 2, 2026*
