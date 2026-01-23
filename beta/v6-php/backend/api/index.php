<?php
declare(strict_types=1);
/* Front controller REST */
header('Content-Type: application/json; charset=UTF-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('Referrer-Policy: no-referrer');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { exit; }

$config = require __DIR__ . '/../config/env.php';
date_default_timezone_set($config['TIMEZONE']);

require_once __DIR__ . '/../logs/AuditLogger.php';
require_once __DIR__ . '/../ai/RiskScore.php';
require_once __DIR__ . '/../utils/IntentDetector.php';
require_once __DIR__ . '/../intents/Knowledge.php';
require_once __DIR__ . '/../security/Mailer.php';
require_once __DIR__ . '/../services/ChatService.php';

use Backend\Services\ChatService;
use Backend\Logs\AuditLogger;
use Backend\AI\RiskScore;
use Backend\Utils\IntentDetector;
use Backend\Intents\Knowledge;
use Backend\Security\Mailer;

$service = new ChatService(
    new RiskScore(),
    new IntentDetector(),
    new Knowledge(),
    new AuditLogger(__DIR__ . '/../../storage/audit.log'),
    new Mailer($config['ALERT_EMAIL_TO'], $config['ALERT_EMAIL_FROM'])
);

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$payload = json_decode(file_get_contents('php://input'), true);

if ($path === '/chat' && isset($payload['message'])) {
    echo json_encode($service->handleChat(trim(strip_tags($payload['message']))));
    exit;
}

if ($path === '/emergency') {
    echo json_encode($service->handleEmergency());
    exit;
}

http_response_code(404);
echo json_encode(['error' => 'Endpoint inválido']);
