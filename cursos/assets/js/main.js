document.addEventListener('click', function(e){
  if(e.target.matches('a[href^="#"]')){
    e.preventDefault();
    var id = e.target.getAttribute('href').slice(1);
    var el = document.getElementById(id);
    if(el) el.scrollIntoView({behavior:'smooth', block:'start'});
  }
});