-- Init DB for ESF Thamara
CREATE TABLE IF NOT EXISTS admin_users (
  id serial PRIMARY KEY,
  username text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS questions (
  id serial PRIMARY KEY,
  text text NOT NULL,
  type text NOT NULL DEFAULT 'text',
  options jsonb NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS triagem_respostas (
  id serial PRIMARY KEY,
  patient_name text NULL,
  answers jsonb NOT NULL,
  pdf_url text NULL,
  created_at timestamptz DEFAULT now()
);

-- Seed admin (password: change-me)
-- Replace with secure password after deploy.
