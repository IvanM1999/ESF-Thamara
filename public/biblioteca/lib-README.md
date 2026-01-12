# 📚 Biblioteca Comunitária — App Web Completo

Este é um aplicativo web completo, leve e responsivo, para organizar e explorar uma biblioteca digital.  
Funciona totalmente offline, possui modo escuro, abas internas, capas automáticas, estatísticas e integração com PWA.

---

## 🚀 Funcionalidades

- **Busca instantânea** por título, autor, ano ou gênero  
- **Filtros avançados** (gênero e intervalo de ano)  
- **Abas internas**:
  - 📚 Todos os livros  
  - ⭐ Favoritos  
  - 📘 Quero ler  
  - ✔ Já li  
- **Sistema de status** salvo no navegador (localStorage)  
- **Capas automáticas** com iniciais e cor gerada  
- **Modo escuro** com persistência  
- **Estatísticas** (total, favoritos, quero ler, lidos)  
- **PWA instalável** (manifest + service worker)  
- **Interface moderna**, responsiva e animada  
- **Carrega apenas dois arquivos externos**:
  - `library.json`
  - `genres.json`

---

## 📁 Estrutura do Projeto

```
/
├── biblioteca.html        # App principal (único arquivo HTML)
├── library.json           # Lista de livros
├── genres.json            # Lista de gêneros por livro
├── manifest.json          # Manifesto PWA
├── service-worker.js      # Cache offline
└── icons/                 # Ícones do PWA (opcional)
```

---

## 🧩 Como funciona

### 1. `biblioteca.html`
Contém:

- Todo o **HTML da interface**
- Todo o **CSS completo**
- Todo o **JavaScript completo**
- Integração com:
  - Modo escuro
  - Abas internas
  - Capas automáticas
  - Estatísticas
  - Sistema de favoritos/quero ler/já li
  - Carregamento dos JSONs externos
  - PWA

### 2. `library.json`
Arquivo contendo os livros no formato:

```json
{
  "id-do-livro": {
    "title": "Título",
    "author": "Autor",
    "year": 1899,
    "read": "link para leitura online",
    "pdf": "link para PDF"
  }
}
```

### 3. `genres.json`
Arquivo contendo os gêneros de cada livro:

```json
{
  "id-do-livro": ["Romance", "Clássico"]
}
```

### 4. `manifest.json`
Permite instalar o app como PWA:

```json
{
  "name": "Biblioteca Comunitária",
  "short_name": "Biblioteca",
  "start_url": "biblioteca.html",
  "display": "standalone",
  "background_color": "#f5f7fa",
  "theme_color": "#005c8a",
  "icons": [
    { "src": "icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

### 5. `service-worker.js`
Cache offline básico:

```js
const CACHE_NAME = "biblioteca-cache-v1";
const URLS_TO_CACHE = [
  "biblioteca.html",
  "library.json",
  "genres.json"
];

self.addEventListener("install", event => {
  event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(URLS_TO_CACHE)));
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    )
  );
});

self.addEventListener("fetch", event => {
  event.respondWith(caches.match(event.request).then(r => r || fetch(event.request)));
});
```

---

## 🛠 Como rodar

1. Coloque todos os arquivos na mesma pasta.
2. Abra `biblioteca.html` no navegador.
3. Para instalar como app:
   - No Chrome/Edge → “Instalar aplicativo”
4. Para rodar como PWA local:
   - Use um servidor simples (ex.: `npx serve` ou Live Server)

---

## 🔄 Como reconstruir tudo no futuro

Sempre que quiser recriar o projeto:

1. Crie os arquivos:
   - `biblioteca.html`
   - `library.json`
   - `genres.json`
   - `manifest.json`
   - `service-worker.js`

2. Copie o conteúdo deste README.

3. Cole o HTML, CSS e JS completos dentro de `biblioteca.html`.

4. Atualize `library.json` e `genres.json` conforme necessário.

5. Pronto — o app estará funcionando exatamente como antes.

---

## 🧠 Observações

- O app funciona **100% offline** após o primeiro carregamento.  
- O localStorage mantém:
  - Favoritos  
  - Quero ler  
  - Já li  
  - Tema escuro/claro  
- O service worker mantém:
  - HTML  
  - JSONs  
- O design foi pensado para:
  - Android  
  - iOS  
  - Desktop  
  - Tablets  

---

## 📜 Licença

Este projeto é livre para uso, modificação e distribuição.

---

## ✨ Autor

Criado a biblioteca de livros e melhorias de codigo com apoio do Microsoft Copilot.  
Organizado e mantido por **Ivan**.