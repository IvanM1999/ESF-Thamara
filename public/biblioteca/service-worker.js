const APP_VERSION = "1.0.0";
const CACHE_NAME = `biblioteca-cache-${APP_VERSION}`;

const STATIC_ASSETS = [
  "./",
  "./index.html",
  "./library.json",
  "./genres.json",
  "./manifest.json"
];

/* ======================
   INSTALL
====================== */
self.addEventListener("install", event => {
  self.skipWaiting(); // força atualização
  event.waitUntil(
    caches.open(CACHE_NAME)
    .then(cache => cache.addAll(STATIC_ASSETS))
  );
});

/* ======================
   ACTIVATE
====================== */
self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(
        keys
        .filter(k => k !== CACHE_NAME)
        .map(k => caches.delete(k))
      )
    )
  );
  self.clients.claim();
});

/* ======================
   FETCH
====================== */
self.addEventListener("fetch", event => {
  const req = event.request;
  
  // Só GET
  if (req.method !== "GET") return;
  
  event.respondWith(
    caches.match(req).then(cacheRes => {
      if (cacheRes) return cacheRes;
      
      return fetch(req)
        .then(netRes => {
          // Proteção: só cachear respostas válidas
          if (
            !netRes ||
            netRes.status !== 200 ||
            netRes.type !== "basic"
          ) {
            return netRes;
          }
          
          const clone = netRes.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(req, clone);
          });
          
          return netRes;
        })
        .catch(() => {
          // Fallback offline mínimo
          if (req.headers.get("accept")?.includes("text/html")) {
            return caches.match("./index.html");
          }
        });
    })
  );
});