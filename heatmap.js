(function(){
  if(localStorage.getItem('consent')!=='1') return;
  document.addEventListener('click', function(e){
    var t=e.target; var data={slug:location.pathname.split('/').pop(), x:e.clientX, y:e.clientY, ts:Date.now()};
    try{ fetch('/api/heatmap',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(data)}); }catch(e){}
  }, true);
})();
