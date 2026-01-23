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