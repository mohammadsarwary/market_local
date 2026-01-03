        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <div class="logo">
                    <div class="logo-icon">
                        <i class="fas fa-shield-halved"></i>
                    </div>
                    <div>
                        <div style="font-size: 18px;">Admin Panel</div>
                        <div style="font-size: 11px; color: #6B7280; font-weight: 400;">Marketplace Manager</div>
                    </div>
                </div>
            </div>

            <nav class="sidebar-nav">
                <div class="nav-section">
                    <div class="nav-section-title">MODERATION</div>
                    <a href="dashboard.php" class="nav-item <?php echo ($current_page == 'dashboard') ? 'active' : ''; ?>">
                        <i class="fas fa-th-large"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="pending_queue.php" class="nav-item <?php echo ($current_page == 'pending') ? 'active' : ''; ?>">
                        <i class="fas fa-clock"></i>
                        <span>Pending Queue</span>
                        <span class="nav-badge" id="pending-count">142</span>
                    </a>
                    <a href="reports.php" class="nav-item <?php echo ($current_page == 'reports') ? 'active' : ''; ?>">
                        <i class="fas fa-flag"></i>
                        <span>Reported Ads</span>
                        <span class="nav-badge" id="reports-count">12</span>
                    </a>
                </div>

                <div class="nav-section">
                    <div class="nav-section-title">MANAGEMENT</div>
                    <a href="users.php" class="nav-item <?php echo ($current_page == 'users') ? 'active' : ''; ?>">
                        <i class="fas fa-users"></i>
                        <span>Users</span>
                    </a>
                    <a href="categories.php" class="nav-item <?php echo ($current_page == 'categories') ? 'active' : ''; ?>">
                        <i class="fas fa-folder"></i>
                        <span>Categories</span>
                    </a>
                </div>

                <div class="nav-section">
                    <div class="nav-section-title">SYSTEM</div>
                    <a href="analytics.php" class="nav-item <?php echo ($current_page == 'analytics') ? 'active' : ''; ?>">
                        <i class="fas fa-chart-line"></i>
                        <span>Analytics & Reports</span>
                    </a>
                    <a href="settings.php" class="nav-item <?php echo ($current_page == 'settings') ? 'active' : ''; ?>">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </a>
                </div>
            </nav>

            <div style="position: absolute; bottom: 20px; left: 0; right: 0; padding: 0 20px;">
                <a href="logout.php" class="nav-item" style="color: #EF4444;">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Log Out</span>
                </a>
            </div>
        </aside>

        <main class="main-content">
            <div class="top-navbar">
                <div class="breadcrumb">
                    <a href="dashboard.php">Dashboard</a>
                    <?php if (isset($breadcrumb)): ?>
                        <?php foreach ($breadcrumb as $item): ?>
                            <span class="breadcrumb-separator">/</span>
                            <?php if (isset($item['url'])): ?>
                                <a href="<?php echo $item['url']; ?>"><?php echo $item['label']; ?></a>
                            <?php else: ?>
                                <span><?php echo $item['label']; ?></span>
                            <?php endif; ?>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </div>

                <div class="navbar-actions">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search ID or keyword...">
                    </div>

                    <button class="notification-btn">
                        <i class="fas fa-bell"></i>
                        <span class="notification-badge">3</span>
                    </button>

                    <div class="user-menu">
                        <div class="user-avatar">
                            <?php echo strtoupper(substr($admin_user['name'] ?? 'A', 0, 1)); ?>
                        </div>
                        <div class="user-info">
                            <div class="user-name"><?php echo htmlspecialchars($admin_user['name'] ?? 'Admin User'); ?></div>
                            <div class="user-role">Super Moderator</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="content-wrapper">
