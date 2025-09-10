// Verifier example for the Edge (public repo). Provide PUBLIC key (PEM) as SIGNING_PUBLIC env or inline.
window.verifySignature = async function(url, sigUrl, pubPem){
  try{
    const [data, sigB64] = await Promise.all([fetch(url).then(r=>r.text()), fetch(sigUrl).then(r=>r.text())]);
    const enc = new TextEncoder().encode(data);
    const key = await window.crypto.subtle.importKey('spki', _pemToArrayBuffer(pubPem), {name:'RSASSA-PKCS1-v1_5', hash:'SHA-256'}, false, ['verify']);
    const sig = Uint8Array.from(atob(sigB64), c=>c.charCodeAt(0));
    return await window.crypto.subtle.verify('RSASSA-PKCS1-v1_5', key, sig, enc);
  }catch(e){ return false; }
};
function _pemToArrayBuffer(pem){ const b64 = pem.replace(/-----.*-----/g,'').replace(/\s+/g,''); const raw = atob(b64); const arr = new Uint8Array(raw.length); for(let i=0;i<raw.length;i++) arr[i]=raw.charCodeAt(i); return arr.buffer; }
