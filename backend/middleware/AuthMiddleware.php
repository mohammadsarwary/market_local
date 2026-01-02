<?php
require_once __DIR__ . '/../utils/JWT.php';
require_once __DIR__ . '/../utils/Response.php';

/**
 * Authentication Middleware
 * 
 * Validates JWT token and sets current user
 */

class AuthMiddleware {
    /**
     * Verify JWT token and get user ID
     * 
     * @return int User ID
     */
    public static function authenticate() {
        $token = JWT::getBearerToken();
        
        if (!$token) {
            Response::unauthorized("Access token is missing");
        }

        $decoded = JWT::decode($token);
        
        if (!$decoded) {
            Response::unauthorized("Invalid or expired token");
        }

        if (!isset($decoded['user_id'])) {
            Response::unauthorized("Invalid token payload");
        }

        return $decoded['user_id'];
    }

    /**
     * Optional authentication (doesn't fail if no token)
     * 
     * @return int|null User ID or null
     */
    public static function optionalAuth() {
        $token = JWT::getBearerToken();
        
        if (!$token) {
            return null;
        }

        $decoded = JWT::decode($token);
        
        if (!$decoded || !isset($decoded['user_id'])) {
            return null;
        }

        return $decoded['user_id'];
    }
}
