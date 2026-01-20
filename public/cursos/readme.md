# Ambiente de Cursos Livres

Este sistema é uma plataforma educacional offline-first para organização de cursos livres.

## Como usar
Abra o arquivo `index.html` em qualquer navegador moderno.

## Como adicionar cursos
Edite o arquivo `data/cursos.json` e adicione novos objetos seguindo o padrão:

- id
- titulo
- descricao
- area
- tipo
- link
- imagem

## Tipos
- interno → páginas locais
- externo → links externos
- gov → cursos da Escola Virtual Gov.br

## Estrutura
O sistema carrega todos os dados dinamicamente a partir do JSON.

## Adaptação Gov.br
O design e arquitetura permitem integração futura com autenticação, APIs e serviços do gov.br sem refatoração estrutural.