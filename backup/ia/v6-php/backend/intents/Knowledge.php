<?php
declare(strict_types=1);
namespace Backend\Intents;

final class Knowledge {
    private array $responses = [
        'sintoma' => 'Procure a unidade de saúde para avaliação clínica.',
        'agendamento' => 'Agendamentos são realizados na sua ESF.',
        'emergência' => 'Em emergência, ligue 192 (SAMU).'
    ];

    public function getResponse(?string $intent): string {
        return $this->responses[$intent]
            ?? 'Não foi possível identificar sua necessidade.';
    }
}
