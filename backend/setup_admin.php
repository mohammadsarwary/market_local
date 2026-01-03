<?php
/**
 * Admin Setup Script
 * Run this once to set up admin functionality
 */

require_once __DIR__ . '/config/database.php';

echo "=== Market Local Admin Setup ===\n\n";

$database = new Database();
$db = $database->getConnection();

if (!$db) {
    die("❌ Database connection failed!\n");
}

echo "✅ Database connected successfully\n\n";

// Step 1: Add admin fields to users table
echo "Step 1: Adding admin fields to users table...\n";

try {
    $query = "ALTER TABLE users ADD COLUMN is_admin TINYINT(1) DEFAULT 0 AFTER is_active";
    $db->exec($query);
    echo "✅ Added is_admin field\n";
} catch (PDOException $e) {
    if (strpos($e->getMessage(), 'Duplicate column') !== false) {
        echo "ℹ️  is_admin field already exists\n";
    } else {
        echo "❌ Error: " . $e->getMessage() . "\n";
    }
}

try {
    $query = "ALTER TABLE users ADD COLUMN admin_role ENUM('super_admin', 'admin', 'moderator') NULL AFTER is_admin";
    $db->exec($query);
    echo "✅ Added admin_role field\n";
} catch (PDOException $e) {
    if (strpos($e->getMessage(), 'Duplicate column') !== false) {
        echo "ℹ️  admin_role field already exists\n";
    } else {
        echo "❌ Error: " . $e->getMessage() . "\n";
    }
}

try {
    $query = "ALTER TABLE users ADD INDEX idx_is_admin (is_admin)";
    $db->exec($query);
    echo "✅ Added index on is_admin\n";
} catch (PDOException $e) {
    if (strpos($e->getMessage(), 'Duplicate key') !== false) {
        echo "ℹ️  Index already exists\n";
    } else {
        echo "❌ Error: " . $e->getMessage() . "\n";
    }
}

echo "\n";

// Step 2: Create admin_logs table
echo "Step 2: Creating admin_logs table...\n";

try {
    $query = "CREATE TABLE IF NOT EXISTS admin_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        admin_id INT NOT NULL,
        action VARCHAR(100) NOT NULL,
        target_id INT,
        target_type VARCHAR(50),
        details TEXT,
        ip_address VARCHAR(45),
        user_agent VARCHAR(255),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE CASCADE,
        INDEX idx_admin (admin_id),
        INDEX idx_action (action),
        INDEX idx_created (created_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
    
    $db->exec($query);
    echo "✅ admin_logs table created\n";
} catch (PDOException $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}

echo "\n";

// Step 3: Create default admin user
echo "Step 3: Creating default admin user...\n";

$adminEmail = 'admin@marketlocal.com';
$adminPassword = password_hash('admin123', PASSWORD_BCRYPT);

try {
    // Check if admin already exists
    $query = "SELECT id FROM users WHERE email = :email LIMIT 1";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':email', $adminEmail);
    $stmt->execute();
    
    if ($stmt->fetch()) {
        // Update existing user to admin
        $query = "UPDATE users SET is_admin = 1, admin_role = 'super_admin', is_verified = 1, is_active = 1 WHERE email = :email";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':email', $adminEmail);
        $stmt->execute();
        echo "✅ Updated existing user to super admin\n";
    } else {
        // Create new admin user
        $query = "INSERT INTO users (name, email, password, is_admin, admin_role, is_verified, is_active) 
                  VALUES ('Admin', :email, :password, 1, 'super_admin', 1, 1)";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':email', $adminEmail);
        $stmt->bindParam(':password', $adminPassword);
        $stmt->execute();
        echo "✅ Created new super admin user\n";
    }
    
    echo "\n📧 Admin Email: admin@marketlocal.com\n";
    echo "🔑 Admin Password: admin123\n";
    echo "⚠️  IMPORTANT: Change this password after first login!\n";
    
} catch (PDOException $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}

echo "\n";

// Step 4: Verify setup
echo "Step 4: Verifying setup...\n";

try {
    $query = "SELECT COUNT(*) as count FROM users WHERE is_admin = 1";
    $stmt = $db->prepare($query);
    $stmt->execute();
    $result = $stmt->fetch();
    
    echo "✅ Total admin users: " . $result['count'] . "\n";
    
    $query = "SELECT name, email, admin_role FROM users WHERE is_admin = 1";
    $stmt = $db->prepare($query);
    $stmt->execute();
    $admins = $stmt->fetchAll();
    
    echo "\nAdmin Users:\n";
    foreach ($admins as $admin) {
        echo "  - {$admin['name']} ({$admin['email']}) - Role: {$admin['admin_role']}\n";
    }
    
} catch (PDOException $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}

echo "\n=== Setup Complete! ===\n\n";
echo "Next Steps:\n";
echo "1. Test admin login at: /backend/admin_api.php/login\n";
echo "2. Change the default admin password\n";
echo "3. Start building the admin frontend UI\n";
echo "\nFor API documentation, see: backend/docs/admin_api_documentation.md\n";
