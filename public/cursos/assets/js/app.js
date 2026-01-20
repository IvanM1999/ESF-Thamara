// Ambiente de Cursos Livres
// Motor de renderização e filtros

let cursos = [];

const container = document.getElementById("coursesContainer");
const searchInput = document.getElementById("searchInput");
const filterArea = document.getElementById("filterArea");
const filterType = document.getElementById("filterType");

// Carrega o JSON
fetch("data/cursos.json")
    .then(response => response.json())
    .then(data => {
        cursos = data;
        renderCursos(cursos);
    });

// Renderiza os cursos na tela
function renderCursos(lista) {
    container.innerHTML = "";

    lista.forEach(curso => {
        const card = document.createElement("article");
        card.className = "course-card";

        const link = document.createElement("a");
        link.href = curso.link;

        if (curso.tipo !== "interno") {
            link.target = "_blank";
            link.rel = "noopener";
        }

        link.innerHTML = `
            <img src="${curso.imagem}" alt="">
            <h2>${curso.titulo}</h2>
            <p>${curso.descricao}</p>
            <span class="badge ${curso.tipo}">${curso.tipo.toUpperCase()}</span>
        `;

        card.appendChild(link);
        container.appendChild(card);
    });
}

// Aplica filtros
function applyFilters() {
    const search = searchInput.value.toLowerCase();
    const area = filterArea.value;
    const type = filterType.value;

    const filtered = cursos.filter(curso => {
        const matchesSearch =
            curso.titulo.toLowerCase().includes(search) ||
            curso.descricao.toLowerCase().includes(search);

        const matchesArea = area === "" || curso.area === area;
        const matchesType = type === "" || curso.tipo === type;

        return matchesSearch && matchesArea && matchesType;
    });

    renderCursos(filtered);
}

searchInput.addEventListener("input", applyFilters);
filterArea.addEventListener("change", applyFilters);
filterType.addEventListener("change", applyFilters);