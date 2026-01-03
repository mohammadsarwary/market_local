<?php
require_once __DIR__ . '/../utils/JWT.php';
require_once __DIR__ . '/../utils/Response.php';

/**
 * Admin Middleware
 * Verifies admin authentication and authorization
 */
class AdminMiddleware {
    
    /**
     * Authenticate admin user from JWT token
     * Returns admin data if valid, exits with error if not
     * 
     * @return array Admin data with user_id, is_admin, and admin_role
     */
    public static function authenticate() {
        $headers = getallheaders();
        $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';

        if (empty($authHeader)) {
            Response::error("Authorization header missing", 401);
        }

        if (!preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
            Response::error("Invalid authorization format", 401);
        }

        $token = $matches[1];
        $decoded = JWT::decode($token);

        if (!$decoded) {
            Response::error("Invalid or expired token", 401);
        }

        if (!isset($decoded['is_admin']) || !$decoded['is_admin']) {
            Response::error("Admin access required", 403);
        }

        require_once __DIR__ . '/../config/database.php';
        $database = new Database();
        $db = $database->getConnection();

        if (!$db) {
            Response::serverError("Database connection failed");
        }

        $query = "SELECT is_admin, admin_role, is_active FROM users WHERE id = :user_id LIMIT 1";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':user_id', $decoded['user_id']);
        $stmt->execute();
        $user = $stmt->fetch();

        if (!$user) {
            Response::error("User not found", 404);
        }

        if (!$user['is_admin']) {
            Response::error("Admin privileges revoked", 403);
        }

        if (!$user['is_active']) {
            Response::error("Account is deactivated", 403);
        }

        return [
            'user_id' => $decoded['user_id'],
            'is_admin' => true,
            'admin_role' => $user['admin_role']
        ];
    }

    /**
     * Check if user has specific admin role
     * 
     * @param string $requiredRole Required role (super_admin, admin, moderator)
     * @return bool
     */
    public static function hasRole($requiredRole) {
        $adminData = self::authenticate();
        
        $roleHierarchy = [
            'super_admin' => 3,
            'admin' => 2,
            'moderator' => 1
        ];

        $userLevel = $roleHierarchy[$adminData['admin_role']] ?? 0;
        $requiredLevel = $roleHierarchy[$requiredRole] ?? 0;

        if ($userLevel < $requiredLevel) {
            Response::error("Insufficient permissions. $requiredRole role required.", 403);
        }

        return true;
    }

    /**
     * Require super admin role
     */
    public static function requireSuperAdmin() {
        return self::hasRole('super_admin');
    }

    /**
     * Require admin role or higher
     */
    public static function requireAdmin() {
        return self::hasRole('admin');
    }
}
