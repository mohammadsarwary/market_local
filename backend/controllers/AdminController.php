<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../utils/JWT.php';
require_once __DIR__ . '/../utils/Response.php';
require_once __DIR__ . '/../utils/Validator.php';

/**
 * Admin Controller
 * Handles all admin-related operations
 */
class AdminController {
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
     * Admin Login
     * POST /admin/login
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

        if (!$user['is_admin']) {
            Response::error("Access denied. Admin privileges required.", 403);
        }

        if (!$user['is_active']) {
            Response::error("Account is deactivated", 403);
        }

        $this->userModel->updateLastLogin($user['id']);

        unset($user['password']);

        $accessToken = JWT::encode([
            'user_id' => $user['id'],
            'is_admin' => true,
            'admin_role' => $user['admin_role']
        ]);
        
        $refreshToken = JWT::encode([
            'user_id' => $user['id'],
            'is_admin' => true
        ], JWTConfig::$refresh_token_expiry);

        $this->saveRefreshToken($user['id'], $refreshToken);

        Response::success([
            'user' => $user,
            'access_token' => $accessToken,
            'refresh_token' => $refreshToken,
            'token_type' => 'Bearer',
            'expires_in' => JWTConfig::$access_token_expiry
        ], "Admin login successful");
    }

    /**
     * Verify Admin Session
     * GET /admin/verify
     */
    public function verify() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        $adminData = AdminMiddleware::authenticate();

        $user = $this->userModel->findById($adminData['user_id']);

        if (!$user) {
            Response::notFound("User not found");
        }

        Response::success([
            'user' => $user,
            'admin_role' => $user['admin_role']
        ], "Admin session valid");
    }

    /**
     * Get Dashboard Statistics
     * GET /admin/stats
     */
    public function getStats() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $stats = [
            'total_users' => $this->getTotalUsers(),
            'active_users' => $this->getActiveUsers(),
            'total_ads' => $this->getTotalAds(),
            'active_ads' => $this->getActiveAds(),
            'pending_ads' => $this->getPendingAds(),
            'total_reports' => $this->getTotalReports(),
            'pending_reports' => $this->getPendingReports(),
            'new_users_today' => $this->getNewUsersToday(),
            'new_ads_today' => $this->getNewAdsToday(),
            'new_users_week' => $this->getNewUsersThisWeek(),
            'new_ads_week' => $this->getNewAdsThisWeek()
        ];

        Response::success($stats);
    }

    /**
     * Get Recent Activity
     * GET /admin/activity
     */
    public function getRecentActivity() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $limit = $_GET['limit'] ?? 20;

        $query = "
            (SELECT 'user' as type, id, name as title, email as subtitle, created_at 
             FROM users ORDER BY created_at DESC LIMIT :limit)
            UNION ALL
            (SELECT 'ad' as type, id, title, CONCAT('Price: $', price) as subtitle, created_at 
             FROM ads ORDER BY created_at DESC LIMIT :limit)
            UNION ALL
            (SELECT 'report' as type, id, reason as title, reported_type as subtitle, created_at 
             FROM reports ORDER BY created_at DESC LIMIT :limit)
            ORDER BY created_at DESC LIMIT :limit
        ";

        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();

        $activity = $stmt->fetchAll();

        Response::success($activity);
    }

    /**
     * List All Users with Filters
     * GET /admin/users
     */
    public function listUsers() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 20;
        $offset = ($page - 1) * $limit;
        $search = $_GET['search'] ?? '';
        $status = $_GET['status'] ?? '';

        $query = "SELECT id, name, email, phone, location, rating, active_listings, 
                         is_verified, is_active, is_admin, admin_role, created_at, last_login 
                  FROM users WHERE 1=1";

        $params = [];

        if (!empty($search)) {
            $query .= " AND (name LIKE :search OR email LIKE :search OR phone LIKE :search)";
            $params[':search'] = "%$search%";
        }

        if ($status === 'active') {
            $query .= " AND is_active = 1";
        } elseif ($status === 'inactive') {
            $query .= " AND is_active = 0";
        } elseif ($status === 'verified') {
            $query .= " AND is_verified = 1";
        } elseif ($status === 'admin') {
            $query .= " AND is_admin = 1";
        }

        $countQuery = "SELECT COUNT(*) as total FROM (" . $query . ") as count_table";
        $countStmt = $this->db->prepare($countQuery);
        foreach ($params as $key => $value) {
            $countStmt->bindValue($key, $value);
        }
        $countStmt->execute();
        $total = $countStmt->fetch()['total'];

        $query .= " ORDER BY created_at DESC LIMIT :limit OFFSET :offset";
        $stmt = $this->db->prepare($query);
        
        foreach ($params as $key => $value) {
            $stmt->bindValue($key, $value);
        }
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        
        $stmt->execute();
        $users = $stmt->fetchAll();

        Response::success([
            'users' => $users,
            'pagination' => [
                'page' => $page,
                'limit' => $limit,
                'total' => $total,
                'pages' => ceil($total / $limit)
            ]
        ]);
    }

    /**
     * Get User Details
     * GET /admin/users/:id
     */
    public function getUserDetails($userId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $user = $this->userModel->findById($userId);

        if (!$user) {
            Response::notFound("User not found");
        }

        $query = "SELECT COUNT(*) as count FROM ads WHERE user_id = :user_id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':user_id', $userId);
        $stmt->execute();
        $user['total_ads'] = $stmt->fetch()['count'];

        $query = "SELECT COUNT(*) as count FROM ads WHERE user_id = :user_id AND status = 'active'";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':user_id', $userId);
        $stmt->execute();
        $user['active_ads_count'] = $stmt->fetch()['count'];

        $query = "SELECT * FROM ads WHERE user_id = :user_id ORDER BY created_at DESC LIMIT 10";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':user_id', $userId);
        $stmt->execute();
        $user['recent_ads'] = $stmt->fetchAll();

        Response::success($user);
    }

    /**
     * Suspend User
     * PUT /admin/users/:id/suspend
     */
    public function suspendUser($userId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $data = json_decode(file_get_contents("php://input"), true);
        $reason = $data['reason'] ?? 'Suspended by admin';

        $query = "UPDATE users SET is_active = 0 WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $userId);

        if ($stmt->execute()) {
            $this->logAdminAction('suspend_user', $userId, $reason);
            Response::success(null, "User suspended successfully");
        } else {
            Response::serverError("Failed to suspend user");
        }
    }

    /**
     * Activate User
     * PUT /admin/users/:id/activate
     */
    public function activateUser($userId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $query = "UPDATE users SET is_active = 1 WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $userId);

        if ($stmt->execute()) {
            $this->logAdminAction('activate_user', $userId, 'User activated');
            Response::success(null, "User activated successfully");
        } else {
            Response::serverError("Failed to activate user");
        }
    }

    /**
     * Verify User
     * PUT /admin/users/:id/verify
     */
    public function verifyUser($userId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $query = "UPDATE users SET is_verified = 1 WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $userId);

        if ($stmt->execute()) {
            $this->logAdminAction('verify_user', $userId, 'User verified');
            Response::success(null, "User verified successfully");
        } else {
            Response::serverError("Failed to verify user");
        }
    }

    /**
     * Delete User
     * DELETE /admin/users/:id
     */
    public function deleteUser($userId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        $adminData = AdminMiddleware::authenticate();

        if ($adminData['admin_role'] !== 'super_admin') {
            Response::error("Only super admins can delete users", 403);
        }

        $data = json_decode(file_get_contents("php://input"), true);
        $reason = $data['reason'] ?? 'Deleted by admin';

        $query = "DELETE FROM users WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $userId);

        if ($stmt->execute()) {
            $this->logAdminAction('delete_user', $userId, $reason);
            Response::success(null, "User deleted successfully");
        } else {
            Response::serverError("Failed to delete user");
        }
    }

    /**
     * Get User Activity Log
     * GET /admin/users/:id/activity
     */
    public function getUserActivity($userId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $query = "
            SELECT 'ad_created' as type, id, title as description, created_at 
            FROM ads WHERE user_id = :user_id
            UNION ALL
            SELECT 'message_sent' as type, id, message as description, created_at 
            FROM messages WHERE sender_id = :user_id
            UNION ALL
            SELECT 'review_given' as type, id, comment as description, created_at 
            FROM reviews WHERE reviewer_id = :user_id
            ORDER BY created_at DESC LIMIT 50
        ";

        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':user_id', $userId);
        $stmt->execute();

        $activity = $stmt->fetchAll();

        Response::success($activity);
    }

    /**
     * Export Users to CSV
     * GET /admin/users/export
     */
    public function exportUsers() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $query = "SELECT id, name, email, phone, location, rating, active_listings, 
                         is_verified, is_active, created_at 
                  FROM users ORDER BY created_at DESC";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $users = $stmt->fetchAll();

        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="users_export_' . date('Y-m-d') . '.csv"');

        $output = fopen('php://output', 'w');
        fputcsv($output, ['ID', 'Name', 'Email', 'Phone', 'Location', 'Rating', 'Active Listings', 'Verified', 'Active', 'Created At']);

        foreach ($users as $user) {
            fputcsv($output, [
                $user['id'],
                $user['name'],
                $user['email'],
                $user['phone'],
                $user['location'],
                $user['rating'],
                $user['active_listings'],
                $user['is_verified'] ? 'Yes' : 'No',
                $user['is_active'] ? 'Yes' : 'No',
                $user['created_at']
            ]);
        }

        fclose($output);
        exit;
    }

    /**
     * List All Ads with Filters
     * GET /admin/ads
     */
    public function listAds() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 20;
        $offset = ($page - 1) * $limit;
        $status = $_GET['status'] ?? '';
        $category = $_GET['category'] ?? '';
        $search = $_GET['search'] ?? '';

        $query = "SELECT a.*, u.name as user_name, u.email as user_email, c.name as category_name 
                  FROM ads a 
                  LEFT JOIN users u ON a.user_id = u.id 
                  LEFT JOIN categories c ON a.category_id = c.id 
                  WHERE 1=1";

        $params = [];

        if (!empty($status)) {
            $query .= " AND a.status = :status";
            $params[':status'] = $status;
        }

        if (!empty($category)) {
            $query .= " AND a.category_id = :category";
            $params[':category'] = $category;
        }

        if (!empty($search)) {
            $query .= " AND (a.title LIKE :search OR a.description LIKE :search)";
            $params[':search'] = "%$search%";
        }

        $countQuery = "SELECT COUNT(*) as total FROM (" . $query . ") as count_table";
        $countStmt = $this->db->prepare($countQuery);
        foreach ($params as $key => $value) {
            $countStmt->bindValue($key, $value);
        }
        $countStmt->execute();
        $total = $countStmt->fetch()['total'];

        $query .= " ORDER BY a.created_at DESC LIMIT :limit OFFSET :offset";
        $stmt = $this->db->prepare($query);
        
        foreach ($params as $key => $value) {
            $stmt->bindValue($key, $value);
        }
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        
        $stmt->execute();
        $ads = $stmt->fetchAll();

        Response::success([
            'ads' => $ads,
            'pagination' => [
                'page' => $page,
                'limit' => $limit,
                'total' => $total,
                'pages' => ceil($total / $limit)
            ]
        ]);
    }

    /**
     * Get Ad Details
     * GET /admin/ads/:id
     */
    public function getAdDetails($adId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $query = "SELECT a.*, u.name as user_name, u.email as user_email, u.phone as user_phone,
                         c.name as category_name 
                  FROM ads a 
                  LEFT JOIN users u ON a.user_id = u.id 
                  LEFT JOIN categories c ON a.category_id = c.id 
                  WHERE a.id = :id";
        
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $adId);
        $stmt->execute();
        $ad = $stmt->fetch();

        if (!$ad) {
            Response::notFound("Ad not found");
        }

        $query = "SELECT * FROM ad_images WHERE ad_id = :ad_id ORDER BY display_order";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':ad_id', $adId);
        $stmt->execute();
        $ad['images'] = $stmt->fetchAll();

        Response::success($ad);
    }

    /**
     * Delete Ad
     * DELETE /admin/ads/:id
     */
    public function deleteAd($adId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $data = json_decode(file_get_contents("php://input"), true);
        $reason = $data['reason'] ?? 'Deleted by admin';

        $query = "DELETE FROM ads WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $adId);

        if ($stmt->execute()) {
            $this->logAdminAction('delete_ad', $adId, $reason);
            Response::success(null, "Ad deleted successfully");
        } else {
            Response::serverError("Failed to delete ad");
        }
    }

    /**
     * Feature Ad
     * PUT /admin/ads/:id/feature
     */
    public function featureAd($adId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $data = json_decode(file_get_contents("php://input"), true);
        $featured = $data['featured'] ?? true;

        $query = "UPDATE ads SET is_featured = :featured WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':featured', $featured, PDO::PARAM_BOOL);
        $stmt->bindParam(':id', $adId);

        if ($stmt->execute()) {
            $action = $featured ? 'Featured' : 'Unfeatured';
            $this->logAdminAction('feature_ad', $adId, "$action ad");
            Response::success(null, "Ad $action successfully");
        } else {
            Response::serverError("Failed to feature ad");
        }
    }

    /**
     * Promote Ad
     * PUT /admin/ads/:id/promote
     */
    public function promoteAd($adId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $data = json_decode(file_get_contents("php://input"), true);
        $days = $data['days'] ?? 7;
        $promotedUntil = date('Y-m-d H:i:s', strtotime("+$days days"));

        $query = "UPDATE ads SET is_promoted = 1, promoted_until = :promoted_until WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':promoted_until', $promotedUntil);
        $stmt->bindParam(':id', $adId);

        if ($stmt->execute()) {
            $this->logAdminAction('promote_ad', $adId, "Promoted for $days days");
            Response::success(null, "Ad promoted successfully");
        } else {
            Response::serverError("Failed to promote ad");
        }
    }

    /**
     * Export Ads to CSV
     * GET /admin/ads/export
     */
    public function exportAds() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $query = "SELECT a.id, a.title, a.price, a.condition, a.location, a.status, a.views, 
                         a.created_at, u.name as user_name, c.name as category_name 
                  FROM ads a 
                  LEFT JOIN users u ON a.user_id = u.id 
                  LEFT JOIN categories c ON a.category_id = c.id 
                  ORDER BY a.created_at DESC";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $ads = $stmt->fetchAll();

        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="ads_export_' . date('Y-m-d') . '.csv"');

        $output = fopen('php://output', 'w');
        fputcsv($output, ['ID', 'Title', 'Price', 'Condition', 'Location', 'Status', 'Views', 'User', 'Category', 'Created At']);

        foreach ($ads as $ad) {
            fputcsv($output, [
                $ad['id'],
                $ad['title'],
                $ad['price'],
                $ad['condition'],
                $ad['location'],
                $ad['status'],
                $ad['views'],
                $ad['user_name'],
                $ad['category_name'],
                $ad['created_at']
            ]);
        }

        fclose($output);
        exit;
    }

    /**
     * List Reports with Filters
     * GET /admin/reports
     */
    public function listReports() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 20;
        $offset = ($page - 1) * $limit;
        $status = $_GET['status'] ?? '';
        $type = $_GET['type'] ?? '';

        $query = "SELECT r.*, u.name as reporter_name, u.email as reporter_email 
                  FROM reports r 
                  LEFT JOIN users u ON r.reporter_id = u.id 
                  WHERE 1=1";

        $params = [];

        if (!empty($status)) {
            $query .= " AND r.status = :status";
            $params[':status'] = $status;
        }

        if (!empty($type)) {
            $query .= " AND r.reported_type = :type";
            $params[':type'] = $type;
        }

        $countQuery = "SELECT COUNT(*) as total FROM (" . $query . ") as count_table";
        $countStmt = $this->db->prepare($countQuery);
        foreach ($params as $key => $value) {
            $countStmt->bindValue($key, $value);
        }
        $countStmt->execute();
        $total = $countStmt->fetch()['total'];

        $query .= " ORDER BY r.created_at DESC LIMIT :limit OFFSET :offset";
        $stmt = $this->db->prepare($query);
        
        foreach ($params as $key => $value) {
            $stmt->bindValue($key, $value);
        }
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        
        $stmt->execute();
        $reports = $stmt->fetchAll();

        Response::success([
            'reports' => $reports,
            'pagination' => [
                'page' => $page,
                'limit' => $limit,
                'total' => $total,
                'pages' => ceil($total / $limit)
            ]
        ]);
    }

    /**
     * Get Report Details
     * GET /admin/reports/:id
     */
    public function getReportDetails($reportId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $query = "SELECT r.*, u.name as reporter_name, u.email as reporter_email 
                  FROM reports r 
                  LEFT JOIN users u ON r.reporter_id = u.id 
                  WHERE r.id = :id";
        
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $reportId);
        $stmt->execute();
        $report = $stmt->fetch();

        if (!$report) {
            Response::notFound("Report not found");
        }

        if ($report['reported_type'] === 'ad') {
            $query = "SELECT * FROM ads WHERE id = :id";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(':id', $report['reported_id']);
            $stmt->execute();
            $report['reported_content'] = $stmt->fetch();
        } elseif ($report['reported_type'] === 'user') {
            $query = "SELECT id, name, email, phone FROM users WHERE id = :id";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(':id', $report['reported_id']);
            $stmt->execute();
            $report['reported_content'] = $stmt->fetch();
        }

        Response::success($report);
    }

    /**
     * Resolve Report
     * PUT /admin/reports/:id/resolve
     */
    public function resolveReport($reportId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $data = json_decode(file_get_contents("php://input"), true);
        $action = $data['action'] ?? 'resolved';

        $query = "UPDATE reports SET status = 'resolved' WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $reportId);

        if ($stmt->execute()) {
            $this->logAdminAction('resolve_report', $reportId, "Report resolved: $action");
            Response::success(null, "Report resolved successfully");
        } else {
            Response::serverError("Failed to resolve report");
        }
    }

    /**
     * Dismiss Report
     * PUT /admin/reports/:id/dismiss
     */
    public function dismissReport($reportId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $data = json_decode(file_get_contents("php://input"), true);
        $reason = $data['reason'] ?? 'Dismissed by admin';

        $query = "UPDATE reports SET status = 'dismissed' WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $reportId);

        if ($stmt->execute()) {
            $this->logAdminAction('dismiss_report', $reportId, $reason);
            Response::success(null, "Report dismissed successfully");
        } else {
            Response::serverError("Failed to dismiss report");
        }
    }

    /**
     * Take Action on Report
     * POST /admin/reports/:id/action
     */
    public function takeReportAction($reportId) {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $data = json_decode(file_get_contents("php://input"), true);
        $action = $data['action'] ?? '';

        $query = "SELECT * FROM reports WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $reportId);
        $stmt->execute();
        $report = $stmt->fetch();

        if (!$report) {
            Response::notFound("Report not found");
        }

        switch ($action) {
            case 'delete_content':
                if ($report['reported_type'] === 'ad') {
                    $this->deleteAd($report['reported_id']);
                }
                break;
            case 'suspend_user':
                if ($report['reported_type'] === 'user') {
                    $this->suspendUser($report['reported_id']);
                }
                break;
            case 'warn_user':
                break;
        }

        $query = "UPDATE reports SET status = 'resolved' WHERE id = :id";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':id', $reportId);
        $stmt->execute();

        $this->logAdminAction('report_action', $reportId, "Action taken: $action");

        Response::success(null, "Action taken successfully");
    }

    /**
     * Get Report Statistics
     * GET /admin/reports/stats
     */
    public function getReportStats() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $stats = [
            'total_reports' => $this->getTotalReports(),
            'pending_reports' => $this->getPendingReports(),
            'resolved_reports' => $this->getResolvedReports(),
            'dismissed_reports' => $this->getDismissedReports(),
            'reports_by_type' => $this->getReportsByType()
        ];

        Response::success($stats);
    }

    /**
     * Get Analytics - User Growth
     * GET /admin/analytics/users
     */
    public function getUserGrowthAnalytics() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $period = $_GET['period'] ?? '30days';
        $days = $this->parsePeriod($period);

        $query = "SELECT DATE(created_at) as date, COUNT(*) as count 
                  FROM users 
                  WHERE created_at >= DATE_SUB(NOW(), INTERVAL :days DAY)
                  GROUP BY DATE(created_at) 
                  ORDER BY date ASC";
        
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':days', $days, PDO::PARAM_INT);
        $stmt->execute();
        $data = $stmt->fetchAll();

        Response::success($data);
    }

    /**
     * Get Analytics - Ad Posting Trends
     * GET /admin/analytics/ads
     */
    public function getAdPostingAnalytics() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $period = $_GET['period'] ?? '7days';
        $days = $this->parsePeriod($period);

        $query = "SELECT DATE(created_at) as date, COUNT(*) as count 
                  FROM ads 
                  WHERE created_at >= DATE_SUB(NOW(), INTERVAL :days DAY)
                  GROUP BY DATE(created_at) 
                  ORDER BY date ASC";
        
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':days', $days, PDO::PARAM_INT);
        $stmt->execute();
        $data = $stmt->fetchAll();

        Response::success($data);
    }

    /**
     * Get Analytics - Category Distribution
     * GET /admin/analytics/categories
     */
    public function getCategoryAnalytics() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $query = "SELECT c.name, COUNT(a.id) as count 
                  FROM categories c 
                  LEFT JOIN ads a ON c.id = a.category_id 
                  GROUP BY c.id, c.name 
                  ORDER BY count DESC";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $data = $stmt->fetchAll();

        Response::success($data);
    }

    /**
     * Get Analytics - Location Distribution
     * GET /admin/analytics/locations
     */
    public function getLocationAnalytics() {
        require_once __DIR__ . '/../middleware/AdminMiddleware.php';
        AdminMiddleware::authenticate();

        $query = "SELECT location, COUNT(*) as count 
                  FROM ads 
                  WHERE location IS NOT NULL 
                  GROUP BY location 
                  ORDER BY count DESC 
                  LIMIT 20";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $data = $stmt->fetchAll();

        Response::success($data);
    }

    // Private Helper Methods

    private function getTotalUsers() {
        $query = "SELECT COUNT(*) as count FROM users";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getActiveUsers() {
        $query = "SELECT COUNT(*) as count FROM users WHERE is_active = 1";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getTotalAds() {
        $query = "SELECT COUNT(*) as count FROM ads";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getActiveAds() {
        $query = "SELECT COUNT(*) as count FROM ads WHERE status = 'active'";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getPendingAds() {
        $query = "SELECT COUNT(*) as count FROM ads WHERE status = 'pending'";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'] ?? 0;
    }

    private function getTotalReports() {
        $query = "SELECT COUNT(*) as count FROM reports";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getPendingReports() {
        $query = "SELECT COUNT(*) as count FROM reports WHERE status = 'pending'";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getResolvedReports() {
        $query = "SELECT COUNT(*) as count FROM reports WHERE status = 'resolved'";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getDismissedReports() {
        $query = "SELECT COUNT(*) as count FROM reports WHERE status = 'dismissed'";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getReportsByType() {
        $query = "SELECT reported_type, COUNT(*) as count FROM reports GROUP BY reported_type";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    private function getNewUsersToday() {
        $query = "SELECT COUNT(*) as count FROM users WHERE DATE(created_at) = CURDATE()";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getNewAdsToday() {
        $query = "SELECT COUNT(*) as count FROM ads WHERE DATE(created_at) = CURDATE()";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getNewUsersThisWeek() {
        $query = "SELECT COUNT(*) as count FROM users WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function getNewAdsThisWeek() {
        $query = "SELECT COUNT(*) as count FROM ads WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        return $stmt->fetch()['count'];
    }

    private function parsePeriod($period) {
        if (preg_match('/(\d+)days?/', $period, $matches)) {
            return (int)$matches[1];
        }
        return 30;
    }

    private function logAdminAction($action, $targetId, $details) {
        $query = "INSERT INTO admin_logs (admin_id, action, target_id, details, created_at) 
                  VALUES (:admin_id, :action, :target_id, :details, NOW())";
        
        try {
            $stmt = $this->db->prepare($query);
            $adminId = 1;
            $stmt->bindParam(':admin_id', $adminId);
            $stmt->bindParam(':action', $action);
            $stmt->bindParam(':target_id', $targetId);
            $stmt->bindParam(':details', $details);
            $stmt->execute();
        } catch (Exception $e) {
        }
    }

    private function saveRefreshToken($userId, $token) {
        $expiresAt = date('Y-m-d H:i:s', time() + JWTConfig::$refresh_token_expiry);
        
        $query = "INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (:user_id, :token, :expires_at)";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(':user_id', $userId);
        $stmt->bindParam(':token', $token);
        $stmt->bindParam(':expires_at', $expiresAt);
        
        return $stmt->execute();
    }
}
