<?php
/**
 * Test Auth Registration Endpoint Directly
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Simulate the exact flow that index.php would use
$_SERVER['REQUEST_METHOD'] = 'POST';

// Set JSON input
$testData = json_encode([
    'name' => 'Test User Direct',
    'email' => 'testdirect_' . time() . '@example.com',
    'password' => 'password123',
    'location' => 'Kabul'
]);

// Mock php://input
file_put_contents('php://memory', $testData);

require_once __DIR__ . '/config/config.php';

echo "\n=== Testing AuthController Directly ===\n\n";

try {
    require_once __DIR__ . '/controllers/AuthController.php';
    
    echo "AuthController loaded successfully\n";
    
    $controller = new AuthController();
    echo "AuthController instantiated\n";
    
    // Manually set the input data since we can't override php://input easily
    $_POST = json_decode($testData, true);
    
    echo "Calling register method...\n\n";
    
    // This should output JSON and exit
    $controller->register();
    
} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    echo "Trace: " . $e->getTraceAsString() . "\n";
}
?>
