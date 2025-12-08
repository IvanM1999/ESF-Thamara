const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3061;

// Servir arquivos estáticos (HTML, CSS, JS, imagens)
app.use(express.static(path.join(__dirname, "public")));

// Rota principal
app.get("/", (req, res) => {
   res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.listen(PORT, () => {
   console.log(`Servidor rodando na porta ${PORT}`);
});