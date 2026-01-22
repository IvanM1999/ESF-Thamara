export function detectIntent(text) {
  if (!text) return null;
  if (text.includes("oi") || text.includes("ola")) return "saudacao";
  if (text.includes("horario")) return "horarios";
  if (text.includes("endereco") || text.includes("onde fica")) return "endereco";
  if (text.includes("vacina")) return "vacinas";
  if (text.includes("dor no peito") || text.includes("falta de ar")) return "emergencia";
  return null;
}