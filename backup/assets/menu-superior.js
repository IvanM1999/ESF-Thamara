// menu-superior.js
// ------------------------
// Este script injeta o menu superior XP em todas as páginas
// usando fetch() para carregar o menu-superior.html.
//
// Basta colocar em qualquer página:
// <div id="menu-superior"></div>
// <script src="/assets/js/menu-superior.js"></script>
// ------------------------

document.addEventListener("DOMContentLoaded", () => {
    const target = document.getElementById("menu-superior");

    if (!target) {
        console.warn("menu-superior.js: elemento #menu-superior não encontrado.");
        return;
    }

    fetch("/assets/js/menu-superior.html")
        .then((res) => {
            if (!res.ok) {
                throw new Error("Erro ao carregar menu-superior.html");
            }
            return res.text();
        })
        .then((html) => {
            target.innerHTML = html;
        })
        .catch((err) => {
            console.error("menu-superior.js erro:", err);
            target.innerHTML = "<p style='color:red;'>Falha ao carregar menu.</p>";
        });
});