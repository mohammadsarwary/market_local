-- Migration: Add Admin Fields to Users Table
-- Created: January 2026
-- Purpose: Enable admin functionality for Market Local

-- Add is_admin field to users table
ALTER TABLE users ADD COLUMN is_admin TINYINT(1) DEFAULT 0 AFTER is_active;

-- Add admin_role field for future role-based permissions
ALTER TABLE users ADD COLUMN admin_role ENUM('super_admin', 'admin', 'moderator') NULL AFTER is_admin;

-- Add index for faster admin queries
ALTER TABLE users ADD INDEX idx_is_admin (is_admin);

-- Create first super admin (update email/password as needed)
-- Password: admin123 (hashed with bcrypt)
-- IMPORTANT: Change this after first login!
UPDATE users SET is_admin = 1, admin_role = 'super_admin' WHERE email = 'admin@marketlocal.com';

-- If admin user doesn't exist, create one
INSERT INTO users (name, email, password, is_admin, admin_role, is_verified, is_active) 
SELECT 'Admin', 'admin@marketlocal.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 'super_admin', 1, 1
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@marketlocal.com');
