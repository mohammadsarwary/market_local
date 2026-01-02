<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/Ad.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../utils/Response.php';
require_once __DIR__ . '/../utils/Validator.php';

/**
 * Ad Controller
 */

class AdController {
    private $db;
    private $adModel;
    private $userModel;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getConnection();
        
        if (!$this->db) {
            Response::serverError("Database connection failed");
        }
        
        $this->adModel = new Ad($this->db);
        $this->userModel = new User($this->db);
    }

    /**
     * Get all ads with filters
     * GET /api/ads
     */
    public function getAll() {
        $filters = [
            'category_id' => $_GET['category_id'] ?? null,
            'search' => $_GET['search'] ?? null,
            'min_price' => $_GET['min_price'] ?? null,
            'max_price' => $_GET['max_price'] ?? null,
            'location' => $_GET['location'] ?? null,
            'condition' => $_GET['condition'] ?? null,
            'sort' => $_GET['sort'] ?? 'newest'
        ];

        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = isset($_GET['limit']) ? min((int)$_GET['limit'], MAX_PAGE_SIZE) : DEFAULT_PAGE_SIZE;

        $ads = $this->adModel->getAll($filters, $page, $limit);

        Response::success([
            'ads' => $ads,
            'page' => $page,
            'limit' => $limit
        ]);
    }

    /**
     * Get ad by ID
     * GET /api/ads/:id
     */
    public function getById($id) {
        $userId = AuthMiddleware::optionalAuth();
        
        $ad = $this->adModel->getById($id, $userId);

        if (!$ad) {
            Response::notFound("Ad not found");
        }

        $this->adModel->incrementViews($id);

        Response::success($ad);
    }

    /**
     * Create new ad
     * POST /api/ads
     */
    public function create() {
        $userId = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents("php://input"), true);

        $validator = new Validator();
        $validator->required($data['title'] ?? '', 'title')
                  ->minLength($data['title'] ?? '', 5, 'title')
                  ->maxLength($data['title'] ?? '', 200, 'title');

        $validator->required($data['description'] ?? '', 'description')
                  ->minLength($data['description'] ?? '', 20, 'description');

        $validator->required($data['price'] ?? '', 'price')
                  ->numeric($data['price'] ?? '', 'price')
                  ->min($data['price'] ?? 0, 0, 'price');

        $validator->required($data['category_id'] ?? '', 'category_id')
                  ->numeric($data['category_id'] ?? '', 'category_id');

        $validator->required($data['location'] ?? '', 'location');

        if ($validator->fails()) {
            Response::validationError($validator->getErrors());
        }

        $adData = [
            'user_id' => $userId,
            'category_id' => $data['category_id'],
            'title' => trim($data['title']),
            'description' => trim($data['description']),
            'price' => $data['price'],
            'condition' => $data['condition'] ?? 'good',
            'location' => trim($data['location']),
            'latitude' => $data['latitude'] ?? null,
            'longitude' => $data['longitude'] ?? null
        ];

        $adId = $this->adModel->create($adData);

        if (!$adId) {
            Response::serverError("Failed to create ad");
        }

        $this->userModel->incrementStat($userId, 'active_listings', 1);

        $ad = $this->adModel->getById($adId);

        Response::success($ad, "Ad created successfully", 201);
    }

    /**
     * Update ad
     * PUT /api/ads/:id
     */
    public function update($id) {
        $userId = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents("php://input"), true);

        $ad = $this->adModel->getById($id);

        if (!$ad) {
            Response::notFound("Ad not found");
        }

        if ($ad['user_id'] != $userId) {
            Response::forbidden("You don't have permission to update this ad");
        }

        $validator = new Validator();

        if (isset($data['title'])) {
            $validator->minLength($data['title'], 5, 'title')
                      ->maxLength($data['title'], 200, 'title');
        }

        if (isset($data['description'])) {
            $validator->minLength($data['description'], 20, 'description');
        }

        if (isset($data['price'])) {
            $validator->numeric($data['price'], 'price')
                      ->min($data['price'], 0, 'price');
        }

        if ($validator->fails()) {
            Response::validationError($validator->getErrors());
        }

        $updateData = [];
        $allowedFields = ['title', 'description', 'price', 'condition', 'location', 'category_id'];

        foreach ($allowedFields as $field) {
            if (isset($data[$field])) {
                $updateData[$field] = $data[$field];
            }
        }

        if (empty($updateData)) {
            Response::error("No data to update", 400);
        }

        if (!$this->adModel->update($id, $updateData)) {
            Response::serverError("Failed to update ad");
        }

        $ad = $this->adModel->getById($id);

        Response::success($ad, "Ad updated successfully");
    }

    /**
     * Delete ad
     * DELETE /api/ads/:id
     */
    public function delete($id) {
        $userId = AuthMiddleware::authenticate();

        $ad = $this->adModel->getById($id);

        if (!$ad) {
            Response::notFound("Ad not found");
        }

        if ($ad['user_id'] != $userId) {
            Response::forbidden("You don't have permission to delete this ad");
        }

        if (!$this->adModel->delete($id)) {
            Response::serverError("Failed to delete ad");
        }

        $this->userModel->incrementStat($userId, 'active_listings', -1);

        Response::success(null, "Ad deleted successfully");
    }

    /**
     * Mark ad as sold
     * POST /api/ads/:id/sold
     */
    public function markAsSold($id) {
        $userId = AuthMiddleware::authenticate();

        $ad = $this->adModel->getById($id);

        if (!$ad) {
            Response::notFound("Ad not found");
        }

        if ($ad['user_id'] != $userId) {
            Response::forbidden("You don't have permission to update this ad");
        }

        if (!$this->adModel->markAsSold($id)) {
            Response::serverError("Failed to mark ad as sold");
        }

        $this->userModel->incrementStat($userId, 'active_listings', -1);
        $this->userModel->incrementStat($userId, 'sold_items', 1);

        Response::success(null, "Ad marked as sold");
    }

    /**
     * Upload ad images
     * POST /api/ads/:id/images
     */
    public function uploadImages($id) {
        $userId = AuthMiddleware::authenticate();

        $ad = $this->adModel->getById($id);

        if (!$ad) {
            Response::notFound("Ad not found");
        }

        if ($ad['user_id'] != $userId) {
            Response::forbidden("You don't have permission to upload images for this ad");
        }

        if (!isset($_FILES['images'])) {
            Response::error("No images provided", 400);
        }

        $files = $_FILES['images'];
        $uploadedImages = [];

        $fileCount = is_array($files['name']) ? count($files['name']) : 1;

        for ($i = 0; $i < $fileCount; $i++) {
            $fileName = is_array($files['name']) ? $files['name'][$i] : $files['name'];
            $fileTmpName = is_array($files['tmp_name']) ? $files['tmp_name'][$i] : $files['tmp_name'];
            $fileSize = is_array($files['size']) ? $files['size'][$i] : $files['size'];
            $fileType = is_array($files['type']) ? $files['type'][$i] : $files['type'];
            $fileError = is_array($files['error']) ? $files['error'][$i] : $files['error'];

            if ($fileError !== UPLOAD_ERR_OK) {
                continue;
            }

            if ($fileSize > MAX_FILE_SIZE) {
                continue;
            }

            if (!in_array($fileType, ALLOWED_IMAGE_TYPES)) {
                continue;
            }

            $extension = pathinfo($fileName, PATHINFO_EXTENSION);
            $newFileName = 'ad_' . $id . '_' . time() . '_' . $i . '.' . $extension;
            $uploadPath = UPLOAD_DIR . 'ads/' . $newFileName;

            if (move_uploaded_file($fileTmpName, $uploadPath)) {
                $imageUrl = BASE_URL . '/uploads/ads/' . $newFileName;
                $isPrimary = ($i === 0 && empty($ad['images']));
                
                $this->adModel->addImage($id, $imageUrl, $isPrimary);
                $uploadedImages[] = $imageUrl;
            }
        }

        if (empty($uploadedImages)) {
            Response::error("No images were uploaded successfully", 400);
        }

        Response::success(['images' => $uploadedImages], "Images uploaded successfully");
    }

    /**
     * Get user's ads
     * GET /api/users/:userId/ads
     */
    public function getUserAds($userId) {
        $status = $_GET['status'] ?? 'active';
        
        $ads = $this->adModel->getUserAds($userId, $status);

        Response::success($ads);
    }

    /**
     * Toggle favorite
     * POST /api/ads/:id/favorite
     */
    public function toggleFavorite($id) {
        $userId = AuthMiddleware::authenticate();

        $ad = $this->adModel->getById($id);

        if (!$ad) {
            Response::notFound("Ad not found");
        }

        $query = "SELECT id FROM favorites WHERE user_id = :user_id AND ad_id = :ad_id LIMIT 1";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':user_id', $userId);
        $stmt->bindParam(':ad_id', $id);
        $stmt->execute();
        $favorite = $stmt->fetch();

        if ($favorite) {
            $query = "DELETE FROM favorites WHERE user_id = :user_id AND ad_id = :ad_id";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(':user_id', $userId);
            $stmt->bindParam(':ad_id', $id);
            $stmt->execute();

            Response::success(['is_favorited' => false], "Removed from favorites");
        } else {
            $query = "INSERT INTO favorites (user_id, ad_id) VALUES (:user_id, :ad_id)";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(':user_id', $userId);
            $stmt->bindParam(':ad_id', $id);
            $stmt->execute();

            Response::success(['is_favorited' => true], "Added to favorites");
        }
    }

    /**
     * Get user's favorites
     * GET /api/users/favorites
     */
    public function getFavorites() {
        $userId = AuthMiddleware::authenticate();

        $query = "SELECT a.*, c.name as category_name,
                  (SELECT image_url FROM ad_images WHERE ad_id = a.id AND is_primary = 1 LIMIT 1) as primary_image
                  FROM ads a
                  INNER JOIN favorites f ON a.id = f.ad_id
                  LEFT JOIN categories c ON a.category_id = c.id
                  WHERE f.user_id = :user_id AND a.status = 'active'
                  ORDER BY f.created_at DESC";

        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':user_id', $userId);
        $stmt->execute();

        $favorites = $stmt->fetchAll();

        Response::success($favorites);
    }
}
