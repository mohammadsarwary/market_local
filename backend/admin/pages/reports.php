<?php
$current_page = 'reports';
$page_title = 'Reported Ads';
$breadcrumb = [['label' => 'Moderation'], ['label' => 'Reported Ads']];

include '../includes/auth_check.php';
include '../includes/header.php';
include '../includes/sidebar.php';
?>

<div class="page-header">
    <h1 class="page-title">Reported Ads</h1>
    <p class="page-description">Review and take action on user-reported content.</p>
</div>

<div class="card">
    <div class="card-header">
        <div class="filters-bar" style="margin: 0;">
            <select class="form-control" style="width: 150px;">
                <option>Type: All</option>
                <option>Spam</option>
                <option>Scam</option>
                <option>Inappropriate</option>
            </select>
            <select class="form-control" style="width: 150px;">
                <option>Status: All</option>
                <option>Pending</option>
                <option>Resolved</option>
                <option>Dismissed</option>
            </select>
        </div>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>REPORT ID</th>
                    <th>AD DETAILS</th>
                    <th>REASON</th>
                    <th>REPORTER</th>
                    <th>STATUS</th>
                    <th>DATE</th>
                    <th>ACTIONS</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="color: #FFFFFF; font-weight: 500;">#RPT-001</td>
                    <td>
                        <div style="color: #FFFFFF; font-weight: 500;">iPhone 13 Pro Max</div>
                        <div style="color: #6B7280; font-size: 12px;">by John Doe</div>
                    </td>
                    <td><span class="badge badge-danger">Scam</span></td>
                    <td style="color: #9CA3AF;">User #12345</td>
                    <td><span class="badge badge-warning">Pending</span></td>
                    <td style="color: #9CA3AF;">2 hours ago</td>
                    <td>
                        <div style="display: flex; gap: 8px;">
                            <button class="btn btn-sm btn-primary">Review</button>
                            <button class="btn btn-sm btn-secondary">Dismiss</button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<?php include '../includes/footer.php'; ?>
