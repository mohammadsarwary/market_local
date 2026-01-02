<?php
/**
 * Debug Test for Registration
 * 
 * This file helps diagnose registration issues
 * Access: http://yourdomain.com/api/test_register.php
 */

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "<h2>Registration Debug Test</h2>";

// Test 1: Check if files exist
echo "<h3>1. File Check</h3>";
$files = [
    'config/database.php',
    'models/User.php',
    'utils/JWT.php',
    'utils/Response.php',
    'utils/Validator.php'
];

foreach ($files as $file) {
    $exists = file_exists(__DIR__ . '/' . $file);
    echo $file . ": " . ($exists ? "✓ Found" : "✗ Missing") . "<br>";
}

// Test 2: Database Connection
echo "<h3>2. Database Connection</h3>";
require_once __DIR__ . '/config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($db) {
    echo "✓ Database connected successfully<br>";
    
    // Check if users table exists
    try {
        $stmt = $db->query("SHOW TABLES LIKE 'users'");
        $table = $stmt->fetch();
        if ($table) {
            echo "✓ Users table exists<br>";
            
            // Check table structure
            $stmt = $db->query("DESCRIBE users");
            $columns = $stmt->fetchAll(PDO::FETCH_COLUMN);
            echo "✓ Users table columns: " . implode(', ', $columns) . "<br>";
        } else {
            echo "✗ Users table does not exist<br>";
        }
    } catch (Exception $e) {
        echo "✗ Error checking table: " . $e->getMessage() . "<br>";
    }
} else {
    echo "✗ Database connection failed<br>";
    echo "Check your database credentials in config/database.php<br>";
}

// Test 3: Test User Model
if ($db) {
    echo "<h3>3. User Model Test</h3>";
    require_once __DIR__ . '/models/User.php';
    
    try {
        $userModel = new User($db);
        echo "✓ User model instantiated<br>";
        
        // Test if email exists (should return false for new email)
        $testEmail = 'test_' . time() . '@example.com';
        $exists = $userModel->findByEmail($testEmail);
        echo "✓ findByEmail() method works: " . ($exists ? "User found" : "No user found") . "<br>";
        
    } catch (Exception $e) {
        echo "✗ User model error: " . $e->getMessage() . "<br>";
    }
}

// Test 4: Test Registration with Sample Data
if ($db) {
    echo "<h3>4. Test Registration</h3>";
    
    require_once __DIR__ . '/models/User.php';
    require_once __DIR__ . '/utils/Validator.php';
    
    $testData = [
        'name' => 'Test User',
        'email' => 'test_' . time() . '@example.com',
        'phone' => null,
        'password' => password_hash('password123', PASSWORD_BCRYPT),
        'location' => 'Test Location'
    ];
    
    echo "Test data prepared:<br>";
    echo "- Name: " . $testData['name'] . "<br>";
    echo "- Email: " . $testData['email'] . "<br>";
    echo "- Location: " . $testData['location'] . "<br>";
    
    try {
        $userModel = new User($db);
        $userId = $userModel->create($testData);
        
        if ($userId) {
            echo "✓ User created successfully! User ID: " . $userId . "<br>";
            
            // Verify user was created
            $user = $userModel->findById($userId);
            if ($user) {
                echo "✓ User verified in database<br>";
                echo "User details: " . json_encode($user, JSON_PRETTY_PRINT) . "<br>";
            }
        } else {
            echo "✗ Failed to create user (returned false)<br>";
        }
    } catch (Exception $e) {
        echo "✗ Registration error: " . $e->getMessage() . "<br>";
        echo "Stack trace: <pre>" . $e->getTraceAsString() . "</pre>";
    }
}

// Test 5: Test JWT
echo "<h3>5. JWT Test</h3>";
require_once __DIR__ . '/config/jwt.php';
require_once __DIR__ . '/utils/JWT.php';

try {
    $testPayload = ['user_id' => 123];
    $token = JWT::encode($testPayload);
    echo "✓ JWT token generated: " . substr($token, 0, 50) . "...<br>";
    
    $decoded = JWT::decode($token);
    if ($decoded && $decoded['user_id'] == 123) {
        echo "✓ JWT token decoded successfully<br>";
    } else {
        echo "✗ JWT decode failed<br>";
    }
} catch (Exception $e) {
    echo "✗ JWT error: " . $e->getMessage() . "<br>";
}

// Test 6: Test Full Registration Flow
echo "<h3>6. Full Registration API Test</h3>";
echo "To test the full API, use this curl command:<br>";
echo "<pre>";
echo "curl -X POST http://yourdomain.com/api/auth/register \\\n";
echo "  -H \"Content-Type: application/json\" \\\n";
echo "  -d '{\n";
echo "    \"name\": \"Test User\",\n";
echo "    \"email\": \"test@example.com\",\n";
echo "    \"password\": \"password123\",\n";
echo "    \"location\": \"Kabul\"\n";
echo "  }'";
echo "</pre>";

echo "<h3>Summary</h3>";
echo "If all tests above passed (✓), your registration should work.<br>";
echo "If any test failed (✗), fix that issue first.<br>";
echo "<br>";
echo "<strong>Common Issues:</strong><br>";
echo "1. Database credentials incorrect in config/database.php<br>";
echo "2. Users table not created (import schema.sql)<br>";
echo "3. Wrong base URL or routing issue<br>";
echo "4. PHP version too old (need PHP 8.0+)<br>";
echo "5. Missing PHP extensions (PDO, PDO_MySQL)<br>";
?>
