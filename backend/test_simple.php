<?php
/**
 * Simple Registration Test
 * Access this file directly to test registration
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");

require_once __DIR__ . '/config/config.php';
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/models/User.php';
require_once __DIR__ . '/utils/JWT.php';
require_once __DIR__ . '/utils/Response.php';
require_once __DIR__ . '/utils/Validator.php';

// Get POST data
$data = json_decode(file_get_contents("php://input"), true);

// If no POST data, show test form
if (!$data) {
    ?>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Registration Test</title>
        <style>
            body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
            input, button { width: 100%; padding: 10px; margin: 5px 0; }
            button { background: #4CAF50; color: white; border: none; cursor: pointer; }
            #result { margin-top: 20px; padding: 10px; background: #f0f0f0; white-space: pre-wrap; }
        </style>
    </head>
    <body>
        <h2>Registration Test Form</h2>
        <form id="regForm">
            <input type="text" id="name" placeholder="Name" value="Test User" required>
            <input type="email" id="email" placeholder="Email" value="test@example.com" required>
            <input type="password" id="password" placeholder="Password" value="password123" required>
            <input type="text" id="location" placeholder="Location" value="Kabul">
            <button type="submit">Register</button>
        </form>
        <div id="result"></div>

        <script>
        document.getElementById('regForm').onsubmit = async (e) => {
            e.preventDefault();
            
            const data = {
                name: document.getElementById('name').value,
                email: document.getElementById('email').value,
                password: document.getElementById('password').value,
                location: document.getElementById('location').value
            };
            
            document.getElementById('result').textContent = 'Sending request...';
            
            try {
                const response = await fetch('test_simple.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                
                const result = await response.text();
                document.getElementById('result').textContent = result;
            } catch (error) {
                document.getElementById('result').textContent = 'Error: ' + error.message;
            }
        };
        </script>
    </body>
    </html>
    <?php
    exit;
}

// Process registration
try {
    echo "Starting registration process...\n";
    
    // Connect to database
    $database = new Database();
    $db = $database->getConnection();
    
    if (!$db) {
        echo json_encode(['error' => 'Database connection failed']);
        exit;
    }
    
    echo "Database connected...\n";
    
    // Validate input
    $validator = new Validator();
    $validator->required($data['name'] ?? '', 'name')
              ->minLength($data['name'] ?? '', 2, 'name');
    
    $validator->required($data['email'] ?? '', 'email')
              ->email($data['email'] ?? '', 'email');
    
    $validator->required($data['password'] ?? '', 'password')
              ->minLength($data['password'] ?? '', 6, 'password');
    
    if ($validator->fails()) {
        echo json_encode(['error' => 'Validation failed', 'errors' => $validator->getErrors()]);
        exit;
    }
    
    echo "Validation passed...\n";
    
    // Create user model
    $userModel = new User($db);
    
    // Check if email exists
    if ($userModel->findByEmail($data['email'])) {
        echo json_encode(['error' => 'Email already registered']);
        exit;
    }
    
    echo "Email is available...\n";
    
    // Prepare user data
    $userData = [
        'name' => trim($data['name']),
        'email' => strtolower(trim($data['email'])),
        'phone' => $data['phone'] ?? null,
        'password' => password_hash($data['password'], PASSWORD_BCRYPT),
        'location' => $data['location'] ?? null
    ];
    
    echo "Creating user...\n";
    
    // Create user
    $userId = $userModel->create($userData);
    
    if (!$userId) {
        echo json_encode(['error' => 'Failed to create user']);
        exit;
    }
    
    echo "User created with ID: $userId\n";
    
    // Get user details
    $user = $userModel->findById($userId);
    
    if (!$user) {
        echo json_encode(['error' => 'User created but could not retrieve details']);
        exit;
    }
    
    echo "User retrieved...\n";
    
    // Generate tokens
    $accessToken = JWT::encode(['user_id' => $userId]);
    $refreshToken = JWT::encode(['user_id' => $userId], JWTConfig::$refresh_token_expiry);
    
    echo "Tokens generated...\n";
    
    // Return success response
    $response = [
        'success' => true,
        'message' => 'Registration successful',
        'data' => [
            'user' => $user,
            'access_token' => $accessToken,
            'refresh_token' => $refreshToken,
            'token_type' => 'Bearer',
            'expires_in' => JWTConfig::$access_token_expiry
        ]
    ];
    
    echo json_encode($response, JSON_PRETTY_PRINT);
    
} catch (Exception $e) {
    echo json_encode([
        'error' => 'Exception occurred',
        'message' => $e->getMessage(),
        'trace' => $e->getTraceAsString()
    ]);
}
?>
