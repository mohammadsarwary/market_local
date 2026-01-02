<?php
require_once __DIR__ . '/../config/database.php';

/**
 * Ad Model
 */

class Ad {
    private $conn;
    private $table = 'ads';

    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Create new ad
     * 
     * @param array $data
     * @return int|false Ad ID or false
     */
    public function create($data) {
        $query = "INSERT INTO " . $this->table . " 
                  (user_id, category_id, title, description, price, condition, location, latitude, longitude) 
                  VALUES (:user_id, :category_id, :title, :description, :price, :condition, :location, :latitude, :longitude)";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(':user_id', $data['user_id']);
        $stmt->bindParam(':category_id', $data['category_id']);
        $stmt->bindParam(':title', $data['title']);
        $stmt->bindParam(':description', $data['description']);
        $stmt->bindParam(':price', $data['price']);
        $stmt->bindParam(':condition', $data['condition']);
        $stmt->bindParam(':location', $data['location']);
        $stmt->bindParam(':latitude', $data['latitude']);
        $stmt->bindParam(':longitude', $data['longitude']);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }

        return false;
    }

    /**
     * Get ads with filters and pagination
     * 
     * @param array $filters
     * @param int $page
     * @param int $limit
     * @return array
     */
    public function getAll($filters = [], $page = 1, $limit = 20) {
        $offset = ($page - 1) * $limit;
        $where = ["a.status = 'active'"];
        $params = [];

        if (!empty($filters['category_id'])) {
            $where[] = "a.category_id = :category_id";
            $params[':category_id'] = $filters['category_id'];
        }

        if (!empty($filters['search'])) {
            $where[] = "(a.title LIKE :search OR a.description LIKE :search)";
            $params[':search'] = '%' . $filters['search'] . '%';
        }

        if (!empty($filters['min_price'])) {
            $where[] = "a.price >= :min_price";
            $params[':min_price'] = $filters['min_price'];
        }

        if (!empty($filters['max_price'])) {
            $where[] = "a.price <= :max_price";
            $params[':max_price'] = $filters['max_price'];
        }

        if (!empty($filters['location'])) {
            $where[] = "a.location LIKE :location";
            $params[':location'] = '%' . $filters['location'] . '%';
        }

        if (!empty($filters['condition'])) {
            $where[] = "a.condition = :condition";
            $params[':condition'] = $filters['condition'];
        }

        $whereClause = implode(' AND ', $where);
        
        $orderBy = "a.created_at DESC";
        if (!empty($filters['sort'])) {
            switch ($filters['sort']) {
                case 'price_asc':
                    $orderBy = "a.price ASC";
                    break;
                case 'price_desc':
                    $orderBy = "a.price DESC";
                    break;
                case 'oldest':
                    $orderBy = "a.created_at ASC";
                    break;
            }
        }

        $query = "SELECT a.*, u.name as user_name, u.avatar as user_avatar, u.rating as user_rating,
                  c.name as category_name,
                  (SELECT image_url FROM ad_images WHERE ad_id = a.id AND is_primary = 1 LIMIT 1) as primary_image,
                  (SELECT COUNT(*) FROM favorites WHERE ad_id = a.id) as favorite_count
                  FROM " . $this->table . " a
                  LEFT JOIN users u ON a.user_id = u.id
                  LEFT JOIN categories c ON a.category_id = c.id
                  WHERE $whereClause
                  ORDER BY $orderBy
                  LIMIT :limit OFFSET :offset";

        $stmt = $this->conn->prepare($query);
        
        foreach ($params as $key => $value) {
            $stmt->bindValue($key, $value);
        }
        
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        
        $stmt->execute();

        return $stmt->fetchAll();
    }

    /**
     * Get ad by ID
     * 
     * @param int $id
     * @param int|null $userId Optional user ID to check if favorited
     * @return array|false
     */
    public function getById($id, $userId = null) {
        $query = "SELECT a.*, u.name as user_name, u.avatar as user_avatar, u.rating as user_rating,
                  u.review_count as user_review_count, u.created_at as user_member_since,
                  c.name as category_name";
        
        if ($userId) {
            $query .= ", (SELECT COUNT(*) FROM favorites WHERE ad_id = a.id AND user_id = :user_id) as is_favorited";
        }
        
        $query .= " FROM " . $this->table . " a
                    LEFT JOIN users u ON a.user_id = u.id
                    LEFT JOIN categories c ON a.category_id = c.id
                    WHERE a.id = :id AND a.status = 'active'
                    LIMIT 1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);
        
        if ($userId) {
            $stmt->bindParam(':user_id', $userId);
        }
        
        $stmt->execute();

        $ad = $stmt->fetch();
        
        if ($ad) {
            $ad['images'] = $this->getAdImages($id);
        }

        return $ad;
    }

    /**
     * Get ad images
     * 
     * @param int $adId
     * @return array
     */
    public function getAdImages($adId) {
        $query = "SELECT image_url, is_primary FROM ad_images 
                  WHERE ad_id = :ad_id ORDER BY display_order ASC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':ad_id', $adId);
        $stmt->execute();

        return $stmt->fetchAll();
    }

    /**
     * Get user's ads
     * 
     * @param int $userId
     * @param string $status
     * @return array
     */
    public function getUserAds($userId, $status = 'active') {
        $query = "SELECT a.*, c.name as category_name,
                  (SELECT image_url FROM ad_images WHERE ad_id = a.id AND is_primary = 1 LIMIT 1) as primary_image
                  FROM " . $this->table . " a
                  LEFT JOIN categories c ON a.category_id = c.id
                  WHERE a.user_id = :user_id AND a.status = :status
                  ORDER BY a.created_at DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':user_id', $userId);
        $stmt->bindParam(':status', $status);
        $stmt->execute();

        return $stmt->fetchAll();
    }

    /**
     * Update ad
     * 
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function update($id, $data) {
        $fields = [];
        $params = [':id' => $id];

        $allowedFields = ['title', 'description', 'price', 'condition', 'location', 'category_id'];

        foreach ($allowedFields as $field) {
            if (isset($data[$field])) {
                $fields[] = "$field = :$field";
                $params[":$field"] = $data[$field];
            }
        }

        if (empty($fields)) {
            return false;
        }

        $query = "UPDATE " . $this->table . " SET " . implode(', ', $fields) . " WHERE id = :id";
        $stmt = $this->conn->prepare($query);

        return $stmt->execute($params);
    }

    /**
     * Delete ad (soft delete)
     * 
     * @param int $id
     * @return bool
     */
    public function delete($id) {
        $query = "UPDATE " . $this->table . " SET status = 'deleted' WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);

        return $stmt->execute();
    }

    /**
     * Mark ad as sold
     * 
     * @param int $id
     * @return bool
     */
    public function markAsSold($id) {
        $query = "UPDATE " . $this->table . " SET status = 'sold' WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);

        return $stmt->execute();
    }

    /**
     * Increment views
     * 
     * @param int $id
     * @return bool
     */
    public function incrementViews($id) {
        $query = "UPDATE " . $this->table . " SET views = views + 1 WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);

        return $stmt->execute();
    }

    /**
     * Add ad image
     * 
     * @param int $adId
     * @param string $imageUrl
     * @param bool $isPrimary
     * @return bool
     */
    public function addImage($adId, $imageUrl, $isPrimary = false) {
        if ($isPrimary) {
            $this->conn->prepare("UPDATE ad_images SET is_primary = 0 WHERE ad_id = :ad_id")
                       ->execute([':ad_id' => $adId]);
        }

        $query = "INSERT INTO ad_images (ad_id, image_url, is_primary) VALUES (:ad_id, :image_url, :is_primary)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':ad_id', $adId);
        $stmt->bindParam(':image_url', $imageUrl);
        $stmt->bindParam(':is_primary', $isPrimary, PDO::PARAM_BOOL);

        return $stmt->execute();
    }
}
