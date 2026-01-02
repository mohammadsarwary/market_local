<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../utils/JWT.php';
require_once __DIR__ . '/../utils/Response.php';
require_once __DIR__ . '/../utils/Validator.php';

/**
 * Authentication Controller
 */

class AuthController {
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
     * Register new user
     * POST /api/auth/register
     */
    public function register() {
        $data = json_decode(file_get_contents("php://input"), true);

        $validator = new Validator();
        $validator->required($data['name'] ?? '', 'name')
                  ->minLength($data['name'] ?? '', 2, 'name')
                  ->maxLength($data['name'] ?? '', 100, 'name');

        $validator->required($data['email'] ?? '', 'email')
                  ->email($data['email'] ?? '', 'email');

        if (!empty($data['phone'])) {
            $validator->phone($data['phone'], 'phone');
        }

        $validator->required($data['password'] ?? '', 'password')
                  ->minLength($data['password'] ?? '', 6, 'password');

        if ($validator->fails()) {
            Response::validationError($validator->getErrors());
        }

        if ($this->userModel->findByEmail($data['email'])) {
            Response::error("Email already registered", 409);
        }

        if (!empty($data['phone']) && $this->userModel->findByPhone($data['phone'])) {
            Response::error("Phone number already registered", 409);
        }

        $userData = [
            'name' => trim($data['name']),
            'email' => strtolower(trim($data['email'])),
            'phone' => $data['phone'] ?? null,
            'password' => password_hash($data['password'], PASSWORD_BCRYPT),
            'location' => $data['location'] ?? null
        ];

        $userId = $this->userModel->create($userData);

        if (!$userId) {
            Response::serverError("Failed to create user");
        }

        $user = $this->userModel->findById($userId);

        $accessToken = JWT::encode(['user_id' => $userId]);
        $refreshToken = JWT::encode(['user_id' => $userId], JWTConfig::$refresh_token_expiry);

        $this->saveRefreshToken($userId, $refreshToken);

        Response::success([
            'user' => $user,
            'access_token' => $accessToken,
            'refresh_token' => $refreshToken,
            'token_type' => 'Bearer',
            'expires_in' => JWTConfig::$access_token_expiry
        ], "Registration successful", 201);
    }

    /**
     * Login user
     * POST /api/auth/login
     */
    public function login() {
        $data = json_decode(file_get_contents("php://input"), true);

        $validator = new Validator();
        $validator->required($data['email'] ?? '', 'email')
                  ->email($data['email'] ?? '', 'email');

        $validator->required($data['password'] ?? '', 'password');

        if ($validator->fails()) {
            Response::validationError($validator->getErrors());
        }

        $user = $this->userModel->findByEmail($data['email']);

        if (!$user || !password_verify($data['password'], $user['password'])) {
            Response::error("Invalid email or password", 401);
        }

        if (!$user['is_active']) {
            Response::error("Account is deactivated", 403);
        }

        $this->userModel->updateLastLogin($user['id']);

        unset($user['password']);

        $accessToken = JWT::encode(['user_id' => $user['id']]);
        $refreshToken = JWT::encode(['user_id' => $user['id']], JWTConfig::$refresh_token_expiry);

        $this->saveRefreshToken($user['id'], $refreshToken);

        Response::success([
            'user' => $user,
            'access_token' => $accessToken,
            'refresh_token' => $refreshToken,
            'token_type' => 'Bearer',
            'expires_in' => JWTConfig::$access_token_expiry
        ], "Login successful");
    }

    /**
     * Refresh access token
     * POST /api/auth/refresh
     */
    public function refresh() {
        $data = json_decode(file_get_contents("php://input"), true);

        if (empty($data['refresh_token'])) {
            Response::error("Refresh token is required", 400);
        }

        $decoded = JWT::decode($data['refresh_token']);

        if (!$decoded) {
            Response::error("Invalid or expired refresh token", 401);
        }

        if (!$this->verifyRefreshToken($data['refresh_token'])) {
            Response::error("Refresh token not found or expired", 401);
        }

        $userId = $decoded['user_id'];
        $user = $this->userModel->findById($userId);

        if (!$user) {
            Response::error("User not found", 404);
        }

        $accessToken = JWT::encode(['user_id' => $userId]);

        Response::success([
            'access_token' => $accessToken,
            'token_type' => 'Bearer',
            'expires_in' => JWTConfig::$access_token_expiry
        ], "Token refreshed successfully");
    }

    /**
     * Logout user
     * POST /api/auth/logout
     */
    public function logout() {
        $data = json_decode(file_get_contents("php://input"), true);

        if (!empty($data['refresh_token'])) {
            $this->deleteRefreshToken($data['refresh_token']);
        }

        Response::success(null, "Logout successful");
    }

    /**
     * Get current user
     * GET /api/auth/me
     */
    public function me() {
        require_once __DIR__ . '/../middleware/AuthMiddleware.php';
        $userId = AuthMiddleware::authenticate();

        $user = $this->userModel->findById($userId);

        if (!$user) {
            Response::notFound("User not found");
        }

        Response::success($user);
    }

    /**
     * Save refresh token to database
     */
    private function saveRefreshToken($userId, $token) {
        $expiresAt = date('Y-m-d H:i:s', time() + JWTConfig::$refresh_token_expiry);
        
        $query = "INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (:user_id, :token, :expires_at)";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':user_id', $userId);
        $stmt->bindParam(':token', $token);
        $stmt->bindParam(':expires_at', $expiresAt);
        
        return $stmt->execute();
    }

    /**
     * Verify refresh token exists and is valid
     */
    private function verifyRefreshToken($token) {
        $query = "SELECT id FROM refresh_tokens WHERE token = :token AND expires_at > NOW() LIMIT 1";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':token', $token);
        $stmt->execute();
        
        return $stmt->fetch() !== false;
    }

    /**
     * Delete refresh token
     */
    private function deleteRefreshToken($token) {
        $query = "DELETE FROM refresh_tokens WHERE token = :token";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':token', $token);
        
        return $stmt->execute();
    }
}
