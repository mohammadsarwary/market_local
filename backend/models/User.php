<?php
require_once __DIR__ . '/../config/database.php';

/**
 * User Model
 */

class User {
    private $conn;
    private $table = 'users';

    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Create new user
     * 
     * @param array $data
     * @return int|false User ID or false
     */
    public function create($data) {
        $query = "INSERT INTO " . $this->table . " 
                  (name, email, phone, password, location) 
                  VALUES (:name, :email, :phone, :password, :location)";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(':name', $data['name']);
        $stmt->bindParam(':email', $data['email']);
        $stmt->bindParam(':phone', $data['phone']);
        $stmt->bindParam(':password', $data['password']);
        $stmt->bindParam(':location', $data['location']);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }

        return false;
    }

    /**
     * Find user by email
     * 
     * @param string $email
     * @return array|false
     */
    public function findByEmail($email) {
        $query = "SELECT * FROM " . $this->table . " WHERE email = :email LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':email', $email);
        $stmt->execute();

        return $stmt->fetch();
    }

    /**
     * Find user by phone
     * 
     * @param string $phone
     * @return array|false
     */
    public function findByPhone($phone) {
        $query = "SELECT * FROM " . $this->table . " WHERE phone = :phone LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':phone', $phone);
        $stmt->execute();

        return $stmt->fetch();
    }

    /**
     * Find user by ID
     * 
     * @param int $id
     * @return array|false
     */
    public function findById($id) {
        $query = "SELECT id, name, email, phone, avatar, bio, location, rating, 
                  review_count, active_listings, sold_items, followers, is_verified, 
                  created_at, updated_at 
                  FROM " . $this->table . " WHERE id = :id AND is_active = 1 LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);
        $stmt->execute();

        return $stmt->fetch();
    }

    /**
     * Update user profile
     * 
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function update($id, $data) {
        $fields = [];
        $params = [':id' => $id];

        $allowedFields = ['name', 'phone', 'bio', 'location', 'avatar'];

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
     * Update password
     * 
     * @param int $id
     * @param string $password
     * @return bool
     */
    public function updatePassword($id, $password) {
        $query = "UPDATE " . $this->table . " SET password = :password WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':password', $password);
        $stmt->bindParam(':id', $id);

        return $stmt->execute();
    }

    /**
     * Update last login timestamp
     * 
     * @param int $id
     * @return bool
     */
    public function updateLastLogin($id) {
        $query = "UPDATE " . $this->table . " SET last_login = NOW() WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);

        return $stmt->execute();
    }

    /**
     * Delete user (soft delete)
     * 
     * @param int $id
     * @return bool
     */
    public function delete($id) {
        $query = "UPDATE " . $this->table . " SET is_active = 0 WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);

        return $stmt->execute();
    }

    /**
     * Increment user stats
     * 
     * @param int $id
     * @param string $field (active_listings, sold_items, followers)
     * @param int $amount
     * @return bool
     */
    public function incrementStat($id, $field, $amount = 1) {
        $allowedFields = ['active_listings', 'sold_items', 'followers'];
        
        if (!in_array($field, $allowedFields)) {
            return false;
        }

        $query = "UPDATE " . $this->table . " SET $field = $field + :amount WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':amount', $amount);
        $stmt->bindParam(':id', $id);

        return $stmt->execute();
    }

    /**
     * Update user rating
     * 
     * @param int $id
     * @return bool
     */
    public function updateRating($id) {
        $query = "UPDATE " . $this->table . " u
                  SET u.rating = (
                      SELECT COALESCE(AVG(r.rating), 0) 
                      FROM reviews r 
                      WHERE r.reviewed_user_id = :id
                  ),
                  u.review_count = (
                      SELECT COUNT(*) 
                      FROM reviews r 
                      WHERE r.reviewed_user_id = :id
                  )
                  WHERE u.id = :id";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);

        return $stmt->execute();
    }
}
