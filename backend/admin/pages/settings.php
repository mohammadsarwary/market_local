<?php
$current_page = 'settings';
$page_title = 'Settings';
$breadcrumb = [['label' => 'Settings']];

include '../includes/auth_check.php';
include '../includes/header.php';
include '../includes/sidebar.php';
?>

<div class="page-header">
    <h1 class="page-title">Settings</h1>
    <p class="page-description">Configure admin panel preferences and system settings.</p>
</div>

<div class="card">
    <h3 style="font-size: 18px; font-weight: 600; margin-bottom: 24px;">Admin Preferences</h3>
    
    <div class="form-group">
        <label class="form-label">Display Name</label>
        <input type="text" class="form-control" value="<?php echo htmlspecialchars($admin_user['name'] ?? 'Admin User'); ?>">
    </div>

    <div class="form-group">
        <label class="form-label">Email</label>
        <input type="email" class="form-control" value="<?php echo htmlspecialchars($admin_user['email'] ?? 'admin@example.com'); ?>">
    </div>

    <div style="display: flex; gap: 12px; margin-top: 24px;">
        <button class="btn btn-secondary">Cancel</button>
        <button class="btn btn-primary">Save Changes</button>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
