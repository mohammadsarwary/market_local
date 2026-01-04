let currentReportPage = 1;
let currentReportFilters = {
    type: '',
    status: ''
};

async function loadReports(page = 1) {
    try {
        const result = await apiGet('reports', {
            page: page,
            limit: 20,
            ...currentReportFilters
        });

        if (result && result.success) {
            renderReportsTable(result.data.reports);
            updateReportPagination(result.data.pagination);
        }
    } catch (error) {
        console.error('Error loading reports:', error);
    }
}

function renderReportsTable(reports) {
    const tbody = document.querySelector('#reports-table tbody');
    if (!tbody || !reports) return;

    tbody.innerHTML = reports.map(report => `
        <tr>
            <td style="color: #FFFFFF; font-weight: 500;">#RPT-${String(report.id).padStart(4, '0')}</td>
            <td>
                <div style="color: #FFFFFF; font-weight: 500;">${report.ad_title || 'N/A'}</div>
                <div style="color: #6B7280; font-size: 12px;">by ${report.ad_user_name || 'Unknown'}</div>
            </td>
            <td><span class="badge badge-${getReportTypeBadgeClass(report.reason)}">${report.reason}</span></td>
            <td>
                <div style="color: #9CA3AF;">${report.reporter_name || 'Anonymous'}</div>
                <div style="color: #6B7280; font-size: 12px;">User #${report.reporter_id}</div>
            </td>
            <td><span class="badge badge-${getReportStatusBadgeClass(report.status)}">${report.status}</span></td>
            <td style="color: #9CA3AF;">${formatDate(report.created_at)}</td>
            <td>
                <div style="display: flex; gap: 8px;">
                    <button class="btn btn-sm btn-secondary" onclick="viewReportDetails(${report.id})" title="View Details">
                        <i class="fas fa-eye"></i>
                    </button>
                    ${report.status === 'pending' ? `
                        <button class="btn btn-sm btn-success" onclick="resolveReport(${report.id})" title="Resolve">
                            <i class="fas fa-check"></i>
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="dismissReport(${report.id})" title="Dismiss">
                            <i class="fas fa-times"></i>
                        </button>
                    ` : ''}
                </div>
            </td>
        </tr>
    `).join('');
}

function getReportTypeBadgeClass(type) {
    const classes = {
        'spam': 'warning',
        'scam': 'danger',
        'inappropriate': 'danger',
        'duplicate': 'info',
        'misleading': 'warning',
        'other': 'secondary'
    };
    return classes[type?.toLowerCase()] || 'secondary';
}

function getReportStatusBadgeClass(status) {
    const classes = {
        'pending': 'warning',
        'resolved': 'success',
        'dismissed': 'secondary',
        'action_taken': 'info'
    };
    return classes[status] || 'secondary';
}

async function viewReportDetails(reportId) {
    try {
        const result = await apiGet(`reports/${reportId}`);
        
        if (result && result.success) {
            showReportDetailsModal(result.data);
        }
    } catch (error) {
        console.error('Error loading report details:', error);
    }
}

function showReportDetailsModal(report) {
    const modal = document.getElementById('report-details-modal') || createReportDetailsModal();
    
    const modalContent = modal.querySelector('.modal-content');
    modalContent.innerHTML = `
        <div class="modal-header">
            <h2>Report Details #RPT-${String(report.id).padStart(4, '0')}</h2>
            <button class="modal-close" onclick="closeModal('report-details-modal')">&times;</button>
        </div>
        <div class="modal-body">
            <div style="background: #1A1A1A; padding: 16px; border-radius: 8px; margin-bottom: 24px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <div>
                        <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Report Type</div>
                        <span class="badge badge-${getReportTypeBadgeClass(report.reason)}">${report.reason}</span>
                    </div>
                    <div>
                        <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Status</div>
                        <span class="badge badge-${getReportStatusBadgeClass(report.status)}">${report.status}</span>
                    </div>
                    <div>
                        <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Reported</div>
                        <div style="color: #FFFFFF;">${formatDate(report.created_at)}</div>
                    </div>
                </div>
            </div>

            <div style="margin-bottom: 24px;">
                <h3 style="color: #FFFFFF; font-size: 16px; margin-bottom: 12px;">Reported Ad</h3>
                <div style="background: #1A1A1A; padding: 16px; border-radius: 8px;">
                    <div style="display: flex; gap: 16px;">
                        ${report.ad_image ? `<img src="${report.ad_image}" style="width: 80px; height: 80px; border-radius: 8px; object-fit: cover;">` : ''}
                        <div style="flex: 1;">
                            <div style="color: #FFFFFF; font-weight: 500; margin-bottom: 4px;">${report.ad_title || 'N/A'}</div>
                            <div style="color: #6B7280; font-size: 14px; margin-bottom: 8px;">${report.ad_description || 'No description'}</div>
                            <div style="display: flex; gap: 16px;">
                                <div>
                                    <span style="color: #6B7280; font-size: 12px;">Price:</span>
                                    <span style="color: #EF4444; font-weight: 600;">$${parseFloat(report.ad_price || 0).toLocaleString()}</span>
                                </div>
                                <div>
                                    <span style="color: #6B7280; font-size: 12px;">Posted by:</span>
                                    <span style="color: #FFFFFF;">${report.ad_user_name || 'Unknown'}</span>
                                </div>
                            </div>
                            <button class="btn btn-sm btn-secondary" onclick="viewAdDetails(${report.ad_id})" style="margin-top: 12px;">
                                <i class="fas fa-external-link-alt"></i> View Full Ad
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div style="margin-bottom: 24px;">
                <h3 style="color: #FFFFFF; font-size: 16px; margin-bottom: 12px;">Report Details</h3>
                <div style="background: #1A1A1A; padding: 16px; border-radius: 8px;">
                    <div style="color: #6B7280; font-size: 12px; margin-bottom: 8px;">Description</div>
                    <div style="color: #9CA3AF; line-height: 1.6;">${report.description || 'No additional details provided'}</div>
                </div>
            </div>

            <div style="margin-bottom: 24px;">
                <h3 style="color: #FFFFFF; font-size: 16px; margin-bottom: 12px;">Reporter Information</h3>
                <div style="background: #1A1A1A; padding: 16px; border-radius: 8px;">
                    <div style="display: flex; justify-content: space-between;">
                        <div>
                            <div style="color: #FFFFFF; font-weight: 500; margin-bottom: 4px;">${report.reporter_name || 'Anonymous'}</div>
                            <div style="color: #6B7280; font-size: 14px;">${report.reporter_email || 'N/A'}</div>
                            <div style="color: #6B7280; font-size: 14px;">User ID: #${report.reporter_id}</div>
                        </div>
                        <div style="text-align: right;">
                            <div style="color: #6B7280; font-size: 12px; margin-bottom: 4px;">Previous Reports</div>
                            <div style="color: #FFFFFF; font-size: 20px; font-weight: 600;">${report.reporter_report_count || 0}</div>
                        </div>
                    </div>
                </div>
            </div>

            ${report.action_taken ? `
                <div style="margin-bottom: 24px;">
                    <h3 style="color: #FFFFFF; font-size: 16px; margin-bottom: 12px;">Action Taken</h3>
                    <div style="background: rgba(16, 185, 129, 0.1); padding: 16px; border-radius: 8px; border: 1px solid rgba(16, 185, 129, 0.3);">
                        <div style="color: #10B981; font-weight: 500; margin-bottom: 8px;">
                            <i class="fas fa-check-circle"></i> ${report.action_taken}
                        </div>
                        <div style="color: #6B7280; font-size: 14px;">
                            Resolved by ${report.resolved_by_name || 'Admin'} on ${formatDate(report.resolved_at)}
                        </div>
                        ${report.admin_notes ? `<div style="color: #9CA3AF; margin-top: 8px; font-size: 14px;">Notes: ${report.admin_notes}</div>` : ''}
                    </div>
                </div>
            ` : ''}
        </div>
        <div class="modal-footer">
            ${report.status === 'pending' ? `
                <button class="btn btn-danger" onclick="showTakeActionModal(${report.id})">
                    <i class="fas fa-gavel"></i> Take Action
                </button>
                <button class="btn btn-success" onclick="resolveReport(${report.id})">
                    <i class="fas fa-check"></i> Resolve
                </button>
                <button class="btn btn-secondary" onclick="dismissReport(${report.id})">
                    <i class="fas fa-times"></i> Dismiss
                </button>
            ` : ''}
            <button class="btn btn-secondary" onclick="closeModal('report-details-modal')">Close</button>
        </div>
    `;
    
    modal.classList.add('active');
}

function createReportDetailsModal() {
    const modal = document.createElement('div');
    modal.id = 'report-details-modal';
    modal.className = 'modal';
    modal.innerHTML = '<div class="modal-content" style="max-width: 900px;"></div>';
    document.body.appendChild(modal);
    return modal;
}

async function resolveReport(reportId) {
    const confirmed = await Swal.fire({
        title: 'Resolve Report?',
        text: 'Mark this report as resolved without taking action.',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, Resolve',
        cancelButtonText: 'Cancel',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (confirmed.isConfirmed) {
        const result = await apiPut(`reports/${reportId}/resolve`);
        
        if (result && result.success) {
            showNotification('Report resolved successfully', 'success');
            closeModal('report-details-modal');
            
            // Reload data without page refresh
            loadReports(currentReportPage);
            
            // Update dashboard stats if on dashboard
            if (typeof loadDashboardData === 'function') {
                loadDashboardData();
            }
        }
    }
}

async function dismissReport(reportId) {
    const { value: reason } = await Swal.fire({
        title: 'Dismiss Report',
        input: 'textarea',
        inputLabel: 'Reason for dismissal (optional)',
        inputPlaceholder: 'Enter reason...',
        showCancelButton: true,
        confirmButtonText: 'Dismiss',
        cancelButtonText: 'Cancel',
        background: '#1A1A1A',
        color: '#FFFFFF'
    });

    if (reason !== undefined) {
        const result = await apiPut(`reports/${reportId}/dismiss`, { reason });
        
        if (result && result.success) {
            showNotification('Report dismissed successfully', 'success');
            closeModal('report-details-modal');
            
            // Reload data without page refresh
            loadReports(currentReportPage);
            
            // Update dashboard stats if on dashboard
            if (typeof loadDashboardData === 'function') {
                loadDashboardData();
            }
        }
    }
}

function showTakeActionModal(reportId) {
    Swal.fire({
        title: 'Take Action',
        html: `
            <div style="text-align: left; margin-top: 20px;">
                <label style="display: block; margin-bottom: 8px; color: #FFFFFF;">Select Action:</label>
                <select id="action-type" class="swal2-input" style="width: 100%; background: #1A1A1A; color: #FFFFFF; border: 1px solid #2A2A2A;">
                    <option value="delete_ad">Delete the reported ad</option>
                    <option value="ban_user">Ban the ad owner</option>
                    <option value="warn_user">Warn the ad owner</option>
                    <option value="suspend_ad">Suspend the ad temporarily</option>
                </select>
                <label style="display: block; margin-top: 16px; margin-bottom: 8px; color: #FFFFFF;">Admin Notes:</label>
                <textarea id="action-notes" class="swal2-textarea" placeholder="Enter notes about this action..." style="background: #1A1A1A; color: #FFFFFF; border: 1px solid #2A2A2A;"></textarea>
            </div>
        `,
        showCancelButton: true,
        confirmButtonText: 'Take Action',
        cancelButtonText: 'Cancel',
        background: '#1A1A1A',
        color: '#FFFFFF',
        preConfirm: () => {
            const actionType = document.getElementById('action-type').value;
            const notes = document.getElementById('action-notes').value;
            
            if (!notes) {
                Swal.showValidationMessage('Please provide notes for this action');
                return false;
            }
            
            return { actionType, notes };
        }
    }).then((result) => {
        if (result.isConfirmed) {
            takeActionOnReport(reportId, result.value.actionType, result.value.notes);
        }
    });
}

async function takeActionOnReport(reportId, actionType, notes) {
    const result = await apiPost(`reports/${reportId}/action`, {
        action: actionType,
        notes: notes
    });
    
    if (result && result.success) {
        showNotification('Action taken successfully', 'success');
        closeModal('report-details-modal');
        
        // Reload data without page refresh
        loadReports(currentReportPage);
        
        // Update dashboard stats if on dashboard
        if (typeof loadDashboardData === 'function') {
            loadDashboardData();
        }
        
        // Reload ads if action affected ads
        if ((actionType === 'delete_ad' || actionType === 'suspend_ad') && typeof loadAds === 'function') {
            loadAds(1);
        }
        
        // Reload users if action affected users
        if ((actionType === 'ban_user' || actionType === 'warn_user') && typeof loadUsers === 'function') {
            loadUsers(1);
        }
    }
}

function updateReportPagination(pagination) {
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

const reportTypeFilter = document.getElementById('report-type-filter');
if (reportTypeFilter) {
    reportTypeFilter.addEventListener('change', function(e) {
        currentReportFilters.type = e.target.value;
        loadReports(1);
    });
}

const reportStatusFilter = document.getElementById('report-status-filter');
if (reportStatusFilter) {
    reportStatusFilter.addEventListener('change', function(e) {
        currentReportFilters.status = e.target.value;
        loadReports(1);
    });
}

if (document.getElementById('reports-table')) {
    loadReports(1);
    setInterval(loadReports, 60000);
}
