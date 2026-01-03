<?php
session_start();

if (!isset($_SESSION['admin_token']) || !isset($_SESSION['admin_user'])) {
    header('Location: login.php');
    exit();
}

$admin_user = $_SESSION['admin_user'];
$admin_token = $_SESSION['admin_token'];
?>
