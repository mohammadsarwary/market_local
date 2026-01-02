# API Reference - Market Local Backend

**Base URL:** `https://market.bazarino.store/api`  
**Version:** 1.0.0  
**Last Updated:** January 2, 2026

---

## Table of Contents

1. [Authentication Endpoints](#authentication-endpoints)
2. [User Endpoints](#user-endpoints)
3. [Ad Endpoints](#ad-endpoints)
4. [Category Endpoints](#category-endpoints)
5. [Request/Response Examples](#requestresponse-examples)

---

## Authentication Endpoints

### Register User

Create a new user account.

**Endpoint:** `POST /auth/register`  
**Authentication:** Not required

**Request Body:**
```json
{
  "name": "string (required, 2-100 chars)",
  "email": "string (required, valid email)",
  "phone": "string (optional)",
  "password": "string (required, min 6 chars)",
  "location": "string (optional)"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "user": {
      "id": "1",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": null,
      "avatar": "default-avatar.png",
      "bio": null,
      "location": "Kabul",
      "rating": "0.0",
      "review_count": "0",
      "active_listings": "0",
      "sold_items": "0",
      "followers": "0",
      "is_verified": "0",
      "created_at": "2026-01-02 10:30:00",
      "updated_at": "2026-01-02 10:30:00"
    },
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

**Error Responses:**
- `422` - Validation error
- `409` - Email already registered

---

### Login

Authenticate user and get tokens.

**Endpoint:** `POST /auth/login`  
**Authentication:** Not required

**Request Body:**
```json
{
  "email": "string (required)",
  "password": "string (required)"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "access_token": "...",
    "refresh_token": "...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

**Error Responses:**
- `401` - Invalid credentials
- `403` - Account deactivated

---

### Refresh Token

Get new access token using refresh token.

**Endpoint:** `POST /auth/refresh`  
**Authentication:** Not required

**Request Body:**
```json
{
  "refresh_token": "string (required)"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "data": {
    "access_token": "...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

**Error Responses:**
- `401` - Invalid or expired refresh token

---

### Logout

Invalidate refresh token.

**Endpoint:** `POST /auth/logout`  
**Authentication:** Not required

**Request Body:**
```json
{
  "refresh_token": "string (optional)"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Logout successful",
  "data": null
}
```

---

### Get Current User

Get authenticated user's profile.

**Endpoint:** `GET /auth/me`  
**Authentication:** Required

**Success Response (200):**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "id": "1",
    "name": "John Doe",
    "email": "john@example.com",
    ...
  }
}
```

**Error Responses:**
- `401` - Unauthorized

---

## User Endpoints

### Get User Profile

Get public profile of any user.

**Endpoint:** `GET /users/:id`  
**Authentication:** Not required

**URL Parameters:**
- `id` (integer) - User ID

**Success Response (200):**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "id": "1",
    "name": "John Doe",
    "avatar": "...",
    "rating": "4.5",
    "review_count": "10",
    "active_listings": "5",
    "sold_items": "15",
    ...
  }
}
```

**Error Responses:**
- `404` - User not found

---

### Update Profile

Update authenticated user's profile.

**Endpoint:** `PUT /users/profile`  
**Authentication:** Required

**Request Body:**
```json
{
  "name": "string (optional, 2-100 chars)",
  "phone": "string (optional)",
  "bio": "string (optional, max 500 chars)",
  "location": "string (optional)"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "id": "1",
    "name": "Updated Name",
    ...
  }
}
```

**Error Responses:**
- `401` - Unauthorized
- `422` - Validation error
- `409` - Phone number already in use

---

### Upload Avatar

Upload or update profile picture.

**Endpoint:** `POST /users/avatar`  
**Authentication:** Required  
**Content-Type:** `multipart/form-data`

**Form Data:**
- `avatar` (file) - Image file (JPEG, PNG, WebP, max 5MB)

**Success Response (200):**
```json
{
  "success": true,
  "message": "Avatar updated successfully",
  "data": {
    "avatar": "https://market.bazarino.store/api/uploads/avatars/avatar_1_1234567890.jpg"
  }
}
```

**Error Responses:**
- `401` - Unauthorized
- `400` - Invalid file type or size

---

### Change Password

Change user's password.

**Endpoint:** `POST /users/change-password`  
**Authentication:** Required

**Request Body:**
```json
{
  "current_password": "string (required)",
  "new_password": "string (required, min 6 chars)"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Password changed successfully",
  "data": null
}
```

**Error Responses:**
- `401` - Unauthorized
- `400` - Current password incorrect
- `422` - Validation error

---

### Delete Account

Delete user account (soft delete).

**Endpoint:** `DELETE /users/account`  
**Authentication:** Required

**Request Body:**
```json
{
  "password": "string (required)"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Account deleted successfully",
  "data": null
}
```

**Error Responses:**
- `401` - Unauthorized
- `400` - Password incorrect

---

## Ad Endpoints

### Get All Ads

Get list of ads with optional filters.

**Endpoint:** `GET /ads`  
**Authentication:** Not required

**Query Parameters:**
- `category_id` (integer, optional) - Filter by category
- `search` (string, optional) - Search in title/description
- `min_price` (number, optional) - Minimum price
- `max_price` (number, optional) - Maximum price
- `location` (string, optional) - Filter by location
- `condition` (string, optional) - Filter by condition (new, like_new, good, fair, poor)
- `sort` (string, optional) - Sort order (newest, price_asc, price_desc, oldest)
- `page` (integer, optional, default: 1) - Page number
- `limit` (integer, optional, default: 20, max: 100) - Items per page

**Success Response (200):**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "ads": [
      {
        "id": "1",
        "user_id": "1",
        "category_id": "1",
        "title": "iPhone 13 Pro Max",
        "description": "Brand new...",
        "price": "1200.00",
        "condition": "new",
        "location": "Kabul",
        "status": "active",
        "views": "50",
        "favorites": "0",
        "user_name": "John Doe",
        "user_avatar": "...",
        "user_rating": "4.5",
        "category_name": "Electronics",
        "primary_image": "...",
        "favorite_count": "5",
        "created_at": "2026-01-02 10:00:00"
      }
    ],
    "page": 1,
    "limit": 20
  }
}
```

---

### Get Ad by ID

Get detailed information about a specific ad.

**Endpoint:** `GET /ads/:id`  
**Authentication:** Optional (shows is_favorited if authenticated)

**URL Parameters:**
- `id` (integer) - Ad ID

**Success Response (200):**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "id": "1",
    "user_id": "1",
    "title": "iPhone 13 Pro Max",
    "description": "Brand new iPhone...",
    "price": "1200.00",
    "condition": "new",
    "location": "Kabul",
    "latitude": "34.5553",
    "longitude": "69.2075",
    "status": "active",
    "views": "51",
    "user_name": "John Doe",
    "user_avatar": "...",
    "user_rating": "4.5",
    "user_review_count": "10",
    "user_member_since": "2025-12-01 00:00:00",
    "category_name": "Electronics",
    "is_favorited": "0",
    "images": [
      {
        "image_url": "https://...",
        "is_primary": "1"
      }
    ],
    "created_at": "2026-01-02 10:00:00"
  }
}
```

**Error Responses:**
- `404` - Ad not found

---

### Create Ad

Create a new ad listing.

**Endpoint:** `POST /ads`  
**Authentication:** Required

**Request Body:**
```json
{
  "title": "string (required, 5-200 chars)",
  "description": "string (required, min 20 chars)",
  "price": "number (required, min 0)",
  "category_id": "integer (required)",
  "condition": "string (optional, default: good)",
  "location": "string (required)",
  "latitude": "number (optional)",
  "longitude": "number (optional)"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "Ad created successfully",
  "data": {
    "id": "1",
    "title": "...",
    ...
  }
}
```

**Error Responses:**
- `401` - Unauthorized
- `422` - Validation error

---

### Update Ad

Update an existing ad.

**Endpoint:** `PUT /ads/:id`  
**Authentication:** Required (must be ad owner)

**URL Parameters:**
- `id` (integer) - Ad ID

**Request Body:**
```json
{
  "title": "string (optional)",
  "description": "string (optional)",
  "price": "number (optional)",
  "condition": "string (optional)",
  "location": "string (optional)",
  "category_id": "integer (optional)"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Ad updated successfully",
  "data": { ... }
}
```

**Error Responses:**
- `401` - Unauthorized
- `403` - Not ad owner
- `404` - Ad not found
- `422` - Validation error

---

### Delete Ad

Delete an ad (soft delete).

**Endpoint:** `DELETE /ads/:id`  
**Authentication:** Required (must be ad owner)

**URL Parameters:**
- `id` (integer) - Ad ID

**Success Response (200):**
```json
{
  "success": true,
  "message": "Ad deleted successfully",
  "data": null
}
```

**Error Responses:**
- `401` - Unauthorized
- `403` - Not ad owner
- `404` - Ad not found

---

### Mark Ad as Sold

Mark an ad as sold.

**Endpoint:** `POST /ads/:id/sold`  
**Authentication:** Required (must be ad owner)

**URL Parameters:**
- `id` (integer) - Ad ID

**Success Response (200):**
```json
{
  "success": true,
  "message": "Ad marked as sold",
  "data": null
}
```

**Error Responses:**
- `401` - Unauthorized
- `403` - Not ad owner
- `404` - Ad not found

---

### Upload Ad Images

Upload images for an ad.

**Endpoint:** `POST /ads/:id/images`  
**Authentication:** Required (must be ad owner)  
**Content-Type:** `multipart/form-data`

**URL Parameters:**
- `id` (integer) - Ad ID

**Form Data:**
- `images` (file[]) - One or more image files (JPEG, PNG, WebP, max 5MB each)

**Success Response (200):**
```json
{
  "success": true,
  "message": "Images uploaded successfully",
  "data": {
    "images": [
      "https://market.bazarino.store/api/uploads/ads/ad_1_1234567890_0.jpg",
      "https://market.bazarino.store/api/uploads/ads/ad_1_1234567890_1.jpg"
    ]
  }
}
```

**Error Responses:**
- `401` - Unauthorized
- `403` - Not ad owner
- `404` - Ad not found
- `400` - Invalid file type or size

---

### Toggle Favorite

Add or remove ad from favorites.

**Endpoint:** `POST /ads/:id/favorite`  
**Authentication:** Required

**URL Parameters:**
- `id` (integer) - Ad ID

**Success Response (200):**
```json
{
  "success": true,
  "message": "Added to favorites",
  "data": {
    "is_favorited": true
  }
}
```

Or:

```json
{
  "success": true,
  "message": "Removed from favorites",
  "data": {
    "is_favorited": false
  }
}
```

**Error Responses:**
- `401` - Unauthorized
- `404` - Ad not found

---

### Get User's Favorites

Get list of user's favorited ads.

**Endpoint:** `GET /users/favorites`  
**Authentication:** Required

**Success Response (200):**
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "id": "1",
      "title": "iPhone 13 Pro Max",
      "price": "1200.00",
      "category_name": "Electronics",
      "primary_image": "...",
      ...
    }
  ]
}
```

**Error Responses:**
- `401` - Unauthorized

---

### Get User's Ads

Get ads posted by a specific user.

**Endpoint:** `GET /users/:userId/ads`  
**Authentication:** Not required

**URL Parameters:**
- `userId` (integer) - User ID

**Query Parameters:**
- `status` (string, optional, default: active) - Filter by status (active, sold)

**Success Response (200):**
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "id": "1",
      "title": "...",
      "price": "...",
      "status": "active",
      ...
    }
  ]
}
```

---

## Category Endpoints

### Get All Categories

Get list of all active categories.

**Endpoint:** `GET /categories`  
**Authentication:** Not required

**Success Response (200):**
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "id": "1",
      "name": "Electronics",
      "slug": "electronics",
      "icon": "devices",
      "parent_id": null,
      "display_order": 1
    },
    {
      "id": "2",
      "name": "Vehicles",
      "slug": "vehicles",
      "icon": "directions_car",
      "parent_id": null,
      "display_order": 2
    }
  ]
}
```

---

## Request/Response Examples

### Example 1: Complete Registration Flow

**1. Register:**
```bash
curl -X POST https://market.bazarino.store/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "securepass123",
    "location": "Kabul"
  }'
```

**2. Use Access Token:**
```bash
curl -X GET https://market.bazarino.store/api/auth/me \
  -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc..."
```

---

### Example 2: Post an Ad with Images

**1. Create Ad:**
```bash
curl -X POST https://market.bazarino.store/api/ads \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "iPhone 13 Pro Max - 256GB",
    "description": "Brand new iPhone 13 Pro Max in blue color. Never used, still in box with all accessories.",
    "price": 1200,
    "category_id": 1,
    "condition": "new",
    "location": "Kabul, Afghanistan",
    "latitude": 34.5553,
    "longitude": 69.2075
  }'
```

**Response:**
```json
{
  "success": true,
  "message": "Ad created successfully",
  "data": {
    "id": "15",
    ...
  }
}
```

**2. Upload Images:**
```bash
curl -X POST https://market.bazarino.store/api/ads/15/images \
  -H "Authorization: Bearer {token}" \
  -F "images=@/path/to/image1.jpg" \
  -F "images=@/path/to/image2.jpg" \
  -F "images=@/path/to/image3.jpg"
```

---

### Example 3: Search and Filter

**Search for iPhones under $1000 in Kabul:**
```bash
curl -X GET "https://market.bazarino.store/api/ads?search=iphone&max_price=1000&location=Kabul&sort=price_asc"
```

---

### Example 4: Error Handling

**Invalid Email Format:**
```bash
curl -X POST https://market.bazarino.store/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John",
    "email": "invalid-email",
    "password": "pass"
  }'
```

**Response (422):**
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

---

## Rate Limits

Currently, there are **no rate limits** implemented. This will be added in a future version.

**Recommended client-side practices:**
- Implement request debouncing for search
- Cache responses when appropriate
- Use pagination for large lists
- Avoid unnecessary API calls

---

## Changelog

### v1.0.0 (January 2, 2026)
- Initial API release
- All core endpoints implemented
- JWT authentication
- Image upload support
- Search and filtering

---

*For more information, see the [main documentation](documentation.md).*
