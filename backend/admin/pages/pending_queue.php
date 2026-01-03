<?php
$current_page = 'pending';
$page_title = 'Pending Queue';
$breadcrumb = [['label' => 'Moderation'], ['label' => 'Pending Queue']];

include '../includes/auth_check.php';
include '../includes/header.php';
include '../includes/sidebar.php';
?>

<div class="page-header">
    <h1 class="page-title">Pending Queue</h1>
    <p class="page-description">Review and moderate ads waiting for approval.</p>
</div>

<div class="card" style="background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(59, 130, 246, 0.1)); border: 1px solid rgba(239, 68, 68, 0.3); margin-bottom: 24px;">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
            <div style="display: flex; gap: 32px; margin-bottom: 8px;">
                <div>
                    <div style="font-size: 12px; color: #9CA3AF; text-transform: uppercase; margin-bottom: 4px;">Remaining</div>
                    <div style="font-size: 32px; font-weight: 700; color: #FFFFFF;">142</div>
                </div>
                <div>
                    <div style="font-size: 12px; color: #9CA3AF; text-transform: uppercase; margin-bottom: 4px;">Reviewed</div>
                    <div style="font-size: 32px; font-weight: 700; color: #10B981;">58</div>
                </div>
                <div>
                    <div style="font-size: 12px; color: #9CA3AF; text-transform: uppercase; margin-bottom: 4px;">Avg Time</div>
                    <div style="font-size: 32px; font-weight: 700; color: #3B82F6;">45s</div>
                </div>
            </div>
            <div style="display: inline-block; padding: 4px 12px; background-color: rgba(16, 185, 129, 0.1); color: #10B981; border-radius: 12px; font-size: 12px; font-weight: 500;">
                <span style="display: inline-block; width: 8px; height: 8px; background-color: #10B981; border-radius: 50%; margin-right: 6px;"></span>
                Active
            </div>
        </div>
        <div style="display: flex; gap: 12px;">
            <button class="btn btn-secondary">
                <i class="fas fa-filter"></i>
                All Items
            </button>
            <button class="btn btn-secondary">
                <i class="fas fa-tag"></i>
                Electronics
            </button>
            <button class="btn btn-secondary">
                <i class="fas fa-car"></i>
                Vehicles
            </button>
        </div>
    </div>
</div>

<div style="display: grid; grid-template-columns: 1fr 400px; gap: 24px;">
    <div>
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Queue Items</h3>
                <div style="display: flex; gap: 8px;">
                    <button class="btn btn-sm btn-secondary">
                        <i class="fas fa-sort"></i>
                        Sort
                    </button>
                </div>
            </div>

            <div id="queue-items">
                <div class="card" style="margin-bottom: 16px; cursor: pointer; transition: all 0.2s;" onclick="selectAd(1)">
                    <div style="display: flex; gap: 16px;">
                        <img src="https://via.placeholder.com/120x120" alt="Product" style="width: 120px; height: 120px; border-radius: 8px; object-fit: cover;">
                        <div style="flex: 1;">
                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 8px;">
                                <div>
                                    <h4 style="font-size: 16px; font-weight: 600; color: #FFFFFF; margin-bottom: 4px;">iPhone 13 Pro Max - 256GB - Sierra Blue</h4>
                                    <div style="font-size: 14px; color: #9CA3AF;">Electronics > Mobile Phones</div>
                                </div>
                                <div style="display: flex; gap: 8px; align-items: center;">
                                    <span class="badge" style="background-color: rgba(245, 158, 11, 0.1); color: #F59E0B;">
                                        <i class="fas fa-flag"></i> AI Flag
                                    </span>
                                    <div style="font-size: 20px; font-weight: 700; color: #EF4444;">$850.00</div>
                                </div>
                            </div>
                            <div style="display: flex; gap: 16px; margin-bottom: 12px;">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <div style="width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, #EF4444, #3B82F6); display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 14px;">J</div>
                                    <div>
                                        <div style="font-size: 14px; color: #FFFFFF; font-weight: 500;">John Doe</div>
                                        <div style="font-size: 12px; color: #6B7280;">
                                            <i class="fas fa-star" style="color: #F59E0B;"></i> 4.8/5 (12 reviews)
                                        </div>
                                    </div>
                                </div>
                                <div style="border-left: 1px solid #2A2A2A; padding-left: 16px;">
                                    <div style="font-size: 12px; color: #9CA3AF;">Joined</div>
                                    <div style="font-size: 14px; color: #FFFFFF;">2 Years ago</div>
                                </div>
                                <div style="border-left: 1px solid #2A2A2A; padding-left: 16px;">
                                    <div style="font-size: 12px; color: #9CA3AF;">Verified</div>
                                    <div style="font-size: 14px; color: #10B981;"><i class="fas fa-check-circle"></i> Yes</div>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 8px; color: #6B7280; font-size: 12px;">
                                <i class="fas fa-clock"></i>
                                <span>Submitted 10m ago</span>
                                <span style="margin: 0 8px;">•</span>
                                <i class="fas fa-images"></i>
                                <span>3 images</span>
                                <span style="margin: 0 8px;">•</span>
                                <i class="fas fa-map-marker-alt"></i>
                                <span>New York, NY</span>
                                <span style="margin: 0 8px;">•</span>
                                <span>ID: #AD-839201</span>
                            </div>
                        </div>
                    </div>
                    <div style="margin-top: 16px; padding-top: 16px; border-top: 1px solid #2A2A2A;">
                        <div style="background-color: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); border-radius: 8px; padding: 12px; display: flex; align-items: start; gap: 12px;">
                            <i class="fas fa-exclamation-triangle" style="color: #EF4444; font-size: 18px; margin-top: 2px;"></i>
                            <div>
                                <div style="font-weight: 600; color: #EF4444; margin-bottom: 4px;">Potential Policy Violation Detected</div>
                                <div style="font-size: 13px; color: #9CA3AF;">The description contains keywords ("bank transfer only", "shipping only") that may indicate a scam attempt. Please review carefully.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card" style="margin-bottom: 16px; cursor: pointer; transition: all 0.2s;" onclick="selectAd(2)">
                    <div style="display: flex; gap: 16px;">
                        <img src="https://via.placeholder.com/120x120" alt="Product" style="width: 120px; height: 120px; border-radius: 8px; object-fit: cover;">
                        <div style="flex: 1;">
                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 8px;">
                                <div>
                                    <h4 style="font-size: 16px; font-weight: 600; color: #FFFFFF; margin-bottom: 4px;">Sofa Set - 3 Piece</h4>
                                    <div style="font-size: 14px; color: #9CA3AF;">Furniture > Living Room</div>
                                </div>
                                <div style="font-size: 20px; font-weight: 700; color: #EF4444;">$450.00</div>
                            </div>
                            <div style="display: flex; gap: 16px; margin-bottom: 12px;">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <div style="width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, #10B981, #3B82F6); display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 14px;">S</div>
                                    <div>
                                        <div style="font-size: 14px; color: #FFFFFF; font-weight: 500;">Sarah M</div>
                                        <div style="font-size: 12px; color: #6B7280;">
                                            <i class="fas fa-star" style="color: #F59E0B;"></i> 4.5/5 (8 reviews)
                                        </div>
                                    </div>
                                </div>
                                <div style="border-left: 1px solid #2A2A2A; padding-left: 16px;">
                                    <div style="font-size: 12px; color: #9CA3AF;">Joined</div>
                                    <div style="font-size: 14px; color: #FFFFFF;">1 Year ago</div>
                                </div>
                                <div style="border-left: 1px solid #2A2A2A; padding-left: 16px;">
                                    <div style="font-size: 12px; color: #9CA3AF;">Verified</div>
                                    <div style="font-size: 14px; color: #10B981;"><i class="fas fa-check-circle"></i> Yes</div>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 8px; color: #6B7280; font-size: 12px;">
                                <i class="fas fa-clock"></i>
                                <span>Submitted 15m ago</span>
                                <span style="margin: 0 8px;">•</span>
                                <i class="fas fa-images"></i>
                                <span>5 images</span>
                                <span style="margin: 0 8px;">•</span>
                                <i class="fas fa-map-marker-alt"></i>
                                <span>Brooklyn, NY</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card" style="margin-bottom: 16px; cursor: pointer; transition: all 0.2s;" onclick="selectAd(3)">
                    <div style="display: flex; gap: 16px;">
                        <img src="https://via.placeholder.com/120x120" alt="Product" style="width: 120px; height: 120px; border-radius: 8px; object-fit: cover;">
                        <div style="flex: 1;">
                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 8px;">
                                <div>
                                    <h4 style="font-size: 16px; font-weight: 600; color: #FFFFFF; margin-bottom: 4px;">Toyota Camry 2020</h4>
                                    <div style="font-size: 14px; color: #9CA3AF;">Vehicles > Cars</div>
                                </div>
                                <div style="font-size: 20px; font-weight: 700; color: #EF4444;">$18,500</div>
                            </div>
                            <div style="display: flex; gap: 16px; margin-bottom: 12px;">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <div style="width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, #F59E0B, #EF4444); display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 14px;">M</div>
                                    <div>
                                        <div style="font-size: 14px; color: #FFFFFF; font-weight: 500;">Mike R</div>
                                        <div style="font-size: 12px; color: #6B7280;">
                                            <i class="fas fa-star" style="color: #F59E0B;"></i> 4.9/5 (24 reviews)
                                        </div>
                                    </div>
                                </div>
                                <div style="border-left: 1px solid #2A2A2A; padding-left: 16px;">
                                    <div style="font-size: 12px; color: #9CA3AF;">Joined</div>
                                    <div style="font-size: 14px; color: #FFFFFF;">3 Years ago</div>
                                </div>
                                <div style="border-left: 1px solid #2A2A2A; padding-left: 16px;">
                                    <div style="font-size: 12px; color: #9CA3AF;">Verified</div>
                                    <div style="font-size: 14px; color: #10B981;"><i class="fas fa-check-circle"></i> Yes</div>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 8px; color: #6B7280; font-size: 12px;">
                                <i class="fas fa-clock"></i>
                                <span>Submitted 22m ago</span>
                                <span style="margin: 0 8px;">•</span>
                                <i class="fas fa-images"></i>
                                <span>8 images</span>
                                <span style="margin: 0 8px;">•</span>
                                <i class="fas fa-map-marker-alt"></i>
                                <span>Los Angeles, CA</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div style="position: sticky; top: 90px;">
        <div class="card">
            <div style="text-align: center; padding: 40px 20px;">
                <i class="fas fa-image" style="font-size: 48px; color: #6B7280; margin-bottom: 16px;"></i>
                <div style="font-size: 16px; color: #9CA3AF;">Select an ad to preview</div>
            </div>
        </div>

        <div class="card" style="margin-top: 16px;">
            <h3 style="font-size: 16px; font-weight: 600; margin-bottom: 16px;">Quick Actions</h3>
            <div style="display: flex; flex-direction: column; gap: 8px;">
                <button class="btn btn-primary" style="width: 100%; justify-content: center;">
                    <i class="fas fa-check"></i>
                    Approve (A)
                </button>
                <button class="btn" style="width: 100%; justify-content: center; background-color: rgba(239, 68, 68, 0.1); color: #EF4444; border: 1px solid rgba(239, 68, 68, 0.3);">
                    <i class="fas fa-times"></i>
                    Reject (R)
                </button>
                <button class="btn btn-secondary" style="width: 100%; justify-content: center;">
                    <i class="fas fa-forward"></i>
                    Skip (Esc)
                </button>
                <button class="btn btn-secondary" style="width: 100%; justify-content: center;">
                    <i class="fas fa-edit"></i>
                    Edit Content
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function selectAd(adId) {
    console.log('Selected ad:', adId);
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'a' || e.key === 'A') {
        console.log('Approve shortcut');
    } else if (e.key === 'r' || e.key === 'R') {
        console.log('Reject shortcut');
    } else if (e.key === 'Escape') {
        console.log('Skip shortcut');
    }
});
</script>

<?php
include '../includes/footer.php';
?>
