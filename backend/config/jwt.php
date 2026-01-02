<?php
/**
 * JWT Configuration
 * 
 * IMPORTANT: Change the secret key to a random string in production
 */

class JWTConfig {
    // Change this to a random, secure string in production
    public static $secret_key = "cZJbBb9EuUbKko1PvUeKxCaKkzCjMVKW";
    
    // Token expiration times (in seconds)
    public static $access_token_expiry = 3600;        // 1 hour
    public static $refresh_token_expiry = 2592000;    // 30 days
    
    // Issuer
    public static $issuer = "market_local_api";
    
    // Audience
    public static $audience = "market_local_app";
}
