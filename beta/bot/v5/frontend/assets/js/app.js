async function send(){
  const text = document.getElementById("msg").value;
  const r = await fetch("/api/chat", {
    method: "POST",
    headers: {"Content-Type":"application/json"},
    body: JSON.stringify({ text })
  });
  const j = await r.json();
  document.getElementById("out").innerText = JSON.stringify(j, null, 2);
}

function emergency(){
  fetch("/api/emergency", { method:"POST" });
  alert("Emergência registrada. Ligue 192.");
}