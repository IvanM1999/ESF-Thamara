const { Pool } = require('pg');

// Configuração centralizada do Pool de conexões
// O Render fornece a DATABASE_URL automaticamente
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: {
        rejectUnauthorized: false // Necessário para conexões SSL no Render/Heroku
    }
});

module.exports = {
    query: (text, params) => pool.query(text, params),
};