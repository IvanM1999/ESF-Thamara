-- TABELAS ADMINISTRATIVAS (PAINEL DE CONTROLE) --

-- Tabela de Usuários Administrativos (Garante que existe)
CREATE TABLE IF NOT EXISTS admin_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);

-- Tabela de Logs de Acesso (Monitoramento)
CREATE TABLE IF NOT EXISTS access_logs (
    id SERIAL PRIMARY KEY,
    ip VARCHAR(45),
    path TEXT,
    method VARCHAR(10),
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT NOW()
);

-- Tabela de IPs Permitidos (Controle de Acesso)
CREATE TABLE IF NOT EXISTS allowed_ips (
    id SERIAL PRIMARY KEY,
    ip VARCHAR(45) UNIQUE NOT NULL,
    description TEXT,
    added_at TIMESTAMP DEFAULT NOW()
);