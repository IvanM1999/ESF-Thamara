<?php
declare(strict_types=1);
namespace Backend\AI;

final class RiskScore {
    private array $criticalTerms = [
        'dor no peito','falta de ar','desmaio','sangramento',
        'suicídio','overdose','convulsão','parada'
    ];

    public function calculate(string $message, bool $emergency=false): int {
        if ($emergency) return 100;
        $score = 0;
        $text = mb_strtolower($message);
        foreach ($this->criticalTerms as $term) {
            if (str_contains($text,$term)) $score += 20;
        }
        return min(100,$score);
    }

    public function classify(int $score): string {
        return match(true) {
            $score <= 30 => 'baixo',
            $score <= 70 => 'médio',
            default => 'crítico'
        };
    }
}
