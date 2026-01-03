let currentPage = 1;
let currentFilters = {
    search: '',
    status: '',
    role: ''
};

async function loadUsers(page = 1) {
    try {
        const result = await apiRequest('users', {
            page: page,
            limit: 20,
            ...currentFilters
        });

        if (result && result.success) {
            renderUsersTable(result.data.users);
            updatePagination(result.data.pagination);
        }
    } catch (error) {
        console.error('Error loading users:', error);
    }
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

if (document.getElementById('users-table')) {
    loadUsers(1);
}
