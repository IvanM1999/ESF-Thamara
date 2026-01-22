const express = require('express');
const router = express.Router();
const db = require('../db'); // Importa a conexão centralizada

router.get('/', async (req, res) => {
    try {
        // Busca todas as interações cadastradas
        const result = await db.query('SELECT * FROM chatbot_interactions');
        
        // Mapeia para o formato que o frontend já espera
        const data = result.rows.map(row => ({
            id: row.intent_id,
            keys: row.keys,
            resp: row.response,
            options: row.options || []
        }));
        
        res.json(data);
    } catch (err) {
        console.error("Erro no chatbot API:", err);
        res.status(500).json({ error: 'Erro interno ao buscar inteligência do bot' });
    }
});

// POST /api/chatbot/feedback - Registrar erro da IA (Feedback do usuário)
router.post('/feedback', async (req, res) => {
    try {
        const { query, response } = req.body;
        const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
        await db.query('INSERT INTO ai_feedback (user_query, bot_response, ip) VALUES ($1, $2, $3)', [query, response, ip]);
        res.json({ ok: true });
    } catch (err) {
        console.error("Erro ao salvar feedback:", err);
        res.status(500).json({ error: 'Erro interno' });
    }
});

module.exports = router;