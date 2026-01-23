<?php
declare(strict_types=1);
namespace Backend\Utils;

final class IntentDetector {
    private array $map = [
        'sintoma'=>['dor','febre','tosse'],
        'agendamento'=>['consulta','agendar'],
        'emergência'=>['socorro','urgente']
    ];

    public function detect(string $message): ?string {
        $text = mb_strtolower($message);
        foreach ($this->map as $intent=>$words) {
            foreach ($words as $w) {
                if (str_contains($text,$w)) return $intent;
            }
        }
        return null;
    }
}
