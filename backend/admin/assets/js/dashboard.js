async function loadDashboardData() {
    try {
        const result = await apiRequest('stats');
        
        if (result && result.success) {
            const data = result.data;
            
            document.getElementById('total-ads').textContent = formatNumber(data.total_ads);
            document.getElementById('active-users').textContent = formatNumber(data.active_users);
            document.getElementById('revenue').textContent = formatCurrency(data.revenue_month);
            document.getElementById('pending-approvals').textContent = data.pending_ads;
        }
    } catch (error) {
        console.error('Error loading dashboard data:', error);
    }
}

async function loadRecentActivity() {
    try {
        const result = await apiRequest('activity');
        
        if (result && result.success) {
            const activityFeed = document.querySelector('.activity-feed');
            if (activityFeed && result.data.length > 0) {
                activityFeed.innerHTML = result.data.map(activity => `
                    <div class="activity-item">
                        <div class="activity-icon ${activity.type}">
                            <i class="fas fa-${activity.icon}"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-text">${activity.text}</div>
                            <div class="activity-time">${formatDate(activity.created_at)}</div>
                        </div>
                    </div>
                `).join('');
            }
        }
    } catch (error) {
        console.error('Error loading activity:', error);
    }
}

if (document.getElementById('total-ads')) {
    loadDashboardData();
    loadRecentActivity();
    
    setInterval(loadDashboardData, 30000);
    setInterval(loadRecentActivity, 60000);
}
