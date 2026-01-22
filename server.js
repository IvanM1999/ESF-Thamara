const express = require("express");
const path = require("path");
const cors = require("cors");
const helmet = require("helmet");
require("dotenv").config(); // Carrega variáveis de ambiente localmente
const db = require('./backend/db'); // Importa conexão para logs
const bcrypt = require('bcryptjs'); // Necessário para criar o hash da senha

const app = express();
const PORT = process.env.PORT || 3061;

// --- Middlewares de Segurança e Utilidade ---
app.use(helmet({
    contentSecurityPolicy: false, // Desativado temporariamente para permitir scripts externos (CDN do Xenova)
}));
app.use(cors());
app.use(express.json()); // Permite receber JSON no corpo das requisições (POST/PUT)
app.use(express.urlencoded({ extended: true }));

// --- Middleware de Log de Acessos (Monitoramento) ---
app.use(async (req, res, next) => {
    try {
        const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
        const path = req.path;
        // Ignora arquivos estáticos comuns para não lotar o banco
        if (!path.match(/\.(css|js|png|jpg|ico|svg)$/)) {
            await db.query('INSERT INTO access_logs (ip, path, method, user_agent) VALUES ($1, $2, $3, $4)', 
                [ip, path, req.method, req.get('User-Agent')]);
        }
    } catch (err) {
        console.error("Erro ao salvar log:", err.message);
    }
    next();
});

// Servir arquivos estáticos (HTML, CSS, JS, imagens)
app.use(express.static(path.join(__dirname, "public")));
app.use('/beta', express.static(path.join(__dirname, "beta"))); // Servir a pasta beta

// --- Rotas da API ---
app.use('/api/chatbot', require('./backend/routes/chatbot'));
app.use('/api/admin', require('./backend/routes/admin'));

// Rota principal
app.get("/", (req, res) => {
   res.sendFile(path.join(__dirname, "public", "index.html"));
});

// --- SEED: Criar usuário admin padrão se não existir ---
(async () => {
    try {
        const res = await db.query('SELECT count(*) FROM admin_users');
        if (res.rows[0].count === '0') {
            const hash = await bcrypt.hash('senha123', 10);
            await db.query('INSERT INTO admin_users (username, password_hash) VALUES ($1, $2)', ['thamara', hash]);
            console.log('✅ Usuário admin "thamara" criado com senha "senha123"');
        }
    } catch (e) { console.error('⚠️ Erro ao verificar/criar admin:', e.message); }
})();

app.listen(PORT, () => {
   console.log(`Servidor rodando na porta ${PORT}`);
});