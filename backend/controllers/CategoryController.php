<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/Response.php';

/**
 * Category Controller
 */

class CategoryController {
    private $db;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getConnection();
        
        if (!$this->db) {
            Response::serverError("Database connection failed");
        }
    }

    /**
     * Get all categories
     * GET /api/categories
     */
    public function getAll() {
        $query = "SELECT id, name, slug, icon, parent_id, display_order 
                  FROM categories 
                  WHERE is_active = 1 
                  ORDER BY display_order ASC, name ASC";

        $stmt = $this->db->prepare($query);
        $stmt->execute();

        $categories = $stmt->fetchAll();

        Response::success($categories);
    }
}
