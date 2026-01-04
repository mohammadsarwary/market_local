let currentAdPage = 1;
let currentAdFilters = {
    search: '',
    status: '',
    category: ''
};
let selectedAd = null;

async function loadAds(page = 1) {
    try {
        const result = await apiGet('ads', {
            page: page,
            limit: 20,
            ...currentAdFilters
        });

        if (result && result.success) {
            renderAdsTable(result.data.ads);
            updateAdPagination(result.data.pagination);
        }
    } catch (error) {
        console.error('Error loading ads:', error);
    }
}

async function loadPendingAds() {
    try {
        const result = await apiGet('ads/pending');

        if (result && result.success) {
            renderPendingQueue(result.data);
        }
    } catch (error) {
        console.error('Error loading pending ads:', error);
    }
}

function renderAdsTable(ads) {
    const tbody = document.querySelector('#ads-table tbody');
    if (!tbody || !ads) return;

    tbody.innerHTML = ads.map(ad => `
        <tr>
            <td><input type="checkbox" data-ad-id="${ad.id}"></td>
            <td>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <img src="${ad.images?.[0] || 'https://via.placeholder.com/60'}" 
                         style="width: 60px; height: 60px; border-radius: 8px; object-fit: cover;">
                    <div>
                        <div style="color: #FFFFFF; font-weight: 500;">${ad.title}</div>
                        <div style="color: #6B7280; font-size: 12px;">${ad.category_name || 'Uncategorized'}</div>
                    </div>
                </div>
            </td>
            <td>
                <div style="color: #FFFFFF; font-weight: 500;">${ad.user_name}</div>
                <div style="color: #6B7280; font-size: 12px;">${ad.user_email}</div>
            </td>
            <td style="color: #EF4444; font-weight: 600; font-size: 16px;">$${parseFloat(ad.price).toLocaleString()}</td>
            <td><span class="badge badge-${getStatusBadgeClass(ad.status)}">${ad.status}</span></td>
            <td style="color: #9CA3AF;">${formatDate(ad.created_at)}</td>
            <td>
                <div style="display: flex; gap: 8px;">
                    <button class="btn btn-sm btn-secondary" onclick="viewAdDetails(${ad.id})" title="View Details">
                        <i class="fas fa-eye"></i>
                    </button>
                    ${ad.status === 'pending' ? `
                        <button class="btn btn-sm btn-success" onclick="approveAd(${ad.id})" title="Approve">
                            <i class="fas fa-check"></i>
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="rejectAd(${ad.id})" title="Reject">
                            <i class="fas fa-times"></i>
                        </button>
                    ` : ''}
                    <button class="btn btn-sm btn-danger" onclick="deleteAd(${ad.id})" title="Delete">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
}

function renderPendingQueue(ads) {
    const container = document.getElementById('queue-items');
    if (!container || !ads || ads.length === 0) return;

    container.innerHTML = ads.map(ad => `
        <div class="card" style="margin-bottom: 16px; cursor: pointer; transition: all 0.2s;" onclick="selectAdForReview(${ad.id})">
            <div style="display: flex; gap: 16px;">
                <img src="${ad.images?.[0] || 'https://via.placeholder.com/120'}" 
                     alt="Product" 
                     style="width: 120px; height: 120px; border-radius: 8px; object-fit: cover;">
                <div style="flex: 1;">
                    <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 8px;">
                        <div>
                            <h4 style="font-size: 16px; font-weight: 600; color: #FFFFFF; margin-bottom: 4px;">${ad.title}</h4>
                            <div style="font-size: 14px; color: #9CA3AF;">${ad.category_name || 'Uncategorized'}</div>
                        </div>
                        <div style="display: flex; gap: 8px; align-items: center;">
                            ${ad.flagged ? '<span class="badge" style="background-color: rgba(245, 158, 11, 0.1); color: #F59E0B;"><i class="fas fa-flag"></i> AI Flag</span>' : ''}
                            <div style="font-size: 20px; font-weight: 700; color: #EF4444;">$${parseFloat(ad.price).toLocaleString()}</div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 16px; margin-bottom: 12px;">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <div style="width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, #EF4444, #3B82F6); display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 14px;">
                                ${ad.user_name?.charAt(0).toUpperCase() || 'U'}
                            </div>
                            <div>
                                <div style="font-size: 14px; color: #FFFFFF; font-weight: 500;">${ad.user_name}</div>
                                <div style="font-size: 12px; color: #6B7280;">
                                    <i class="fas fa-star" style="color: #F59E0B;"></i> ${ad.user_rating || '0.0'}/5
                                </div>
                            </div>
                        </div>
                        <div style="border-left: 1px solid #2A2A2A; padding-left: 16px;">
                            <div style="font-size: 12px; color: #9CA3AF;">Posted</div>
                            <div style="font-size: 14px; color: #FFFFFF;">${formatDate(ad.created_at)}</div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 8px;">
                        <button class="btn btn-sm btn-success" onclick="event.stopPropagation(); approveAd(${ad.id})">
                            <i class="fas fa-check"></i> Approve
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="event.stopPropagation(); showRejectModal(${ad.id})">
                            <i class="fas fa-times"></i> Reject
                        </button>
                        <button class="btn btn-sm btn-secondary" onclick="event.stopPropagation(); viewAdDetails(${ad.id})">
                            <i class="fas fa-eye"></i> Details
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `).join('');
}

function getStatusBadgeClass(status) {
    const classes = {
        'active': 'success',
        'pending': 'warning',
        'rejected': 'danger',
        'sold': 'info',
        'expired': 'secondary'
    };
    return classes[status] || 'secondary';
}

async function viewAdDetails(adId) {
    try {
        const result = await apiGet(`ads/${adId}`);
        
        if (result && result.success) {
            selectedAd = result.data;
            showAdDetailsModal(result.data);
        }
    } catch (error) {
        console.error('Error loading ad details:', error);
    }
}

function showAdDetailsModal(ad) {
    const modal = document.getElementById('ad-details-modal') || createAdDetailsModal();
    
    const modalContent = modal.querySelector('.modal-content');
    modalContent.innerHTML = `
        <div class="modal-header">
            <h2>Ad Details</h2>
            <button class="modal-close" onclick="closeModal('ad-details-modal')">&times;</button>
        </div>
        <div class="modal-body">
            <div class="image-gallery" style="margin-bottom: 24px;">
                ${ad.images?.map((img, idx) => `
                    <img src="${img}" alt="Image ${idx + 1}" 
                         style="width: 100%; max-height: 400px; object-fit: contain; border-radius: 8px; margin-bottom: 8px;"
                         onclick="openImageGallery(${ad.id}, ${idx})">
                `).join('') || '<p>No images available</p>'}
            </div>
            <h3 style="color: #FFFFFF; margin-bottom: 16px;">${ad.title}</h3>
            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; margin-bottom: 24px;">
                <div>
                    <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Price</div>
                    <div style="color: #EF4444; font-size: 24px; font-weight: 700;">$${parseFloat(ad.price).toLocaleString()}</div>
                </div>
                <div>
                    <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Category</div>
                    <div style="color: #FFFFFF; font-size: 16px;">${ad.category_name || 'Uncategorized'}</div>
                </div>
                <div>
                    <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Condition</div>
                    <div style="color: #FFFFFF; font-size: 16px;">${ad.condition || 'N/A'}</div>
                </div>
                <div>
                    <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Location</div>
                    <div style="color: #FFFFFF; font-size: 16px;">${ad.location || 'N/A'}</div>
                </div>
            </div>
            <div style="margin-bottom: 24px;">
                <div style="color: #6B7280; font-size: 12px; margin-bottom: 8px;">Description</div>
                <div style="color: #9CA3AF; line-height: 1.6;">${ad.description || 'No description provided'}</div>
            </div>
            <div style="margin-bottom: 24px;">
                <div style="color: #6B7280; font-size: 12px; margin-bottom: 8px;">Seller Information</div>
                <div style="background: #1A1A1A; padding: 16px; border-radius: 8px;">
                    <div style="color: #FFFFFF; font-weight: 500; margin-bottom: 4px;">${ad.user_name}</div>
                    <div style="color: #6B7280; font-size: 14px;">${ad.user_email}</div>
                    <div style="color: #6B7280; font-size: 14px;">${ad.user_phone || 'No phone'}</div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            ${ad.status === 'pending' ? `
                <button class="btn btn-success" onclick="approveAd(${ad.id})">
                    <i class="fas fa-check"></i> Approve
                </button>
                <button class="btn btn-danger" onclick="showRejectModal(${ad.id})">
                    <i class="fas fa-times"></i> Reject
                </button>
            ` : ''}
            <button class="btn btn-secondary" onclick="closeModal('ad-details-modal')">Close</button>
        </div>
    `;
    
    modal.classList.add('active');
}

function createAdDetailsModal() {
    const modal = document.createElement('div');
    modal.id = 'ad-details-modal';
    modal.className = 'modal';
    modal.innerHTML = '<div class="modal-content" style="max-width: 800px;"></div>';
    document.body.appendChild(modal);
    return modal;
}

async function approveAd(adId) {
    const confirmed = await Swal.fire({
        title: 'Approve Ad?',
        text: 'This ad will be published and visible to users.',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, Approve',
        cancelButtonText: 'Cancel',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (confirmed.isConfirmed) {
        const result = await apiPut(`ads/${adId}/approve`);
        
        if (result && result.success) {
            showNotification('Ad approved successfully', 'success');
            closeModal('ad-details-modal');
            
            // Reload data without page refresh
            if (document.getElementById('ads-table')) {
                loadAds(currentAdPage);
            }
            if (document.getElementById('queue-items')) {
                loadPendingAds();
            }
            
            // Update dashboard stats if on dashboard
            if (typeof loadDashboardData === 'function') {
                loadDashboardData();
            }
        }
    }
}

function showRejectModal(adId) {
    Swal.fire({
        title: 'Reject Ad',
        input: 'textarea',
        inputLabel: 'Rejection Reason',
        inputPlaceholder: 'Enter reason for rejection...',
        inputAttributes: {
            'aria-label': 'Enter reason for rejection'
        },
        showCancelButton: true,
        confirmButtonText: 'Reject Ad',
        cancelButtonText: 'Cancel',
        background: '#1A1A1A',
        color: '#FFFFFF',
        inputValidator: (value) => {
            if (!value) {
                return 'Please provide a reason for rejection';
            }
        }
    }).then((result) => {
        if (result.isConfirmed) {
            rejectAd(adId, result.value);
        }
    });
}

async function rejectAd(adId, reason) {
    const result = await apiPut(`ads/${adId}/reject`, { reason });
    
    if (result && result.success) {
        showNotification('Ad rejected successfully', 'success');
        closeModal('ad-details-modal');
        
        // Reload data without page refresh
        if (document.getElementById('ads-table')) {
            loadAds(currentAdPage);
        }
        if (document.getElementById('queue-items')) {
            loadPendingAds();
        }
        
        // Update dashboard stats if on dashboard
        if (typeof loadDashboardData === 'function') {
            loadDashboardData();
        }
    }
}

async function deleteAd(adId) {
    const confirmed = await Swal.fire({
        title: 'Delete Ad?',
        text: 'This action cannot be undone. The ad will be permanently deleted.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, Delete',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#EF4444',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (confirmed.isConfirmed) {
        const result = await apiDelete(`ads/${adId}`);
        
        if (result && result.success) {
            showNotification('Ad deleted successfully', 'success');
            
            // Reload data without page refresh
            if (document.getElementById('ads-table')) {
                loadAds(currentAdPage);
            }
            if (document.getElementById('queue-items')) {
                loadPendingAds();
            }
            
            // Update dashboard stats if on dashboard
            if (typeof loadDashboardData === 'function') {
                loadDashboardData();
            }
        }
    }
}

async function bulkApproveAds() {
    const checkboxes = document.querySelectorAll('#ads-table input[type="checkbox"]:checked');
    const adIds = Array.from(checkboxes)
        .filter(cb => cb.dataset.adId)
        .map(cb => parseInt(cb.dataset.adId));

    if (adIds.length === 0) {
        showNotification('Please select ads to approve', 'warning');
        return;
    }

    const confirmed = await Swal.fire({
        title: 'Bulk Approve',
        text: `Approve ${adIds.length} selected ad(s)?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, Approve All',
        cancelButtonText: 'Cancel',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (confirmed.isConfirmed) {
        const result = await apiPost('ads/bulk-action', {
            action: 'approve',
            ad_ids: adIds
        });
        
        if (result && result.success) {
            showNotification(`${adIds.length} ad(s) approved successfully`, 'success');
            
            // Reload data without page refresh
            loadAds(currentAdPage);
            
            // Update dashboard stats if on dashboard
            if (typeof loadDashboardData === 'function') {
                loadDashboardData();
            }
        }
    }
}

function openImageGallery(adId, startIndex = 0) {
    if (!selectedAd || !selectedAd.images) return;
    
    const images = selectedAd.images;
    let currentIndex = startIndex;
    
    const galleryHtml = `
        <div id="image-gallery-overlay" style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.95); z-index: 10000; display: flex; align-items: center; justify-content: center;">
            <button onclick="closeImageGallery()" style="position: absolute; top: 20px; right: 20px; background: rgba(255,255,255,0.1); border: none; color: white; font-size: 32px; width: 50px; height: 50px; border-radius: 50%; cursor: pointer;">&times;</button>
            <button onclick="previousImage()" style="position: absolute; left: 20px; background: rgba(255,255,255,0.1); border: none; color: white; font-size: 32px; width: 50px; height: 50px; border-radius: 50%; cursor: pointer;">&lt;</button>
            <img id="gallery-image" src="${images[currentIndex]}" style="max-width: 90%; max-height: 90%; object-fit: contain;">
            <button onclick="nextImage()" style="position: absolute; right: 20px; background: rgba(255,255,255,0.1); border: none; color: white; font-size: 32px; width: 50px; height: 50px; border-radius: 50%; cursor: pointer;">&gt;</button>
            <div style="position: absolute; bottom: 20px; color: white; font-size: 16px;">${currentIndex + 1} / ${images.length}</div>
        </div>
    `;
    
    const overlay = document.createElement('div');
    overlay.innerHTML = galleryHtml;
    document.body.appendChild(overlay.firstElementChild);
    
    window.galleryImages = images;
    window.currentGalleryIndex = currentIndex;
}

function closeImageGallery() {
    const overlay = document.getElementById('image-gallery-overlay');
    if (overlay) overlay.remove();
}

function previousImage() {
    if (!window.galleryImages) return;
    window.currentGalleryIndex = (window.currentGalleryIndex - 1 + window.galleryImages.length) % window.galleryImages.length;
    document.getElementById('gallery-image').src = window.galleryImages[window.currentGalleryIndex];
}

function nextImage() {
    if (!window.galleryImages) return;
    window.currentGalleryIndex = (window.currentGalleryIndex + 1) % window.galleryImages.length;
    document.getElementById('gallery-image').src = window.galleryImages[window.currentGalleryIndex];
}

function updateAdPagination(pagination) {
    if (!pagination) return;
    
    const paginationInfo = document.querySelector('.pagination')?.previousElementSibling;
    if (paginationInfo) {
        paginationInfo.innerHTML = `
            Showing <strong>${pagination.from}</strong> to <strong>${pagination.to}</strong> of <strong>${formatNumber(pagination.total)}</strong> results
        `;
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) modal.classList.remove('active');
}

function selectAdForReview(adId) {
    viewAdDetails(adId);
}

const adSearchInput = document.getElementById('ad-search');
if (adSearchInput) {
    adSearchInput.addEventListener('input', debounce(function(e) {
        currentAdFilters.search = e.target.value;
        loadAds(1);
    }, 500));
}

const adStatusFilter = document.getElementById('ad-status-filter');
if (adStatusFilter) {
    adStatusFilter.addEventListener('change', function(e) {
        currentAdFilters.status = e.target.value;
        loadAds(1);
    });
}

const adCategoryFilter = document.getElementById('ad-category-filter');
if (adCategoryFilter) {
    adCategoryFilter.addEventListener('change', function(e) {
        currentAdFilters.category = e.target.value;
        loadAds(1);
    });
}

if (document.getElementById('ads-table')) {
    loadAds(1);
}

if (document.getElementById('queue-items')) {
    loadPendingAds();
    setInterval(loadPendingAds, 60000);
}
