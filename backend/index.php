<?php
/**
 * Market Local API - Main Entry Point
 * 
 * Simple routing system for REST API
 */

require_once __DIR__ . '/config/config.php';
require_once __DIR__ . '/utils/Response.php';

// Get request method and URI
$method = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Remove base path if API is in subdirectory
$basePath = '/api'; // Change this if your API is in a different folder
$uri = str_replace($basePath, '', $uri);

// Remove trailing slash
$uri = rtrim($uri, '/');

// Split URI into segments
$segments = explode('/', trim($uri, '/'));

// Route the request
try {
    // API root
    if (empty($segments[0])) {
        Response::success([
            'name' => APP_NAME,
            'version' => APP_VERSION,
            'status' => 'running'
        ], 'API is running');
    }

    // Remove 'api' prefix if present
    if ($segments[0] === 'api') {
        array_shift($segments);
    }

    $resource = $segments[0] ?? '';
    $id = $segments[1] ?? null;
    $action = $segments[2] ?? null;

    // Authentication routes
    if ($resource === 'auth') {
        require_once __DIR__ . '/controllers/AuthController.php';
        $controller = new AuthController();

        switch ($id) {
            case 'register':
                if ($method === 'POST') {
                    $controller->register();
                } else {
                    Response::error('Method not allowed. Use POST', 405);
                }
                break;

            case 'login':
                if ($method === 'POST') {
                    $controller->login();
                } else {
                    Response::error('Method not allowed. Use POST', 405);
                }
                break;

            case 'refresh':
                if ($method === 'POST') {
                    $controller->refresh();
                } else {
                    Response::error('Method not allowed. Use POST', 405);
                }
                break;

            case 'logout':
                if ($method === 'POST') {
                    $controller->logout();
                } else {
                    Response::error('Method not allowed. Use POST', 405);
                }
                break;

            case 'me':
                if ($method === 'GET') {
                    $controller->me();
                } else {
                    Response::error('Method not allowed. Use GET', 405);
                }
                break;

            default:
                Response::notFound('Auth endpoint not found');
        }
    }

    // User routes
    elseif ($resource === 'users') {
        require_once __DIR__ . '/controllers/UserController.php';
        $controller = new UserController();

        if ($id === 'profile') {
            if ($method === 'PUT') {
                $controller->updateProfile();
            }
        } elseif ($id === 'avatar') {
            if ($method === 'POST') {
                $controller->updateAvatar();
            }
        } elseif ($id === 'change-password') {
            if ($method === 'POST') {
                $controller->changePassword();
            }
        } elseif ($id === 'account') {
            if ($method === 'DELETE') {
                $controller->deleteAccount();
            }
        } elseif ($id === 'favorites') {
            if ($method === 'GET') {
                require_once __DIR__ . '/controllers/AdController.php';
                $adController = new AdController();
                $adController->getFavorites();
            }
        } elseif (is_numeric($id)) {
            if ($method === 'GET') {
                if ($action === 'ads') {
                    require_once __DIR__ . '/controllers/AdController.php';
                    $adController = new AdController();
                    $adController->getUserAds($id);
                } else {
                    $controller->getProfile($id);
                }
            }
        } else {
            Response::notFound('User endpoint not found');
        }
    }

    // Ad routes
    elseif ($resource === 'ads') {
        require_once __DIR__ . '/controllers/AdController.php';
        $controller = new AdController();

        if ($id === null) {
            // GET /api/ads - Get all ads
            if ($method === 'GET') {
                $controller->getAll();
            }
            // POST /api/ads - Create ad
            elseif ($method === 'POST') {
                $controller->create();
            }
        } elseif (is_numeric($id)) {
            if ($action === null) {
                // GET /api/ads/:id - Get ad by ID
                if ($method === 'GET') {
                    $controller->getById($id);
                }
                // PUT /api/ads/:id - Update ad
                elseif ($method === 'PUT') {
                    $controller->update($id);
                }
                // DELETE /api/ads/:id - Delete ad
                elseif ($method === 'DELETE') {
                    $controller->delete($id);
                }
            } elseif ($action === 'sold') {
                // POST /api/ads/:id/sold - Mark as sold
                if ($method === 'POST') {
                    $controller->markAsSold($id);
                }
            } elseif ($action === 'images') {
                // POST /api/ads/:id/images - Upload images
                if ($method === 'POST') {
                    $controller->uploadImages($id);
                }
            } elseif ($action === 'favorite') {
                // POST /api/ads/:id/favorite - Toggle favorite
                if ($method === 'POST') {
                    $controller->toggleFavorite($id);
                }
            }
        } else {
            Response::notFound('Ad endpoint not found');
        }
    }

    // Categories routes
    elseif ($resource === 'categories') {
        require_once __DIR__ . '/controllers/CategoryController.php';
        $controller = new CategoryController();

        if ($method === 'GET') {
            $controller->getAll();
        }
    }

    // Default 404
    else {
        Response::notFound('Endpoint not found');
    }

} catch (Exception $e) {
    error_log("API Error: " . $e->getMessage());
    Response::serverError("An error occurred: " . $e->getMessage());
}
