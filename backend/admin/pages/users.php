<?php
$current_page = 'users';
$page_title = 'User Management';
$breadcrumb = [['label' => 'User Management']];

include '../includes/auth_check.php';
include '../includes/header.php';
include '../includes/sidebar.php';
?>

<div class="page-header">
    <h1 class="page-title">User Management</h1>
    <p class="page-description">View, search, and manage verified user accounts and marketplace sellers.</p>
</div>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
    <div class="stats-grid" style="grid-template-columns: repeat(4, 1fr); margin: 0;">
        <div class="stat-card" style="padding: 16px;">
            <div class="stat-label">Total Users</div>
            <div class="stat-value" style="font-size: 24px;" id="total-users-count">24,593</div>
            <div class="stat-change positive"><i class="fas fa-arrow-up"></i> +12%</div>
        </div>
        <div class="stat-card" style="padding: 16px;">
            <div class="stat-label">New Today</div>
            <div class="stat-value" style="font-size: 24px;" id="new-today-count">+145</div>
            <div class="stat-change positive"><i class="fas fa-arrow-up"></i> +5%</div>
        </div>
        <div class="stat-card" style="padding: 16px;">
            <div class="stat-label">Verified Sellers</div>
            <div class="stat-value" style="font-size: 24px;" id="verified-count">8,420</div>
            <div class="stat-change positive"><i class="fas fa-arrow-up"></i> +2.4%</div>
        </div>
        <div class="stat-card" style="padding: 16px;">
            <div class="stat-label">Banned</div>
            <div class="stat-value" style="font-size: 24px;" id="banned-count">542</div>
            <div class="stat-change negative"><i class="fas fa-arrow-down"></i> -0.1%</div>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <div class="filters-bar" style="margin: 0;">
            <div class="search-box" style="flex: 1; max-width: 400px;">
                <i class="fas fa-search"></i>
                <input type="text" id="user-search" placeholder="Search by name, email, or phone...">
            </div>
            <select class="form-control" id="status-filter" style="width: 150px;">
                <option value="">Status: All</option>
                <option value="active">Active</option>
                <option value="pending">Pending</option>
                <option value="banned">Banned</option>
            </select>
            <select class="form-control" id="role-filter" style="width: 150px;">
                <option value="">Role: All</option>
                <option value="seller">Seller</option>
                <option value="buyer">Buyer</option>
                <option value="admin">Admin</option>
            </select>
            <button class="btn btn-secondary">
                <i class="fas fa-filter"></i>
            </button>
        </div>
        <div style="display: flex; gap: 12px;">
            <button class="btn btn-secondary">
                <i class="fas fa-download"></i>
                Export
            </button>
            <button class="btn btn-primary" onclick="window.location.href='user_add.php'">
                <i class="fas fa-plus"></i>
                Add New User
            </button>
        </div>
    </div>

    <div class="table-container">
        <table id="users-table">
            <thead>
                <tr>
                    <th><input type="checkbox" id="select-all"></th>
                    <th>USER</th>
                    <th>CONTACT INFO</th>
                    <th>ROLE</th>
                    <th>STATUS</th>
                    <th>JOINED</th>
                    <th>ACTIONS</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><input type="checkbox"></td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #EF4444, #3B82F6); display: flex; align-items: center; justify-content: center; font-weight: 600;">S</div>
                            <div>
                                <div style="color: #FFFFFF; font-weight: 500;">Sarah Miller</div>
                                <div style="color: #6B7280; font-size: 12px;">@sarah_m</div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div style="color: #9CA3AF;">sarah@example.com</div>
                        <div style="color: #6B7280; font-size: 12px;">+1(555) 123-4567</div>
                    </td>
                    <td><span class="badge badge-info">Seller</span></td>
                    <td><span class="badge badge-success">Active</span></td>
                    <td style="color: #9CA3AF;">Oct 24, 2023</td>
                    <td>
                        <div style="display: flex; gap: 8px;">
                            <button class="btn btn-sm btn-secondary" onclick="viewUser(1)">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-sm btn-secondary" onclick="editUser(1)">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm" style="background-color: rgba(239, 68, 68, 0.1); color: #EF4444;" onclick="banUser(1)">
                                <i class="fas fa-ban"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td><input type="checkbox"></td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #10B981, #3B82F6); display: flex; align-items: center; justify-content: center; font-weight: 600;">M</div>
                            <div>
                                <div style="color: #FFFFFF; font-weight: 500;">Michael Chen</div>
                                <div style="color: #6B7280; font-size: 12px;">@mike_c</div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div style="color: #9CA3AF;">mike.chen@test.com</div>
                        <div style="color: #6B7280; font-size: 12px;">+1(555) 987-6543</div>
                    </td>
                    <td><span class="badge badge-info">Buyer</span></td>
                    <td><span class="badge badge-warning">Pending</span></td>
                    <td style="color: #9CA3AF;">Oct 23, 2023</td>
                    <td>
                        <div style="display: flex; gap: 8px;">
                            <button class="btn btn-sm btn-secondary" onclick="viewUser(2)">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-sm btn-secondary" onclick="editUser(2)">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm" style="background-color: rgba(239, 68, 68, 0.1); color: #EF4444;" onclick="banUser(2)">
                                <i class="fas fa-ban"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td><input type="checkbox"></td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #F59E0B, #EF4444); display: flex; align-items: center; justify-content: center; font-weight: 600;">E</div>
                            <div>
                                <div style="color: #FFFFFF; font-weight: 500;">Emma Davis</div>
                                <div style="color: #6B7280; font-size: 12px;">@emma_d</div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div style="color: #9CA3AF;">emma.d@company.net</div>
                        <div style="color: #6B7280; font-size: 12px;">+1(555) 234-5678</div>
                    </td>
                    <td><span class="badge" style="background-color: rgba(139, 92, 246, 0.1); color: #8B5CF6;">Admin</span></td>
                    <td><span class="badge badge-success">Active</span></td>
                    <td style="color: #9CA3AF;">Oct 20, 2023</td>
                    <td>
                        <div style="display: flex; gap: 8px;">
                            <button class="btn btn-sm btn-secondary" onclick="viewUser(3)">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-sm btn-secondary" onclick="editUser(3)">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm" style="background-color: rgba(239, 68, 68, 0.1); color: #EF4444;" onclick="banUser(3)">
                                <i class="fas fa-ban"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td><input type="checkbox"></td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #3B82F6, #8B5CF6); display: flex; align-items: center; justify-content: center; font-weight: 600;">A</div>
                            <div>
                                <div style="color: #FFFFFF; font-weight: 500;">Alex Johnson</div>
                                <div style="color: #6B7280; font-size: 12px;">@alex_j</div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div style="color: #9CA3AF;">alex.j@provider.com</div>
                        <div style="color: #6B7280; font-size: 12px;">+1(555) 345-6789</div>
                    </td>
                    <td><span class="badge badge-info">Seller</span></td>
                    <td><span class="badge badge-danger">Banned</span></td>
                    <td style="color: #9CA3AF;">Sep 15, 2023</td>
                    <td>
                        <div style="display: flex; gap: 8px;">
                            <button class="btn btn-sm btn-secondary" onclick="viewUser(4)">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-sm btn-secondary" onclick="editUser(4)">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm" style="background-color: rgba(16, 185, 129, 0.1); color: #10B981;" onclick="activateUser(4)">
                                <i class="fas fa-check"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td><input type="checkbox"></td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #EC4899, #8B5CF6); display: flex; align-items: center; justify-content: center; font-weight: 600;">O</div>
                            <div>
                                <div style="color: #FFFFFF; font-weight: 500;">Olivia Smith</div>
                                <div style="color: #6B7280; font-size: 12px;">@liv_smith</div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div style="color: #9CA3AF;">olivia.s@designmail.com</div>
                        <div style="color: #6B7280; font-size: 12px;">+1(555) 456-7890</div>
                    </td>
                    <td><span class="badge badge-info">Buyer</span></td>
                    <td><span class="badge badge-success">Active</span></td>
                    <td style="color: #9CA3AF;">Sep 12, 2023</td>
                    <td>
                        <div style="display: flex; gap: 8px;">
                            <button class="btn btn-sm btn-secondary" onclick="viewUser(5)">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-sm btn-secondary" onclick="editUser(5)">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm" style="background-color: rgba(239, 68, 68, 0.1); color: #EF4444;" onclick="banUser(5)">
                                <i class="fas fa-ban"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 24px; padding-top: 24px; border-top: 1px solid #2A2A2A;">
        <div style="color: #9CA3AF; font-size: 14px;">
            Showing <strong>1</strong> to <strong>5</strong> of <strong>24,593</strong> results
        </div>
        <div class="pagination">
            <button class="page-btn">Previous</button>
            <button class="page-btn active">1</button>
            <button class="page-btn">2</button>
            <button class="page-btn">3</button>
            <button class="page-btn">...</button>
            <button class="page-btn">48</button>
            <button class="page-btn">Next</button>
        </div>
    </div>
</div>

<div class="modal" id="userModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 class="modal-title">User Details</h2>
            <button class="close-modal" onclick="closeModal()"><i class="fas fa-times"></i></button>
        </div>
        <div id="modal-body">
        </div>
    </div>
</div>

<script>
const API_BASE_URL = '../../admin_api.php';

function viewUser(userId) {
    document.getElementById('userModal').classList.add('active');
}

function editUser(userId) {
    window.location.href = `user_edit.php?id=${userId}`;
}

async function banUser(userId) {
    const result = await Swal.fire({
        title: 'Ban User?',
        text: 'This will permanently ban the user from the platform.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#EF4444',
        cancelButtonColor: '#6B7280',
        confirmButtonText: 'Yes, ban user',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (result.isConfirmed) {
        Swal.fire({
            title: 'Banned!',
            text: 'User has been banned successfully.',
            icon: 'success',
            background: '#1A1A1A',
            color: '#FFFFFF',
            confirmButtonColor: '#EF4444'
        });
    }
}

async function activateUser(userId) {
    const result = await Swal.fire({
        title: 'Activate User?',
        text: 'This will reactivate the user account.',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#10B981',
        cancelButtonColor: '#6B7280',
        confirmButtonText: 'Yes, activate',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (result.isConfirmed) {
        Swal.fire({
            title: 'Activated!',
            text: 'User has been activated successfully.',
            icon: 'success',
            background: '#1A1A1A',
            color: '#FFFFFF',
            confirmButtonColor: '#10B981'
        });
    }
}

function closeModal() {
    document.getElementById('userModal').classList.remove('active');
}

document.getElementById('select-all').addEventListener('change', function() {
    const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
    checkboxes.forEach(cb => cb.checked = this.checked);
});
</script>

<?php
include '../includes/footer.php';
?>
