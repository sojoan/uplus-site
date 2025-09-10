(function(){
  window.downloadFree = function(slug){
    try{ var id = Math.random().toString(36).slice(2); localStorage.setItem('dl_'+slug, id);
      fetch('/api/heatmap',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({slug, x:0, y:0, ts:Date.now(), type:'lead_click'})});
    }catch(e){}
  }
})();
