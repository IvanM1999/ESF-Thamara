import { ChatEngine } from "./app.js";

const engine = new ChatEngine();

// Elementos do DOM
const chatHistory = document.getElementById("chatHistory");
const userInput = document.getElementById("userInput");
const sendBtn = document.getElementById("sendBtn");
const emergencyBtn = document.getElementById("emergencyBtn");
const typingIndicator = document.getElementById("typingIndicator");

// Estado
let isTyping = false;

/**
 * Adiciona mensagem ao chat
 * @param {string} text - O texto da mensagem
 * @param {string} sender - 'user' ou 'bot'
 */
function addMessage(text, sender) {
    const msgDiv = document.createElement("div");
    msgDiv.classList.add("message", sender);
    msgDiv.innerHTML = text;
    chatHistory.appendChild(msgDiv);
    scrollToBottom();
}

/**
 * Adiciona botões de opção
 * @param {Array} options 
 */
function addOptions(options) {
    if (!options || options.length === 0) return;

    const optionsDiv = document.createElement("div");
    optionsDiv.classList.add("options-container");
    optionsDiv.style.marginTop = "10px";
    optionsDiv.style.display = "flex";
    optionsDiv.style.gap = "10px";
    optionsDiv.style.flexWrap = "wrap";

    options.forEach(opt => {
        const btn = document.createElement("button");
        btn.textContent = opt;
        btn.className = "option-btn"; // Classe CSS sugerida
        btn.style.padding = "8px 12px";
        btn.style.cursor = "pointer";
        btn.style.border = "1px solid #005c8a";
        btn.style.background = "#f0f8ff";
        btn.style.borderRadius = "15px";
        
        btn.onclick = () => handleUserMessage(opt);
        optionsDiv.appendChild(btn);
    });

    chatHistory.appendChild(optionsDiv);
    scrollToBottom();
}

function scrollToBottom() {
    chatHistory.scrollTop = chatHistory.scrollHeight;
}

function showTyping() {
    isTyping = true;
    typingIndicator.style.display = "block";
    scrollToBottom();
}

function hideTyping() {
    isTyping = false;
    typingIndicator.style.display = "none";
}

/**
 * Processa a mensagem do usuário
 */
async function handleUserMessage(text) {
    if (!text.trim()) return;

    // 1. Adiciona mensagem do usuário
    addMessage(text, "user");
    userInput.value = "";

    // 2. Simula pensamento da IA
    showTyping();

    // Pequeno delay para parecer natural
    setTimeout(() => {
        hideTyping();

        // 3. Obtém resposta da Engine
        const intent = engine.findBestMatch(text);
        const risk = engine.calculateRiskScore(text);

        // 4. Exibe resposta
        addMessage(intent.resp, "bot");

        // 5. Se alto risco, adiciona alerta extra
        if (risk > 50) {
            addMessage("🚨 **Atenção:** Seus sintomas indicam uma possível urgência. Não espere, procure atendimento presencial.", "bot");
        }

        // 6. Mostra opções
        if (intent.options) {
            addOptions(intent.options);
        }

    }, 800);
}

// Event Listeners
sendBtn.addEventListener("click", () => handleUserMessage(userInput.value));
userInput.addEventListener("keypress", (e) => { if (e.key === "Enter") handleUserMessage(userInput.value); });
emergencyBtn.addEventListener("click", () => handleUserMessage("Emergência médica grave"));