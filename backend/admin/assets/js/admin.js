const API_BASE_URL = '/admin_api.php';

let activeRequests = 0;

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

function showLoading(show = true) {
    activeRequests += show ? 1 : -1;
    if (activeRequests < 0) activeRequests = 0;
    
    const loader = document.getElementById('global-loader');
    if (loader) {
        loader.style.display = activeRequests > 0 ? 'flex' : 'none';
    }
}

function handleApiError(error, customMessage = null) {
    console.error('API Error:', error);
    
    // Don't show notification for auth errors as user will be redirected
    if (error.message && (error.message.includes('401') || error.message.includes('Unauthorized'))) {
        return;
    }
    
    const message = customMessage || error.message || 'An error occurred. Please try again.';
    showNotification(message, 'error');
}

async function apiRequest(action, data = {}, method = 'GET', showLoader = true) {
    if (showLoader) showLoading(true);
    
    try {
        const options = {
            method: method,
            headers: getAuthHeaders()
        };

        let url = `${API_BASE_URL}/${action}`;

        if (method === 'POST' || method === 'PUT') {
            options.body = JSON.stringify(data);
        } else if (method === 'GET' && Object.keys(data).length > 0) {
            const params = new URLSearchParams(data);
            url += `?${params.toString()}`;
        }

        const response = await fetch(url, options);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const result = await response.json();

        if (!result.success) {
            if (result.message === 'Unauthorized' || result.message === 'Invalid token') {
                localStorage.removeItem('admin_token');
                localStorage.removeItem('admin_user');
                window.location.href = '../login.php';
                return null;
            }
            throw new Error(result.message || 'Request failed');
        }

        return result;
    } catch (error) {
        handleApiError(error);
        return null;
    } finally {
        if (showLoader) showLoading(false);
    }
}

async function apiGet(action, params = {}) {
    return apiRequest(action, params, 'GET');
}

async function apiPost(action, data = {}) {
    return apiRequest(action, data, 'POST');
}

async function apiPut(action, data = {}) {
    return apiRequest(action, data, 'PUT');
}

async function apiDelete(action, data = {}) {
    return apiRequest(action, data, 'DELETE');
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
    const token = getAuthToken();
    if (!token) {
        console.warn('No auth token available, skipping pending counts load');
        return;
    }
    
    const result = await apiRequest('stats');
    if (result && result.success) {
        const pendingCount = document.getElementById('pending-count');
        const reportsCount = document.getElementById('reports-count');
        
        if (pendingCount) pendingCount.textContent = result.data.pending_ads || 0;
        if (reportsCount) reportsCount.textContent = result.data.pending_reports || 0;
    }
}

if (document.getElementById('pending-count') || document.getElementById('reports-count')) {
    // Wait a moment for token to be set from PHP session
    setTimeout(() => {
        loadPendingCounts();
        setInterval(loadPendingCounts, 60000);
    }, 100);
}
