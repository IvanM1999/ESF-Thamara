--- /dev/null
    c:\Users\dk\OneDrive\.Projetos\ESF-Thamara\ESF-Thamara\v8\neural.js
@@ -0,0  1,152 @@
 import { pipeline, env } from 'https://cdn.jsdelivr.net/npm/@xenova/transformers@2.6.0';
 
 // Configuração para rodar no navegador (WebGPU/WASM)
 env.allowLocalModels = false;
 
 export class NeuralBrain {
     constructor(config = {}) {
         this.config = {
             model: 'Xenova/paraphrase-multilingual-MiniLM-L12-v2', // Modelo mais robusto para PT-BR
             threshold: 0.40, // Confiança mínima
             apiEndpoint: '../api/get-interactions.php', // Endpoint unificado (SQL)
             logEndpoint: '../api/log-interaction.php',
             historyLimit: 3, // Manter o histórico das últimas 3 trocas (user/bot)
             ...config
         };
         
         this.knowledgeBase = [];
         this.extractor = null;
         this.context = {
             history: [] // Formato: [{ role: 'user' | 'bot', content: '...' }]
         };
         this.status = 'initializing'; // initializing, ready, error
     }
 
     // Inicializa o motor: Carrega dados do DB e o Modelo Neural em paralelo
     async initialize() {
         try {
             const [data, extractor] = await Promise.all([
                 this.fetchKnowledgeBase(),
                 this.loadModel()
             ]);
 
             this.knowledgeBase = data;
             this.extractor = extractor;
 
             // Pré-calcula os vetores (embeddings) para todas as intenções do banco
             await this.embedKnowledgeBase();
 
             this.status = 'ready';
             return true;
         } catch (error) {
             console.error("NeuralBrain Init Error:", error);
             this.status = 'error';
             return false;
         }
     }
 
     async fetchKnowledgeBase() {
         const res = await fetch(this.config.apiEndpoint);
         if (!res.ok) {
             throw new Error(`Falha ao buscar base de conhecimento. Status: ${res.status}`);
         }
         return await res.json();
     }
 
     async loadModel() {
         return await pipeline('feature-extraction', this.config.model);
     }
 
     // Otimização: Processamento em lote (Batch)
     async embedKnowledgeBase() {
         for (let item of this.knowledgeBase) {
             if (item.keys && item.keys.length > 0) {
                 const output = await this.extractor(item.keys, { pooling: 'mean', normalize: true });
                 
                 const embeddingSize = output.dims[output.dims.length - 1];
                 const batchSize = item.keys.length;
                 item.embeddings = [];
 
                 // Fatia o tensor plano em vetores individuais
                 for (let i = 0; i < batchSize; i++) {
                     const start = i * embeddingSize;
                     const end = start + embeddingSize;
                     item.embeddings.push(output.data.slice(start, end));
                 }
             }
         }
     }
 
     // Cálculo de Similaridade de Cosseno
     cosineSimilarity(a, b) {
         let dot = 0, normA = 0, normB = 0;
         for (let i = 0; i < a.length; i++) {
             dot += a[i] * b[i];
             normA += a[i] * a[i];
             normB += b[i] * b[i];
         }
         return dot / (Math.sqrt(normA) * Math.sqrt(normB));
     }
 
     // Processa a pergunta do usuário
     async processQuery(text) {
         if (this.status !== 'ready') return { text: "A IA ainda está carregando os motores neurais...", intentId: 'loading' };
 
         const output = await this.extractor(text, { pooling: 'mean', normalize: true });
         const userEmbedding = output.data;
 
         // 1. Busca Direta
         let matches = this.findMatches(userEmbedding);
         let contextUsed = false;
 
         // 2. Busca Contextual (se a confiança for baixa ou houver histórico)
         if (this.context.history.length > 0 && (matches[0].score < 0.65 || text.length < 20)) {
             const historyText = this.context.history.map(h => h.content).join(' ');
             const contextQuery = `${historyText} ${text}`;
             const contextOutput = await this.extractor(contextQuery, { pooling: 'mean', normalize: true });
             const contextMatches = this.findMatches(contextOutput.data);
 
             // Se o contexto melhorar a precisão significativamente
             if (contextMatches[0].score > matches[0].score + 0.05) {
                 matches = contextMatches;
                 contextUsed = true;
             }
         }
 
         const bestMatch = matches[0];
         
         // Fallback (Não entendeu)
         let response;
         if (bestMatch.score < this.config.threshold) {
             response = {
                 text: "Desculpe, não tenho certeza sobre isso. Tente ser mais específico.",
                 intentId: 'fallback',
                 score: bestMatch.score,
                 options: [],
                 contextUsed: contextUsed
             };
         } else {
             response = {
                 text: bestMatch.item.resp,
                 options: bestMatch.item.options,
                 intentId: bestMatch.item.id,
                 score: bestMatch.score,
                 contextUsed: contextUsed
             };
         }
 
         // Atualiza o histórico da conversa (remove HTML para não poluir o embedding futuro)
         const cleanResponse = response.text.replace(/<[^>]*>?/gm, '');
         this.context.history.push({ role: 'user', content: text });
         this.context.history.push({ role: 'bot', content: cleanResponse });
 
         // Garante que o histórico não exceda o limite
         const limit = this.config.historyLimit * 2; // (user + bot)
         if (this.context.history.length > limit) {
             this.context.history = this.context.history.slice(-limit);
         }
         
         return response;
     }
 
     findMatches(embedding) {
         return this.knowledgeBase.map(item => {
             let maxScore = -1;
             if (item.embeddings) {
                 for (let emb of item.embeddings) {
                     const score = this.cosineSimilarity(embedding, emb);
                     if (score > maxScore) maxScore = score;
                 }
             }
             return { item, score: maxScore };
         }).sort((a, b) => b.score - a.score);
     }
 
     // Envia o feedback para o backend
     async sendFeedback(data) {
         try {
             const response = await fetch(this.config.logEndpoint, {
                 method: 'POST',
                 headers: { 'Content-Type': 'application/json' },
                 body: JSON.stringify(data)
             });
             if (!response.ok) {
                 console.error('Falha ao enviar feedback. Status:', response.status);
             }
         } catch (error) {
             console.error('Erro de rede ao enviar feedback:', error);
         }
     }
 }
