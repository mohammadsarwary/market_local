<?php
/**
 * Debug version of register endpoint
 * Access: POST https://market.bazarino.store/api/register_debug.php
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('log_errors', 1);

// Log everything
$logFile = __DIR__ . '/debug_log.txt';

$log = "=== Registration Debug " . date('Y-m-d H:i:s') . " ===\n";
$log .= "REQUEST_METHOD: " . $_SERVER['REQUEST_METHOD'] . "\n";
$log .= "REQUEST_URI: " . $_SERVER['REQUEST_URI'] . "\n";
$log .= "CONTENT_TYPE: " . ($_SERVER['CONTENT_TYPE'] ?? 'not set') . "\n";

// Get raw input
$rawInput = file_get_contents("php://input");
$log .= "RAW INPUT LENGTH: " . strlen($rawInput) . "\n";
$log .= "RAW INPUT: " . $rawInput . "\n";

// Try to decode
$data = json_decode($rawInput, true);
$log .= "JSON DECODE SUCCESS: " . ($data !== null ? 'YES' : 'NO') . "\n";
$log .= "DECODED DATA: " . print_r($data, true) . "\n";

file_put_contents($logFile, $log . "\n\n", FILE_APPEND);

// Now try actual registration
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['error' => 'Method not allowed. Use POST']);
    exit;
}

if (empty($rawInput)) {
    echo json_encode([
        'error' => 'No input data received',
        'debug' => [
            'raw_input_length' => strlen($rawInput),
            'content_type' => $_SERVER['CONTENT_TYPE'] ?? 'not set',
            'request_method' => $_SERVER['REQUEST_METHOD']
        ]
    ]);
    exit;
}

if ($data === null) {
    echo json_encode([
        'error' => 'Invalid JSON',
        'debug' => [
            'raw_input' => $rawInput,
            'json_error' => json_last_error_msg()
        ]
    ]);
    exit;
}

// Now proceed with actual registration
require_once __DIR__ . '/config/config.php';
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/models/User.php';
require_once __DIR__ . '/utils/JWT.php';
require_once __DIR__ . '/utils/Response.php';
require_once __DIR__ . '/utils/Validator.php';

try {
    $database = new Database();
    $db = $database->getConnection();
    
    if (!$db) {
        echo json_encode(['error' => 'Database connection failed']);
        exit;
    }
    
    $userModel = new User($db);
    
    // Validate
    $validator = new Validator();
    $validator->required($data['name'] ?? '', 'name')
              ->minLength($data['name'] ?? '', 2, 'name');
    
    $validator->required($data['email'] ?? '', 'email')
              ->email($data['email'] ?? '', 'email');
    
    $validator->required($data['password'] ?? '', 'password')
              ->minLength($data['password'] ?? '', 6, 'password');
    
    if ($validator->fails()) {
        echo json_encode([
            'success' => false,
            'message' => 'Validation failed',
            'errors' => $validator->getErrors()
        ]);
        exit;
    }
    
    // Check if email exists
    if ($userModel->findByEmail($data['email'])) {
        echo json_encode([
            'success' => false,
            'message' => 'Email already registered'
        ]);
        exit;
    }
    
    // Create user
    $userData = [
        'name' => trim($data['name']),
        'email' => strtolower(trim($data['email'])),
        'phone' => $data['phone'] ?? null,
        'password' => password_hash($data['password'], PASSWORD_BCRYPT),
        'location' => $data['location'] ?? null
    ];
    
    $userId = $userModel->create($userData);
    
    if (!$userId) {
        echo json_encode([
            'success' => false,
            'message' => 'Failed to create user'
        ]);
        exit;
    }
    
    $user = $userModel->findById($userId);
    
    $accessToken = JWT::encode(['user_id' => $userId]);
    $refreshToken = JWT::encode(['user_id' => $userId], JWTConfig::$refresh_token_expiry);
    
    // Save refresh token
    $expiresAt = date('Y-m-d H:i:s', time() + JWTConfig::$refresh_token_expiry);
    $query = "INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (:user_id, :token, :expires_at)";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':user_id', $userId);
    $stmt->bindParam(':token', $refreshToken);
    $stmt->bindParam(':expires_at', $expiresAt);
    $stmt->execute();
    
    echo json_encode([
        'success' => true,
        'message' => 'Registration successful',
        'data' => [
            'user' => $user,
            'access_token' => $accessToken,
            'refresh_token' => $refreshToken,
            'token_type' => 'Bearer',
            'expires_in' => JWTConfig::$access_token_expiry
        ]
    ], JSON_PRETTY_PRINT);
    
} catch (Exception $e) {
    echo json_encode([
        'error' => 'Exception occurred',
        'message' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine()
    ]);
}
?>
