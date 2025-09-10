(function(){
  try{
    var v=parseInt(localStorage.getItem('viewc')||'0',10)+1; localStorage.setItem('viewc', v);
    if(v>=3){
      var b=document.createElement('div'); b.style='position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,.75);display:flex;align-items:center;justify-content:center;z-index:99999';
      b.innerHTML='<div style="background:#151923;color:#E6E8EC;padding:24px;border-radius:12px;max-width:520px;font-family:system-ui"><h2>Contenido PRO</h2><p>Desbloquea todo por 19 €/mes.</p><p><a href="mini_checkout.html" class="btn">Activar ahora</a></p></div>';
      document.body.appendChild(b);
    }
  }catch(e){}
})();
