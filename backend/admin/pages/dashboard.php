<?php
$current_page = 'dashboard';
$page_title = 'Dashboard';
$breadcrumb = [];

include '../includes/auth_check.php';
include '../includes/header.php';
include '../includes/sidebar.php';
?>

<div class="page-header">
    <h1 class="page-title">Analytics Overview</h1>
    <p class="page-description">Track performance metrics, user engagement, and marketplace trends.</p>
</div>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
    <div class="date-range-picker">
        <i class="fas fa-calendar"></i>
        <span class="date-range-text">30 Days</span>
        <i class="fas fa-chevron-down" style="font-size: 12px; color: #6B7280;"></i>
    </div>
    <button class="btn btn-primary">
        <i class="fas fa-download"></i>
        Export Report
    </button>
</div>

<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-header">
            <div>
                <div class="stat-label">Total Ads Posted</div>
                <div class="stat-value" id="total-ads">12,450</div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    <span>+15.2%</span>
                </div>
            </div>
            <div class="stat-icon blue">
                <i class="fas fa-rectangle-ad"></i>
            </div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-header">
            <div>
                <div class="stat-label">Active Users</div>
                <div class="stat-value" id="active-users">8,320</div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    <span>+12%</span>
                </div>
            </div>
            <div class="stat-icon blue">
                <i class="fas fa-users"></i>
            </div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-header">
            <div>
                <div class="stat-label">Revenue Generated</div>
                <div class="stat-value" id="revenue">$45,200</div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    <span>+2.5%</span>
                </div>
            </div>
            <div class="stat-icon green">
                <i class="fas fa-dollar-sign"></i>
            </div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-header">
            <div>
                <div class="stat-label">Pending Approvals</div>
                <div class="stat-value" id="pending-approvals">142</div>
                <div class="stat-change negative">
                    <i class="fas fa-arrow-down"></i>
                    <span>-8%</span>
                </div>
            </div>
            <div class="stat-icon orange">
                <i class="fas fa-clock"></i>
            </div>
        </div>
    </div>
</div>

<div class="pending-alerts">
    <div class="alert alert-warning">
        <i class="fas fa-exclamation-triangle alert-icon"></i>
        <div class="alert-content">
            <div class="alert-title">Pending Ads Require Attention</div>
            <div class="alert-message">142 ads are waiting for moderation approval</div>
        </div>
        <button class="alert-action" onclick="window.location.href='pending_queue.php'">Review Now</button>
    </div>

    <div class="alert alert-danger">
        <i class="fas fa-flag alert-icon"></i>
        <div class="alert-content">
            <div class="alert-title">New Reports Submitted</div>
            <div class="alert-message">12 new reports need to be reviewed</div>
        </div>
        <button class="alert-action" onclick="window.location.href='reports.php'">View Reports</button>
    </div>
</div>

<div class="charts-grid">
    <div class="chart-card" style="grid-column: span 2;">
        <div class="chart-header">
            <h3 class="chart-title">Ad Posting Trends</h3>
            <button class="chart-menu"><i class="fas fa-ellipsis-vertical"></i></button>
        </div>
        <div class="chart-container">
            <canvas id="adTrendsChart"></canvas>
        </div>
    </div>

    <div class="chart-card">
        <div class="chart-header">
            <h3 class="chart-title">Category Share</h3>
            <button class="chart-menu"><i class="fas fa-ellipsis-vertical"></i></button>
        </div>
        <div class="chart-container">
            <canvas id="categoryChart"></canvas>
        </div>
        <div class="category-legend">
            <div class="legend-item">
                <div class="legend-label">
                    <div class="legend-color" style="background-color: #3B82F6;"></div>
                    <span class="legend-name">Vehicles</span>
                </div>
                <span class="legend-value">35%</span>
            </div>
            <div class="legend-item">
                <div class="legend-label">
                    <div class="legend-color" style="background-color: #60A5FA;"></div>
                    <span class="legend-name">Real Estate</span>
                </div>
                <span class="legend-value">25%</span>
            </div>
            <div class="legend-item">
                <div class="legend-label">
                    <div class="legend-color" style="background-color: #93C5FD;"></div>
                    <span class="legend-name">Electronics</span>
                </div>
                <span class="legend-value">25%</span>
            </div>
            <div class="legend-item">
                <div class="legend-label">
                    <div class="legend-color" style="background-color: #6B7280;"></div>
                    <span class="legend-name">Other</span>
                </div>
                <span class="legend-value">15%</span>
            </div>
        </div>
    </div>
</div>

<div class="charts-grid">
    <div class="chart-card">
        <div class="chart-header">
            <h3 class="chart-title">Top Performing Cities</h3>
            <a href="#" style="color: #EF4444; font-size: 14px; text-decoration: none;">View All</a>
        </div>
        <div class="city-table">
            <div class="city-row" style="padding-top: 0;">
                <div style="font-size: 12px; color: #6B7280; font-weight: 600; text-transform: uppercase;">CITY</div>
                <div style="font-size: 12px; color: #6B7280; font-weight: 600; text-transform: uppercase;">ACTIVE ADS</div>
                <div style="font-size: 12px; color: #6B7280; font-weight: 600; text-transform: uppercase;">ENGAGEMENT</div>
                <div style="font-size: 12px; color: #6B7280; font-weight: 600; text-transform: uppercase;">TREND</div>
            </div>
            <div class="city-row">
                <div class="city-name">Tehran</div>
                <div class="city-ads">5,230</div>
                <div class="city-engagement">
                    <div class="engagement-fill" style="width: 85%;"></div>
                </div>
                <div class="city-trend positive">+12%</div>
            </div>
            <div class="city-row">
                <div class="city-name">Mashhad</div>
                <div class="city-ads">3,100</div>
                <div class="city-engagement">
                    <div class="engagement-fill" style="width: 65%;"></div>
                </div>
                <div class="city-trend negative">-8%</div>
            </div>
            <div class="city-row">
                <div class="city-name">Isfahan</div>
                <div class="city-ads">2,450</div>
                <div class="city-engagement">
                    <div class="engagement-fill" style="width: 55%;"></div>
                </div>
                <div class="city-trend positive">+5%</div>
            </div>
        </div>
    </div>

    <div class="chart-card">
        <div class="chart-header">
            <h3 class="chart-title">User Demographics</h3>
            <div style="display: flex; gap: 16px; font-size: 12px;">
                <span style="color: #3B82F6;"><i class="fas fa-circle" style="font-size: 8px;"></i> Male</span>
                <span style="color: #EC4899;"><i class="fas fa-circle" style="font-size: 8px;"></i> Female</span>
            </div>
        </div>
        <div style="margin-top: 24px;">
            <div class="demographics-bar">
                <div class="demographics-label">18-24 Years</div>
                <div class="demographics-progress">
                    <div class="progress-segment male" style="width: 20%;"></div>
                    <div class="progress-segment female" style="width: 12%;"></div>
                </div>
                <div class="demographics-value">32%</div>
            </div>
            <div class="demographics-bar">
                <div class="demographics-label">25-34 Years</div>
                <div class="demographics-progress">
                    <div class="progress-segment male" style="width: 28%;"></div>
                    <div class="progress-segment female" style="width: 17%;"></div>
                </div>
                <div class="demographics-value">45%</div>
            </div>
            <div class="demographics-bar">
                <div class="demographics-label">35-44 Years</div>
                <div class="demographics-progress">
                    <div class="progress-segment male" style="width: 10%;"></div>
                    <div class="progress-segment female" style="width: 5%;"></div>
                </div>
                <div class="demographics-value">15%</div>
            </div>
            <div class="demographics-bar">
                <div class="demographics-label">45+ Years</div>
                <div class="demographics-progress">
                    <div class="progress-segment male" style="width: 5%;"></div>
                    <div class="progress-segment female" style="width: 3%;"></div>
                </div>
                <div class="demographics-value">8%</div>
            </div>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h3 class="card-title">Recent Activity</h3>
        <a href="#" style="color: #EF4444; font-size: 14px; text-decoration: none;">View All</a>
    </div>
    <div class="activity-feed">
        <div class="activity-item">
            <div class="activity-icon green">
                <i class="fas fa-check"></i>
            </div>
            <div class="activity-content">
                <div class="activity-text"><strong>Ad Approved:</strong> iPhone 13 Pro Max by John Doe</div>
                <div class="activity-time">2 minutes ago</div>
            </div>
        </div>
        <div class="activity-item">
            <div class="activity-icon blue">
                <i class="fas fa-user-plus"></i>
            </div>
            <div class="activity-content">
                <div class="activity-text"><strong>New User:</strong> Sarah Miller registered</div>
                <div class="activity-time">15 minutes ago</div>
            </div>
        </div>
        <div class="activity-item">
            <div class="activity-icon red">
                <i class="fas fa-flag"></i>
            </div>
            <div class="activity-content">
                <div class="activity-text"><strong>Report Submitted:</strong> Suspicious listing flagged</div>
                <div class="activity-time">1 hour ago</div>
            </div>
        </div>
        <div class="activity-item">
            <div class="activity-icon green">
                <i class="fas fa-check"></i>
            </div>
            <div class="activity-content">
                <div class="activity-text"><strong>Ad Approved:</strong> Toyota Camry 2020 by Mike Chen</div>
                <div class="activity-time">2 hours ago</div>
            </div>
        </div>
    </div>
</div>

<script>
const API_BASE_URL = '../../admin_api.php';

async function loadDashboardStats() {
    try {
        const token = localStorage.getItem('admin_token');
        const response = await fetch(`${API_BASE_URL}?action=stats`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        
        const data = await response.json();
        if (data.success) {
            document.getElementById('total-ads').textContent = data.data.total_ads.toLocaleString();
            document.getElementById('active-users').textContent = data.data.active_users.toLocaleString();
            document.getElementById('revenue').textContent = '$' + data.data.revenue_month.toLocaleString();
            document.getElementById('pending-approvals').textContent = data.data.pending_ads;
        }
    } catch (error) {
        console.error('Error loading stats:', error);
    }
}

const adTrendsCtx = document.getElementById('adTrendsChart').getContext('2d');
const adTrendsChart = new Chart(adTrendsCtx, {
    type: 'line',
    data: {
        labels: ['Aug 01', 'Aug 05', 'Aug 10', 'Aug 15', 'Aug 20', 'Aug 25', 'Aug 30'],
        datasets: [{
            label: 'Ad Postings',
            data: [320, 380, 420, 450, 480, 520, 580],
            borderColor: '#3B82F6',
            backgroundColor: 'rgba(59, 130, 246, 0.1)',
            tension: 0.4,
            fill: true,
            pointRadius: 6,
            pointBackgroundColor: '#3B82F6',
            pointBorderColor: '#0F0F0F',
            pointBorderWidth: 2
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: false
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                grid: {
                    color: '#2A2A2A'
                },
                ticks: {
                    color: '#6B7280'
                }
            },
            x: {
                grid: {
                    display: false
                },
                ticks: {
                    color: '#6B7280'
                }
            }
        }
    }
});

const categoryCtx = document.getElementById('categoryChart').getContext('2d');
const categoryChart = new Chart(categoryCtx, {
    type: 'doughnut',
    data: {
        labels: ['Vehicles', 'Real Estate', 'Electronics', 'Other'],
        datasets: [{
            data: [35, 25, 25, 15],
            backgroundColor: ['#3B82F6', '#60A5FA', '#93C5FD', '#6B7280'],
            borderWidth: 0
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '70%',
        plugins: {
            legend: {
                display: false
            }
        }
    }
});

loadDashboardStats();
setInterval(loadDashboardStats, 30000);
</script>

<?php
include '../includes/footer.php';
?>
