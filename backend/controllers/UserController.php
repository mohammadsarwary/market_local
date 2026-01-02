<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../utils/Response.php';
require_once __DIR__ . '/../utils/Validator.php';

/**
 * User Controller
 */

class UserController {
    private $db;
    private $userModel;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getConnection();
        
        if (!$this->db) {
            Response::serverError("Database connection failed");
        }
        
        $this->userModel = new User($this->db);
    }

    /**
     * Get user profile
     * GET /api/users/:id
     */
    public function getProfile($id) {
        $user = $this->userModel->findById($id);

        if (!$user) {
            Response::notFound("User not found");
        }

        Response::success($user);
    }

    /**
     * Update user profile
     * PUT /api/users/profile
     */
    public function updateProfile() {
        $userId = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents("php://input"), true);

        $validator = new Validator();

        if (isset($data['name'])) {
            $validator->required($data['name'], 'name')
                      ->minLength($data['name'], 2, 'name')
                      ->maxLength($data['name'], 100, 'name');
        }

        if (isset($data['phone'])) {
            $validator->phone($data['phone'], 'phone');
            
            $existingUser = $this->userModel->findByPhone($data['phone']);
            if ($existingUser && $existingUser['id'] != $userId) {
                Response::error("Phone number already in use", 409);
            }
        }

        if (isset($data['bio'])) {
            $validator->maxLength($data['bio'], 500, 'bio');
        }

        if ($validator->fails()) {
            Response::validationError($validator->getErrors());
        }

        $updateData = [];
        $allowedFields = ['name', 'phone', 'bio', 'location'];

        foreach ($allowedFields as $field) {
            if (isset($data[$field])) {
                $updateData[$field] = $data[$field];
            }
        }

        if (empty($updateData)) {
            Response::error("No data to update", 400);
        }

        if (!$this->userModel->update($userId, $updateData)) {
            Response::serverError("Failed to update profile");
        }

        $user = $this->userModel->findById($userId);

        Response::success($user, "Profile updated successfully");
    }

    /**
     * Update user avatar
     * POST /api/users/avatar
     */
    public function updateAvatar() {
        $userId = AuthMiddleware::authenticate();

        if (!isset($_FILES['avatar'])) {
            Response::error("Avatar file is required", 400);
        }

        $file = $_FILES['avatar'];

        if ($file['error'] !== UPLOAD_ERR_OK) {
            Response::error("File upload failed", 400);
        }

        if ($file['size'] > MAX_FILE_SIZE) {
            Response::error("File size exceeds maximum allowed size (5MB)", 400);
        }

        if (!in_array($file['type'], ALLOWED_IMAGE_TYPES)) {
            Response::error("Invalid file type. Only JPEG, PNG, and WebP are allowed", 400);
        }

        $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
        $filename = 'avatar_' . $userId . '_' . time() . '.' . $extension;
        $uploadPath = UPLOAD_DIR . 'avatars/' . $filename;

        if (!move_uploaded_file($file['tmp_name'], $uploadPath)) {
            Response::serverError("Failed to save file");
        }

        $avatarUrl = BASE_URL . '/uploads/avatars/' . $filename;

        if (!$this->userModel->update($userId, ['avatar' => $avatarUrl])) {
            Response::serverError("Failed to update avatar");
        }

        Response::success(['avatar' => $avatarUrl], "Avatar updated successfully");
    }

    /**
     * Change password
     * POST /api/users/change-password
     */
    public function changePassword() {
        $userId = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents("php://input"), true);

        $validator = new Validator();
        $validator->required($data['current_password'] ?? '', 'current_password');
        $validator->required($data['new_password'] ?? '', 'new_password')
                  ->minLength($data['new_password'] ?? '', 6, 'new_password');

        if ($validator->fails()) {
            Response::validationError($validator->getErrors());
        }

        $query = "SELECT password FROM users WHERE id = :id LIMIT 1";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $userId);
        $stmt->execute();
        $user = $stmt->fetch();

        if (!$user || !password_verify($data['current_password'], $user['password'])) {
            Response::error("Current password is incorrect", 400);
        }

        $newPasswordHash = password_hash($data['new_password'], PASSWORD_BCRYPT);

        if (!$this->userModel->updatePassword($userId, $newPasswordHash)) {
            Response::serverError("Failed to update password");
        }

        Response::success(null, "Password changed successfully");
    }

    /**
     * Delete account
     * DELETE /api/users/account
     */
    public function deleteAccount() {
        $userId = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents("php://input"), true);

        $validator = new Validator();
        $validator->required($data['password'] ?? '', 'password');

        if ($validator->fails()) {
            Response::validationError($validator->getErrors());
        }

        $query = "SELECT password FROM users WHERE id = :id LIMIT 1";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $userId);
        $stmt->execute();
        $user = $stmt->fetch();

        if (!$user || !password_verify($data['password'], $user['password'])) {
            Response::error("Password is incorrect", 400);
        }

        if (!$this->userModel->delete($userId)) {
            Response::serverError("Failed to delete account");
        }

        Response::success(null, "Account deleted successfully");
    }
}
