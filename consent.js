(function(){
  if(localStorage.getItem('consent')==='1'){ return; }
  var b=document.createElement('div'); b.style='position:fixed;bottom:10px;left:10px;right:10px;background:#151923;color:#E6E8EC;padding:12px;border-radius:12px;z-index:9999;font-family:system-ui';
  b.innerHTML='Usamos cookies necesarias y analíticas opcionales. <button id="c-ok" style="margin-left:8px">Aceptar</button> <button id="c-no">Rechazar</button>';
  document.body.appendChild(b);
  document.getElementById('c-ok').onclick=function(){ localStorage.setItem('consent','1'); b.remove(); };
  document.getElementById('c-no').onclick=function(){ localStorage.setItem('consent','0'); b.remove(); };
})();
