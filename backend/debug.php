<?php
/**
 * Debug routing and request
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");

echo json_encode([
    'REQUEST_METHOD' => $_SERVER['REQUEST_METHOD'],
    'REQUEST_URI' => $_SERVER['REQUEST_URI'],
    'SCRIPT_NAME' => $_SERVER['SCRIPT_NAME'],
    'PHP_SELF' => $_SERVER['PHP_SELF'],
    'QUERY_STRING' => $_SERVER['QUERY_STRING'] ?? '',
    'HTTP_HOST' => $_SERVER['HTTP_HOST'],
    'SERVER_NAME' => $_SERVER['SERVER_NAME'],
    'POST_DATA' => file_get_contents("php://input"),
    'CONTENT_TYPE' => $_SERVER['CONTENT_TYPE'] ?? '',
    'HTTP_AUTHORIZATION' => $_SERVER['HTTP_AUTHORIZATION'] ?? 'Not set',
    'parsed_uri' => parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH),
    'after_basepath_removal' => str_replace('/api', '', parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH)),
    'segments' => explode('/', trim(str_replace('/api', '', parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH)), '/')),
], JSON_PRETTY_PRINT);
?>
