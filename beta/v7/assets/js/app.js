// ai risk-score

export function calculateRiskScore(intent, text) {
  let score = 0;

  if (intent === "emergencia") score += 80;

  const critical = ["dor no peito","falta de ar","desmaio","convulsao","sangramento"];
  critical.forEach(w => { if (text.includes(w)) score += 20; });

  return Math.min(score,100);
}

//audit
import fs from "fs";
export function logEvent(evt){
  fs.appendFileSync("audit.log", JSON.stringify(evt) + "\n");
}

// chatbot intents
export const intents = [
  {
    name: "emergencia",
    keywords: ["emergencia", "socorro", "ajuda", "urgencia", "acidente", "salvar vida"],
    response: "🚨 **Emergência:**<br>Se você está enfrentando uma emergência médica, ligue imediatamente para o número 192 (SAMU) ou vá ao pronto-socorro mais próximo. Sua saúde é prioridade!",
  },
    {
    name: "saude",
    keywords: ["saude", "consulta", "medico", "enfermeira", "atendimento", "unidade"],
    response: "🏥 **Atendimento na Unidade de Saúde:**<br>Nossa unidade oferece atendimento médico e de enfermagem para diversas condições de saúde. Agende sua consulta pelo telefone ou diretamente na recepção.",
  },
];  

//intent detection
export function detectIntent(text) {
  if (!text) return null;
  if (text.includes("oi") || text.includes("ola")) return "saudacao";
  if (text.includes("horario")) return "horarios";
  if (text.includes("endereco") || text.includes("onde fica")) return "endereco";
  if (text.includes("vacina")) return "vacinas";
  if (text.includes("dor no peito") || text.includes("falta de ar")) return "emergencia";
  return null;
}

// simple chatbot response
export function getChatbotResponse(intent) {
  const intentObj = intents.find(i => i.name === intent);
  return intentObj ? intentObj.response : "Desculpe, não entendi sua pergunta. Por favor, reformule.";
}   

// FAQ data
export const faqData = {
  horarios: "⏰ **Horários de Funcionamento:**<br>Segunda a Sexta: 7h às 17h<br>Sábado: 7h às 12h<br>Domingo: Fechado",
  endereco: "📍 **Endereço da Unidade de Saúde:**<br>Rua das Flores, 123 - Centro, Cidade XYZ<br>Telefone: (11) 1234-5678",
  vacinas: "💉 **Vacinas Disponíveis:**<br>Oferecemos vacinas contra COVID-19, Influenza, Hepatite B, Tétano, entre outras. Consulte o calendário de vacinação na unidade ou no nosso site.",
};
// chatbot sql additions
--- a/file:///c%3A/Users/dk/OneDrive/.Projetos/ESF-Thamara/ESF-Thamara/server_sql/chatbot.sql
+++ b/file:///c%3A/Users/dk/OneDrive/.Projetos/ESF-Thamara/ESF-Thamara/server_sql/chatbot.sql
@@ -110,6 +110,7 @@
    
    ('vacinas', ARRAY['vacina', 'imunizacao', 'vacinar', 'vacinacao', 'calendario de vacinacao'], '💉 **Vacinas Disponíveis:**<br>Oferecemos vacinas contra COVID-19, Influenza, Hepatite B, Tétano, entre outras.<br>Consulte o calendário de vacinação na unidade ou no nosso site.', ARRAY['Calendário de Vacinação', 'Voltar']),
    ('emergencia', ARRAY['dor no peito', 'falta de ar', 'desmaio', 'convulsao', 'sangramento'], '🚨 **Emergência:**<br>Se você está enfrentando uma emergência médica, ligue imediatamente para o número 192 (SAMU) ou vá ao pronto-socorro mais próximo. Sua saúde é prioridade!', ARRAY[]);

    
// chat service
import knowledge from "../intents/knowledge.js";
import { detectIntent } from "../utils/intentDetector.js";
import { calculateRiskScore } from "../ai/riskScore.js";
import { logEvent } from "../logs/audit.js";
import { sendEmergencyMail } from "../security/mailer.js";

export async function handleChat(req, res) {
  const text = (req.body.text || "").toLowerCase();
  const intent = detectIntent(text);
  const riskScore = calculateRiskScore(intent, text);

  const event = { type:"CHAT", text, intent, riskScore, ts:new Date().toISOString() };
  logEvent(event);

  if (riskScore >= 70) await sendEmergencyMail(event);

  res.json({
    answer: knowledge[intent] || knowledge.fallback,
    intent,
    riskScore
  });
}

export async function triggerEmergency(req, res) {
  const event = { type:"EMERGENCY_BUTTON", riskScore:100, ts:new Date().toISOString() };
  logEvent(event);
  await sendEmergencyMail(event);
  res.json({ ok:true });
}

//mailer
import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS }
});

export async function sendEmergencyMail(event){
  await transporter.sendMail({
    from: process.env.SMTP_USER,
    to: "dsbrti2022@gmail.com",
    subject: "ALERTA CRÍTICO - IA ESF",
    text: JSON.stringify(event, null, 2)
  });
}
