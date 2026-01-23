export function calculateRiskScore(intent, text) {
  let score = 0;

  if (intent === "emergencia") score += 80;

  const critical = ["dor no peito","falta de ar","desmaio","convulsao","sangramento"];
  critical.forEach(w => { if (text.includes(w)) score += 20; });

  return Math.min(score,100);
}