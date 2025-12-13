# ESF-Thamara
Site público para apoio ás equipes médica 

🌐 ESF Thamara Katryne Rodrigues Schmidt – Portal Comunitário

> Este projeto nasceu com o propósito de informar e apoiar a comunidade do bairro Progresso, em Blumenau (SC). Mais do que um sistema técnico, ele é um espaço digital que reúne informações de saúde, notícias, calendário de atendimentos e blogs explicativos, tudo em uma linguagem acessível e acolhedora.

🎯 Objetivo
Garantir que a comunidade tenha acesso fácil às informações da Estratégia Saúde da Família (ESF).

Oferecer blogs informativos em linguagem simples, para que mesmo pessoas com baixa escolaridade ou em situação de vulnerabilidade possam compreender.

Promover transparência sobre os atendimentos, horários e dinâmicas da unidade.

Apoiar entidades sociais brasileiras com uma ferramenta digital gratuita e aberta.

📂 Estrutura básica do Projeto
public/ → Frontend estático (site estilo Windows XP vítreo).

backend/ → Aplicação Node.js/Express com autenticação administrativa, triagem e geração de PDFs.

server_sql/ → Scripts SQL para criação de tabelas e dados iniciais.

render.yaml → Configuração de exemplo para deploy no Render.com..

🚀 Como usar Localmente
Clone o repositório:

bash
git clone https://github.com/IvanM1999/esf-thamara.git
cd esf-thamara
Instale dependências do backend:

bash
cd backend
npm install
Configure variáveis de ambiente em .env:

Código
DATABASE_URL=postgres://usuario:senha@localhost:5432/esf
JWT_SECRET=umsegurosegredo
Crie o banco de dados:

bash
psql -U usuario -d esf -f server_sql/init.sql
Inicie o backend:

bash
npm start
Sirva o frontend com qualquer servidor estático.

Deploy no Render
Crie um Managed Postgres.

Configure o backend como Web Service e o frontend como Static Site.

Defina variáveis de ambiente (DATABASE_URL, JWT_SECRET).

Rode os scripts SQL no banco.

PDFs gerados ficam em public/pdfs.

📖 Licença
Este projeto utiliza uma versão adaptada da Licença MIT, com foco em uso social no Brasil:

Forks são permitidos, desde que associados ao projeto original.

É proibida qualquer forma de monetização.

O uso é destinado exclusivamente a entidades sociais brasileiras.

Transparência é obrigatória: cada fork deve manter uma página de apresentação vinculando ao projeto original.

✨ Comunidade
Este portal é feito para e pela comunidade. Ele busca ser um espaço digital de confiança, onde qualquer pessoa possa encontrar informações úteis, compreender sua rotina de atendimento e sentir-se parte de um projeto coletivo de saúde e cidadania.
