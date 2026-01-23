<?php
declare(strict_types=1);
namespace Backend\Services;

use Backend\AI\RiskScore;
use Backend\Utils\IntentDetector;
use Backend\Intents\Knowledge;
use Backend\Logs\AuditLogger;
use Backend\Security\Mailer;

final class ChatService {
    public function __construct(
        private RiskScore $risk,
        private IntentDetector $intent,
        private Knowledge $knowledge,
        private AuditLogger $logger,
        private Mailer $mailer
    ) {}

    public function handleChat(string $message): array {
        $intent = $this->intent->detect($message);
        $score = $this->risk->calculate($message);
        $level = $this->risk->classify($score);

        $response = [
            'response' => $this->knowledge->getResponse($intent),
            'score' => $score,
            'classification' => $level
        ];

        $this->logger->append(['type'=>'chat','message'=>$message,'response'=>$response]);

        if ($score >= 70) {
            $this->mailer->sendCriticalAlert($response);
        }

        return $response;
    }

    public function handleEmergency(): array {
        $data = ['type'=>'emergency','score'=>100,'classification'=>'crítico'];
        $this->logger->append($data);
        $this->mailer->sendCriticalAlert($data);
        return ['status'=>'Emergência registrada com sucesso'];
    }
}
