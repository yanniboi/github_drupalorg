<?php

require '../settings.php';
require '../utility.php';

// Verify the request.
if (!isset($_POST['payload']) || !isset($_SERVER['HTTP_X_HUB_SIGNATURE'])) {
  // Show message for sysadmin debug
  print "Server found...";
  header('Access denied', TRUE, 403);
  exit;
}

// Verify the signature.
$data = file_get_contents( "php://input" );
$signature = hash_hmac('sha1', $data, $secret);

if ($_SERVER['HTTP_X_HUB_SIGNATURE'] !== "sha1=$signature") {
  header('Access denied', TRUE, 403);
  exit;
}

$payload = json_decode($_POST['payload']);

// Make sure that a pull request object is set in the received event notification.
if (isset($payload->pull_request)) {
  handle_pull_request($payload);
}
else {
  handle_code_push($payload);
}