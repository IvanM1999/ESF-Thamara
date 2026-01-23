async function sendChat(){
 const res=await fetch('/chat',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({message:chat.value})});
 output.textContent=JSON.stringify(await res.json(),null,2);
}
async function sendEmergency(){
 const res=await fetch('/emergency',{method:'POST'});
 output.textContent=JSON.stringify(await res.json(),null,2);
}
