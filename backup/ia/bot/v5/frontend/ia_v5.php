<?php
// API em PHP para tratamento avançado da IA V5 (Enterprise)
// Local: /APIs/ia_v5.php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

// Configuração do Banco de Dados (PostgreSQL)
// O PHP tentará ler a variável de ambiente do sistema (Render/Heroku)
$dbUrl = getenv('DATABASE_URL'); 

if (!$dbUrl) {
    // Fallback para desenvolvimento local ou erro
    echo json_encode(['error' => 'Configuração de banco de dados não encontrada']);
    exit;
}

try {
    // Conexão PDO com PostgreSQL
    $dbopts = parse_url($dbUrl);
    $dsn = "pgsql:host=" . $dbopts["host"] . ";port=" . $dbopts["port"] . ";dbname=" . ltrim($dbopts["path"], "/") . ";sslmode=require";
    $pdo = new PDO($dsn, $dbopts["user"], $dbopts["pass"]);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Erro de conexão: ' . $e->getMessage()]);
    exit;
}

// Processamento da Requisição
$input = json_decode(file_get_contents('php://input'), true);
$action = $input['action'] ?? '';

if ($action === 'report_error') {
    // Registrar erro da IA para re-treinamento
    $query = $input['query'] ?? '';
    $response = $input['response'] ?? '';
    $ip = $_SERVER['REMOTE_ADDR'];

    $stmt = $pdo->prepare("INSERT INTO ai_feedback (user_query, bot_response, ip) VALUES (:q, :r, :ip)");
    $stmt->execute([':q' => $query, ':r' => $response, ':ip' => $ip]);

    echo json_encode(['status' => 'success', 'message' => 'Erro registrado. O bot aprenderá com isso.']);

} else {
    echo json_encode(['error' => 'Ação desconhecida']);
}
?>