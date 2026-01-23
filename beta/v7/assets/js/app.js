import { knowledgeBase } from "./knowledge-base.js";

export class ChatEngine {
    constructor() {
        this.knowledge = knowledgeBase;
    }

    /**
     * Normaliza o texto removendo acentos e colocando em minúsculas
     */
    normalize(text) {
        return text.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
    }

    /**
     * Calcula o risco baseado em palavras-chave críticas
     */
    calculateRiskScore(text) {
        let score = 0;
        const normalizedText = this.normalize(text);
        
        const criticalKeywords = [
            "dor no peito", "falta de ar", "desmaio", "convulsao", 
            "sangramento", "infarto", "derrame", "nao respira", "roxo"
        ];

        criticalKeywords.forEach(word => {
            if (normalizedText.includes(word)) score += 30;
        });

        return Math.min(score, 100);
    }

    /**
     * Encontra a melhor intenção baseada em pontuação de palavras-chave
     */
    findBestMatch(userText) {
        const normalizedInput = this.normalize(userText);
        let bestMatch = null;
        let highestScore = 0;

        this.knowledge.forEach(intent => {
            let currentScore = 0;
            
            // Verifica correspondência exata ou parcial nas chaves
            intent.keys.forEach(key => {
                const normalizedKey = this.normalize(key);
                if (normalizedInput.includes(normalizedKey)) {
                    // Palavras maiores valem mais pontos para evitar falsos positivos curtos
                    currentScore += (normalizedKey.length > 3 ? 10 : 5);
                }
            });

            if (currentScore > highestScore) {
                highestScore = currentScore;
                bestMatch = intent;
            }
        });

        // Retorna fallback se a pontuação for muito baixa
        return highestScore > 0 ? bestMatch : this.knowledge.find(k => k.id === "fallback");
    }
}
