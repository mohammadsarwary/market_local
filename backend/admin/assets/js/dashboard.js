let dashboardCharts = {};

async function loadDashboardData() {
    try {
        const result = await apiGet('stats', {}, false);
        
        if (result && result.success) {
            const data = result.data;
            
            updateStatCard('total-ads', data.total_ads);
            updateStatCard('active-users', data.active_users);
            updateStatCard('revenue', data.revenue_month, true);
            updateStatCard('pending-approvals', data.pending_ads);
            
            updateAlertCounts(data);
        }
    } catch (error) {
        console.error('Error loading dashboard data:', error);
    }
}

function updateStatCard(elementId, value, isCurrency = false) {
    const element = document.getElementById(elementId);
    if (element) {
        element.textContent = isCurrency ? formatCurrency(value) : formatNumber(value);
    }
}

function updateAlertCounts(data) {
    const pendingAlert = document.querySelector('.alert-warning .alert-message');
    if (pendingAlert && data.pending_ads) {
        pendingAlert.textContent = `${data.pending_ads} ads are waiting for moderation approval`;
    }
    
    const reportsAlert = document.querySelector('.alert-danger .alert-message');
    if (reportsAlert && data.pending_reports) {
        reportsAlert.textContent = `${data.pending_reports} new reports need to be reviewed`;
    }
}

async function loadRecentActivity() {
    try {
        const result = await apiGet('activity', {}, false);
        
        if (result && result.success) {
            const activityFeed = document.querySelector('.activity-feed');
            if (activityFeed && result.data && result.data.length > 0) {
                activityFeed.innerHTML = result.data.map(activity => {
                    const iconClass = getActivityIconClass(activity.type);
                    const icon = getActivityIcon(activity.type);
                    return `
                        <div class="activity-item">
                            <div class="activity-icon ${iconClass}">
                                <i class="fas fa-${icon}"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">${activity.text || activity.description}</div>
                                <div class="activity-time">${formatDate(activity.created_at)}</div>
                            </div>
                        </div>
                    `;
                }).join('');
            }
        }
    } catch (error) {
        console.error('Error loading activity:', error);
    }
}

function getActivityIconClass(type) {
    const classes = {
        'ad_approved': 'green',
        'user_registered': 'blue',
        'report_submitted': 'red',
        'ad_posted': 'blue',
        'user_banned': 'red'
    };
    return classes[type] || 'blue';
}

function getActivityIcon(type) {
    const icons = {
        'ad_approved': 'check',
        'user_registered': 'user-plus',
        'report_submitted': 'flag',
        'ad_posted': 'plus-circle',
        'user_banned': 'ban'
    };
    return icons[type] || 'circle';
}

async function initializeDashboardCharts() {
    const adTrendsCanvas = document.getElementById('adTrendsChart');
    const categoryCanvas = document.getElementById('categoryChart');
    
    if (adTrendsCanvas) {
        try {
            const result = await apiGet('analytics/ads', { period: '30days' }, false);
            if (result && result.success) {
                const ctx = adTrendsCanvas.getContext('2d');
                dashboardCharts.adTrends = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: result.data.labels || ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                        datasets: [{
                            label: 'Ad Postings',
                            data: result.data.values || [320, 380, 450, 520],
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
                        plugins: { legend: { display: false } },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: { color: '#2A2A2A' },
                                ticks: { color: '#6B7280' }
                            },
                            x: {
                                grid: { display: false },
                                ticks: { color: '#6B7280' }
                            }
                        }
                    }
                });
            }
        } catch (error) {
            console.error('Error initializing ad trends chart:', error);
        }
    }
    
    if (categoryCanvas) {
        try {
            const result = await apiGet('analytics/categories', {}, false);
            if (result && result.success) {
                const ctx = categoryCanvas.getContext('2d');
                dashboardCharts.category = new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: result.data.labels || ['Vehicles', 'Real Estate', 'Electronics', 'Other'],
                        datasets: [{
                            data: result.data.values || [35, 25, 25, 15],
                            backgroundColor: ['#3B82F6', '#60A5FA', '#93C5FD', '#6B7280'],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '70%',
                        plugins: { legend: { display: false } }
                    }
                });
            }
        } catch (error) {
            console.error('Error initializing category chart:', error);
        }
    }
}

function refreshDashboard() {
    loadDashboardData();
    loadRecentActivity();
}

async function exportDashboardReport() {
    try {
        showNotification('Generating report...', 'info');
        const result = await apiGet('reports/export', { type: 'dashboard' });
        
        if (result && result.success) {
            showNotification('Report exported successfully', 'success');
            if (result.data.download_url) {
                window.open(result.data.download_url, '_blank');
            }
        }
    } catch (error) {
        console.error('Error exporting report:', error);
    }
}

const exportBtn = document.querySelector('.btn-primary');
if (exportBtn && exportBtn.textContent.includes('Export')) {
    exportBtn.addEventListener('click', exportDashboardReport);
}

if (document.getElementById('total-ads')) {
    loadDashboardData();
    loadRecentActivity();
    initializeDashboardCharts();
    
    setInterval(refreshDashboard, 30000);
}
