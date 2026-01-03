# 🛡️ Admin API Documentation

**Base URL:** `/backend/admin_api.php`  
**Authentication:** Bearer Token (JWT)  
**Content-Type:** application/json

---

## 🔐 Authentication

### Admin Login
**POST** `/login`

Login as an admin user. Returns JWT tokens for authenticated admin sessions.

**Request Body:**
```json
{
  "email": "admin@marketlocal.com",
  "password": "admin123"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Admin login successful",
  "data": {
    "user": {
      "id": 1,
      "name": "Admin",
      "email": "admin@marketlocal.com",
      "is_admin": 1,
      "admin_role": "super_admin"
    },
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

**Error Responses:**
- `401` - Invalid credentials
- `403` - Not an admin or account deactivated

---

### Verify Admin Session
**GET** `/verify`

Verify that the current admin session is valid.

**Headers:**
```
Authorization: Bearer {access_token}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Admin session valid",
  "data": {
    "user": { ... },
    "admin_role": "super_admin"
  }
}
```

---

## 📊 Dashboard Statistics

### Get Dashboard Stats
**GET** `/stats`

Get comprehensive dashboard statistics.

**Headers:**
```
Authorization: Bearer {access_token}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "total_users": 1250,
    "active_users": 980,
    "total_ads": 3420,
    "active_ads": 2100,
    "pending_ads": 45,
    "total_reports": 23,
    "pending_reports": 8,
    "new_users_today": 12,
    "new_ads_today": 34,
    "new_users_week": 85,
    "new_ads_week": 234
  }
}
```

---

### Get Recent Activity
**GET** `/activity?limit=20`

Get recent activity across the platform.

**Query Parameters:**
- `limit` (optional) - Number of activities to return (default: 20)

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "type": "user",
      "id": 123,
      "title": "John Doe",
      "subtitle": "john@example.com",
      "created_at": "2026-01-03 10:30:00"
    },
    {
      "type": "ad",
      "id": 456,
      "title": "iPhone 15 Pro",
      "subtitle": "Price: $999",
      "created_at": "2026-01-03 10:25:00"
    }
  ]
}
```

---

## 👥 User Management

### List All Users
**GET** `/users?page=1&limit=20&status=active&search=john`

Get paginated list of users with optional filters.

**Query Parameters:**
- `page` (optional) - Page number (default: 1)
- `limit` (optional) - Items per page (default: 20)
- `status` (optional) - Filter by status: `active`, `inactive`, `verified`, `admin`
- `search` (optional) - Search by name, email, or phone

**Response (200):**
```json
{
  "success": true,
  "data": {
    "users": [
      {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com",
        "phone": "+1234567890",
        "location": "New York",
        "rating": 4.5,
        "active_listings": 5,
        "is_verified": true,
        "is_active": true,
        "is_admin": false,
        "created_at": "2026-01-01 10:00:00",
        "last_login": "2026-01-03 09:00:00"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 1250,
      "pages": 63
    }
  }
}
```

---

### Get User Details
**GET** `/users/{id}`

Get detailed information about a specific user.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "total_ads": 25,
    "active_ads_count": 5,
    "recent_ads": [ ... ]
  }
}
```

---

### Suspend User
**PUT** `/users/{id}/suspend`

Suspend a user account.

**Request Body:**
```json
{
  "reason": "Violation of terms of service"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "User suspended successfully"
}
```

---

### Activate User
**PUT** `/users/{id}/activate`

Activate a suspended user account.

**Response (200):**
```json
{
  "success": true,
  "message": "User activated successfully"
}
```

---

### Verify User
**PUT** `/users/{id}/verify`

Manually verify a user account.

**Response (200):**
```json
{
  "success": true,
  "message": "User verified successfully"
}
```

---

### Delete User
**DELETE** `/users/{id}`

Permanently delete a user account. **Requires super_admin role.**

**Request Body:**
```json
{
  "reason": "User requested account deletion"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "User deleted successfully"
}
```

**Error Response:**
- `403` - Only super admins can delete users

---

### Get User Activity Log
**GET** `/users/{id}/activity`

Get activity log for a specific user.

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "type": "ad_created",
      "id": 123,
      "description": "iPhone 15 Pro",
      "created_at": "2026-01-03 10:00:00"
    }
  ]
}
```

---

### Export Users to CSV
**GET** `/users/export`

Export all users to CSV file.

**Response:** CSV file download

---

## 📢 Ad Management

### List All Ads
**GET** `/ads?page=1&limit=20&status=active&category=1&search=iphone`

Get paginated list of ads with optional filters.

**Query Parameters:**
- `page` (optional) - Page number (default: 1)
- `limit` (optional) - Items per page (default: 20)
- `status` (optional) - Filter by status: `active`, `sold`, `expired`, `deleted`
- `category` (optional) - Filter by category ID
- `search` (optional) - Search in title and description

**Response (200):**
```json
{
  "success": true,
  "data": {
    "ads": [
      {
        "id": 1,
        "title": "iPhone 15 Pro",
        "price": 999.00,
        "condition": "like_new",
        "location": "New York",
        "status": "active",
        "views": 150,
        "user_name": "John Doe",
        "user_email": "john@example.com",
        "category_name": "Electronics",
        "created_at": "2026-01-01 10:00:00"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 3420,
      "pages": 171
    }
  }
}
```

---

### Get Ad Details
**GET** `/ads/{id}`

Get detailed information about a specific ad.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "iPhone 15 Pro",
    "description": "Brand new iPhone...",
    "price": 999.00,
    "user_name": "John Doe",
    "user_email": "john@example.com",
    "user_phone": "+1234567890",
    "images": [
      {
        "id": 1,
        "image_url": "uploads/ad1_img1.jpg",
        "is_primary": true
      }
    ]
  }
}
```

---

### Delete Ad
**DELETE** `/ads/{id}`

Permanently delete an ad.

**Request Body:**
```json
{
  "reason": "Violates community guidelines"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Ad deleted successfully"
}
```

---

### Feature Ad
**PUT** `/ads/{id}/feature`

Mark an ad as featured.

**Request Body:**
```json
{
  "featured": true
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Ad Featured successfully"
}
```

---

### Promote Ad
**PUT** `/ads/{id}/promote`

Promote an ad for a specified duration.

**Request Body:**
```json
{
  "days": 7
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Ad promoted successfully"
}
```

---

### Export Ads to CSV
**GET** `/ads/export`

Export all ads to CSV file.

**Response:** CSV file download

---

## 🚨 Reports Management

### List Reports
**GET** `/reports?page=1&limit=20&status=pending&type=ad`

Get paginated list of reports with optional filters.

**Query Parameters:**
- `page` (optional) - Page number (default: 1)
- `limit` (optional) - Items per page (default: 20)
- `status` (optional) - Filter by status: `pending`, `reviewed`, `resolved`, `dismissed`
- `type` (optional) - Filter by type: `ad`, `user`, `message`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "reports": [
      {
        "id": 1,
        "reported_type": "ad",
        "reported_id": 123,
        "reason": "Spam",
        "description": "This ad is spam",
        "status": "pending",
        "reporter_name": "Jane Doe",
        "reporter_email": "jane@example.com",
        "created_at": "2026-01-03 10:00:00"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 23,
      "pages": 2
    }
  }
}
```

---

### Get Report Details
**GET** `/reports/{id}`

Get detailed information about a specific report.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "reported_type": "ad",
    "reported_id": 123,
    "reason": "Spam",
    "description": "This ad is spam",
    "status": "pending",
    "reporter_name": "Jane Doe",
    "reported_content": {
      "id": 123,
      "title": "iPhone 15 Pro",
      "price": 999.00
    }
  }
}
```

---

### Resolve Report
**PUT** `/reports/{id}/resolve`

Mark a report as resolved.

**Request Body:**
```json
{
  "action": "Content removed"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Report resolved successfully"
}
```

---

### Dismiss Report
**PUT** `/reports/{id}/dismiss`

Dismiss a report.

**Request Body:**
```json
{
  "reason": "Not a violation"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Report dismissed successfully"
}
```

---

### Take Action on Report
**POST** `/reports/{id}/action`

Take specific action based on a report.

**Request Body:**
```json
{
  "action": "delete_content"
}
```

**Available Actions:**
- `delete_content` - Delete the reported content
- `suspend_user` - Suspend the reported user
- `warn_user` - Send warning to user

**Response (200):**
```json
{
  "success": true,
  "message": "Action taken successfully"
}
```

---

### Get Report Statistics
**GET** `/reports/stats`

Get statistics about reports.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "total_reports": 23,
    "pending_reports": 8,
    "resolved_reports": 12,
    "dismissed_reports": 3,
    "reports_by_type": [
      {
        "reported_type": "ad",
        "count": 15
      },
      {
        "reported_type": "user",
        "count": 8
      }
    ]
  }
}
```

---

## 📈 Analytics

### User Growth Analytics
**GET** `/analytics/users?period=30days`

Get user growth data over time.

**Query Parameters:**
- `period` (optional) - Time period: `7days`, `30days`, `90days` (default: 30days)

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "date": "2026-01-01",
      "count": 15
    },
    {
      "date": "2026-01-02",
      "count": 23
    }
  ]
}
```

---

### Ad Posting Analytics
**GET** `/analytics/ads?period=7days`

Get ad posting trends over time.

**Query Parameters:**
- `period` (optional) - Time period: `7days`, `30days`, `90days` (default: 7days)

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "date": "2026-01-01",
      "count": 45
    }
  ]
}
```

---

### Category Distribution Analytics
**GET** `/analytics/categories`

Get distribution of ads across categories.

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "name": "Electronics",
      "count": 850
    },
    {
      "name": "Vehicles",
      "count": 620
    }
  ]
}
```

---

### Location Distribution Analytics
**GET** `/analytics/locations`

Get distribution of ads by location.

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "location": "New York",
      "count": 450
    },
    {
      "location": "Los Angeles",
      "count": 380
    }
  ]
}
```

---

## 🔒 Authorization

All admin endpoints require a valid JWT token in the Authorization header:

```
Authorization: Bearer {access_token}
```

### Admin Roles

- **super_admin** - Full access to all features including user deletion
- **admin** - Access to most features except critical operations
- **moderator** - Limited access to content moderation

### Error Responses

**401 Unauthorized:**
```json
{
  "success": false,
  "message": "Authorization header missing"
}
```

**403 Forbidden:**
```json
{
  "success": false,
  "message": "Admin access required"
}
```

**404 Not Found:**
```json
{
  "success": false,
  "message": "Resource not found"
}
```

**500 Internal Server Error:**
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details"
}
```

---

## 📝 Notes

1. All timestamps are in `Y-m-d H:i:s` format
2. All endpoints return JSON responses
3. Pagination starts at page 1
4. Default limit is 20 items per page
5. Admin actions are logged in the `admin_logs` table
6. CSV exports are downloaded directly as files

---

**Last Updated:** January 3, 2026  
**Version:** 1.0.0
