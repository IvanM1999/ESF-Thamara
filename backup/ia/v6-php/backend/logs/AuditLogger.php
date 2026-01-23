<?php
declare(strict_types=1);
namespace Backend\Logs;

final class AuditLogger {
    public function __construct(private string $file) {
        if (!file_exists($this->file)) {
            touch($this->file);
            chmod($this->file,0640);
        }
    }

    public function append(array $data): void {
        $entry = [
            'timestamp'=>(new \DateTimeImmutable())->format(DATE_ATOM),
            'payload'=>$data
        ];
        file_put_contents(
            $this->file,
            json_encode($entry,JSON_UNESCAPED_UNICODE).PHP_EOL,
            FILE_APPEND|LOCK_EX
        );
    }
}
