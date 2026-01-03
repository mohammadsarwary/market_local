<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/controllers/AdminController.php';

$controller = new AdminController();

$requestUri = $_SERVER['REQUEST_URI'];
$requestMethod = $_SERVER['REQUEST_METHOD'];

$basePath = '/backend/admin_api.php';
$path = str_replace($basePath, '', parse_url($requestUri, PHP_URL_PATH));
$path = trim($path, '/');

$segments = explode('/', $path);

try {
    switch ($segments[0]) {
        
        case 'login':
            if ($requestMethod === 'POST') {
                $controller->login();
            }
            break;

        case 'verify':
            if ($requestMethod === 'GET') {
                $controller->verify();
            }
            break;

        case 'stats':
            if ($requestMethod === 'GET') {
                $controller->getStats();
            }
            break;

        case 'activity':
            if ($requestMethod === 'GET') {
                $controller->getRecentActivity();
            }
            break;

        case 'users':
            if ($requestMethod === 'GET' && !isset($segments[1])) {
                $controller->listUsers();
            } elseif ($requestMethod === 'GET' && $segments[1] === 'export') {
                $controller->exportUsers();
            } elseif ($requestMethod === 'GET' && isset($segments[1]) && is_numeric($segments[1])) {
                if (isset($segments[2]) && $segments[2] === 'activity') {
                    $controller->getUserActivity($segments[1]);
                } else {
                    $controller->getUserDetails($segments[1]);
                }
            } elseif ($requestMethod === 'PUT' && isset($segments[1]) && isset($segments[2])) {
                $userId = $segments[1];
                $action = $segments[2];
                
                switch ($action) {
                    case 'suspend':
                        $controller->suspendUser($userId);
                        break;
                    case 'activate':
                        $controller->activateUser($userId);
                        break;
                    case 'verify':
                        $controller->verifyUser($userId);
                        break;
                    default:
                        http_response_code(404);
                        echo json_encode(['success' => false, 'message' => 'Action not found']);
                }
            } elseif ($requestMethod === 'DELETE' && isset($segments[1])) {
                $controller->deleteUser($segments[1]);
            }
            break;

        case 'ads':
            if ($requestMethod === 'GET' && !isset($segments[1])) {
                $controller->listAds();
            } elseif ($requestMethod === 'GET' && $segments[1] === 'export') {
                $controller->exportAds();
            } elseif ($requestMethod === 'GET' && isset($segments[1]) && is_numeric($segments[1])) {
                $controller->getAdDetails($segments[1]);
            } elseif ($requestMethod === 'PUT' && isset($segments[1]) && isset($segments[2])) {
                $adId = $segments[1];
                $action = $segments[2];
                
                switch ($action) {
                    case 'feature':
                        $controller->featureAd($adId);
                        break;
                    case 'promote':
                        $controller->promoteAd($adId);
                        break;
                    default:
                        http_response_code(404);
                        echo json_encode(['success' => false, 'message' => 'Action not found']);
                }
            } elseif ($requestMethod === 'DELETE' && isset($segments[1])) {
                $controller->deleteAd($segments[1]);
            }
            break;

        case 'reports':
            if ($requestMethod === 'GET' && !isset($segments[1])) {
                $controller->listReports();
            } elseif ($requestMethod === 'GET' && $segments[1] === 'stats') {
                $controller->getReportStats();
            } elseif ($requestMethod === 'GET' && isset($segments[1]) && is_numeric($segments[1])) {
                $controller->getReportDetails($segments[1]);
            } elseif ($requestMethod === 'PUT' && isset($segments[1]) && isset($segments[2])) {
                $reportId = $segments[1];
                $action = $segments[2];
                
                switch ($action) {
                    case 'resolve':
                        $controller->resolveReport($reportId);
                        break;
                    case 'dismiss':
                        $controller->dismissReport($reportId);
                        break;
                    default:
                        http_response_code(404);
                        echo json_encode(['success' => false, 'message' => 'Action not found']);
                }
            } elseif ($requestMethod === 'POST' && isset($segments[1]) && $segments[2] === 'action') {
                $controller->takeReportAction($segments[1]);
            }
            break;

        case 'analytics':
            if ($requestMethod === 'GET' && isset($segments[1])) {
                switch ($segments[1]) {
                    case 'users':
                        $controller->getUserGrowthAnalytics();
                        break;
                    case 'ads':
                        $controller->getAdPostingAnalytics();
                        break;
                    case 'categories':
                        $controller->getCategoryAnalytics();
                        break;
                    case 'locations':
                        $controller->getLocationAnalytics();
                        break;
                    default:
                        http_response_code(404);
                        echo json_encode(['success' => false, 'message' => 'Analytics endpoint not found']);
                }
            }
            break;

        default:
            http_response_code(404);
            echo json_encode([
                'success' => false,
                'message' => 'Endpoint not found',
                'path' => $path
            ]);
            break;
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Internal server error',
        'error' => $e->getMessage()
    ]);
}
