<?php
$current_page = 'analytics';
$page_title = 'Analytics & Reports';
$breadcrumb = [['label' => 'Analytics']];

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

<div class="charts-grid">
    <div class="chart-card" style="grid-column: span 2;">
        <div class="chart-header">
            <h3 class="chart-title">User Growth</h3>
            <button class="chart-menu"><i class="fas fa-ellipsis-vertical"></i></button>
        </div>
        <div class="chart-container">
            <canvas id="userGrowthChart"></canvas>
        </div>
    </div>

    <div class="chart-card">
        <div class="chart-header">
            <h3 class="chart-title">Revenue Trends</h3>
            <button class="chart-menu"><i class="fas fa-ellipsis-vertical"></i></button>
        </div>
        <div class="chart-container">
            <canvas id="revenueChart"></canvas>
        </div>
    </div>
</div>

<script>
const userGrowthCtx = document.getElementById('userGrowthChart').getContext('2d');
new Chart(userGrowthCtx, {
    type: 'line',
    data: {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        datasets: [{
            label: 'Users',
            data: [1200, 1900, 3000, 5000, 6500, 8320],
            borderColor: '#3B82F6',
            backgroundColor: 'rgba(59, 130, 246, 0.1)',
            tension: 0.4,
            fill: true
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            y: { grid: { color: '#2A2A2A' }, ticks: { color: '#6B7280' } },
            x: { grid: { display: false }, ticks: { color: '#6B7280' } }
        }
    }
});

const revenueCtx = document.getElementById('revenueChart').getContext('2d');
new Chart(revenueCtx, {
    type: 'bar',
    data: {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        datasets: [{
            label: 'Revenue',
            data: [12000, 19000, 25000, 32000, 38000, 45200],
            backgroundColor: '#10B981'
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            y: { grid: { color: '#2A2A2A' }, ticks: { color: '#6B7280' } },
            x: { grid: { display: false }, ticks: { color: '#6B7280' } }
        }
    }
});
</script>

<?php include '../includes/footer.php'; ?>
