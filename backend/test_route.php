<?php
/**
 * Test if routing is working properly
 * This simulates what index.php does
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== ROUTING TEST ===\n\n";

// Simulate a POST request to /api/auth/register
$_SERVER['REQUEST_METHOD'] = 'POST';
$_SERVER['REQUEST_URI'] = '/api/auth/register';

// Create test JSON data
$testData = [
    'name' => 'Route Test User',
    'email' => 'routetest_' . time() . '@example.com',
    'password' => 'password123',
    'location' => 'Kabul'
];

// Write to a temp file to simulate php://input
$tempFile = tempnam(sys_get_temp_dir(), 'test_input');
file_put_contents($tempFile, json_encode($testData));

echo "Test data prepared:\n";
echo json_encode($testData, JSON_PRETTY_PRINT) . "\n\n";

// Now test the routing logic
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
echo "Original URI: $uri\n";

$basePath = '/api';
$uri = str_replace($basePath, '', $uri);
echo "After removing base path: $uri\n";

$uri = rtrim($uri, '/');
echo "After rtrim: $uri\n";

$segments = explode('/', trim($uri, '/'));
echo "Segments: " . print_r($segments, true) . "\n";

$resource = $segments[0] ?? '';
$id = $segments[1] ?? null;

echo "Resource: $resource\n";
echo "ID: $id\n\n";

if ($resource === 'auth' && $id === 'register') {
    echo "✓ Routing matched correctly!\n";
    echo "Would call: AuthController->register()\n\n";
    
    // Now actually try to call it
    echo "Attempting to load and call AuthController...\n\n";
    
    try {
        // Override php://input for testing
        stream_wrapper_unregister("php");
        stream_wrapper_register("php", "TestStreamWrapper");
        TestStreamWrapper::$data = json_encode($testData);
        
        require_once __DIR__ . '/config/config.php';
        require_once __DIR__ . '/controllers/AuthController.php';
        
        $controller = new AuthController();
        $controller->register();
        
    } catch (Exception $e) {
        echo "ERROR: " . $e->getMessage() . "\n";
        echo "File: " . $e->getFile() . "\n";
        echo "Line: " . $e->getLine() . "\n";
        echo "Trace:\n" . $e->getTraceAsString() . "\n";
    }
} else {
    echo "✗ Routing did NOT match\n";
    echo "Expected resource='auth' and id='register'\n";
    echo "Got resource='$resource' and id='$id'\n";
}

// Helper class to mock php://input
class TestStreamWrapper {
    public static $data = '';
    private $position = 0;

    public function stream_open($path, $mode, $options, &$opened_path) {
        $this->position = 0;
        return true;
    }

    public function stream_read($count) {
        $ret = substr(self::$data, $this->position, $count);
        $this->position += strlen($ret);
        return $ret;
    }

    public function stream_eof() {
        return $this->position >= strlen(self::$data);
    }

    public function stream_stat() {
        return [];
    }
}
?>
