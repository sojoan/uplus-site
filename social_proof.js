(async function(){
  try{
    const j=await fetch('/api/sales_summary').then(r=>r.json());
    if((j.count||0)>0){
      const el=document.createElement('div'); el.style='position:fixed;right:10px;bottom:70px;background:#151923;color:#E6E8EC;padding:10px 12px;border-radius:12px;font-family:system-ui;opacity:.92';
      el.textContent = `${j.count} compras en las últimas 24h`; document.body.appendChild(el);
      setTimeout(()=>el.remove(), 8000);
    }
  }catch(e){}
})();
