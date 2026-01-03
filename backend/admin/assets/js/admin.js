const API_BASE_URL = '../admin_api.php';

function getAuthToken() {
    return localStorage.getItem('admin_token');
}

function getAuthHeaders() {
    const token = getAuthToken();
    return {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
    };
}

async function apiRequest(action, data = {}, method = 'GET') {
    try {
        const options = {
            method: method,
            headers: getAuthHeaders()
        };

        let url = `${API_BASE_URL}?action=${action}`;

        if (method === 'POST' || method === 'PUT') {
            options.body = JSON.stringify({ action, ...data });
        } else if (method === 'GET' && Object.keys(data).length > 0) {
            const params = new URLSearchParams(data);
            url += `&${params.toString()}`;
        }

        const response = await fetch(url, options);
        const result = await response.json();

        if (!result.success && result.message === 'Unauthorized') {
            localStorage.removeItem('admin_token');
            localStorage.removeItem('admin_user');
            window.location.href = '../login.php';
            return null;
        }

        return result;
    } catch (error) {
        console.error('API Request Error:', error);
        showNotification('Connection error. Please try again.', 'error');
        return null;
    }
}

function showNotification(message, type = 'success') {
    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        background: '#1A1A1A',
        color: '#FFFFFF',
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer);
            toast.addEventListener('mouseleave', Swal.resumeTimer);
        }
    });

    Toast.fire({
        icon: type,
        title: message
    });
}

function formatDate(dateString) {
    const date = new Date(dateString);
    const now = new Date();
    const diff = now - date;
    const seconds = Math.floor(diff / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    if (seconds < 60) return `${seconds} seconds ago`;
    if (minutes < 60) return `${minutes} minutes ago`;
    if (hours < 24) return `${hours} hours ago`;
    if (days < 30) return `${days} days ago`;
    
    return date.toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'short', 
        day: 'numeric' 
    });
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(amount);
}

function formatNumber(number) {
    return new Intl.NumberFormat('en-US').format(number);
}

function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    const mobileMenuBtn = document.getElementById('mobile-menu-btn');

    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', function() {
            sidebar.classList.toggle('mobile-open');
        });
    }

    document.addEventListener('click', function(e) {
        if (window.innerWidth <= 768) {
            if (!sidebar.contains(e.target) && !mobileMenuBtn?.contains(e.target)) {
                sidebar.classList.remove('mobile-open');
            }
        }
    });

    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.classList.remove('active');
            }
        });
    });
});

async function loadPendingCounts() {
    const result = await apiRequest('stats');
    if (result && result.success) {
        const pendingCount = document.getElementById('pending-count');
        const reportsCount = document.getElementById('reports-count');
        
        if (pendingCount) pendingCount.textContent = result.data.pending_ads || 0;
        if (reportsCount) reportsCount.textContent = result.data.pending_reports || 0;
    }
}

if (document.getElementById('pending-count') || document.getElementById('reports-count')) {
    loadPendingCounts();
    setInterval(loadPendingCounts, 60000);
}
