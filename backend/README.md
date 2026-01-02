# Market Local API

PHP REST API for Market Local marketplace application.

## 📋 Requirements

- PHP 8.0 or higher
- MySQL 5.7 or higher / MariaDB 10.3 or higher
- Apache with mod_rewrite enabled
- cPanel hosting (recommended)

## 🚀 Installation

### 1. Database Setup

1. Create a new MySQL database in cPanel
2. Import the schema:
   ```bash
   mysql -u username -p database_name < database/schema.sql
   ```

### 2. Configuration

1. Update database credentials in `config/database.php`:
   ```php
   private $host = "localhost";
   private $db_name = "your_database_name";
   private $username = "your_username";
   private $password = "your_password";
   ```

2. Update JWT secret key in `config/jwt.php`:
   ```php
   public static $secret_key = "your-random-secret-key-here";
   ```

3. Update base URL in `config/config.php`:
   ```php
   define('BASE_URL', 'https://yourdomain.com/api');
   ```

4. Update base path in `.htaccess` and `index.php` if needed:
   ```apache
   RewriteBase /api/
   ```

### 3. Upload to cPanel

1. Compress the `backend` folder
2. Upload to your cPanel File Manager
3. Extract in your desired directory (e.g., `public_html/api/`)
4. Set permissions:
   - Folders: 755
   - Files: 644
   - `uploads/` folder: 755 (writable)

### 4. Test the API

Visit: `https://yourdomain.com/api/`

You should see:
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

## 📚 API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Login user | No |
| POST | `/api/auth/refresh` | Refresh access token | No |
| POST | `/api/auth/logout` | Logout user | No |
| GET | `/api/auth/me` | Get current user | Yes |

### Users

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/users/:id` | Get user profile | No |
| PUT | `/api/users/profile` | Update profile | Yes |
| POST | `/api/users/avatar` | Update avatar | Yes |
| POST | `/api/users/change-password` | Change password | Yes |
| DELETE | `/api/users/account` | Delete account | Yes |
| GET | `/api/users/favorites` | Get user's favorites | Yes |
| GET | `/api/users/:id/ads` | Get user's ads | No |

### Ads

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/ads` | Get all ads (with filters) | No |
| GET | `/api/ads/:id` | Get ad by ID | No |
| POST | `/api/ads` | Create new ad | Yes |
| PUT | `/api/ads/:id` | Update ad | Yes |
| DELETE | `/api/ads/:id` | Delete ad | Yes |
| POST | `/api/ads/:id/sold` | Mark ad as sold | Yes |
| POST | `/api/ads/:id/images` | Upload ad images | Yes |
| POST | `/api/ads/:id/favorite` | Toggle favorite | Yes |

### Categories

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/categories` | Get all categories | No |

## 🔐 Authentication

The API uses JWT (JSON Web Tokens) for authentication.

### Register/Login Response:
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

### Using the Token:

Include the access token in the Authorization header:
```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
```

### Token Expiry:
- Access Token: 1 hour
- Refresh Token: 30 days

Use the refresh endpoint to get a new access token without re-logging in.

## 📝 Request Examples

### Register User
```bash
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+93700000000",
  "password": "password123",
  "location": "Kabul"
}
```

### Create Ad
```bash
POST /api/ads
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "iPhone 13 Pro Max",
  "description": "Brand new iPhone 13 Pro Max, 256GB, Blue color",
  "price": 1200,
  "category_id": 1,
  "condition": "new",
  "location": "Kabul",
  "latitude": 34.5553,
  "longitude": 69.2075
}
```

### Search Ads
```bash
GET /api/ads?search=iphone&category_id=1&min_price=500&max_price=2000&sort=price_asc
```

### Upload Ad Images
```bash
POST /api/ads/123/images
Authorization: Bearer {token}
Content-Type: multipart/form-data

images: [file1.jpg, file2.jpg, file3.jpg]
```

## 🔧 Troubleshooting

### 404 Errors
- Check if mod_rewrite is enabled
- Verify .htaccess file is uploaded
- Check RewriteBase path in .htaccess

### Database Connection Failed
- Verify database credentials in config/database.php
- Check if database exists
- Ensure database user has proper permissions

### Upload Errors
- Check uploads/ folder permissions (755)
- Verify MAX_FILE_SIZE in config/config.php
- Check PHP upload_max_filesize and post_max_size

### CORS Issues
- CORS headers are set in config/config.php
- For production, update Access-Control-Allow-Origin to your domain

## 🔒 Security Notes

1. **Change JWT Secret**: Update the secret key in `config/jwt.php`
2. **Disable Error Display**: Set `display_errors = 0` in production
3. **Use HTTPS**: Always use SSL/TLS in production
4. **Database Backups**: Regular backups recommended
5. **File Permissions**: Ensure proper file/folder permissions

## 📦 Project Structure

```
backend/
├── config/           # Configuration files
├── controllers/      # Request handlers
├── models/          # Database models
├── middleware/      # Authentication middleware
├── utils/           # Helper utilities
├── database/        # Database schema
├── uploads/         # Uploaded files
│   ├── avatars/
│   └── ads/
├── .htaccess        # Apache configuration
├── index.php        # Main entry point
└── README.md        # This file
```

## 🆘 Support

For issues or questions, please check:
1. Error logs in cPanel
2. PHP error_log file
3. Browser console for CORS issues

## 📄 License

This project is part of the Market Local application.
