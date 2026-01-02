# 🚀 cPanel Deployment Guide

Step-by-step guide to deploy your Market Local API to cPanel hosting.

## 📋 Pre-Deployment Checklist

- [ ] cPanel hosting account with PHP 8.0+
- [ ] MySQL database access
- [ ] FTP/File Manager access
- [ ] Domain or subdomain configured

## 🗄️ Step 1: Create MySQL Database

1. **Login to cPanel**
2. **Go to MySQL Databases**
3. **Create New Database:**
   - Database Name: `market_local` (or your choice)
   - Click "Create Database"
4. **Create Database User:**
   - Username: Choose a username
   - Password: Generate strong password
   - Click "Create User"
5. **Add User to Database:**
   - Select the user and database
   - Grant ALL PRIVILEGES
   - Click "Add"
6. **Note down:**
   - Database name: `username_market_local`
   - Username: `username_dbuser`
   - Password: `your_password`
   - Host: `localhost`

## 📤 Step 2: Upload Files

### Option A: File Manager (Recommended)

1. **Compress the backend folder** on your computer
   - Right-click `backend` folder → Compress to ZIP
2. **Login to cPanel → File Manager**
3. **Navigate to deployment location:**
   - For main domain: `public_html/api/`
   - For subdomain: `public_html/subdomain/api/`
4. **Upload the ZIP file**
5. **Extract the ZIP file**
6. **Delete the ZIP file**

### Option B: FTP

1. **Use FileZilla or similar FTP client**
2. **Connect to your server:**
   - Host: `ftp.yourdomain.com`
   - Username: Your cPanel username
   - Password: Your cPanel password
   - Port: 21
3. **Upload the entire `backend` folder** to `public_html/api/`

## ⚙️ Step 3: Configure the API

### 3.1 Database Configuration

Edit `config/database.php`:

```php
private $host = "localhost";
private $db_name = "username_market_local";  // Your full database name
private $username = "username_dbuser";        // Your database username
private $password = "your_strong_password";   // Your database password
```

### 3.2 JWT Secret Key

Edit `config/jwt.php`:

```php
public static $secret_key = "CHANGE-THIS-TO-RANDOM-STRING-2026";
```

**Generate a random secret key:**
```bash
# Use this online: https://randomkeygen.com/
# Or generate in PHP:
# echo bin2hex(random_bytes(32));
```

### 3.3 Base URL Configuration

Edit `config/config.php`:

```php
define('BASE_URL', 'https://yourdomain.com/api');
// Or if in subdirectory:
// define('BASE_URL', 'https://yourdomain.com/subfolder/api');
```

### 3.4 Update .htaccess

Edit `.htaccess`:

```apache
RewriteBase /api/
# Or if in subdirectory:
# RewriteBase /subfolder/api/
```

Also update in `index.php`:

```php
$basePath = '/api'; // Change to match your path
```

### 3.5 Error Reporting (Production)

Edit `config/config.php` for production:

```php
error_reporting(0);
ini_set('display_errors', 0);
```

## 🗃️ Step 4: Import Database Schema

### Option A: phpMyAdmin

1. **cPanel → phpMyAdmin**
2. **Select your database** from left sidebar
3. **Click "Import" tab**
4. **Choose file:** `database/schema.sql`
5. **Click "Go"**
6. **Verify:** Check if all tables are created

### Option B: MySQL Command Line

```bash
mysql -u username_dbuser -p username_market_local < database/schema.sql
```

## 🔐 Step 5: Set Permissions

### Using File Manager:

1. **Right-click on `uploads` folder**
2. **Change Permissions → 755**
3. **Apply to subdirectories:**
   - `uploads/avatars/` → 755
   - `uploads/ads/` → 755

### Using FTP:

- Set folder permissions to **755** (rwxr-xr-x)
- Set file permissions to **644** (rw-r--r--)

## ✅ Step 6: Test the API

### 6.1 Test API Root

Visit: `https://yourdomain.com/api/`

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

### 6.2 Test Registration

**Using Postman or curl:**

```bash
curl -X POST https://yourdomain.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "location": "Kabul"
  }'
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "user": { ... },
    "access_token": "...",
    "refresh_token": "..."
  }
}
```

### 6.3 Test Login

```bash
curl -X POST https://yourdomain.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### 6.4 Test Categories

Visit: `https://yourdomain.com/api/categories`

Should return list of default categories.

## 🔧 Troubleshooting

### Issue: 500 Internal Server Error

**Solutions:**
1. Check `.htaccess` file is uploaded
2. Verify mod_rewrite is enabled (contact hosting support)
3. Check file permissions
4. Check PHP error logs in cPanel

### Issue: Database Connection Failed

**Solutions:**
1. Verify database credentials in `config/database.php`
2. Ensure database user has proper privileges
3. Check if database exists
4. Verify host is `localhost`

### Issue: 404 Not Found

**Solutions:**
1. Check `RewriteBase` in `.htaccess`
2. Verify `$basePath` in `index.php`
3. Ensure mod_rewrite is enabled
4. Check if .htaccess file exists

### Issue: CORS Errors

**Solutions:**
1. Update `Access-Control-Allow-Origin` in `config/config.php`
2. For specific domain:
   ```php
   header("Access-Control-Allow-Origin: https://yourapp.com");
   ```

### Issue: File Upload Fails

**Solutions:**
1. Check `uploads/` folder permissions (755)
2. Verify PHP `upload_max_filesize` setting
3. Check `post_max_size` in PHP settings
4. Ensure `uploads/` folder exists

### Issue: JWT Token Invalid

**Solutions:**
1. Verify JWT secret key is set in `config/jwt.php`
2. Check token is sent in Authorization header
3. Ensure token format: `Bearer {token}`

## 📊 Monitoring & Maintenance

### Check Error Logs

**cPanel → Error Logs**
- View PHP errors
- Monitor API issues
- Track failed requests

### Database Backups

**cPanel → Backup Wizard**
- Schedule automatic backups
- Download database backups regularly

### Update PHP Version

**cPanel → Select PHP Version**
- Keep PHP updated (8.0+)
- Enable required extensions:
  - PDO
  - PDO_MySQL
  - JSON
  - mbstring

## 🔒 Security Best Practices

1. **Use HTTPS:** Install SSL certificate (Let's Encrypt free)
2. **Strong Passwords:** Use complex database passwords
3. **JWT Secret:** Use long random string
4. **Disable Error Display:** In production
5. **Regular Updates:** Keep PHP and MySQL updated
6. **File Permissions:** Don't use 777
7. **Database Backups:** Regular automated backups
8. **Rate Limiting:** Consider implementing (future)

## 📱 Connect Flutter App

Update your Flutter app's API base URL:

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://yourdomain.com/api';
  
  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  
  // Ad endpoints
  static const String ads = '$baseUrl/ads';
  
  // ... other endpoints
}
```

## 🎉 Deployment Complete!

Your API is now live and ready to use!

**Next Steps:**
1. Test all endpoints with Postman
2. Update Flutter app with production API URL
3. Test Flutter app with live API
4. Monitor error logs for issues
5. Set up regular database backups

## 📞 Need Help?

- Check cPanel error logs
- Contact hosting support for server issues
- Review API documentation in README.md
