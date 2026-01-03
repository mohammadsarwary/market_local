<?php
$current_page = 'categories';
$page_title = 'Categories';
$breadcrumb = [['label' => 'Categories']];

include '../includes/auth_check.php';
include '../includes/header.php';
include '../includes/sidebar.php';
?>

<div class="page-header">
    <h1 class="page-title">Hierarchy</h1>
    <p class="page-description">Manage structure & taxonomy</p>
</div>

<div style="display: grid; grid-template-columns: 1fr 400px; gap: 24px;">
    <div class="card">
        <div class="card-header">
            <div style="display: flex; align-items: center; gap: 12px;">
                <div class="search-box" style="flex: 1;">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Filter categories...">
                </div>
            </div>
            <button class="btn btn-primary">
                <i class="fas fa-plus"></i>
                Add Root
            </button>
        </div>

        <div style="padding: 0;">
            <div class="nav-item" style="border-bottom: 1px solid #2A2A2A; border-radius: 0;">
                <i class="fas fa-home" style="color: #3B82F6;"></i>
                <span style="color: #FFFFFF; font-weight: 500;">Real Estate</span>
                <i class="fas fa-chevron-down" style="margin-left: auto; font-size: 12px; color: #6B7280;"></i>
            </div>
            <div style="padding-left: 40px;">
                <div class="nav-item" style="border-bottom: 1px solid #2A2A2A; border-radius: 0; background-color: rgba(239, 68, 68, 0.05);">
                    <i class="fas fa-circle" style="font-size: 8px; color: #EF4444;"></i>
                    <span style="color: #FFFFFF;">Residential</span>
                    <span class="badge badge-success" style="margin-left: auto;">Active</span>
                </div>
                <div class="nav-item" style="border-bottom: 1px solid #2A2A2A; border-radius: 0;">
                    <i class="fas fa-circle" style="font-size: 8px; color: #6B7280;"></i>
                    <span style="color: #9CA3AF;">Commercial</span>
                </div>
                <div class="nav-item" style="border-bottom: 1px solid #2A2A2A; border-radius: 0;">
                    <i class="fas fa-circle" style="font-size: 8px; color: #6B7280;"></i>
                    <span style="color: #9CA3AF;">Short-term</span>
                    <i class="fas fa-eye-slash" style="margin-left: auto; color: #6B7280;"></i>
                </div>
            </div>

            <div class="nav-item" style="border-bottom: 1px solid #2A2A2A; border-radius: 0;">
                <i class="fas fa-car" style="color: #F59E0B;"></i>
                <span style="color: #FFFFFF; font-weight: 500;">Vehicles</span>
                <i class="fas fa-chevron-right" style="margin-left: auto; font-size: 12px; color: #6B7280;"></i>
            </div>

            <div class="nav-item" style="border-bottom: 1px solid #2A2A2A; border-radius: 0;">
                <i class="fas fa-mobile-alt" style="color: #8B5CF6;"></i>
                <span style="color: #FFFFFF; font-weight: 500;">Electronics</span>
                <i class="fas fa-chevron-right" style="margin-left: auto; font-size: 12px; color: #6B7280;"></i>
            </div>

            <div class="nav-item" style="border-radius: 0;">
                <i class="fas fa-couch" style="color: #10B981;"></i>
                <span style="color: #FFFFFF; font-weight: 500;">Home & Kitchen</span>
                <i class="fas fa-chevron-right" style="margin-left: auto; font-size: 12px; color: #6B7280;"></i>
            </div>
        </div>
    </div>

    <div>
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                <div>
                    <div style="font-size: 12px; color: #9CA3AF; margin-bottom: 4px;">Categories > Real Estate > <span style="color: #EF4444;">Residential</span></div>
                    <h2 style="font-size: 24px; font-weight: 700; color: #FFFFFF;">Edit Category</h2>
                    <p style="font-size: 14px; color: #9CA3AF;">Update details for "Residential"</p>
                </div>
                <button class="btn" style="background-color: rgba(239, 68, 68, 0.1); color: #EF4444; border: 1px solid rgba(239, 68, 68, 0.3);">
                    <i class="fas fa-trash"></i>
                    Delete
                </button>
            </div>

            <div class="form-group">
                <label class="form-label">Category Name</label>
                <input type="text" class="form-control" value="Residential">
            </div>

            <div class="form-group">
                <label class="form-label">Slug (URL)</label>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <span style="color: #6B7280; font-size: 14px;">/categories/</span>
                    <input type="text" class="form-control" value="residential" style="flex: 1;">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Parent Category</label>
                <select class="form-control">
                    <option>Real Estate</option>
                    <option>Vehicles</option>
                    <option>Electronics</option>
                </select>
                <div style="font-size: 12px; color: #6B7280; margin-top: 4px;">Changing parent will move this entire branch</div>
            </div>

            <div class="form-group">
                <label class="form-label">Icon</label>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div style="width: 48px; height: 48px; background-color: rgba(59, 130, 246, 0.1); border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-home" style="font-size: 24px; color: #3B82F6;"></i>
                    </div>
                    <button class="btn btn-secondary">
                        <i class="fas fa-image"></i>
                        Change Icon
                    </button>
                </div>
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                <label class="form-label" style="margin: 0;">Active Status</label>
                <label style="position: relative; display: inline-block; width: 48px; height: 24px;">
                    <input type="checkbox" checked style="opacity: 0; width: 0; height: 0;">
                    <span style="position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #EF4444; transition: .4s; border-radius: 24px;">
                        <span style="position: absolute; content: ''; height: 18px; width: 18px; left: 3px; bottom: 3px; background-color: white; transition: .4s; border-radius: 50%;"></span>
                    </span>
                </label>
            </div>
            <div style="font-size: 12px; color: #6B7280; margin-bottom: 20px;">Visible to users</div>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                <label class="form-label" style="margin: 0;">Featured</label>
                <label style="position: relative; display: inline-block; width: 48px; height: 24px;">
                    <input type="checkbox" style="opacity: 0; width: 0; height: 0;">
                    <span style="position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #2A2A2A; transition: .4s; border-radius: 24px;">
                        <span style="position: absolute; content: ''; height: 18px; width: 18px; left: 3px; bottom: 3px; background-color: white; transition: .4s; border-radius: 50%;"></span>
                    </span>
                </label>
            </div>
            <div style="font-size: 12px; color: #6B7280; margin-bottom: 20px;">Show on homepage</div>

            <div class="form-group">
                <label class="form-label">Description (Optional)</label>
                <textarea class="form-control" rows="3" placeholder="Add a short description for SEO purposes..."></textarea>
            </div>

            <div style="border-top: 1px solid #2A2A2A; padding-top: 20px; margin-top: 24px;">
                <h3 style="font-size: 14px; font-weight: 600; color: #FFFFFF; margin-bottom: 12px;">Dynamic Attributes</h3>
                <div style="font-size: 13px; color: #6B7280; margin-bottom: 12px;">Fields specific to this category</div>
                <button class="btn btn-secondary" style="width: 100%;">
                    <i class="fas fa-plus"></i>
                    Add Attribute
                </button>
            </div>

            <div style="display: flex; gap: 12px; margin-top: 24px;">
                <button class="btn btn-secondary" style="flex: 1;">Discard</button>
                <button class="btn btn-primary" style="flex: 1;">Save Changes</button>
            </div>
        </div>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
