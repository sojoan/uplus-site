(async function(){
 try{ const j=await fetch('cta_mode.json',{cache:'no-store'}).then(r=>r.json()); 
  if(j.mode==='strong'){ document.querySelectorAll('a.btn').forEach(b=>{ b.style.background='#9EF01A'; b.textContent=b.textContent.replace('Pro','Activa Pro'); }); }
 }catch(e){}
})();
