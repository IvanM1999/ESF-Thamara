<?php
declare(strict_types=1);
namespace Backend\Security;

final class Mailer {
    public function __construct(private string $to, private string $from) {}

    public function sendCriticalAlert(array $data): void {
        $subject='[ALERTA CRÍTICO] IA ESF';
        @mail($this->to,$subject,json_encode($data,JSON_UNESCAPED_UNICODE),'From: '.$this->from);
    }
}
