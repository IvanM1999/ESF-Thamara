const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../db');

// Middleware de Autenticação (Verifica Token JWT)
const authMiddleware = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'Acesso negado' });

    jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        if (err) return res.status(403).json({ error: 'Token inválido' });
        req.user = user;
        next();
    });
};

// POST /api/admin/login
router.post('/login', async (req,res)=>{
  const {username,password} = req.body;
  if(!username || !password) return res.status(400).json({error:'missing'});
  const q = await db.query('SELECT * FROM admin_users WHERE username=$1',[username]);
  const user = q.rows[0];
  if(!user) return res.status(400).json({error:'invalid'});
  const ok = await bcrypt.compare(password, user.password_hash);
  if(!ok) return res.status(400).json({error:'invalid'});
  const token = jwt.sign({id:user.id,username:user.username}, process.env.JWT_SECRET, {expiresIn:'8h'});
  res.json({token});
});

// POST create admin (for initial setup) - protected by a setup token env var
router.post('/create', async (req,res)=>{
  const setup = req.headers['x-setup-token'];
  if(setup !== process.env.SETUP_TOKEN) return res.status(403).json({error:'forbidden'});
  const {username,password} = req.body;
  const hash = await bcrypt.hash(password, 10);
  try{
    await db.query('INSERT INTO admin_users(username,password_hash) VALUES($1,$2)', [username, hash]);
    res.json({ok:true});
  }catch(e){ res.status(500).json({error:'db'}); }
});

// --- NOVAS ROTAS DO PAINEL DE CONTROLE (Protegidas) ---

// GET /api/admin/stats - Estatísticas gerais
router.get('/stats', authMiddleware, async (req, res) => {
    try {
        const totalAccess = await db.query('SELECT COUNT(*) FROM access_logs');
        const uniqueIps = await db.query('SELECT COUNT(DISTINCT ip) FROM access_logs');
        const recentLogs = await db.query('SELECT * FROM access_logs ORDER BY timestamp DESC LIMIT 50');
        
        res.json({
            total: totalAccess.rows[0].count,
            unique: uniqueIps.rows[0].count,
            logs: recentLogs.rows
        });
    } catch (e) { res.status(500).json({ error: 'Erro ao buscar estatísticas' }); }
});

// GET /api/admin/ips - Listar IPs permitidos
router.get('/ips', authMiddleware, async (req, res) => {
    try {
        const ips = await db.query('SELECT * FROM allowed_ips ORDER BY added_at DESC');
        res.json(ips.rows);
    } catch (e) { res.status(500).json({ error: 'Erro ao buscar IPs' }); }
});

// POST /api/admin/ips - Adicionar IP permitido
router.post('/ips', authMiddleware, async (req, res) => {
    const { ip, description } = req.body;
    try {
        await db.query('INSERT INTO allowed_ips (ip, description) VALUES ($1, $2) ON CONFLICT (ip) DO NOTHING', [ip, description]);
        res.json({ ok: true });
    } catch (e) { res.status(500).json({ error: 'Erro ao adicionar IP' }); }
});

module.exports = router;
