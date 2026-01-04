<?php
$current_page = 'users';
$page_title = 'Add New User';
$breadcrumb = [
    ['label' => 'User Management', 'url' => 'users.php'],
    ['label' => 'Add New User']
];

include '../includes/auth_check.php';
include '../includes/header.php';
include '../includes/sidebar.php';
?>

<div class="page-header">
    <div style="display: flex; align-items: center; gap: 16px;">
        <button onclick="window.location.href='users.php'" class="btn btn-secondary" style="padding: 8px 12px;">
            <i class="fas fa-arrow-left"></i>
        </button>
        <div>
            <h1 class="page-title">Add New User</h1>
            <p class="page-description">Create a new user account for the marketplace.</p>
        </div>
    </div>
</div>

<div class="card" style="max-width: 800px;">
    <form id="addUserForm">
        <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px; margin-bottom: 24px;">
            <div class="form-group">
                <label class="form-label" for="name">
                    Full Name <span style="color: #EF4444;">*</span>
                </label>
                <input 
                    type="text" 
                    id="name" 
                    name="name" 
                    class="form-control" 
                    placeholder="Enter full name"
                    required
                >
            </div>

            <div class="form-group">
                <label class="form-label" for="email">
                    Email Address <span style="color: #EF4444;">*</span>
                </label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    class="form-control" 
                    placeholder="user@example.com"
                    required
                >
            </div>

            <div class="form-group">
                <label class="form-label" for="phone">
                    Phone Number
                </label>
                <input 
                    type="tel" 
                    id="phone" 
                    name="phone" 
                    class="form-control" 
                    placeholder="+1234567890"
                >
            </div>

            <div class="form-group">
                <label class="form-label" for="password">
                    Password <span style="color: #EF4444;">*</span>
                </label>
                <input 
                    type="password" 
                    id="password" 
                    name="password" 
                    class="form-control" 
                    placeholder="Enter password"
                    required
                    minlength="6"
                >
            </div>

            <div class="form-group">
                <label class="form-label" for="role">
                    User Role <span style="color: #EF4444;">*</span>
                </label>
                <select id="role" name="role" class="form-control" required>
                    <option value="">Select role...</option>
                    <option value="user">User</option>
                    <option value="seller">Seller</option>
                    <option value="admin">Admin</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label" for="status">
                    Account Status <span style="color: #EF4444;">*</span>
                </label>
                <select id="status" name="status" class="form-control" required>
                    <option value="active">Active</option>
                    <option value="pending">Pending</option>
                    <option value="inactive">Inactive</option>
                </select>
            </div>
        </div>

        <div class="form-group" style="margin-bottom: 24px;">
            <label class="form-label" for="location">
                Location
            </label>
            <input 
                type="text" 
                id="location" 
                name="location" 
                class="form-control" 
                placeholder="City, Country"
            >
        </div>

        <div class="form-group" style="margin-bottom: 24px;">
            <label class="form-label" for="bio">
                Bio / Description
            </label>
            <textarea 
                id="bio" 
                name="bio" 
                class="form-control" 
                rows="4"
                placeholder="Enter user bio or description..."
            ></textarea>
        </div>

        <div style="background: #1A1A1A; padding: 16px; border-radius: 8px; margin-bottom: 24px;">
            <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
                <input 
                    type="checkbox" 
                    id="is_verified" 
                    name="is_verified"
                    style="width: 18px; height: 18px; cursor: pointer;"
                >
                <label for="is_verified" style="color: #FFFFFF; cursor: pointer; margin: 0;">
                    <i class="fas fa-check-circle" style="color: #3B82F6;"></i> Verified Account
                </label>
            </div>
            <div style="display: flex; align-items: center; gap: 12px;">
                <input 
                    type="checkbox" 
                    id="send_welcome_email" 
                    name="send_welcome_email"
                    checked
                    style="width: 18px; height: 18px; cursor: pointer;"
                >
                <label for="send_welcome_email" style="color: #FFFFFF; cursor: pointer; margin: 0;">
                    <i class="fas fa-envelope" style="color: #10B981;"></i> Send Welcome Email
                </label>
            </div>
        </div>

        <div style="display: flex; gap: 12px; justify-content: flex-end;">
            <button type="button" onclick="window.location.href='users.php'" class="btn btn-secondary">
                <i class="fas fa-times"></i>
                Cancel
            </button>
            <button type="submit" class="btn btn-primary" id="submitBtn">
                <i class="fas fa-plus"></i>
                Create User
            </button>
        </div>
    </form>
</div>

<script>
const addUserForm = document.getElementById('addUserForm');
const submitBtn = document.getElementById('submitBtn');

addUserForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const formData = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('phone').value,
        password: document.getElementById('password').value,
        role: document.getElementById('role').value,
        status: document.getElementById('status').value,
        location: document.getElementById('location').value,
        bio: document.getElementById('bio').value,
        is_verified: document.getElementById('is_verified').checked,
        send_welcome_email: document.getElementById('send_welcome_email').checked
    };
    
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';
    
    try {
        const result = await apiPost('users/create', formData);
        
        if (result && result.success) {
            showNotification('User created successfully!', 'success');
            setTimeout(() => {
                window.location.href = 'users.php';
            }, 1500);
        } else {
            showNotification(result?.message || 'Failed to create user', 'error');
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-plus"></i> Create User';
        }
    } catch (error) {
        console.error('Error creating user:', error);
        showNotification('An error occurred. Please try again.', 'error');
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="fas fa-plus"></i> Create User';
    }
});

document.getElementById('password').addEventListener('input', function(e) {
    const password = e.target.value;
    const strength = document.getElementById('password-strength');
    
    if (!strength) {
        const strengthDiv = document.createElement('div');
        strengthDiv.id = 'password-strength';
        strengthDiv.style.cssText = 'margin-top: 8px; font-size: 12px;';
        e.target.parentElement.appendChild(strengthDiv);
    }
    
    const strengthIndicator = document.getElementById('password-strength');
    
    if (password.length === 0) {
        strengthIndicator.innerHTML = '';
        return;
    }
    
    let strength = 0;
    if (password.length >= 6) strength++;
    if (password.length >= 10) strength++;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
    if (/\d/.test(password)) strength++;
    if (/[^a-zA-Z0-9]/.test(password)) strength++;
    
    const colors = ['#EF4444', '#F59E0B', '#10B981'];
    const labels = ['Weak', 'Medium', 'Strong'];
    const index = Math.min(Math.floor(strength / 2), 2);
    
    strengthIndicator.innerHTML = `<span style="color: ${colors[index]};">Password Strength: ${labels[index]}</span>`;
});
</script>

<style>
.form-group {
    margin-bottom: 0;
}

.form-label {
    display: block;
    margin-bottom: 8px;
    font-size: 14px;
    font-weight: 500;
    color: #FFFFFF;
}

.form-control {
    width: 100%;
    padding: 12px 16px;
    background-color: #0F0F0F;
    border: 1px solid #2A2A2A;
    border-radius: 8px;
    color: #FFFFFF;
    font-size: 14px;
    transition: all 0.2s;
}

.form-control:focus {
    outline: none;
    border-color: #3B82F6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-control::placeholder {
    color: #6B7280;
}

textarea.form-control {
    resize: vertical;
    min-height: 100px;
}

select.form-control {
    cursor: pointer;
}

input[type="checkbox"] {
    accent-color: #3B82F6;
}
</style>

<?php
include '../includes/footer.php';
?>
