let currentPage = 1;
let currentFilters = {
    search: '',
    status: '',
    role: ''
};

async function loadUsers(page = 1) {
    try {
        const result = await apiGet('users', {
            page: page,
            limit: 20,
            ...currentFilters
        });

        if (result && result.success) {
            renderUsersTable(result.data.users);
            updatePagination(result.data.pagination);
            updateUserStats(result.data.stats);
        }
    } catch (error) {
        console.error('Error loading users:', error);
    }
}

function updateUserStats(stats) {
    if (!stats) return;
    
    const totalCount = document.getElementById('total-users-count');
    const newTodayCount = document.getElementById('new-today-count');
    const verifiedCount = document.getElementById('verified-count');
    const bannedCount = document.getElementById('banned-count');
    
    if (totalCount) totalCount.textContent = formatNumber(stats.total || 0);
    if (newTodayCount) newTodayCount.textContent = '+' + formatNumber(stats.new_today || 0);
    if (verifiedCount) verifiedCount.textContent = formatNumber(stats.verified || 0);
    if (bannedCount) bannedCount.textContent = formatNumber(stats.banned || 0);
}

function renderUsersTable(users) {
    const tbody = document.querySelector('#users-table tbody');
    if (!tbody || !users) return;

    tbody.innerHTML = users.map(user => `
        <tr>
            <td><input type="checkbox" data-user-id="${user.id}"></td>
            <td>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #EF4444, #3B82F6); display: flex; align-items: center; justify-content: center; font-weight: 600;">
                        ${user.name.charAt(0).toUpperCase()}
                    </div>
                    <div>
                        <div style="color: #FFFFFF; font-weight: 500;">${user.name}</div>
                        <div style="color: #6B7280; font-size: 12px;">@${user.username || user.email.split('@')[0]}</div>
                    </div>
                </div>
            </td>
            <td>
                <div style="color: #9CA3AF;">${user.email}</div>
                <div style="color: #6B7280; font-size: 12px;">${user.phone || 'N/A'}</div>
            </td>
            <td><span class="badge badge-info">${user.role || 'User'}</span></td>
            <td><span class="badge badge-${user.is_active ? 'success' : 'danger'}">${user.is_active ? 'Active' : 'Inactive'}</span></td>
            <td style="color: #9CA3AF;">${formatDate(user.created_at)}</td>
            <td>
                <div style="display: flex; gap: 8px;">
                    <button class="btn btn-sm btn-secondary" onclick="viewUser(${user.id})">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn btn-sm btn-secondary" onclick="editUser(${user.id})">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm" style="background-color: rgba(239, 68, 68, 0.1); color: #EF4444;" onclick="banUser(${user.id})">
                        <i class="fas fa-ban"></i>
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
}

function updatePagination(pagination) {
    if (!pagination) return;
    
    const paginationInfo = document.querySelector('.pagination').previousElementSibling;
    if (paginationInfo) {
        paginationInfo.innerHTML = `
            Showing <strong>${pagination.from}</strong> to <strong>${pagination.to}</strong> of <strong>${formatNumber(pagination.total)}</strong> results
        `;
    }
}

const searchInput = document.getElementById('user-search');
if (searchInput) {
    searchInput.addEventListener('input', debounce(function(e) {
        currentFilters.search = e.target.value;
        loadUsers(1);
    }, 500));
}

const statusFilter = document.getElementById('status-filter');
if (statusFilter) {
    statusFilter.addEventListener('change', function(e) {
        currentFilters.status = e.target.value;
        loadUsers(1);
    });
}

const roleFilter = document.getElementById('role-filter');
if (roleFilter) {
    roleFilter.addEventListener('change', function(e) {
        currentFilters.role = e.target.value;
        loadUsers(1);
    });
}

async function viewUser(userId) {
    try {
        const result = await apiGet(`users/${userId}`);
        
        if (result && result.success) {
            showUserDetailsModal(result.data);
        }
    } catch (error) {
        console.error('Error loading user details:', error);
    }
}

function showUserDetailsModal(user) {
    const modal = document.getElementById('user-details-modal') || createUserDetailsModal();
    
    const modalContent = modal.querySelector('.modal-content');
    modalContent.innerHTML = `
        <div class="modal-header">
            <h2>User Details</h2>
            <button class="modal-close" onclick="closeUserModal()">&times;</button>
        </div>
        <div class="modal-body">
            <div style="display: flex; gap: 24px; margin-bottom: 24px;">
                <div style="width: 100px; height: 100px; border-radius: 50%; background: linear-gradient(135deg, #EF4444, #3B82F6); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 36px; color: #FFFFFF;">
                    ${user.name.charAt(0).toUpperCase()}
                </div>
                <div style="flex: 1;">
                    <h3 style="color: #FFFFFF; margin-bottom: 8px;">${user.name}</h3>
                    <div style="color: #6B7280; margin-bottom: 4px;"><i class="fas fa-envelope"></i> ${user.email}</div>
                    <div style="color: #6B7280; margin-bottom: 4px;"><i class="fas fa-phone"></i> ${user.phone || 'N/A'}</div>
                    <div style="margin-top: 12px;">
                        <span class="badge badge-${user.is_active ? 'success' : 'danger'}">${user.is_active ? 'Active' : 'Inactive'}</span>
                        ${user.is_verified ? '<span class="badge badge-info" style="margin-left: 8px;"><i class="fas fa-check-circle"></i> Verified</span>' : ''}
                    </div>
                </div>
            </div>
            
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px;">
                <div style="background: #1A1A1A; padding: 16px; border-radius: 8px;">
                    <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Total Ads</div>
                    <div style="color: #FFFFFF; font-size: 24px; font-weight: 600;">${user.total_ads || 0}</div>
                </div>
                <div style="background: #1A1A1A; padding: 16px; border-radius: 8px;">
                    <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Active Ads</div>
                    <div style="color: #10B981; font-size: 24px; font-weight: 600;">${user.active_ads || 0}</div>
                </div>
                <div style="background: #1A1A1A; padding: 16px; border-radius: 8px;">
                    <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Member Since</div>
                    <div style="color: #FFFFFF; font-size: 16px; font-weight: 500;">${formatDate(user.created_at)}</div>
                </div>
            </div>
            
            <div style="margin-bottom: 24px;">
                <h4 style="color: #FFFFFF; margin-bottom: 12px;">Account Information</h4>
                <div style="background: #1A1A1A; padding: 16px; border-radius: 8px;">
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px;">
                        <div>
                            <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">User ID</div>
                            <div style="color: #FFFFFF;">#${user.id}</div>
                        </div>
                        <div>
                            <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Last Login</div>
                            <div style="color: #FFFFFF;">${user.last_login ? formatDate(user.last_login) : 'Never'}</div>
                        </div>
                        <div>
                            <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Location</div>
                            <div style="color: #FFFFFF;">${user.location || 'Not specified'}</div>
                        </div>
                        <div>
                            <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Rating</div>
                            <div style="color: #F59E0B;"><i class="fas fa-star"></i> ${user.rating || '0.0'}/5</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            ${user.is_active ? `
                <button class="btn btn-warning" onclick="suspendUser(${user.id})">
                    <i class="fas fa-pause"></i> Suspend
                </button>
                <button class="btn btn-danger" onclick="banUser(${user.id})">
                    <i class="fas fa-ban"></i> Ban
                </button>
            ` : `
                <button class="btn btn-success" onclick="activateUser(${user.id})">
                    <i class="fas fa-check"></i> Activate
                </button>
            `}
            <button class="btn btn-secondary" onclick="closeUserModal()">Close</button>
        </div>
    `;
    
    modal.classList.add('active');
}

function createUserDetailsModal() {
    const modal = document.createElement('div');
    modal.id = 'user-details-modal';
    modal.className = 'modal';
    modal.innerHTML = '<div class="modal-content" style="max-width: 800px;"></div>';
    document.body.appendChild(modal);
    return modal;
}

function closeUserModal() {
    const modal = document.getElementById('user-details-modal');
    if (modal) modal.classList.remove('active');
}

async function editUser(userId) {
    showNotification('Edit user feature coming soon', 'info');
}

async function suspendUser(userId) {
    const confirmed = await Swal.fire({
        title: 'Suspend User?',
        text: 'This user will be temporarily unable to access their account.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, Suspend',
        cancelButtonText: 'Cancel',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (confirmed.isConfirmed) {
        const result = await apiPut(`users/${userId}/suspend`);
        
        if (result && result.success) {
            showNotification('User suspended successfully', 'success');
            closeUserModal();
            
            // Reload data without page refresh
            loadUsers(currentPage);
            
            // Update dashboard stats if on dashboard
            if (typeof loadDashboardData === 'function') {
                loadDashboardData();
            }
        }
    }
}

async function banUser(userId) {
    const confirmed = await Swal.fire({
        title: 'Ban User?',
        text: 'This user will be permanently banned from the platform.',
        icon: 'error',
        showCancelButton: true,
        confirmButtonText: 'Yes, Ban User',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#EF4444',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (confirmed.isConfirmed) {
        const result = await apiPut(`users/${userId}/ban`);
        
        if (result && result.success) {
            showNotification('User banned successfully', 'success');
            closeUserModal();
            
            // Reload data without page refresh
            loadUsers(currentPage);
            
            // Update dashboard stats if on dashboard
            if (typeof loadDashboardData === 'function') {
                loadDashboardData();
            }
        }
    }
}

async function activateUser(userId) {
    const result = await apiPut(`users/${userId}/activate`);
    
    if (result && result.success) {
        showNotification('User activated successfully', 'success');
        closeUserModal();
        
        // Reload data without page refresh
        loadUsers(currentPage);
        
        // Update dashboard stats if on dashboard
        if (typeof loadDashboardData === 'function') {
            loadDashboardData();
        }
    }
}

async function bulkActionUsers(action) {
    const checkboxes = document.querySelectorAll('#users-table input[type="checkbox"]:checked');
    const userIds = Array.from(checkboxes)
        .filter(cb => cb.dataset.userId)
        .map(cb => parseInt(cb.dataset.userId));

    if (userIds.length === 0) {
        showNotification('Please select users first', 'warning');
        return;
    }

    const actionText = action === 'activate' ? 'activate' : action === 'suspend' ? 'suspend' : 'ban';
    const confirmed = await Swal.fire({
        title: `Bulk ${actionText.charAt(0).toUpperCase() + actionText.slice(1)}`,
        text: `${actionText.charAt(0).toUpperCase() + actionText.slice(1)} ${userIds.length} selected user(s)?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: `Yes, ${actionText.charAt(0).toUpperCase() + actionText.slice(1)}`,
        cancelButtonText: 'Cancel',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (confirmed.isConfirmed) {
        const result = await apiPost('users/bulk-action', {
            action: action,
            user_ids: userIds
        });
        
        if (result && result.success) {
            showNotification(`${userIds.length} user(s) ${actionText}d successfully`, 'success');
            
            // Reload data without page refresh
            loadUsers(currentPage);
            
            // Update dashboard stats if on dashboard
            if (typeof loadDashboardData === 'function') {
                loadDashboardData();
            }
        }
    }
}

function showAddUserModal() {
    const modal = document.getElementById('add-user-modal') || createAddUserModal();
    modal.classList.add('active');
    
    // Reset form
    const form = document.getElementById('add-user-form');
    if (form) form.reset();
}

function createAddUserModal() {
    const modal = document.createElement('div');
    modal.id = 'add-user-modal';
    modal.className = 'modal';
    modal.innerHTML = `
        <div class="modal-content" style="max-width: 900px;">
            <div class="modal-header">
                <h2>Add New User</h2>
                <button class="modal-close" onclick="closeAddUserModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="add-user-form">
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px; margin-bottom: 24px;">
                        <div class="form-group">
                            <label class="form-label" for="new-name">
                                Full Name <span style="color: #EF4444;">*</span>
                            </label>
                            <input type="text" id="new-name" name="name" class="form-control" placeholder="Enter full name" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="new-email">
                                Email Address <span style="color: #EF4444;">*</span>
                            </label>
                            <input type="email" id="new-email" name="email" class="form-control" placeholder="user@example.com" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="new-phone">Phone Number</label>
                            <input type="tel" id="new-phone" name="phone" class="form-control" placeholder="+1234567890">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="new-password">
                                Password <span style="color: #EF4444;">*</span>
                            </label>
                            <input type="password" id="new-password" name="password" class="form-control" placeholder="Enter password" required minlength="6">
                            <div id="password-strength" style="margin-top: 8px; font-size: 12px;"></div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="new-role">
                                User Role <span style="color: #EF4444;">*</span>
                            </label>
                            <select id="new-role" name="role" class="form-control" required>
                                <option value="">Select role...</option>
                                <option value="user">User</option>
                                <option value="seller">Seller</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="new-status">
                                Account Status <span style="color: #EF4444;">*</span>
                            </label>
                            <select id="new-status" name="status" class="form-control" required>
                                <option value="active">Active</option>
                                <option value="pending">Pending</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 24px;">
                        <label class="form-label" for="new-location">Location</label>
                        <input type="text" id="new-location" name="location" class="form-control" placeholder="City, Country">
                    </div>
                    <div class="form-group" style="margin-bottom: 24px;">
                        <label class="form-label" for="new-bio">Bio / Description</label>
                        <textarea id="new-bio" name="bio" class="form-control" rows="4" placeholder="Enter user bio or description..."></textarea>
                    </div>
                    <div style="background: #1A1A1A; padding: 16px; border-radius: 8px; margin-bottom: 24px;">
                        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
                            <input type="checkbox" id="new-is-verified" name="is_verified" style="width: 18px; height: 18px; cursor: pointer;">
                            <label for="new-is-verified" style="color: #FFFFFF; cursor: pointer; margin: 0;">
                                <i class="fas fa-check-circle" style="color: #3B82F6;"></i> Verified Account
                            </label>
                        </div>
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <input type="checkbox" id="new-send-email" name="send_welcome_email" checked style="width: 18px; height: 18px; cursor: pointer;">
                            <label for="new-send-email" style="color: #FFFFFF; cursor: pointer; margin: 0;">
                                <i class="fas fa-envelope" style="color: #10B981;"></i> Send Welcome Email
                            </label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeAddUserModal()">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <button class="btn btn-primary" onclick="submitNewUser()" id="submit-new-user-btn">
                    <i class="fas fa-plus"></i> Create User
                </button>
            </div>
        </div>
    `;
    document.body.appendChild(modal);
    
    // Add password strength indicator
    const passwordInput = modal.querySelector('#new-password');
    passwordInput.addEventListener('input', function(e) {
        const password = e.target.value;
        const strengthDiv = document.getElementById('password-strength');
        
        if (password.length === 0) {
            strengthDiv.innerHTML = '';
            return;
        }
        
        let strength = 0;
        if (password.length >= 6) strength++;
        if (password.length >= 10) strength++;
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
        if (/\\d/.test(password)) strength++;
        if (/[^a-zA-Z0-9]/.test(password)) strength++;
        
        const colors = ['#EF4444', '#F59E0B', '#10B981'];
        const labels = ['Weak', 'Medium', 'Strong'];
        const index = Math.min(Math.floor(strength / 2), 2);
        
        strengthDiv.innerHTML = `<span style="color: ${colors[index]};">Password Strength: ${labels[index]}</span>`;
    });
    
    return modal;
}

function closeAddUserModal() {
    const modal = document.getElementById('add-user-modal');
    if (modal) modal.classList.remove('active');
}

async function submitNewUser() {
    const form = document.getElementById('add-user-form');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    const submitBtn = document.getElementById('submit-new-user-btn');
    const originalText = submitBtn.innerHTML;
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';
    
    const formData = {
        name: document.getElementById('new-name').value,
        email: document.getElementById('new-email').value,
        phone: document.getElementById('new-phone').value,
        password: document.getElementById('new-password').value,
        role: document.getElementById('new-role').value,
        status: document.getElementById('new-status').value,
        location: document.getElementById('new-location').value,
        bio: document.getElementById('new-bio').value,
        is_verified: document.getElementById('new-is-verified').checked,
        send_welcome_email: document.getElementById('new-send-email').checked
    };
    
    try {
        const result = await apiPost('users/create', formData);
        
        if (result && result.success) {
            showNotification('User created successfully!', 'success');
            closeAddUserModal();
            loadUsers(currentPage);
        } else {
            showNotification(result?.message || 'Failed to create user', 'error');
        }
    } catch (error) {
        console.error('Error creating user:', error);
        showNotification('An error occurred. Please try again.', 'error');
    } finally {
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
    }
}

const selectAllCheckbox = document.getElementById('select-all');
if (selectAllCheckbox) {
    selectAllCheckbox.addEventListener('change', function(e) {
        const checkboxes = document.querySelectorAll('#users-table tbody input[type="checkbox"]');
        checkboxes.forEach(cb => cb.checked = e.target.checked);
    });
}

if (document.getElementById('users-table')) {
    loadUsers(1);
    
    // Intercept "Add New User" button clicks
    const addUserBtn = document.getElementById('add-user-btn');
    if (addUserBtn) {
        addUserBtn.addEventListener('click', function(e) {
            e.preventDefault();
            showAddUserModal();
        });
    }
}
