(async function(){
  const out=document.getElementById('posts');
  const cfg = await fetch('data/config.json').then(r=>r.json()).catch(()=>({}));
  const api = cfg.directus_api || '';
  let data = [];
  if(api){
    try{
      const res = await fetch(api + '/items/posts?limit=50');
      const json = await res.json();
      data = (json.data || []);
    }catch(e){
      console.warn('Directus fetch failed', e);
    }
  }
  if(!data.length){
    data = await fetch('data/posts.json').then(r=>r.json()).catch(()=>[]);
  }
  if(!data.length){ out.innerHTML='<div class="card">Nenhum post</div>'; return; }
  data.forEach(p=>{
    const a=document.createElement('article'); a.className='card';
    a.innerHTML=`<h3>${p.title}</h3><p>${p.date} • ${p.author}</p><p>${p.summary||''}</p><a href='post.html?id=${encodeURIComponent(p.id)}'>Ler mais</a>`;
    out.appendChild(a);
  });
})();
