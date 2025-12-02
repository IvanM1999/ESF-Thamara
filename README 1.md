ESF Thamara Rodriguez - Site e Backend

Conteúdo:
- public/: frontend estático (site estilo Windows XP vítreo)
- backend/: Node/Express backend com autenticação ADM, triagem, geração de PDF
- server_sql/: scripts SQL para criação de tabelas e seed
- render.yaml: configuração de exemplo para deploy no Render.com

Instruções rápidas:
1. Suba o repositório para GitHub.
2. No Render, crie Managed Postgres ou use o declarado em render.yaml.
3. Crie Web Service para backend (Node) e Static Site para frontend.
4. Defina variáveis de ambiente no serviço backend:
   - DATABASE_URL (fornecido pelo Render)
   - JWT_SECRET (segredo para tokens)
5. Execute o script SQL em server_sql/init.sql no banco.
6. Deploy.

PDFs gerados são armazenados em public/pdfs e servidos estaticamente.
