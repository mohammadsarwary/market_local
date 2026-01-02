<?php
/**
 * Database Configuration
 * 
 * Update these values with your cPanel database credentials
 */

class Database {
    private $host = "localhost";
    private $db_name = "bazapndu_market";
    private $username = "bazapndu_market";  // Change this to your cPanel MySQL username
    private $password = "rezasarwary123";      // Change this to your cPanel MySQL password
    private $conn;

    /**
     * Get database connection
     * 
     * @return PDO|null
     */
    public function getConnection() {
        $this->conn = null;

        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name . ";charset=utf8mb4",
                $this->username,
                $this->password
            );
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
            $this->conn->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
        } catch(PDOException $e) {
            error_log("Connection Error: " . $e->getMessage());
            return null;
        }

        return $this->conn;
    }

    /**
     * Close database connection
     */
    public function closeConnection() {
        $this->conn = null;
    }
}
